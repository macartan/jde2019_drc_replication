# Make a village level dataset for spillovers analysis

villmeans <- cdcdata

# This function takes a default dataset `villmeans` and adds in aggregated .outcome data from .data
add.villmean <- function(.data, .outcome, vdata = villmeans, newname = NULL) {
  if(!is.null(newname)) {names(.data)[names(.data) == .outcome] <- newname; .outcome <- newname}
  D2 <- aggregate(.data[c("IDV", .outcome)], by=list(.data$IDV), FUN="mean", na.rm=TRUE)
  out <- merge(vdata, D2, by.x = "IDV", by.y = "IDV", all.x = TRUE)
  out <- subset(out, select = -c(Group.1))
  return <- out     
}

# CAPTURE
villmeans <- add.villmean(.data = vill, .outcome = "da109_not_verifiable")
head(villmeans)

villmeans <- add.villmean(.data = ind, .outcome = "qr026i_fund_misuse")
head(villmeans)
dim(villmeans)

villmeans <- add.villmean(.data = ind[ind$RA==1,], .outcome = "qr2830_list_experiment", newname ="LIST_RA_1")
villmeans <- add.villmean(.data = ind[ind$RA==0,], .outcome = "qr2830_list_experiment", newname ="LIST_RA_0")

# Clean up interactions -- Impute means where one side has data present
villmeans <- within(villmeans, LIST_RA_1[is.na(LIST_RA_1) & !is.na(LIST_RA_0)] <- mean(LIST_RA_1, na.rm = TRUE))
villmeans <- within(villmeans, LIST_RA_0[is.na(LIST_RA_0) & !is.na(LIST_RA_1)] <- mean(LIST_RA_0, na.rm = TRUE))
villmeans$LIST_RA <- villmeans$LIST_RA_1 - villmeans$LIST_RA_0
villmeans <- subset(villmeans, select = -c(LIST_RA_1,LIST_RA_0))

# villmeans <- add.villmean(.data = ABD_INDIV_PROP, .outcome = "proportion_benef")  
villmeans <- add.villmean(.data = vill, .outcome = "stdev_benefits")
villmeans <- add.villmean(.data = ind[ind$CHIEF==1,], .outcome = "Correct_D_projet", newname ="Right1_Chief")
villmeans <- add.villmean(.data = ind[ind$CHIEF==0,], .outcome = "Correct_D_projet", newname ="Right1_Civ")

# INTERACTIONS
villmeans <- within(villmeans, Right1_Chief[is.na(Right1_Chief) & !is.na(Right1_Civ)] <- mean(Right1_Chief, na.rm = TRUE))
villmeans <- within(villmeans, Right1_Civ[is.na(Right1_Civ) & !is.na(Right1_Chief)] <- mean(Right1_Civ, na.rm = TRUE))

villmeans$Right1 <- villmeans$Right1_Civ - villmeans$Right1_Chief
villmeans <- subset(villmeans, select = -c(Right1_Civ,Right1_Chief))

# MECHANISMS
villmeans <- add.villmean(.data = vill, .outcome = "PART_A1")
villmeans <- add.villmean(.data = vill, .outcome = "N_INTERV")
villmeans <- add.villmean(.data = vill, .outcome = "MALE_DOM")
villmeans <- add.villmean(.data = vill, .outcome = "MFI_SELECTION")
villmeans <- add.villmean(.data = vill,  .outcome = "MFI_COMPOSITION")
villmeans <- add.villmean(.data = vill, .outcome = "MFI_MECHANISMS")
villmeans <- add.villmean(.data = ind, .outcome = "MFI_COMPLAINTS")
villmeans <- add.villmean(.data  = ind, .outcome = "qr002CORRECT")
villmeans <- add.villmean(.data = ind, .outcome = "qi003_accept")
villmeans <- add.villmean(.data = vill, .outcome = "MFI_ACCOUNTING")


dim(villmeans)
head(villmeans)
summary(villmeans)  
summary(villmeans[villmeans$RAPID==1,])  

villmeans2 <- villmeans[,c(1, 8:22)]
gpsvars    <- names(villmeans2)[-1]


