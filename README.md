Within the Infrastructure as Code (IaC) practices, there is enough emphasis on the repeatable and reusable automation enabled using configuration management tools. This is referred to as configuration as Code. Configuration as Code enables consistent methods to configure IT systems. And, when we integrated these processes into DevOps practices, we can ensure that the configuration across different stages of the deployment (Development / Test / Staging / Production) can be consistent. 

One of the best practices in the Configuration as Code practice is to ensure that the configurations that we deploy are made reusable. This means that the configurations are parameterized and have the environmental data separated from the structural configuration data. 

PowerShell Desired State Configuration (DSC) supports the separation of environmental configuration from structural configuration using the [configuration data](https://msdn.microsoft.com/en-us/powershell/dsc/configdata) artifacts. And, sharing of parameterized configurations is done using the composite configuration modules or what we call [composite resources](https://msdn.microsoft.com/en-us/powershell/dsc/authoringresourcecomposite). Composite configurations are very useful when a node configuration requires a combination multiple resources and becomes long and complex.

For example, building a Hyper-V cluster includes configuring host networking, domain join, updating firewall rules, creating/joining a cluster, and so on. Each node in the cluster should have this configuration done in a consistent manner. Therefore, the configurations that are applied for each of these items can be made reusable using the composite configuration methods. 

Also, a real-world deployment pipeline implemented using IaC practices should also have validation of the infrastructure configuration at various stages of the deployment. In the PowerShell world, this is done using [Pester](https://github.com/pester/pester). Within DSC too, Pester plays a very important role in validating the desired state after a configuration is applied and in the operations validation space.

# Infrastructure Blueprints #
The [infrastructure blueprints](https://github.com/rchaganti/InfraBlueprints) project provides guidelines on enabling reusable and repeatable DSC configurations combined with Pester validations that are identified by [Operations Validation Framework](https://github.com/PowerShell/Operation-Validation-Framework).

Infrastructure Blueprints are essentially composite resource packages that contain node configurations and Pester tests that validate desired state and integration after the configuration is applied.

This repository contains multiple composite configuration modules. Each module contains multiple composite resources with ready to use examples and tests that validate the configuration.
 
The following folder structure shows how these composite modules are packaged.
![](http://i.imgur.com/4QZnVg5.png)

- *Diagnostics* folder contains the Simple and Comprehensive tests for performing operations validation.
	- **Simple**: A set of tests that validate the functionality of infrastructure at the desired state.
	- **Comprehensive**: A set of tests that perform a comprehensive operations validation of the infrastructure at the desired state. Comprehensive 
	- For ease of identification, the test script names include *Simple* or *Comprehensive* within the file name.

- *Examples* folder contains a sample configuration data foreach composite configuration and also a configuration document that demonstrates how to use the composite resource.

- *CompositeModuleName*.psd1 is the module manifest for the composite configuration module.

This manifest contains the *RequiredModules* key that has all the required modules for the composite configuration to work. This is listed as a module specification object. For example, the *RequiredModules* key for Hyper-VConfigurations composite module contains the following hashtable.

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @(
        @{ModuleName='cHyper-v';ModuleVersion='3.0.0.0'},
        @{ModuleName='xNetworking';ModuleVersion='2.12.0.0'}
    )

These composite modules are available in the PowerShell Gallery as well. And, therefore, having the *RequiredModules* in the module manifest enables automatic download of all module dependencies automatically.

![](http://i.imgur.com/BZgPmUg.png)

    PS C:\> Install-Module -Name Hyper-VConfigurations -Force -Verbose
    VERBOSE: Using the provider 'PowerShellGet' for searching packages.
    VERBOSE: The -Repository parameter was not specified.  PowerShellGet will use all of the registered repositories.
    VERBOSE: Getting the provider object for the PackageManagement Provider 'NuGet'.
    VERBOSE: The specified Location is 'https://www.powershellgallery.com/api/v2/' and PackageManagementProvider is 'NuGet'.
    VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='Hyper-VConfigurations'' for ''.
    VERBOSE: Total package yield:'1' for the specified package 'Hyper-VConfigurations'.
    VERBOSE: Performing the operation "Install-Module" on target "Version '1.0.0.0' of module 'Hyper-VConfigurations'".
    VERBOSE: The installation scope is specified to be 'AllUsers'.
    VERBOSE: The specified module will be installed in 'C:\Program Files\WindowsPowerShell\Modules'.
    VERBOSE: The specified Location is 'NuGet' and PackageManagementProvider is 'NuGet'.
    VERBOSE: Downloading module 'Hyper-VConfigurations' with version '1.0.0.0' from the repository 'https://www.powershellgallery.com/api/v2/'.
    VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='Hyper-VConfigurations'' for ''.
    VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='cHyper-v'' for ''.
    VERBOSE: Searching repository 'https://www.powershellgallery.com/api/v2/FindPackagesById()?id='xNetworking'' for ''.
    VERBOSE: InstallPackage' - name='cHyper-V', version='3.0.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645'
    VERBOSE: DownloadPackage' - name='cHyper-V', version='3.0.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645\cHyper-V\cHyper-V.nupkg', uri='https://www.powershe
    llgallery.com/api/v2/package/cHyper-V/3.0.0'
    VERBOSE: Downloading 'https://www.powershellgallery.com/api/v2/package/cHyper-V/3.0.0'.
    VERBOSE: Completed downloading 'https://www.powershellgallery.com/api/v2/package/cHyper-V/3.0.0'.
    VERBOSE: Completed downloading 'cHyper-V'.
    VERBOSE: InstallPackageLocal' - name='cHyper-V', version='3.0.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645'
    VERBOSE: InstallPackage' - name='xNetworking', version='3.2.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645'
    VERBOSE: DownloadPackage' - name='xNetworking', version='3.2.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645\xNetworking\xNetworking.nupkg', uri='https://www
    .powershellgallery.com/api/v2/package/xNetworking/3.2.0'
    VERBOSE: Downloading 'https://www.powershellgallery.com/api/v2/package/xNetworking/3.2.0'.
    VERBOSE: Completed downloading 'https://www.powershellgallery.com/api/v2/package/xNetworking/3.2.0'.
    VERBOSE: Completed downloading 'xNetworking'.
    VERBOSE: InstallPackageLocal' - name='xNetworking', version='3.2.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645'
    VERBOSE: InstallPackage' - name='Hyper-VConfigurations', version='1.0.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645'
    VERBOSE: DownloadPackage' - name='Hyper-VConfigurations', version='1.0.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645\Hyper-VConfigurations\Hyper-VConfigura
    tions.nupkg', uri='https://www.powershellgallery.com/api/v2/package/Hyper-VConfigurations/1.0.0'
    VERBOSE: Downloading 'https://www.powershellgallery.com/api/v2/package/Hyper-VConfigurations/1.0.0'.
    VERBOSE: Completed downloading 'https://www.powershellgallery.com/api/v2/package/Hyper-VConfigurations/1.0.0'.
    VERBOSE: Completed downloading 'Hyper-VConfigurations'.
    VERBOSE: InstallPackageLocal' - name='Hyper-VConfigurations', version='1.0.0.0',destination='C:\Users\ravikanth_chaganti\AppData\Local\Temp\1037779645'
    VERBOSE: Installing the dependency module 'cHyper-V' with version '3.0.0.0' for the module 'Hyper-VConfigurations'.
    VERBOSE: Module 'cHyper-V' was installed successfully.
    VERBOSE: Installing the dependency module 'xNetworking' with version '3.2.0.0' for the module 'Hyper-VConfigurations'.
    VERBOSE: Module 'xNetworking' was installed successfully.
    VERBOSE: Module 'Hyper-VConfigurations' was installed successfully.

As you can see in the above *Install-Module* cmdlet output, the required modules are downloaded from the gallery. Thanks to [Chrissy](https://blog.netnerds.net/2017/05/powershell-gallery-metapackages/) for this tip. 

# Available Composite Resource Modules #
| Module Name  | Composite Resources |
| -----------  | ------------------- |
| [Hyper-VConfigurations](https://www.powershellgallery.com/packages/Hyper-VConfigurations) | HyperVSwitchEmbeddedTeam |
|  | HyperVSwitchEmbeddedTeamForS2D |
|  | HyperVSwitchNativeTeam |

You can contribute to this repository by adding your own composite resource modules. If you have something to share, just submit a pull request and we will review the resources and update the repository with your resource modules.