# Infrastructure Blueprint for Hyper-V Converged Virtual Switch (with Switch Embedded Teaming on Windows Server 2016)
This blueprint lets you create and configure a Hyper-V converged virtual switch using a Switch Embedded Team (SET) on Windows Server 2016. Here is how the high-level architecture looks like.

![](http://i.imgur.com/3bMZIkx.png)

You can use the *NodeData.ps1* to supply the configution data specific to your environment.

The integration tests listed in ConvergedSwitch.tests.ps1 validate that the resources are in desired state or not.

The Simple and Comprehensive tests in ConvergedSwitch.Simple.tests.ps1 and ConvergedSwitch.comprehensive.tests.ps1 validate the functionality of the system after the configuration is in desired state.

