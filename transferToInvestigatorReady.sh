#!/bin/bash
#Usage ./transferToInvestigatorReady.sh 549JR_Set3 scriptDirPath projectDirPath InvestigatorReadyPath
ProjID=$1
scriptDirPath=$2
projectDirPath=$3
InvestigatorReadyPath=$4
mkdir $InvestigatorReadyPath/$ProjID
mkdir $InvestigatorReadyPath/$ProjID/Data_Prep_QC 
mkdir $InvestigatorReadyPath/$ProjID/Genome
mkdir $InvestigatorReadyPath/$ProjID/Genome/Absolute_Data 
mkdir $InvestigatorReadyPath/$ProjID/Genome/AGCC
chmod -R 777 $InvestigatorReadyPath/$ProjID
chmod -R 777 $InvestigatorReadyPath/$ProjID/Data_Prep_QC 
chmod -R 777 $InvestigatorReadyPath/$ProjID/Genome
chmod -R 777 $InvestigatorReadyPath/$ProjID/Genome/Absolute_Data 
chmod -R 777 $InvestigatorReadyPath/$ProjID/Genome/AGCC
python $scriptDirPath/copy_from_this_list.py $projectDirPath/ samplist.csv $InvestigatorReadyPath/$ProjID/Genome/AGCC/ 1 >>$projectDirPath/masterOutput.txt 2>>$projectDirPath/masterErrors.txt
