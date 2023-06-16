# Import scripts from controls folder
Import-Module -Name $PSScriptRoot\controls\install.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\communication.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\vmachines.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\storage.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\logging.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\access.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\console.ps1 -Force
Import-Module -Name $PSScriptRoot\controls\network.ps1 -Force

# A function to connect to vCenter/ESXi Server using the Connect-VIServer cmdlet and store the connection in a variable
function Connect-VCServer {
    # Asking the user for the vCenter/ESXi Server Hostname or IP Address
    $server = Read-Host -Prompt "Enter the vCenter/ESXi Server Hostname or IP Address"

    # Set InvalidCertificateAction to warn instead of stop without user interaction
    Write-Host "Setting InvalidCertificateAction to Warn instead of Stop..."
    Set-PowerCLIConfiguration -Scope User -InvalidCertificateAction warn -Confirm:$false

    # print the connection details 
    Write-Host "Connecting to $server" 

    # Connect to the vCenter/ESXi Server using https, stop if the connection fails
    Connect-VIServer -Server $server -Protocol https -ErrorAction Stop
    Write-Host "Successfully connected to $server" -ForegroundColor Green

}

# Connect to the vCenter/ESXi Server
Connect-VCServer

# Run the CIS Benchmark checks and store the results in a variable
# 1.Install
Write-Host "`n* These controls contain recommendations for settings related to 1.Install" -ForegroundColor Blue
Ensure-ESXiIsProperlyPatched
Ensure-VIBAcceptanceLevelIsConfiguredProperly
Ensure-UnauthorizedModulesNotLoaded
#Ensure-DefaultSaltIsConfiguredProperly  #(TSS EXCLUDED)

# 2.Communication 
Write-Host "`n* These controls contain recommendations for settings related to 2.Communication" -ForegroundColor Blue
Ensure-NTPTimeSynchronizationIsConfiguredProperly
Ensure-ESXiHostFirewallIsProperlyConfigured
Ensure-MOBIsDisabled
#Ensure-DefaultSelfSignedCertificateIsNotUsed  #(TSS EXCLUDED)
Ensure-SNMPIsConfiguredProperly
Ensure-dvfilterIsDisabled
Ensure-DefaultExpiredOrRevokedCertificateIsNotUsed
#Ensure-vSphereAuthenticationProxyIsUsedWithAD  #(TSS EXEMPT)
#Ensure-VDSHealthCheckIsDisabled  #(TSS EXCLUDED)

# 3.Logging
Write-Host "`n* These controls contain recommendations for settings related to 3.Logging" -ForegroundColor Blue
Ensure-CentralizedESXiHostDumps
Ensure-PersistentLoggingIsConfigured
Ensure-RemoteLoggingIsConfigured

# 4.Access
Write-Host "`n* These controls contain recommendations for settings related to 4.Access" -ForegroundColor Blue
#Ensure-NonRootExistsForLocalAdmin  #(TSS EXEMPT)
Ensure-PasswordsAreRequiredToBeComplex
Ensure-LoginAttemptsIsSetTo5
Ensure-AccountLockoutIsSetTo15Minutes
Ensure-Previous5PasswordsAreProhibited
#Ensure-ADIsUsedForAuthentication #(TSS EXEMPT)
#Ensure-OnlyAuthorizedUsersBelongToEsxAdminsGroup #(TSS EXEMPT)
#Ensure-ExceptionUsersIsConfiguredManually #(TSS EXEMPT)

# 5.Console
Write-Host "`n* These controls contain recommendations for settings related to 5.Console" -ForegroundColor Blue
Ensure-DCUITimeOutIs600
Ensure-ESXiShellIsDisabled
#Ensure-SSHIsDisabled  #(OK W/2.2)
#Ensure-CIMAccessIsLimited  #(TSS REC BUT NO SER REQ)
#Ensure-NormalLockDownIsEnabled  #(TSS REC BUT NO SER REQ)
#Ensure-StrictLockdownIsEnabled  #(TSS EXCLUDED)
#Ensure-SSHAuthorisedKeysFileIsEmpty  #(TSS EXCLUDED)
Ensure-IdleESXiShellAndSSHTimeout
Ensure-ShellServicesTimeoutIsProperlyConfigured
Ensure-DCUIHasTrustedUsersForLockDownMode
#Ensure-ContentsOfExposedConfigurationsNotModified  #(TSS EXCLUDED)

# 6.Storage 
Write-Host "`n* These controls contain recommendations for settings related to 6.Storage" -ForegroundColor Blue
#Ensure-BidirectionalCHAPAuthIsEnabled  #Not using iSCSI
#Ensure-UniquenessOfCHAPAuthSecretsForiSCSI  #(TSS EXCLUDED)
Ensure-SANResourcesAreSegregatedProperly

