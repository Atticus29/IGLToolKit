##This script takes as input a csv file, which has been modified from the text file output of Affy's Expression Console program (you might have to manually remove the last row; I haven't satisfactorily resolved this program in a way that R can read the table yet). From this input, the script extracts a subset of, re-orders, and in a few cases calculates new columns, as an important step to automate for the IGL data processing pipeline##

##assumes by necessity that the python script has already parsed the affy data

##arguments are 1) original path,2) destination path, 3) name of APS txt file created by Expression or Genotyping Console ##can I pass arguments from a bash script to an Rscript?

##################
##load arguments##
##################

args = commandArgs(trailingOnly=TRUE)
print(args)
original_path = args[1] 
dpath = args[2] 
APS_src_filename = args[3]
project_ID = args[4]
APS_norm_src_filename = args[5]

#############
##libraries##
#############

require(data.table)
#############
##load data##
#############

print(paste(original_path,"/.RData", Sys.Date(), sep=""))
save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))
wsqc = fread(APS_src_filename, header=T)

##this stuff is hackey, before I figured out that you could use column names in data.table that had spaces, provided you used backticks instead of quotes to deal with them##
colnames(wsqc) = gsub("\ |-", ".", colnames(wsqc))
colnames(wsqc) = gsub("(", ".", colnames(wsqc), fixed=T)
colnames(wsqc) = gsub(")", ".", colnames(wsqc), fixed=T)
colnames(wsqc) = gsub("/", ".", colnames(wsqc), fixed=T)
colnames(wsqc) = gsub("%", "X", colnames(wsqc))
colnames(wsqc) = gsub(">", ".", colnames(wsqc), fixed=T)

##set key##
setkey(wsqc, File)
save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))

#######################################################
##Now figure out what kind of data are being analyzed##
#######################################################

audit_dt = fread(paste(original_path,"AUDIT_info.txt", sep="/"))
arr_dt = fread(paste(original_path,"ARR_info.txt", sep="/"))
array_type = as.character(audit_dt[1,Probe_Array_Type])

setwd(original_path)

######################
###go through cases###
######################

###############
###HGU 133 2###
###############
if (array_type == "HG-U133_Plus_2"){ ##needs to be modified
	print("got here HG-U133_Plus_2")
  	norm_method = "MAS5"
	rm(header_row)
	
	wsqcsub = wsqc[,.(FileNames = File, Array_Type = rep("NA",length(wsqc[,1,with=F])), Lot_Number=rep("NA",length(wsqc[,1,with=F])), Hyb_Date=rep("NA",length(wsqc[,1,with=F])), Scan_Date=rep("NA",length(wsqc[,1,with=F])), Noise=round(Noise.Avg,2), SF=round(SF,2), NF=round(NF,2), Background=round(BG.Avg,2),Corner=round(Corner..Avg,2), Percent_P=round(XP,2), Average_Signal_All=round(Signal.All.,2), Actin_Intensity_All= round(Housekeeping_AFFX.HSAC07.X00351_avg.signal,2), Actin_3p_5p_ratio=round(Housekeeping_AFFX.HSAC07.X00351_3.5.ratio,2), GAPDH_Intensity_All=round(Housekeeping_AFFX.HUMGAPDH.M33197_avg.signal,2), GAPDH_3p_5p_ratio= round(Housekeeping_AFFX.HUMGAPDH.M33197_3.5.ratio,2), BioB=round(Spike_AFFX.r2.Ec.bioB_avg.signal,2), BioC=round(Spike_AFFX.r2.Ec.bioC_avg.signal,2),BioD=round(Spike_AFFX.r2.Ec.bioD_avg.signal,2), CreX=round(Spike_AFFX.r2.P1.cre_avg.signal,2))]
	
	header_row = c("File Name", "Array Type","Lot Number", "Hyb. Date", "Scan Date", "Noise", "SF", "NF", "Background", "Corner", "% P", "Average Signal (All)", "Actin Intensity (All)", "Actin 3'/5' Ratio", "GAPDH Intensity (All)", "GAPDH 3'/5' Ratio", "BioB", "BioC", "BioD", "CreX")
}

