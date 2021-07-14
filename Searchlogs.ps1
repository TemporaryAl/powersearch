$Searchpattern = Read-Host -Prompt 'Input the pattern you want to search for in the logs'
Get-ChildItem -Path "c:\users\username\desktop\srb*\*.txt" -Recurse -Force | sls $Searchpattern
Read-Host -Prompt 'Press enter to close...'
