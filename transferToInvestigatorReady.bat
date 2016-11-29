@echo off
title transferToInvestigatorReady of Java GUI
#Usage ./transferToInvestigatorReady.sh 549JR_Set3 scriptDirPath projectDirPath InvestigatorReadyPath
set ProjID=%1
set scriptDirPath=%2
set projectDirPath=%3
set InvestigatorReadyPath=%4
mkdir %InvestigatorReadyPath%/%ProjID%
mkdir %InvestigatorReadyPath%/%ProjID%/Data_Prep_QC 
mkdir %InvestigatorReadyPath%/%ProjID%/Genome
mkdir %InvestigatorReadyPath%/%ProjID%/Genome/Absolute_Data 
mkdir %InvestigatorReadyPath%/%ProjID%/Genome/AGCC
C:\Python27\python.exe %scriptDirPath%/copy_from_this_list.py %projectDirPath%/ samplist.csv %InvestigatorReadyPath%/%ProjID%/Genome/AGCC/ 1 >>%projectDirPath%/masterOutput.txt 2>>%projectDirPath%/masterErrors.txt
pause