#######################
##Rhesus Genome Array##
#######################
if (array_type == "Rhesus"){
	#You may have to go to the edit menu in expression console and click 3'Expression Report controls and add the controls you want. Favor the _at over _s or _x
        print("got here Rhesus")
	norm_method = "MAS5"
        rm(header_row)
        save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))

        wsqcsub = wsqc[,.(FileNames = File,Array_Type=rep("NA",length(wsqc[,1,with=F])), Lot_Number=rep("NA",length(wsqc[,1,with=F])), Hyb_Date=rep("NA",length(wsqc[,1,with=F])), Scan_Date=rep("NA",length(wsqc[,1,with=F])), Noise=round(Noise.Avg,2), SF=round(SF,2), NF=round(NF,2), Background=round(BG.Avg,2), Corner = round(Corner..Avg,2), Percent_P=round(XP,2), Average_Signal=round(Signal.All.,2), Actin_Intensity_All=round(Housekeeping_AFFX.Mmu.actin_avg.signal,2), Actin_3p_5p_ratio=round(Housekeeping_AFFX.Mmu.actin_3.5.ratio,2),  GAPDH_Intensity_All= round(Housekeeping_AFFX.Mmu.gapdh_avg.signal,2), GAPDH_3p_5p_ratio=round( Housekeeping_AFFX.Mmu.gapdh_3.5.ratio,2), BioB=round(Spike_AFFX.r2.Ec.bioB_avg.signal,2), BioC=round(Spike_AFFX.r2.Ec.bioC_avg.signal,2), BioD = round(Spike_AFFX.r2.Ec.bioD_avg.signal,2), CreX= round(Spike_AFFX.r2.P1.cre_avg.signal,2))]

        header_row = c("File Name", "Array Type", "Lot Number", "Hyb. Date", "Scan Date", "Noise", "SF", "NF", "Background", "Corner", "% P", "Average Signal", "Actin Intensity (All)", "Actin 3'/5' Ratio", "GAPDH Intensity (All)", "GAPDH 3'/5' Ratio", "BioB", "BioC", "BioD", "CreX")
}

##############
##Mouse430_2##
##############
if (array_type == "Mouse430_2"){
	print("got here Mouse430")
	norm_method = "MAS5"
	rm(header_row)
	save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))

	wsqcsub = wsqc[,.(FileNames = File, Lot_Number=rep("NA",length(wsqc[,1,with=F])), Hyb_Date=rep("NA",length(wsqc[,1,with=F])), Scan_Date=rep("NA",length(wsqc[,1,with=F])), Noise=round(Noise.Avg,2), SF=round(SF,2), NF=round(NF,2), Background=round(BG.Avg,2), Corner = round(Corner..Avg,2), Percent_P=round(XP,2), Average_Signal=round(Signal.All.,2), Actin_Intensity_All=round(Housekeeping_AFFX.b.ActinMur.M12481_avg.signal,2), Actin_3p_5p_ratio=round(Housekeeping_AFFX.b.ActinMur.M12481_3.5.ratio,2),  GAPDH_Intensity_All= round(Housekeeping_AFFX.GapdhMur.M32599_avg.signal,2), GAPDH_3p_5p_ratio=round(Housekeeping_AFFX.GapdhMur.M32599_3.5.ratio,2), BioB=round(Spike_AFFX.r2.Ec.bioB_avg.signal,2), BioC=round(Spike_AFFX.r2.Ec.bioC_avg.signal,2), BioD = round(Spike_AFFX.r2.Ec.bioD_avg.signal,2), CreX= round(Spike_AFFX.r2.P1.cre_avg.signal,2))]
	
	header_row = c("File Name", "Array Type", "Lot Number", "Hyb. Date", "Scan Date", "Noise", "SF", "NF", "Background", "Corner", "% P", "Average Signal", "Actin Intensity (All)", "Actin 3'/5' Ratio", "GAPDH Intensity (All)", "GAPDH 3'/5' Ratio", "BioB", "BioC", "BioD", "CreX")
}

