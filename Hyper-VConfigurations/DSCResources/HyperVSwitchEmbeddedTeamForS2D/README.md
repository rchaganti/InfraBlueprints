# Hper-V Switch Embedded Team For Storage Spaces Direct#
This composite configuration can be used to deploy a Switch Embedded Team (SET) on a Hyper-V host that is a part of the Storage Spaces Direct. This configuration is depicted in the following figure.

![](http://i.imgur.com/kzoIgh6.png)

This composite configuration accepts the following parameters.

| Parameter Name | Purpose |
| -----------  | ------------------- |
|SwitchName| Name of the SET Switch |
|NetAdapterName| Name of the Network Adapters that should be a part of SET Team |
|ManagementAdapterName| Name of the management network Adapter|
|SMB1AdapterName|  Name of the SMB1 network adapter |
|SMB2AdapterName| Name of the SMB2 Network Adapter|
|TeamingMode| Teaming Mode to be used for the SET|
|LoadbalancingAlgorithm| Load Balancing Algorithm for the SET |
|ManagementVlanId| VLAN ID for the management adapter |
|SMB1VlanId| VLAN ID for the SMB1 Adapter|
|SMB2VlanId|  VLAN ID for the SMB2 Adapter|
|ManagementPrefixLength     | Subnet prefix length for the management adapter|
|SMB1PrefixLength | Subnet prefix length for the SMB1 adapter|
|SMB2PrefixLength|Subnet prefix length for the SMB2adapter |       
|ManagementIPAddress | IP Address for the management adapter |
|ManagementGateway | Gateway IP Address for the management adapter|
|ManagementDns | DNS IP Address for the management adapter|
|SMB1IPAddress | IP Address for the SMB1 adapter|
|SMB2IPAddress | IP Address for the SMB2 adapter|