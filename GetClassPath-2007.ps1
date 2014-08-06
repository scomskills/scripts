##This script accepts a class name, and returns the entire
##Base class path. It also returns Host Class for each
##Base class returned. Essentially, you’ll see the entire
##class path for the given class.
##Jonathan Almquist
##info@scomskills.com
##version 2.0
##updated on 9/25/2012
##Usage = Get-ClassPath.ps1 <class_name>
##Example = Get-ClassPath.ps1 Microsoft.Windows.Computer

param($classname)
$ast = "-"
$class = get-scomclass | where {$_.name -eq $classname}
Write-Host ($ast * 50)
Write-Host "TARGET CLASS" $class
Write-Host ($ast * 50)`n
while ($class -ne "False")
    {
    $property = $class | foreach-object {$_.getProperties()} | Select-Object name
    foreach ($value in $Property)
        {
        if ($value.name -ne $null)
            {
            write-host `t`t`t`t $value.name
            }
            else
            {
            Write-Host `t`t`t`t "No properties"
            }
        }
    write-host `n
    Write-Host ($ast * 50)
    Write-Host "BASE CLASS PATH for" $class
    Write-Host ($ast * 50)`n
    $baseclass = get-scomclass | where {$_.id -eq $class.base.id.tostring()}
    While ($baseclass.base.id -ne $NULL)
        {
        $baseclass.name
        $property = $baseclass | foreach-object {$_.getProperties()} | Select-Object name
        foreach ($value in $Property)
            {
            write-host `t`t`t`t $value.name
            }
        $baseclass = get-scomclass | where {$_.id -eq $baseclass.base.id.tostring()}
        }
    if ($class.hosted -eq "True")
        {
        $hostclass = get-scomclass | where {$_.name -eq $Class.Name} | ForEach-Object {$_.findHostClass()}
        write-host `n
        Write-Host ($ast * 50)
        Write-Host "HOST CLASS for" $class
        Write-Host ($ast * 50)`n
        $class = get-scomclass | where {$_.name -eq $Class.Name} | ForEach-Object {$_.findHostClass()}
        Write-Host $class
        }
        else
        {
        write-host `t`t "*Not Hosted*" `n`n
        $class = "False"
        }
    }