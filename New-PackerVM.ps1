#Requires -RunAsAdministrator
#^^^ Hyper-V cmdlets require eelevation
<#

.SYNOPSIS
    Create a new Hyper-V VM from a Packer build.

.DESCRIPTION
    This rough-and-ready script:
        - Imports a Packer-built VM (copying it)
        - Renames the VHDX file to keep things neat

.EXAMPLE
    From an elevated PowerShell prompt:

      .\New-PackerVM.ps1 -BuildDirectory "T:\packer-builds\" -BaseBuild "debian-10" -NewVMName "MyServer" -HyperVDirectory "T:\Hyper-V\"

.NOTES
    This release:

        Version: 0.4
        Date:    1 December 2021
        Author:  Rob Pomeroy

    Version history:

        0.4 - 1 December 2021 - add progress messages
        0.3 - 22 January 2021 - better handling of user input for paths, using [IO.Path]::Combine()
        0.2 - 13 January 2021 - parameterise
        0.1 - 8 January 2021 - beta

#>
Param(
    # The location of Packer builds
    [Parameter(Mandatory = $true, Position = 0)][String]$BuildDirectory,
    # The base Packer build for the new VM
    [Parameter(Mandatory = $true, Position = 1)][String]$BaseBuild,
    # The name to give the new VM
    [Parameter(Mandatory = $true, Position = 2)][String]$NewVMName,
    # Where the Hyper-V machine will be stored
    [Parameter(Mandatory = $true, Position = 3)][String]$HyperVDirectory
)

# Set up paths using .NET's [IO.Path]::Combine() function
$BaseDirectory = [IO.Path]::Combine($BuildDirectory,  $BaseBuild)
$VMDirectory   = [IO.Path]::Combine($HyperVDirectory, $NewVMName)
$VMVHDDir      = [IO.Path]::Combine($VMDirectory,     'Virtual Hard Disks')
$VHDXPath      = [IO.Path]::Combine($VMVHDDir,        (($BaseBuild -replace "\.", "_") + ".vhdx"))
$NewVHDXPath   = [IO.Path]::Combine($VMVHDDir,        ($NewVMName + ".vhdx"))

# Locate the VMCX file
$VMCX = (Get-ChildItem ([IO.Path]::Combine($BaseDirectory, 'Virtual Machines', '*.vmcx')))[0].FullName

Write-Host "NOTE: This script contains no error checking!"

# Import from the Packer build
Write-Host Importing the Packer build to a virtual machine...
$ImportedVM = Import-VM `
    -Copy `
    -Path $VMCX `
    -Confirm:$false `
    -GenerateNewId `
    -SmartPagingFilePath $VMDirectory `
    -SnapshotFilePath $VMDirectory `
    -VhdDestinationPath $VMVHDDir `
    -VirtualMachinePath $HyperVDirectory

# Rename the new VM
Write-Host Renaming the virtual machine...
Rename-VM $importedVM.Name -NewName $NewVMName

# Rename the VHDX to match the VM name
# - note that Hyper-V changes full stops in VHDX to underscores
Write-Host "Renaming the virtual machine's virtual hard drive file(s)..."
Rename-Item `
    -Path  $VHDXPath `
    -NewName $NewVHDXPath
Get-VMHardDiskDrive -VMName $ImportedVM.Name | Set-VMHardDiskDrive -Path $NewVHDXPath

Write-Host All done. Review any errors above.