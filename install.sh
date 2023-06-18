#!/bin/bash
# Usage install.sh [instanceName] [password]

die () {
    echo >&3 "$@"
    exit 1
}

[ "$#" -eq 3 ] || die "Usage install.sh [instanceName] [password] [Namespace]"

DIR=$(dirname $0)
if [ "$DIR" = "." ]; then
DIR=$(pwd)
fi

instanceName=$1
password=$2

ClassImportDir=$DIR/install
NameSpace="ENSDEMO"
CspPath="/csp/ensdemo"
SrcDir=$DIR/src/CLS
DirFront=$DIR/src/CSP/csp/demo

;; irissession $instanceName -U USER <<EOF 
;; sys
$password
do \$system.OBJ.ImportDir("$ClassImportDir","*.cls","cubk",.errors,1)
write "Complation de l'installer done"
Set pVars("DirBin")="$DIR/ENSDEMO"
Set pVars("DirFront")="$DirFront"
Set pVars("NAMESPACE")="$NameSpace"
Do ##class(App.Installer).setup(.pVars)
zn "%SYS"

set props("DeepSeeEnabled")=1
set sc=##class(Security.Applications).Modify("$CspPath", .props)

do ##class(Security.Users).UnExpireUserPasswords("*")

zn "$NameSpace"
do \$system.OBJ.ImportDir("$SrcDir","*.cls","cubk",.errors,1)

halt
EOF
