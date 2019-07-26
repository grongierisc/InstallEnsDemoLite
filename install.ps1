#####################################################################
# Script d'installation
#
# For example:
# ./livrable.ps1 
#####################################################################

function DoSomething{
  [CmdletBinding()]
  param(
      [Parameter(Position=0,mandatory=$true)]
      [string] $Instance,
      [Parameter(Position=1,mandatory=$true)]
      [SecureString] $password)

  process{

$Dir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.\')

$ClassImportDir=$Dir+"/install"
NameSpace$="ENSDEMO"
$CspPath="/csp/ensdemo"
$SrcDir=$Dir+"/src"

$passwordText =  [System.Net.NetworkCredential]::new('', $password).Password

Write-Output "Root : " $Dir 

$x = @"
SuperUser 
$passwordText
do `$system.OBJ.ImportDir("$ClassImportDir","*.cls","cubk",.errors,1)
write "Complation de l'installer done"  
Set pVars("DirBin")="$DIR/$NameSpace"  
Set pVars("NAMESPACE")="$NameSpace" 
Do ##class(App.Installer).setup(.pVars)  
zn "%SYS"  

set props("DeepSeeEnabled")=1 
set sc=##class(Security.Applications).Modify("$CspPath", .props)   

zn "$NameSpace"  
do `$system.OBJ.ImportDir("$SrcDir","*.cls","cubk",.errors,1)  

halt
"@ ##| Irissession $Instance -U USER  

Get-Variable $x | Irissession $Instance -U USER 
}
}

DoSomething
