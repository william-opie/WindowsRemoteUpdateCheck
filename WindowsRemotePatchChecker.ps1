Clear-Host
Write-Host "Enter the name of the server you wish to check updates for:"
$Server = Read-Host

Write-Host "`nEnter the date you wish to check updates for. Date must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
$CheckDate = Read-Host "`nPlease enter date"

While($true){
    #Clear-Host
    Write-Host "`n`nChecking for installed updates from " -NoNewLine 
    Write-Host "$CheckDate" -NoNewLine -ForegroundColor Yellow
    Write-Host " on " -NoNewLine
    Write-Host "$Server" -ForegroundColor Green -NoNewLine
    Write-Host "...`n`n" -NoNewLine
    Invoke-Command -ComputerName $Server -ScriptBlock {Get-Hotfix} | Where{$_.InstalledOn -ge "$CheckDate"} | Sort InstalledOn | Format-Table

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
                Write-Host "`nEnter the name of the server you wish to check updates for:"
                $Server = Read-Host
            }
            2{
                $Server = $Null
                $CheckDate = $Null
                Write-Host "Enter the name of the server you wish to check updates for:"
                $Server = Read-Host

                Write-Host "`nEnter the date you wish to check updates for. Date must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
                $CheckDate = Read-Host
            }
            3{
                $CheckDate = $Null
                Write-Host "`nEnter the date you wish to check updates for on " -NoNewLine
                Write-Host "$Server" -NoNewLine -ForegroundColor Green
                Write-Host ". `nDate must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
                $CheckDate = Read-Host "`nPlease enter date"
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
