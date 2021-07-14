# powersearch
Tool to search patterns in files with powershell

## Purpose
This was mainly made so I could search inside the gameplay session log files of a game I play, and turned out to be I guess a bit of practice with powershell.

You, however, can use this to look for a specific pattern inside of ***any*** files (including their names, if you'd like) that Windows can open and search the contents of (so .txt are fine, .pdf not quite).

## Usage
``` #powersearch.ps1 (-path) (-pattern) (-extension) 1/2/3(-context) BOOL(-giveoutput)```

The standard mode is an user-interactive mode, which lists your results at the end and allows you to open one.
If supplied all of its parameters, though, this can run without user input at all.

Parameter|Accepted input
---------|--------------
-path| Path to the folder you want the search to start in.
-pattern| The pattern (as a [regex](https://en.wikipedia.org/wiki/Regular_expression)) you want to be searched.
-extension| The extension of the files to search. Accepts * as a wildcard for partial/complete extension.
-context| Use 1 for content-only search, 2 for filename-only and 3 for both.
-giveoutput| (Boolean) If true, the script will not list the found results and ask if the user wants to open one. Instead, it will group them all in an array and return it as output.



