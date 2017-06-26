# TODO #
- Add automated tests for module loading and other checks
- Add automated PowerShell Gallery posting for releases

# Available Composite Resource Modules #
| Module Name  | Composite Resources |
| -----------  | ------------------- |
| [HyperVConfigurations](https://www.powershellgallery.com/packages/HyperVConfigurations) | [HyperVSwitchEmbeddedTeam](https://github.com/rchaganti/InfraBlueprints/tree/Dev/HyperVConfigurations/DSCResources/HyperVSwitchEmbeddedTeam) |
|  | [HyperVSwitchEmbeddedTeamForS2D](https://github.com/rchaganti/InfraBlueprints/tree/Dev/HyperVConfigurations/DSCResources/HyperVSwitchEmbeddedTeamForS2D) |
|  | [HyperVSwitchNativeTeam](https://github.com/rchaganti/InfraBlueprints/tree/Dev/HyperVConfigurations/DSCResources/HyperVSwitchNativeTeam) |
| [SystemConfigurations](https://www.powershellgallery.com/packages/SystemConfigurations) | [SystemDomainJoinWithCustomTimezone](https://github.com/rchaganti/InfraBlueprints/tree/Dev/SystemConfigurations/DSCResources/SystemDomainJoinWithCustomTimezone) |

You can contribute to this repository by adding your own composite resource modules. If you have something to share, just submit a pull request and we will review the resources and update the repository with your resource modules.

# What is this project about? #

This project provides guidelines on enabling reusable and repeatable DSC configurations combined with Pester validations that are identified by [Operations Validation Framework](https://github.com/PowerShell/Operation-Validation-Framework).

Infrastructure Blueprints are essentially composite resource packages that contain node configurations and Pester tests that validate desired state and integration after the configuration is applied.

This repository contains multiple composite configuration modules. Each module contains multiple composite resources with ready to use examples and tests that validate the configuration.
 
The following folder structure shows how these composite modules are packaged.
![](http://i.imgur.com/4QZnVg5.png)

- *Diagnostics* folder contains the Simple and Comprehensive tests for performing operations validation.
	- **Simple**: A set of tests that validate the functionality of infrastructure at the desired state.
	- **Comprehensive**: A set of tests that perform a comprehensive operations validation of the infrastructure at the desired state. Comprehensive 
	- **PreDeploy**: A set of tests that perform pre-deployment validation for the infrastructure that needs to be configured. These tests ensure that the infrastrucutre is ready for the deployment configuration.
	- For ease of identification, the test script names include *Simple* or *Comprehensive* or *PreDeploy* within the file name.	

The Operations Validation Framework can be used to retrieve the list of tests in this module and invoke the relevant ones.
