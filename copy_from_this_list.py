##this script takes a list of items to copy and copies them to a destination directory; currently, the list must be in the same directory as the items to be copied

###########
##imports##
###########
import os
import sys
import shutil
import csv

#############################
##declaring input variables##
#############################
if len(sys.argv) < 5:
    print ("Error: there weren't enough input arguments")
    sys.exit(1)
the_args = sys.argv
lpath = the_args[1]
lisname = the_args[2]
dest = the_args[3]
affy_status = the_args[4] #will be a string

##############
##processing##
##############
if lisname.endswith(".csv"):
    with open(lpath+lisname) as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            if affy_status == "1": #may want to add more tests regarding whether the file exists
                try:
                    shutil.copyfile(lpath+row[0]+".ARR", dest+row[0]+".ARR")
                except:
                    print ("No ARR file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".CEL", dest+row[0]+".CEL")
                except:
                    print ("No CEL file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".DAT", dest+row[0]+".DAT")
                except:
                    print ("No DAT file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".GRD", dest+row[0]+".GRD")
                except:
                    print ("No GRD file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".AUDIT", dest+row[0]+".AUDIT")
                except:
                    print ("No AUDIT file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".JPG", dest+row[0]+".JPG")
                except:
                    print ("No JPG file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".mas5.CHP", dest+row[0]+".mas5.CHP")
                except:
                    print ("No mas5.CHP file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+"_Cel_summary.RPT", dest+row[0]+"_Cel_summary.RPT")
                except:
                    print ("No Cel_summary.RPT file for", lpath+row[0])
                    pass
                try:
                    shutil.copyfile(lpath+row[0]+".rma-gene-full.chp", dest+row[0]+".rma-gene-full.chp")
                except:
                    print ("No .rma-gene-full.chp file for", lpath+row[0])
                    pass
            else:
                shutil.copyfile(lpath+row[0],dest+row[0])
else:
    print ("This script doesn't yet accommodate the input file format")
    sys.exit(1)
