import re
import os
import io
import csv
import sys
import copy

###########################
##user-provided arguments##
###########################
the_args = sys.argv
spath = the_args[1] 

##############
##load files##
##############
x = os.listdir(spath)

###################
##compile regexes##
###################

#########
###ARR###
#########
AffyBarcode_query = re.compile('^.*AffyBarcode.*\d{20}(\d{7})\d{5}.*$')
WholeBarcode_query = re.compile('^.*AffyBarcode.*(\d{20}\d{7}\d{5}).*$')
PATAssignmentMethod_query = re.compile('^.*(PATAssignmentMethod).*$')
Hyb_Date_query = re.compile('^.*CreatedDateTime="(.*)".*$')

###########
###AUDIT###
###########
Fluidics_Station_ID_query = re.compile('^.*Station\sID=(.*)<.*$')
Fluidics_Module_ID_query = re.compile('^.*Module\sID=(.*)<.*$')
Fluidics_Protocol_query = re.compile('^.*Protocol=(.*)<.*$')
Scanner_Serial_Number_query = re.compile('^.*Scanner\sSerial\sNumber=(\d*)<.*$')
Probe_Array_Type_query = re.compile('^.*Probe\sArray\sType=(.*)<.*$')

#########################################
##filter to only the ARR or AUDIT files##
#########################################
ARR_files_only = [a for a in x if a.endswith(".ARR")]
AUDIT_files_only = [a for a in x if a.endswith(".AUDIT")]

##########################
##extract from ARR files##
##########################
arr_info = [[["File_Name", "Whole_Barcode", "Lot_Number", "Hyb_Date"]]]
for f in ARR_files_only:
    with io.open(spath + f, 'r', encoding='utf-16') as farr:
        farr_text = farr.readlines()
    current_row = []
    for i, line in enumerate(farr_text):
        try:
            current_row.append([f.split(".ARR")[0], str(WholeBarcode_query.search(line).group(1)),
                                AffyBarcode_query.search(line).group(1)])
        except:
            pass
        try:
            dummy = PATAssignmentMethod_query.search(line).group(1)
            current_row[0].append(Hyb_Date_query.search(farr_text[i + 1]).group(1))
            arr_info.append(current_row)
        except:
            pass

############################
##extract from AUDIT files##
############################
audit_info = [[["File_Name", "Fluidics_Station_ID", "Fluidics_Module_ID", "Fluidics_Protocol", "Scanner_Serial_Number",
                "Probe_Array_Type"]]]
rescanCather_master = [[["File_Name", "Fluidics_Station_ID", "Fluidics_Module_ID", "Fluidics_Protocol", "Scanner_Serial_Number",
                "Probe_Array_Type"]]]
for f in AUDIT_files_only:
    with io.open(spath + f, 'r', encoding='utf-16') as farr:
        farr_text = farr.readlines()
    current_row = [[f.split(".AUDIT")[0]]]
    rescanCatcher_ls = [[f.split(".AUDIT")[0]]]
    FSIDCounter = 0
    FModCounter = 0
    FProtCounter = 0
    ScannerSerCounter = 0
    ProbeArrayTypeCounter = 0
    for i, line in enumerate(farr_text):
        if FSIDCounter < 1:
            try:
                current_row[0].append(Fluidics_Station_ID_query.search(line).group(1))
                FSIDCounter += 1
            except:
                pass
        if FModCounter < 1:
            try:
                current_row[0].append(Fluidics_Module_ID_query.search(line).group(1))
                FModCounter += 1
            except:
                pass
        if FProtCounter < 1:
            try:
                current_row[0].append(Fluidics_Protocol_query.search(line).group(1))
                FProtCounter += 1
            except:
                pass
        if ScannerSerCounter < 1:
            try:
                current_row[0].append(Scanner_Serial_Number_query.search(line).group(1))
                ScannerSerCounter += 1
            except:
                pass
        if ProbeArrayTypeCounter < 1:
            try:
                current_row[0].append(Probe_Array_Type_query.search(line).group(1))
                ProbeArrayTypeCounter += 1
            except:
                pass
        if i == len(farr_text) - 1:
            audit_info.append(current_row)

    for i, line in enumerate(farr_text):
        try:
            rescanCatcher_ls[0].append(Fluidics_Station_ID_query.search(line).group(1))
        except:
            pass
        try:
            rescanCatcher_ls[0].append(Fluidics_Module_ID_query.search(line).group(1))
        except:
            pass
        try:
            rescanCatcher_ls[0].append(Fluidics_Protocol_query.search(line).group(1))
        except:
            pass
        try:
            rescanCatcher_ls[0].append(Scanner_Serial_Number_query.search(line).group(1))
        except:
            pass
        try:
            rescanCatcher_ls[0].append(Probe_Array_Type_query.search(line).group(1))
        except:
            pass
    if i == len(farr_text) - 1:
        rescanCather_master.append(rescanCatcher_ls)

###################
##save the output##
###################
with open(spath + "ARR_info.txt", 'wb') as f:
    writer = csv.writer(f, delimiter="\t", quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for r in arr_info:
        writer.writerow(r[0])  # +'\n'

with open(spath + "AUDIT_info.txt", 'wb') as f:
    writer = csv.writer(f, delimiter="\t", quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for r in audit_info:  # uniques
        writer.writerow(r[0])  # +'\n'

with open(spath + "AUDIT_info_rescan_catcher.txt", 'wb') as f:
    writer = csv.writer(f, delimiter="\t", quotechar='|', quoting=csv.QUOTE_MINIMAL)
    for r in rescanCather_master:  # uniques
        writer.writerow(r[0])  # +'\n'
