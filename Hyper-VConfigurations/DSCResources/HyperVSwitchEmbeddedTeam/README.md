# Hper-V Switch Embedded Team #
This composite configuration can be used to deploy a Switch Embedded Team (SET) on a Hyper-V host. This configuration is depicted in the following figure.

![](http://i.imgur.com/azIE4AZ.png)

This composite configuration accepts the following parameters.

| Parameter Name | Purpose |
| -----------  | ------------------- |
|SwitchName| Name of the SET Switch |
|NetAdapterName| Name of the Network Adapters that should be a part of SET Team |
|ManagementAdapterName| Name of the management network Adapter|
|ClusterAdapterName|  Name of the Cluster network adapter |
|LiveMigrationAdapterName| Name of the Live Migration Network Adapter|
|TeamingMode| Teaming Mode to be used for the SET|
|LoadbalancingAlgorithm| Load Balancing Algorithm for the SET |
|ManagementVlanId| VLAN ID for the management adapter |
|ClusterVlanId| VLAN ID for the Cluster Adapter|
|LiveMigrationVlanId|  VLAN ID for the Live Migration Adapter|
|ManagementMinimumBandwidthWeight| Bandwidth Weight for the Management Adapter|
|ClusterMinimumBandwidthWeight|Bandwidth Weight for the Cluster Adapter |
|LiveMigrationMinimumBandwidthWeight |Bandwidth Weight for the Live Migration Adapter |
|ManagementPrefixLength     | Subnet prefix length for the management adapter|
|ClusterPrefixLength | Subnet prefix length for the Cluster adapter|
|LiveMigrationPrefixLength|Subnet prefix length for the Cluster adapter |       
|ManagementIPAddress | IP Address for the management adapter |
|ManagementGateway | Gateway IP Address for the management adapter|
|ManagementDns | DNS IP Address for the management adapter|
|ClusterIPAddress | IP Address for the Cluster adapter|
|LiveMigrationIPAddress | IP Address for the Live Migration adapter|
