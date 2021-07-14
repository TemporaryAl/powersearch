#Use: Searchlogs.ps1 (-path) (-pattern) (-extension) (-giveoutputarray)
#The pattern matches regular expressions (regex); the extension is, for example, simply "txt" (no need for the quotes);
#The giveoutput switch turns the script from an user-interactable mode where you can open files with search hits into a script that simply gives an array of the files with hits as output

param(

  [Parameter(Mandatory=$false)][string]$path,
  [Parameter(Mandatory=$false)][string]$pattern,
  [Parameter(Mandatory=$false)][string]$extension,
  [Parameter(Mandatory=$false)][switch]$giveoutputarray

)

if ($path) {$Searchpath = $path} else {$Searchpath = Read-Host -Prompt 'Input the path where you want to search'}

if ($pattern) {$Searchpattern = $pattern} else {$Searchpattern = Read-Host -Prompt 'Input the pattern [regex] you want to search for'}

if ($extension) {$Searchextension = $extension} else {$Searchextension = Read-Host -Prompt 'Input the extension of the filetype you want to search into'}

$Filelist = @()

Get-ChildItem -Path ($Searchpath+"\*."+$Searchextension) -Recurse -Force | Foreach -Begin {$i=1} -Process  {$Filelist += "$_"}  {$i++} -End $null

$HitFilelist = @()

if (-not ($giveoutputarray)) 

{

  $Filelist | Foreach -Begin {$i=0;$j=0} -Process  {if ($slsresult= sls $Searchpattern $_ ) {$HitFilelist += "$_"; $j++; $j; $HitFilelist[$j-1]; $slsresult} } {$i++} -End $null

  [int]$Filetoopen = Read-Host -Prompt 'Type the number of the file to open and then enter to open it, or 0 and then enter to close'

  if ($Filetoopen -gt 0) {Invoke-Item $Hitfilelist[$Filetoopen-1]}

}

else 

{

  $Filelist | Foreach -Begin {$i=0;$j=0} -Process  {if ($slsresult= sls $Searchpattern $_ ) {$HitFilelist += "$_"; $j++;} } {$i++} -End $null
  
  return $Hitfilelist
  
}