<#
.SYNOPSIS
    This tool is designed to help a Windows admin quickly check installed updates on servers, based on a specified date.
.DESCRIPTION
    This tool checks for installed OS updates on a selected server from a specified date.
    - The tool verifies that the server input is a valid server.
    - The tool verifies that the date entered is valid.
    - If no updates are found from the date input, the tool alerts the user that no updates were found.

    After returning the installed updates, the user is then prompted to:
    - Check another server from the same date
    - Check another server from a different date
    - Check the same server from a different date
    - Exit script

    There is also a multi-server search option, allowing you to check multiple servers' OS patches in one go (rather than needing to manually input each server).
    Simply create a .CSV with all of the servers you want to check in one column, input the .CSV into the script when prompted, and the script will check for the installed patches
    based on the date provided.

.NOTES
    @Author: Will Opie
    @Initial Date: 2022-09-06
    @Version: 2022-10-29
#>

#region Functions ------------------------------------------------------------------------------------------------
Function pause ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $null = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}
#endregion Functions --------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "Installed OS Patch Check Tool`n" -ForegroundColor Green
Write-Host "Please select from the following options:"
Write-Host "`n1. Single Server Search`n2. Multi-Server Search"
$SearchSelectionMode = Read-Host "Please enter your selection"
switch($SearchSelectionMode){
    1{
        Do{
            Write-Host "Enter the name of the server you wish to check updates for:"
            $Server = Read-Host
            If(Test-Connection -ComputerName $Server -Count 1 -Quiet){
                $ServerExists = $True
            }
            Else{
                $ServerExists = $False
                Write-Host "`n$Server not found. Please ensure you have entered a valid server, and/or confirm the server is online.`n" -ForegroundColor Red
            }
        }Until($ServerExists)

        Do{
            Write-Host "`nEnter the date you wish to check updates for. Date must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
            $CheckDate = Read-Host "`nPlease enter date"
            If($CheckDate -NotMatch "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}"){
                Write-Host "Invalid input. Please write date in Month/Day/Year format."
            }
        }until($CheckDate -match "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}")

        While($true){
            #Clear-Host
            Write-Host "`n`nChecking for installed updates from " -NoNewLine 
            Write-Host "$CheckDate" -NoNewLine -ForegroundColor Yellow
            Write-Host " on " -NoNewLine
            Write-Host "$Server" -ForegroundColor Green -NoNewLine
            Write-Host "...`n`n" -NoNewLine
            $InstalledUpdates = Invoke-Command -ComputerName $Server -ScriptBlock {Get-Hotfix} | Where-Object{$_.InstalledOn -ge "$CheckDate"} | Sort-Object InstalledOn | Format-Table
            If($Null -eq $InstalledUpdates){
                Clear-Host
                Write-Host "No updates installed from " -NoNewLine
                Write-Host "$CheckDate" -NoNewLine -ForegroundColor Yellow
                Write-Host " on server " -NoNewLine
                Write-Host "$Server" -ForegroundColor Green
            }
            Else{
                Clear-Host
                Write-Host "Below are the installed updates on " -NoNewLine
                Write-Host "$Server" -ForegroundColor Green -NoNewLine
                Write-Host " from " -NoNewLine
                Write-Host "$CheckDate" -ForegroundColor Yellow
                Write-Output $InstalledUpdates
            }

            DO{
                Write-Host "`nCheck another server?`n" -ForegroundColor Red -BackgroundColor Yellow
                Write-Host "[1] Check another server from same date " -NoNewLine
                Write-Host "($CheckDate)" -ForegroundColor Yellow
                Write-Host "[2] Check another server from a different date"
                Write-Host "[3] Check same server from a different date " -NoNewLine
                Write-Host "($Server)" -ForegroundColor Green
                Write-Host "[4] Exit script`n"
                $LoopBack = Read-Host "Please enter your selection"
                Switch($LoopBack)
                {
                    1{
                        $Server = $Null
                        $ServerExists = $Null
                        Do{
                            Write-Host "Enter the name of the server you wish to check updates for:"
                            $Server = Read-Host
                            If(Test-Connection -ComputerName $Server -Count 1 -Quiet){
                                $ServerExists = $True
                            }
                            Else{
                                $ServerExists = $False
                                Write-Host "`n$Server not found. Please ensure you have entered a valid server, and/or confirm the server is online.`n" -ForegroundColor Red
                            }
                        }Until($ServerExists)
                    }
                    2{
                        $Server = $Null
                        $ServerExists = $Null
                        $CheckDate = $Null
                        Do{
                            Write-Host "Enter the name of the server you wish to check updates for:"
                            $Server = Read-Host
                            If(Test-Connection -ComputerName $Server -Count 1 -Quiet){
                                $ServerExists = $True
                            }
                            Else{
                                $ServerExists = $False
                                Write-Host "`n$Server not found. Please ensure you have entered a valid server, and/or confirm the server is online.`n" -ForegroundColor Red
                            }
                        }Until($ServerExists)
                        Do{
                            Write-Host "`nEnter the date you wish to check updates for. Date must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
                            $CheckDate = Read-Host "`nPlease enter date"
                            If($CheckDate -NotMatch "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}"){
                                Write-Host "Invalid input. Please write date in Month/Day/Year format."
                            }
                        }until($CheckDate -match "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}")
                    }
                    3{
                        $CheckDate = $Null
                        Do{
                            Write-Host "`nEnter the date you wish to check updates for on " -NoNewLine
                            Write-Host "$Server" -NoNewLine -ForegroundColor Green
                            Write-Host ". `nDate must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
                            $CheckDate = Read-Host "`nPlease enter date"
                            If($CheckDate -NotMatch "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}"){
                                Write-Host "Invalid input. Please write date in Month/Day/Year format."
                            }
                        }until($CheckDate -match "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}")
                    }
                    4{
                        Write-Host "`nExiting script..." -ForegroundColor Red
                        Start-Sleep -Seconds 3
                        Exit
                    }
                    Default{
                        Write-Host "`nInvalid input. Try again" -BackgroundColor Red -ForegroundColor White
                    }
                }
            }Until($LoopBack -like "[1/2/3/4]")
        }
    }
    2{
        $CSV = $Null
        $ServerList = $Null
        $CheckDate = $Null
        Do{
            Do{
                Clear-Host
                Write-Host "Multi-Server OS Patch Check Tool`n" -ForegroundColor Yellow
                $CSV = Read-Host "Enter path of .csv with server list"
                If(-Not(Test-Path -Path $CSV)){
                    Write-Host "`nInvalid path " -NoNewLine 
                    Write-Host "$CSV" -NoNewLine -ForegroundColor Red
                    Write-Host ". Please enter a valid file path.`n"
                    Start-Sleep -Seconds 3
                }
                If(-Not($CSV.Contains(".csv"))){
                    Write-Host "`n$CSV" -NoNewLine -ForegroundColor Red
                    Write-Host " is not the correct file format. Please input a valid .csv file.`n"
                    Start-Sleep -Seconds 3
                }
            }Until(Test-Path -Path $CSV)
        }Until($CSV.contains(".csv"))
        $ServerList = Get-Content -Path $CSV
        While($true){
            Do{
                Write-Host "`nEnter the date you wish to check updates for. Date must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
                $CheckDate = Read-Host "`nPlease enter date"
                If($CheckDate -NotMatch "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}"){
                    Write-Host "Invalid input. Please write date in Month/Day/Year format."
                }
            }until($CheckDate -match "([1-9]|[1][0-2])\/([0-9]|[1-2][0-9]|[3][0-1])\/20[0-9]{2}")
            $ExportCheck = Read-Host "Would you like to export patch results to a .csv file? Y/N"
            If($ExportCheck -eq 'Y'){
                Do{
                    Do{
                        $ExportList = Read-Host "Enter file path for export. (Use .csv for file extension)"
                        If(-Not ($ExportList.Contains(".csv"))){
                            Write-Host "`n$ExportList" -NoNewLine -ForegroundColor Red
                            Write-Host " must have a .csv file extension.`n"
                        }
                    }Until($ExportList.Contains(".csv"))
                    Write-Output "Installed OS Patch Check" | Add-Content -Path $ExportList
                    If(-Not(Test-Path -Path $ExportList)){
                        Write-Host "`nInvalid path " -NoNewLine 
                        Write-Host "$ExportList" -NoNewLine -ForegroundColor Red
                        Write-Host ". Please enter a valid file path.`n" 
                    }
                }Until(Test-Path -Path $ExportList)
            }
            Clear-Host
            ForEach($Server in $ServerList){
                If(Test-Connection -ComputerName $Server -Count 1 -Quiet){
                    $ServerExists = $True
                }
                Else{
                    $ServerExists = $False
                    Write-Host "`n$Server not found. Please ensure you have entered a valid server, and/or confirm the server is online.`n" -ForegroundColor Red
                }
                If($ServerExists){
                    #Clear-Host
                    Write-Host "`n`nChecking for installed updates from " -NoNewLine 
                    Write-Host "$CheckDate" -NoNewLine -ForegroundColor Yellow
                    Write-Host " on " -NoNewLine
                    Write-Host "$Server" -ForegroundColor Green -NoNewLine
                    Write-Host "...`n`n" -NoNewLine
                    $InstalledUpdates = Invoke-Command -ComputerName $Server -ScriptBlock {Get-Hotfix} | Where-Object{$_.InstalledOn -ge "$CheckDate"} | Sort-Object InstalledOn | Format-Table
                    If($Null -eq $InstalledUpdates){
                        Write-Host "No updates installed from " -NoNewLine
                        Write-Host "$CheckDate" -NoNewLine -ForegroundColor Yellow
                        Write-Host " on server " -NoNewLine
                        Write-Host "$Server" -ForegroundColor Green
                        If($ExportCheck -eq "Y"){
                            Write-Host "No updates installed from $CheckDate on server $Server." | Add-Content -Path $ExportList
                        }
                    }
                    Else{
                        Write-Host "Below are the installed updates on " -NoNewLine
                        Write-Host "$Server" -ForegroundColor Green -NoNewLine
                        Write-Host " from " -NoNewLine
                        Write-Host "$CheckDate" -ForegroundColor Yellow
                        Write-Output $InstalledUpdates
                        If($ExportCheck -eq "Y"){
                            Write-Output "Below are the installed updates on server $Server from $CheckDate :" | Add-Content -Path $ExportList
                            Write-Output $InstalledUpdates | Out-File -Append -FilePath $ExportList
                        }
                    }
                    Write-Host "`nCompleted search for " -NoNewLine
                    Write-Host "$Server" -ForegroundColor Green -NoNewLine
                    Write-Host "... moving to next server in list.`n"                
                }
            }
            pause "`nPress any key to continue...`n"
            $SubmenuSelection = Read-Host "Would you like to search the same list of servers with a different date range? Y/N"
            switch($SubMenuSelection){
                "Y"{
                    $CheckDate = $Null
                    Write-Host "Returning to date selection..."
                    Start-Sleep -Seconds 3
                    Clear-Host
                }
                "N"{
                    Pause "Press any key to exit script."
                    Exit
                }
            }
        }
    }
}