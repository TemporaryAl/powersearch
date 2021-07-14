
#Use: Searchlogs.ps1 (-path) (-pattern) (-extension) 1/2/3(-context) BOOL(-giveoutput)

param(

  [Parameter(Mandatory=$false)][string]$path,
  [Parameter(Mandatory=$false)][string]$pattern,
  [Parameter(Mandatory=$false)][string]$extension,  
  [Parameter(Mandatory=$false)][ValidateRange(1,3)][int]$context,
  [Parameter(Mandatory=$false)][switch]$giveoutput

)

if ($path) {$Searchpath = $path} else {$Searchpath = Read-Host -Prompt 'Input the path where you want to search'}

if ($pattern) {$Searchpattern = $pattern} else {$Searchpattern = Read-Host -Prompt 'Input the pattern [regex] you want to search for'}

if ($extension) {$Searchextension = $extension} else {$Searchextension = Read-Host -Prompt 'Input the extension of the filetype you want to search into (accepts * as wildcard)'}

if ($context) {$null} else {while ((1,2,3) -notcontains $context) {$context = Read-Host -Prompt 'Input 1 for content-only search, 2 for filename-only or 3 for both'}}



$Filelist = @() #Files that match the search path and extension

$Isfilenamehitlist = @() #Sister array of $Filelist, where to each element of $Filelist will correspond a 1 if filename search is active and the filename matches

$HitFilelist = @() #Final resulting array



Get-ChildItem -Path ($Searchpath+"\*."+$Searchextension) -Recurse -Force | Foreach -Begin {$i=1} -Process  {$Filelist += "$_"; $Isfilenamehitlist += "0"; if (($context -gt 1) -AND ($_.ToString() -match $Searchpattern+"[\w,\.]*\.\w*\z")) {$Isfilenamehitlist[$i-1] = "1"} ; $i++;} -End $null #Search items that match the path and extension supplied and add them to Filelist, if filename matches are active and there is a pattern match with the filename, mark 1 in the same position of the sister array of whether each file is a filename match




if (-not ($giveoutput)) #If the user interactive script was selected (default choice)

{

  if ($context -ne 2) #If content search is enabled
  
  {
  
    "`n`nMatches by content:`n`n"
  
    $Filelist | Foreach -Begin {$i=0;$j=0} -Process  {if ($slsresult= sls $Searchpattern -LiteralPath $_ ) {$HitFilelist += "$_"; $i++; $i; $HitFilelist[$i-1]; $slsresult; $Isfilenamehitlist[$j] = 0} $j++ } -End $null #Search items inside of Filelist the contents of which match the [regex] pattern supplied, put them in Hitfilelist AND display the path and pattern matches of each, while removing them from the list of filename-only matches by marking 0 in the same position of the sister array of whether each file is a filename match

  }

  if ($context -ne 1) #If filename search is enabled

  {
  
    if ($context -eq 2) {"`n`nMatches by filename:`n`n"} else {"`n`nMatches only by filename:`n`n"}
  
    $Filelist | Foreach -Begin {$i=0} -Process  {if ($Isfilenamehitlist[$i] -eq 1) {$Hitfilelist.length+1; $Filelist[$i] ; $HitFilelist += "$_"; $Isfilenamehitlist[$i] = 0} $i++ } -End $null #Search items inside of Filelist the filename of which matches the [regex] pattern supplied, put them in Hitfilelist AND display the path of each (just for safety also set their bit in the correspondent sister array to 0)

  }

  "`n`n"



  if ($Hitfilelist) #If there are matching files

  {
  
    [int]$Filetoopen = Read-Host -Prompt 'Type the number of the file to open and then enter to open it, or 0 and then enter to close' #Ask if the user wants to open one or quit

    if ($Filetoopen -gt 0) {Invoke-Item $Hitfilelist[$Filetoopen-1]} #Open the selected file from Hitfilelist, or quit

  }

  else {Read-Host -Prompt 'No results were found, press enter to close'} #Otherwise if there are no results, tell the user and quit

  return #Exit the user interactive scrpit

}



else #If the non-user interactive script was selected



{

  if ($context -ne 2) #If content search is enabled

  {

    $Filelist | Foreach -Begin {$i=0} -Process  {if ($slsresult= sls $Searchpattern -LiteralPath $_ ) {$HitFilelist += "$_";$Isfilenamehitlist[$i] = 0} $i++ } -End $null #Search items inside of Filelist that match the [regex] pattern supplied and put them in Hitfilelist, but do not display anything, while removing them from the list of filename-only matches by marking 0 in the same position of the sister array of whether each file is a filename match

  }

  if ($context -ne 1) #If filename search is enabled

  {

    $Filelist | Foreach -Begin {$i=0} -Process  {if ($Isfilenamehitlist[$i] -gt 0) {$HitFilelist += "$_"; $Isfilenamehitlist[$i] = 0} $i++ } -End $null #Search items inside of Filelist the filename of which matches the [regex] pattern supplied, put them in Hitfilelist, but do not display anything (just for safety also set their bit in the correspondent sister array to 0)

  }
  
  return $Hitfilelist #Return the array of complete filepaths of all the files that got a match as output of the script
      
}
   