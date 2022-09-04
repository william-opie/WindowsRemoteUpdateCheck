Clear-Host
Write-Host "Enter the name of the server you wish to check updates for:"
$Server = Read-Host

Write-Host "`nEnter the date you wish to check updates for. Date must be written in the following format: Month/Day/Year `n(Ex.: 8/31/2022, 12/2/2021)"
$CheckDate = Read-Host

While($true){
    #Clear-Host
    Write-Host "`n`nChecking for installed updates from " -NoNewLine 
    Write-Host "$CheckDate" -NoNewLine -ForegroundColor Yellow
    Write-Host " on " -NoNewLine
    Write-Host "$Server" -ForegroundColor Green -NoNewLine
    Write-Host "...`n`n" -NoNewLine
    Invoke-Command -ComputerName $Server -ScriptBlock {Get-Hotfix} | Where{$_.InstalledOn -ge "$CheckDate"} | Sort InstalledOn

    DO{
        Write-Host "`nCheck another server? Y/N"
        $LoopBack = Read-Host
        Switch($LoopBack)
        {
            Y{
                $Server = $Null
                Write-Host "`nEnter the name of the server you wish to check updates for:"
                $Server = Read-Host
            }
            N{
                Write-Host "`nExiting script..." -ForegroundColor Red
                Start-Sleep -Seconds 3
                Exit
            }
            Default{
                Write-Host "`nInvalid input. Try again" -BackgroundColor Red -ForegroundColor White
            }
        }
    }Until($LoopBack -like "[y/n]")
}