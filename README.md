# WindowsRemoteUpdateCheck
Simple script for checking installed Windows patches on remote servers

NOTES:
The script is currently setup to be run from a user account that has privileges to run Powershell commands on a remote server. There is no prompt to run the script from a different user account. I may create an alternate script with this option later; it should be a simple modification. (See Invoke-Command documentation: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7.2)

HOW TO USE:
When prompted for the server name, enter the name of the remote server you wish to check for installed updates on.

Next, enter the date you wish to check from. The script will check for updates installed on that date and afterwards.
Ex. If you enter 9/1/2022, the script will check for all Windows updates installed on 9/1/2022 to present.

After returning update results, you are then prompted to check for updates on another remote server. The script currently uses the same date entered at the beginning for this subsequent check. I will likely add an option later that allows you to change the date (if desired), but for now the idea is that you would be using this script to check the patch status on multiple servers from the same date (ex. making sure your servers installed the latest "Patch Tuesday" update).

PLANNED FUTURE UPDATES:
- Option to change date on successive update checks
- Option to export results to CSV
- Option to check multiple servers (Ex. Use a .CSV with server names as input)
- Alt script that allows you to enter creds to run script on remote server from a different user account

Please feel free to send any comments, questions, or other feedback.
