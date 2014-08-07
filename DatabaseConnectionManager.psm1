function databaseConnectionManager ($serverName, $databaseName, $sql) {
	$databaseConnection = New-Object system.data.sqlclient.sqlconnection("Data Source=$serverName;Initial Catalog=$databaseName;Integrated Security=SSPI;");
	if ($sql -eq 'test') {
		try {
			$databaseConnection.open()
			InfoToScreen 0 "DatabaseConnectionManager: Successfully connected to $serverName\$databaseName"
			$databaseConnection.close()
		}
		catch [system.exception] {
			InfoToScreen 1 "DatabaseConnectionManager: Error connecting to $serverName\$databaseName."
			InfoToScreen 1 "Quitting program! Fix database connectivity problems before continuing."
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