###########
##HTA-2.0##
###########
if(array_type == "HTA-2_0"){
	print("got here HTA-2_0")
	norm_method = "RMA"
	rm(header_row)
	save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))
	wsqc_norm = fread(APS_norm_src_filename, header=T)

	colnames(wsqc_norm) = gsub("\ |-", ".", colnames(wsqc_norm))
	colnames(wsqc_norm) = gsub("(", ".", colnames(wsqc_norm), fixed=T)
	colnames(wsqc_norm) = gsub(")", ".", colnames(wsqc_norm), fixed=T)
	colnames(wsqc_norm) = gsub("/", ".", colnames(wsqc_norm), fixed=T)
	colnames(wsqc_norm) = gsub(">", ".", colnames(wsqc_norm), fixed=T)
	colnames(wsqc_norm) = gsub("%", "X", colnames(wsqc_norm))
	wsqcsub = wsqc[,.(FileNames = File, Array_Type = rep("NA",length(wsqc[,1,with=F])), Lot_Number=rep("NA",length(wsqc[,1,with=F])), Hyb_Date=rep("NA",length(wsqc[,1,with=F])),Scan_Date=rep("NA",length(wsqc[,1,with=F])),  Background=rep("NA",length(wsqc[,1,with=F])),All_ProbeSet_Mean_Log2 = round(all_probeset_mean,2), All_ProbeSet_RLE_Mean = round(all_probeset_rle_mean,2), Pos_vs_Neg_AUC = round(pos_vs_neg_auc,2), BioB = round(control..affx..bac_spike.AFFX.r2.Ec.bioB.5_at,2),BioC = round(control..affx..bac_spike.AFFX.r2.Ec.bioC.5_at,2), BioD = round(control..affx..bac_spike.AFFX.r2.Ec.bioD.5_at,2), CreX = round(control..affx..bac_spike.AFFX.r2.P1.cre.5_at,2))]
	##this was outside the for loop the first time...hopefully an artifact?
	wsqcsub[,Background := round(wsqc_norm[,bgrd_mean ],2)]
	header_row = c("File Name", "Array Type", "Lot Number", "Hyb. Date", "Scan Date", "Background", "Log2 All Probeset Mean", "All Probeset RLE Mean", "Pos. vs. Neg. AUC", "BioB", "BioC", "BioD", "CreX")
}
###############
##Mo Gene 1.0##
###############
if (array_type == "MoGene1"){
	print("got here MoGene")
  norm_method = "RMA"
	rm(header_row)

	wsqcsub = wsqc[,.(FileNames = File, Array_Type =rep("NA",length(wsqc[,1,with=F])), Lot_Number=rep("NA",length(wsqc[,1,with=F])), Hyb_Date=rep("NA",length(wsqc[,1,with=F])),Scan_Date=rep("NA",length(wsqc[,1,with=F])),  Background=rep("NA",length(wsqc[,1,with=F])),All_ProbeSet_Mean_Log2 = round(all_probeset_mean,2), All_ProbeSet_RLE_Mean = round(all_probeset_rle_mean,2), Pos_vs_Neg_AUC = round(pos_vs_neg_auc,2), BioB = round(rowMeans(wsqc[,.(bac_spike.AFFX.BioB.3_at, bac_spike.AFFX.BioB.5_at, bac_spike.AFFX.BioB.M_at)]),2),BioC = round(rowMeans(wsqc[,.(bac_spike.AFFX.BioC.3_at, bac_spike.AFFX.BioC.5_at)]),2), BioD = round(rowMeans(wsqc[, .(bac_spike.AFFX.BioDn.3_at, bac_spike.AFFX.BioDn.5_at)]),2), CreX = round(rowMeans(wsqc[, .(bac_spike.AFFX.CreX.5_at, bac_spike.AFFX.CreX.3_at)]),2))]
	
	##load background-containing, normalized file
	APS_norm_dt = fread(paste(original_path, gsub(".txt","",APS_src_filename, fixed=T),"_norm.txt",sep=""), header=T)
	wsqcsub [,Background = APS_norm_dt[,Background]] ##see whether I can do this and whether this is the name of the background values from the normalized data
	header_row = c("File Name", "Array Type", "Lot Number", "Hyb. Date", "Scan Date", "Background", "Log2 All Probeset Mean", "All Probeset RLE Mean", "Pos. vs. Neg. AUC", "BioB", "BioC", "BioD", "CreX")
}

