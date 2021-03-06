function databaseConnectionManager ($serverName, $databaseName, $sql) {
    $databaseConnection = New-Object system.data.sqlclient.sqlconnection("Data Source=$serverName;Initial Catalog=$databaseName;Integrated Security=SSPI;");
    if ($sql -eq 'test') {
        try {
            $databaseConnection.open()
            Write-Host "DatabaseConnectionManager: Successfully connected to $serverName\$databaseName"
            $databaseConnection.close()
        } catch [system.exception] {
            Write-Host "DatabaseConnectionManager: Error connecting to $serverName\$databaseName."
            Write-Host "Quitting program! Fix database connectivity problems before continuing."
            exit
        }
    } else {
        $databaseConnection.open()
        # Create the dataset
        $Execute = new-object system.data.sqlclient.sqldataadapter ($sql, $databaseConnection)
        $Dataset = new-object system.data.dataset
        $Execute.Fill($Dataset) | Out-Null
        [System.Collections.ArrayList]$result = @()
        # Add rows to collection
        foreach ($Row in $Dataset.Tables[0]) {
        $result += $Row
        }
        $databaseConnection.close()
        return $result
    }
}
$sql = '
#TSQL goes here
'
$test = databaseConnectionManager 'SQL Server' 'Database' 'test' #this is to test the connection first
$dataset = databaseConnectionManager 'SQL Server' 'Database' $sql #this is to perform actual query
$dataset #return dataset to screen