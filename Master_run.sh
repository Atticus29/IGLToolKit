#!/bin/bash

##arguments
spath=$1
dpath=$2
APS_src_filename=$3
APS_norm_src_filename=$4
project_ID=$5
script_Path=$6

##scripts
/usr/local/bin/python2 $script_Path/gpsr_dup_catcher.py $spath >$spath/masterOutput.txt 2>$spath/masterErrors.txt
/usr/local/bin/python2 $script_Path/array_data_extractor.py $spath >>$spath/masterOutput.txt 2>>$spath/masterErrors.txt
echo "The audit file and the rescan catcher detected" `diff $spath/AUDIT_info.txt $spath/AUDIT_info_rescan_catcher.txt|wc -l` "differences. If this number is >0, note that there was a rescan that requires attention" >>$spath/masterOutput.txt 2>>$spath/masterErrors.txt
/usr/local/bin/Rscript $script_Path/1_APS_generator_master.R $spath $dpath $APS_src_filename $project_ID $APS_norm_src_filename >>$spath/masterOutput.txt 2>>$spath/masterErrors.txt
#Rscript middle_SB_for_knit.R $spath/$project_ID $investigator_txt_filename $MDS_use $project_ID $dpath $Array_type $Annotation_file_path $Helper_functions_path $Functions_path "$Project_title" >>$spath/masterOutput.txt 2>>$spath/masterErrors.txt