# 7.Network 
Write-Host "`n* These controls contain recommendations for settings related to 7.Network" -ForegroundColor Blue
Ensure-vSwitchForgedTransmitsIsReject
Ensure-vSwitchMACAdressChangeIsReject
Ensure-vSwitchPromiscuousModeIsReject
Ensure-PortGroupsNotNativeVLAN
#Ensure-PortGroupsNotUpstreamPhysicalSwitches  #(TSS EXCLUDED)
Ensure-PortGroupsAreNotConfiguredToVLAN0and4095
Ensure-VirtualDistributedSwitchNetflowTrafficSentToAuthorizedCollector
Ensure-PortLevelConfigurationOverridesAreDisabled

# 8.Virual Machines
Write-Host "`n* These controls contain recommendations for settings related to 8.Virtual Machines" -ForegroundColor Blue
Ensure-InformationalMessagesFromVMToVMXLimited
#Ensure-OnlyOneRemoteConnectionIsPermittedToVMAtAnyTime  #(TSS EXCLUDED)
Ensure-UnnecessaryFloppyDevicesAreDisconnected
#Ensure-UnnecessaryCdDvdDevicesAreDisconnected  #(TSS EXCLUDED)
Ensure-UnnecessaryParallelPortsAreDisconnected
Ensure-UnnecessarySerialPortsAreDisabled
Ensure-UnnecessaryUsbDevicesAreDisconnected
Ensure-UnauthorizedModificationOrDisconnectionOfDevicesIsDisabled
#Ensure-UnauthorizedConnectionOfDevicesIsDisabled  #(TSS EXCLUDED)
Ensure-PciPcieDevicePassthroughIsDisabled
Ensure-UnnecessaryFunctionsInsideVMsAreDisabled
Ensure-UseOfTheVMConsoleIsLimited
Ensure-SecureProtocolsAreUsedForVirtualSerialPortAccess
Ensure-StandardProcessesAreUsedForVMDeployment
Ensure-AccessToVMsThroughDvFilterNetworkAPIsIsConfiguredCorrectly
#Ensure-AutologonIsDisabled  #(TSS EXCLUDED)
#Ensure-BIOSBBSIsDisabled  #(TSS EXCLUDED)
#Ensure-GuestHostInteractionProtocolIsDisabled  #(TSS EXCLUDED)
#Ensure-UnityTaskBarIsDisabled  #(TSS EXCLUDED)
#Ensure-UnityActiveIsDisabled  #(TSS EXCLUDED)
#Ensure-UnityWindowContentsIsDisabled  #(TSS EXCLUDED)
#Ensure-UnityPushUpdateIsDisabled  #(TSS EXCLUDED)
#Ensure-DragAndDropVersionGetIsDisabled  #(TSS EXCLUDED)
#Ensure-DragAndDropVersionSetIsDisabled  #(TSS EXCLUDED)
#Ensure-ShellActionIsDisabled  #(TSS EXCLUDED)
#Ensure-DiskRequestTopologyIsDisabled  #(TSS EXCLUDED)
#Ensure-TrashFolderStateIsDisabled  #(TSS EXCLUDED)
#Ensure-GuestHostInterationTrayIconIsDisabled  #(TSS EXCLUDED)
#Ensure-UnityIsDisabled  #(TSS EXCLUDED)
#Ensure-UnityInterlockIsDisabled  #(TSS EXCLUDED)
#Ensure-GetCredsIsDisabled  #(TSS EXCLUDED)
#Ensure-HostGuestFileSystemServerIsDisabled  #(TSS EXCLUDED)
#Ensure-GuestHostInteractionLaunchMenuIsDisabled  #(TSS EXCLUDED)
#Ensure-memSchedFakeSampleStatsIsDisabled  #(TSS EXCLUDED)
Ensure-VMConsoleCopyOperationsAreDisabled
Ensure-VMConsoleDragAndDropOprerationsIsDisabled
Ensure-VMConsoleGUIOptionsIsDisabled
Ensure-VMConsolePasteOperationsAreDisabled
#Ensure-VMLimitsAreConfiguredCorrectly  #(TSS EXCLUDED)
#Ensure-HardwareBased3DAccelerationIsDisabled  #(TSS EXCLUDED)
#Ensure-NonPersistentDisksAreLimited  #(TSS EXCLUDED)
Ensure-VirtualDiskShrinkingIsDisabled
Ensure-VirtualDiskWipingIsDisabled
Ensure-TheNumberOfVMLogFilesIsConfiguredProperly
#Ensure-HostInformationIsNotSentToGuests  #(TSS EXCLUDED)
Ensure-VMLogFileSizeIsLimited

# Read-Host -Prompt "Press Enter to exit"
