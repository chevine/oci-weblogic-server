#!/usr/bin/env python3

import argparse
import csv
import json
from pathlib import Path

import oci
from oci.pagination import list_call_get_all_results


class OCIVCNInventory:

    def __init__(self, profile="DEFAULT"):
        self.config = oci.config.from_file(profile_name=profile)

        self.identity = oci.identity.IdentityClient(self.config)
        self.compute = oci.core.ComputeClient(self.config)
        self.network = oci.core.VirtualNetworkClient(self.config)

    #
    # VCN
    #
    def get_vcn(self, compartment_id, vcn_identifier):

        if vcn_identifier.startswith("ocid1.vcn"):
            return self.network.get_vcn(vcn_identifier).data

        vcns = list_call_get_all_results(
            self.network.list_vcns,
            compartment_id=compartment_id
        ).data

        for vcn in vcns:
            if vcn.display_name == vcn_identifier:
                return vcn

        raise Exception(f"VCN not found: {vcn_identifier}")

    #
    # Networking objects
    #
    def get_subnets(self, compartment_id, vcn_id):
        return list_call_get_all_results(
            self.network.list_subnets,
            compartment_id=compartment_id,
            vcn_id=vcn_id
        ).data

    def get_nsgs(self, compartment_id, vcn_id):
        return list_call_get_all_results(
            self.network.list_network_security_groups,
            compartment_id=compartment_id,
            vcn_id=vcn_id
        ).data

    def get_route_tables(self, compartment_id, vcn_id):
        return list_call_get_all_results(
            self.network.list_route_tables,
            compartment_id=compartment_id,
            vcn_id=vcn_id
        ).data

    def get_security_lists(self, compartment_id, vcn_id):
        return list_call_get_all_results(
            self.network.list_security_lists,
            compartment_id=compartment_id,
            vcn_id=vcn_id
        ).data

    #
    # Compute
    #
    def get_instances(self, compartment_id):
        return list_call_get_all_results(
            self.compute.list_instances,
            compartment_id=compartment_id
        ).data

    def get_instance_networking(self, compartment_id, instance_id):

        vnic_attachments = list_call_get_all_results(
            self.compute.list_vnic_attachments,
            compartment_id=compartment_id,
            instance_id=instance_id
        ).data

        vnics = []

        for attachment in vnic_attachments:

            vnic = self.network.get_vnic(
                attachment.vnic_id
            ).data

            vnics.append({
                "vnic_name": vnic.display_name,
                "private_ip": vnic.private_ip,
                "public_ip": vnic.public_ip,
                "subnet_id": vnic.subnet_id,
                "nsg_ids": list(vnic.nsg_ids)
            })

        return vnics

    #
    # Inventory
    #
    def collect(self, compartment_id, vcn_identifier):

        vcn = self.get_vcn(
            compartment_id,
            vcn_identifier
        )

        subnets = self.get_subnets(
            compartment_id,
            vcn.id
        )

        nsgs = self.get_nsgs(
            compartment_id,
            vcn.id
        )

        route_tables = self.get_route_tables(
            compartment_id,
            vcn.id
        )

        security_lists = self.get_security_lists(
            compartment_id,
            vcn.id
        )

        subnet_map = {s.id: s.display_name for s in subnets}
        nsg_map = {n.id: n.display_name for n in nsgs}

        inventory = {
            "vcn": {
                "name": vcn.display_name,
                "id": vcn.id,
                "cidr_blocks": list(vcn.cidr_blocks)
            },
            "subnets": [],
            "network_security_groups": [],
            "route_tables": [],
            "security_lists": [],
            "instances": []
        }

        #
        # Subnets
        #
        for subnet in subnets:
            inventory["subnets"].append({
                "name": subnet.display_name,
                "cidr": subnet.cidr_block,
                "id": subnet.id
            })

        #
        # NSGs
        #
        for nsg in nsgs:
            inventory["network_security_groups"].append({
                "name": nsg.display_name,
                "id": nsg.id
            })

        #
        # Route Tables
        #
        for rt in route_tables:
            inventory["route_tables"].append({
                "name": rt.display_name,
                "id": rt.id,
                "route_count": len(rt.route_rules)
            })

        #
        # Security Lists
        #
        for sl in security_lists:
            inventory["security_lists"].append({
                "name": sl.display_name,
                "id": sl.id,
                "ingress_rules": len(sl.ingress_security_rules),
                "egress_rules": len(sl.egress_security_rules)
            })

        #
        # Instances
        #
        for instance in self.get_instances(compartment_id):

            vnics = self.get_instance_networking(
                compartment_id,
                instance.id
            )

            vnic_data = []

            for vnic in vnics:

                vnic_data.append({
                    "name": vnic["vnic_name"],
                    "private_ip": vnic["private_ip"],
                    "public_ip": vnic["public_ip"],
                    "subnet": subnet_map.get(
                        vnic["subnet_id"],
                        vnic["subnet_id"]
                    ),
                    "nsgs": [
                        nsg_map.get(nsg, nsg)
                        for nsg in vnic["nsg_ids"]
                    ]
                })

            inventory["instances"].append({
                "name": instance.display_name,
                "id": instance.id,
                "shape": instance.shape,
                "state": instance.lifecycle_state,
                "vnics": vnic_data
            })

        return inventory

    #
    # Export
    #
    def export_json(self, inventory, file_name):
        with open(file_name, "w") as f:
            json.dump(inventory, f, indent=4)

    def export_csv(self, inventory, file_name):

        with open(file_name, "w", newline="") as f:

            writer = csv.writer(f)

            writer.writerow([
                "Instance",
                "State",
                "Shape",
                "Subnet",
                "PrivateIP",
                "PublicIP",
                "NSGs"
            ])

            for instance in inventory["instances"]:

                for vnic in instance["vnics"]:

                    writer.writerow([
                        instance["name"],
                        instance["state"],
                        instance["shape"],
                        vnic["subnet"],
                        vnic["private_ip"],
                        vnic["public_ip"],
                        ",".join(vnic["nsgs"])
                    ])


def main():

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "--compartment-id",
        required=True
    )

    parser.add_argument(
        "--vcn",
        required=True,
        help="VCN Name or VCN OCID"
    )

    parser.add_argument(
        "--profile",
        default="DEFAULT"
    )

    args = parser.parse_args()

    inventory_tool = OCIVCNInventory(
        profile=args.profile
    )

    inventory = inventory_tool.collect(
        args.compartment_id,
        args.vcn
    )

    inventory_tool.export_json(
        inventory,
        "oci_inventory.json"
    )

    inventory_tool.export_csv(
        inventory,
        "oci_instances.csv"
    )

    print(
        f"Inventory completed for VCN "
        f"{inventory['vcn']['name']}"
    )

    print("Generated:")
    print("  oci_inventory.json")
    print("  oci_instances.csv")


if __name__ == "__main__":
    main()