# System Domain Join with Custom Timezone #
This composite configuration can be used to configure a system to domain join, enable remote desktop, disable IE enhanced security, and change the timezone.

This composite configuration accepts the following parameters.

| Parameter Name | Purpose |
| -----------  | ------------------- |
|ComputerName | Host name for the computer where the configuration is getting deployed. |
|DomainName| Name of the AD domain that the computer joins during configuration enact. |
|DomainJoinCredential | Credentials to join the AD domain. |
|Timezone|  Timezone identifier string. |
