##This script accepts a class name, and returns the entire
##Base class path.  It also returns Host Class for each
##Base class returned.  You'll see the entire
##class path for the given class.
##Author: Jonathan Almquist, Scomskills
##version 2.0 (for SCOM 2012)
##Original: 11-01-2008
##Updated: 07-07-2014

##Usage = getClassPath.ps1 <class_system_name>
##Example = getClassPath.ps1 Microsoft.Windows.Computer

param($classname)
$ast = "-"
$class = get-scomclass | where {$_.name -eq $classname}
Write-Host ($ast * 50)
Write-Host "TARGET CLASS" $class
Write-Host ($ast * 50)`n
while ($class -ne "False")
    {
    $property = $class | foreach-object {$_.getProperties()} | Select-Object name
    foreach ($value in $property)
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
        foreach ($value in $property)
            {
            write-host `t`t`t`t $value.name
            }
        $baseclass = get-scomclass | where {$_.id -eq $baseclass.base.id.tostring()}
        }
    if ($class.hosted -eq "True")
        {
        $hostclass = get-scomclass | where {$_.name -eq $class.Name} | ForEach-Object {$_.findHostClass()}
        write-host `n
        Write-Host ($ast * 50)
        Write-Host "HOST CLASS for" $class
        Write-Host ($ast * 50)`n
        $class = get-scomclass | where {$_.name -eq $class.Name} | ForEach-Object {$_.findHostClass()}
        Write-Host $class
        }
        else
        {
        write-host `t`t "*Not Hosted*" `n`n
        $class = "False"
        }
    }