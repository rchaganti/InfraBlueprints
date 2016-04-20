# Infrastructure Blueprints
Infrastructure Blueprints are packages that contain the node configuration and the Pester tests that validate desired state after the configuration is applied and also perform operations validation on the node.

The following folder structure shows how these blueprints are packaged.
![](http://i.imgur.com/lvieXNW.png)

- `<Name>`.Config.ps1 is the re-usable DSC configuration fragment.
- NodeData.psd1 is the configuration data needed for the DSC configuration.
- Tests\Integration folder contains the Pester tests that validate the desired state of the resources configured using DSC.
- Tests\Diagnostics folder contains the Simple and Comprehensive tests for performing operations validation.
	- **Simple**: A set of tests that validate the functionality of infrastructure at the desired state.
	- **Comprehensive**: A set of tests that perform a comprehensive operations validation of the infrastructure at the desired state. Comprehensive 
	- For ease of identification, the test script names include *Simple* or *Comprehensive* within the file name.