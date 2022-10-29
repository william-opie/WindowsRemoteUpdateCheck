# WindowsRemoteUpdateCheck
Simple script for checking installed Windows patches on remote servers

NOTES:
The script is currently setup to be run from a user account that has privileges to run Powershell commands on a remote server. There is no prompt to run the script from a different user account. I may create an alternate script with this option later; it should be a simple modification. (See Invoke-Command documentation: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/invoke-command?view=powershell-7.2)

HOW TO USE:
First select whether you want to search for installed patches on a single server at a time, or multiple servers.

Single Server Search Instructions:
==================================
When prompted for the server name, enter the name of the remote server you wish to check for installed updates on.

Next, enter the date you wish to check from. The script will check for updates installed on that date and afterwards.
Ex. If you enter 9/1/2022, the script will check for all Windows updates installed on 9/1/2022 to present.

After returning update results, you are then prompted to select one of the following options:
1. Check another server from the same date
2. Check another server from a different date
3. Check same server from a different date
4. Exit script
(When choosing an option, only the number of the desired selection needs to be entered (Ex. 3). No period or brackets are needed.)

Multi Server Search Instructions:
=================================
When prompted, input the file path for a .CSV with a list of the servers you want check. The server names should be recorded in a single column in the CSV, with no header column.

After inputting a valid .CSV, you will then be prompted to enter the date you wish to check from. The script will check for updates installed on that date and afterwards.
Ex. If you enter 9/1/2022, the script will check for all Windows updates installed on 9/1/2022 to present.

After selecting a date to check from, you will then be asked if you want to export the installed patch results to a .CSV. If you choose to export the results to .CSV, you will be prompted to enter a file path for exporting.

After choosing whether or not you would like to export the installed OS patch results, the tool then runs through the list of servers provided from the .CSV you input at the beginning. Once completed, you will be asked if you would like to search the entire list of servers again, but from a different date range. If you select no, the script will then exit.

PLANNED FUTURE UPDATES:
- Alt script that allows you to enter creds to run script on remote server from a different user account

Please feel free to send any comments, questions, or other feedback.
