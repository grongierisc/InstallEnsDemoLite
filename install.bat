::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@echo off

:: Parameter to modify
set IRIS_DIR="C:\InterSystems\IRIS"
set /p IRIS_DIR= "Please enter the path of the Intersystems IRIS directory [C:\InterSystems\IRIS] : "

set USERNAME="_SYSTEM"
set /p USERNAME= "Please enter your IRIS username [_SYSTEM] : "

set /p PASSWORD= "Please enter your password : "

:: Pre-configured variables
set BUILD_DIR=install\App
set NAMESPACE=USER

set XML_EXPORT_DIR=docs
set INSTALL_PACKAGE_NAME=App

set NAMESPACE_TO_CREATE=ENSDEMO
set SOURCE_DIR=src/CLS
set FRONT_DIR=src/CSP/csp/demo
set CSP_PATH="/csp/ensdemo"

:: Build and import application to IRIS
echo Importing project...
(
echo %USERNAME%
echo %PASSWORD%

echo zn "%NAMESPACE%" set st = $system.Status.GetErrorText($system.OBJ.ImportDir("%~dp0%BUILD_DIR%",,"ck",,1^^^)^^^) w "IMPORT STATUS: "_$case(st="",1:"OK",:st^^^), ! 
echo set pVars("NAMESPACE"^^^) = "%NAMESPACE_TO_CREATE%"
echo set pVars("SourceDir"^^^) = "%~dp0%SOURCE_DIR%"
echo set pVars("DirFront"^^^)= "%~dp0%FRONT_DIR%"

echo do ##class(App.Installer^^^).setup(.pVars^^^)
echo zn "%SYS"

echo set props("DeepSeeEnabled"^^^)=1
echo set sc=##class(Security.Applications^^^).Modify("%CSP_PATH%", .props^^^)

echo zn "%NAMESPACE_TO_CREATE%"
echo do $system.OBJ.ImportDir("%~dp0%SOURCE_DIR%","*.cls","cubk",.errors,1^^^)

) | "%IRIS_DIR%\bin\irisdb.exe" -s "%IRIS_DIR%\mgr" -U %NAMESPACE%

echo:
echo ... Done
timeout 2 >nul