####################
##GenomeWide SNP 6##
####################
if (array_type == "GenomeWideSNP"){
	print("got here GWSNP")
	rm(header_row)


	##this one requires us to look for the MAPD data as well; we need to agree to convention to name the MAPD file
	##load MAPD file
	wsmapd = APS_norm_dt = fread(file=paste(original_path, gsub(".txt","",APS_src_filename, fixed=T),"_MAPD.txt",sep=""), header=T)
	
	##clean the file names, which will eventually be used as the keys in the merge##
	wsqc[,file_name_cleaned := gsub('.CEL','',File)]
	wsmapd[,file_name_cleaned := gsub('.CN5.CNCHP','',File)]
	setkey(wsqc, file_name_cleaned)
	setkey(wsmapd, file_name_cleaned)
	
	##now merge them##
	wsqcmapd=merge(wsqc,wsmapd,all.x=TRUE)
	if((length(wsqc[,file_name_cleaned])==length(wsmapd[,file_name_cleaned])) & (length(wsqc[,file_name_cleaned]) ==length(wsqcmapd[,file_name_cleaned]))){
		wsqcmapdsub = wsqcmapd[,.(FileNames = file_name_cleaned, Bounds = Bounds.y, MAPD = MAPD, Bounds = Bounds.x, Contrast_QC = Contrast.QC, Contrast_QC_Random = Contrast.QC..Random., Contrast_QC_Nsp = Contrast.QC..Nsp., Contrast_QC_Sty = Contrast.QC..Sty., Contrast_QC_Nsp_Sty_Overlap = Contrast.QC..Nsp.Sty.Overlap., QC_Call_Rate = QC.Call.Rate, Computed_gender = Computed.Gender)]
		wsqc = wsqcmapd
		header_row = c("File Name", "Bounds MAPD", "MAPD", "Bounds QC", "Contrast QC", "Contrast QC Random", "Contrast QC Nsp", "Contrast QC Sty", "Contrast QC Nsp Sty Overlap", "QC Call Rate", "Computed Gender")
	} else{
		print ("Something went wrong; the same number of files were not contained in your source files and your merge. This means either that the file names are different or there weren't the same number of files")
	}
}

##############################################
##Some array-type independent data wrangling##
##############################################
save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))

wsqcsub[,Lot_Number := arr_dt[,Lot_Number]]
wsqcsub[,Hyb_Date := arr_dt[, Hyb_Date]]
wsqcsub[,Array_Type := audit_dt[, Probe_Array_Type]]

cMeans = c("Mean")
cSds = c("Standard deviation")
for (i in 2:ncol(wsqcsub)){
	if(is.numeric(wsqcsub[[i]])){
		#print("this happens")
		cMeans = c(cMeans, round(mean(wsqcsub[[i]]),2))
		cSds = c(cSds, round(sd(wsqcsub[[i]]),2))
	}else{
		cMeans = c(cMeans, "NA")
		cSds = c(cSds, "NA")
	}
}
save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))

cMeans_dt = as.data.table(t(as.data.table(cMeans)))
colnames(cMeans_dt) = colnames(wsqcsub)

cSds_dt = as.data.table(t(as.data.table(cSds)))
colnames(cSds_dt) = colnames(wsqcsub)

wsqcsub = rbind(wsqcsub, cMeans_dt, cSds_dt)

header_row = as.matrix(header_row)
header_row = t(header_row)

save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))

#####################################################
##save the data (with reader-friendly column names)##
#####################################################

##save the samplist.csv for the copy script
fnames_simplified_as_list=strsplit(wsqcsub$FileNames,".", fixed=T) #note that wsqcsub is a dataframe now because of rbind
xsub=lapply(fnames_simplified_as_list, function(e) e[1])
xsub=unlist(xsub)

write.table(xsub[1:(length(xsub)-2)], file=paste(dpath, "samplist.csv", sep="/"), sep=",", row.names=FALSE, col.names = F) #remove the last two entries because they are mean and SD

##save the APS table
Header_1 = paste(project_ID, array_type, Sys.Date(),sep=" ")
write.table(Header_1, file=paste(gsub(".txt","",APS_src_filename, fixed=T),"_processed.csv",sep=""), sep=",", col.names=F, row.names=F)
Header_2 = paste("Data generated using the Affymetrix Expression Console Software v. 1.4.1 and",norm_method," as the normalization algorithm",sep=" ")
write.table(Header_2, file=paste(gsub(".txt","",APS_src_filename, fixed=T),"_processed.csv",sep=""), sep=",", append=TRUE, col.names=F, row.names=F)
write.table(header_row, file=paste(gsub(".txt","",APS_src_filename, fixed=T),"_processed.csv",sep=""), sep=",", append=TRUE, col.names=F, row.names=F)
write.table(wsqcsub, file=paste(gsub(".txt","",APS_src_filename, fixed=T),"_processed.csv",sep=""), col.names=FALSE, sep=",", append =TRUE, row.names=F)
save.image(paste(original_path,"/.RData", Sys.Date(), sep=""))
