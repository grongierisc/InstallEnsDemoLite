#!/bin/bash
# Usage remove.sh [instanceName] [password]

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 2 ] || die "Usage remove.sh [instanceName] [password]"

DIR=$(dirname $0)
if [ "$DIR" = "." ]; then
DIR=$(pwd)
fi

instanceName=$1
password=$2

tClassImportDir=$DIR/install

irissession $instanceName -U %SYS <<EOF 
SuperUser
$password

Set NsEiste = ##class(Config.Namespaces).Exists("ENSDEMO")
do:(NsEiste) ##class(Config.Namespaces).Delete("ENSDEMO")
do:(NsEiste) ##class(%Library.EnsembleMgr).DisableNamespace("ENSDEMO")

set CspExiste = ##Class(Security.Applications).Exists("/csp/ensdemo")
do:(CspExiste) ##Class(Security.Applications).Delete("/csp/ensdemo")

set DbExiste = ##class(Config.Databases).Exists("ENSDEMO")
set Directory = ##class(Config.Databases).GetDirectory("ENSDEMO")
do:(DbExiste) ##class(Config.Databases).Delete("ENSDEMO")
do ##class(SYS.Database).DeleteDatabase(Directory)

halt
EOF

