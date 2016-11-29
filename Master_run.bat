@echo off
title MasterRun of Java GUI
set spath=%1
set dpath=%2
set APS_src_filename=%3
set APS_norm_src_filename=%4
set project_ID=%5
set script_Path=%6
echo %script_Path%
C:\Python27\python.exe %script_Path%\gpsr_dup_catcher.py %spath% >%spath%\masterOutput.txt 2>%spath%\masterErrors.txt
C:\Python27\python.exe %script_Path%\array_data_extractor.py %spath% >>%spath%\masterOutput.txt 2>>%spath%\masterErrors.txt
echo "The audit file and the rescan catcher detected">>%spath%\masterOutput.txt
FC %spath%\AUDIT_info.txt %spath%\AUDIT_info_rescan_catcher.txt|find /v /c "">>%spath%\masterOutput.txt 2>>%spath%\masterErrors.txt
echo "differences. If this number is >0, note that there was a rescan that requires attention" >>%spath%\masterOutput.txt 2>>%spath%\masterErrors.txt
"C:\Program Files\R\R-3.3.2\bin\Rscript.exe" %script_Path%\1_APS_generator_master.R %spath% %dpath% %APS_src_filename% %project_ID% %APS_norm_src_filename% >>%spath%\masterOutput.txt 2>>%spath%\masterErrors.txt
REM pause
