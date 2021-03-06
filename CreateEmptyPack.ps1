<#Provide directory to output xml file, system name for the mp, and display name for the mp#>
param(
    $directory,
    $systemName,
    $displayName
)
function CreateNewPack ($id, $name, $version) {
    $mpStore = New-Object Microsoft.EnterpriseManagement.Configuration.IO.ManagementPackFileStore
    $managementPack = New-Object Microsoft.EnterpriseManagement.Configuration.ManagementPack($id, $name, (New-Object Version(1,0,0,$version)), $mpStore)
    $managementPack.DefaultLanguageCode = 'ENU'
    $managementPack.DisplayName = $name
    $managementPack.Description = $name + ' management pack was auto-generated'
    $managementPack
}
function WriteManagementPack ($directory, $mp) {
    $mpWriter = new-object Microsoft.EnterpriseManagement.Configuration.IO.ManagementPackXmlWriter($directory)
    $mpWriter.WriteManagementPack($mp) | Out-Null
}
$mp = CreateNewPack $systemName $displayName 1
$mp.AcceptChanges()
WriteManagementPack $directory $mp