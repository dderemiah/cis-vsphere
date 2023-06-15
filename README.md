# 🦍 CIS vSphere


![Preview](./docs/images/preview.gif)


> A tool to assess the compliance of a VMware vSphere environment against the CIS Benchmark for VMware vSphere.

## Requirements
* VMware PowerCLI 12.0.0 or higher
* VMware vSphere 7.0
* Read access to the vCenter or ESXi host

## Usage

1. Clone the repo and navigate to the folder: 
```bash
git clone https://github.com/bwdbethke/cis-vsphere.git
cd cis-vsphere
```
2. Install PowerCLI : 
```powershell
Install-Module -Name VMware.PowerCLI -Scope CurrentUser -Force
```
3. Run the script :
```powershell
.\src\cis-vsphere.ps1
```

### Notes 

* To verify the patches, you will need to update the `patches.json` file with the latest patches for your environment.
* version numbers can be found at https://esxi-patches.v-front.de/ESXi-7.0.0.html or retrieved similarly to:

```powershell
$BuildNumber = "20325353"
Add-EsxSoftwareDepot https://hostupdate.vmware.com/software/VUM/PRODUCTION/main/vmw-depot-index.xml
$Image = Get-EsxImageProfile | Where Name -Like "*$BuildNumber-standard*"
$Image.VibList | Sort-Object | Select-Object Name,Version | ConvertTo-Json
```
NOTE: Add-EsxSoftwareDepot and Get-EsxImageProfile are slow to get the data and complete, so give them time to finish 😉

NOTE2: the values for build 19482537 and 20325353 are saved as "patches_<_buildnumber_>.json". Copy the desired
build version contents into the generic `patches.json` file prior to running. If you're using an OEM customized ISO, 
then your version numbers will be different.

## Roadmap

* Add support for vSphere 6.5, 6.7, and 8.0

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
