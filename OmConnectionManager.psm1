function OmConnectionManager ($managementServer, $action) {
    if ($action -eq 'connect') {
        try {
            Add-PSSnapin "Microsoft.EnterpriseManagement.OperationsManager.Client";
            New-SCOMManagementGroupConnection -ComputerName:$managementServer;
            Set-Location "OperationsManagerMonitoring::";
            $mgName = (Get-SCOMManagementGroupConnection).ManagementGroupName
            InfoToScreen 0 "OmConnectionManager: Successfully connected to $mgName."
        } catch [system.exception] {
            InfoToScreen 1 "OmConnectionManager: Error connecting to $managementServer."
            InfoToScreen 1 "Quitting program! Fix SCOM connectivity problems before continuing."
            exit
        }
    } else {
        Get-SCOMManagementGroupConnection -ComputerName:$managementServer | Remove-SCOMManagementGroupConnection
        Remove-PSSnapin "Microsoft.EnterpriseManagement.OperationsManager.Client";
    }
}