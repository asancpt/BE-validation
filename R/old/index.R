
df_sNCA <- function(df) {
  df <- as.data.frame(df)
  NonCompart::sNCA(x = df[, colTime], y = df[, colConc])
}

df_txtNCA <- function(df) {
  df <- as.data.frame(df)
  suppressWarnings(ncar::txtNCA(x = df[, colTime], y = df[, colConc]))
}

library(tidyverse)
library(ncar)

key <- c('SUBJ', 'GRP', 'PRD', 'TRT')
colTime <- 'TIME'
colConc <- 'CONC'

concData <- read.csv('Conc.csv')
head(concData)

conc_single <- concData %>% 
  dplyr::group_by_(.dots = key) %>% 
  tidyr::nest() %>% 
  as.data.frame() %>% 
  dplyr::mutate(sNCA = purrr::map(data,  df_sNCA)) %>% 
  dplyr::mutate(txtNCA = purrr::map(data, df_txtNCA))

fileName="Temp-NCA.rtf"; 

key=c('SUBJ', 'GRP', 'PRD', 'TRT'); colTime="TIME"; colConc="CONC"; 
dose=0; adm="Extravascular"; dur=0; doseUnit="mg"; timeUnit="h";
concUnit="ug/L"; down="Linear"; MW=0

conc_nca <- tblNCA(as.data.frame(concData), key = key, colTime = colTime, 
                   colConc = colConc, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, 
                   timeUnit=timeUnit, concUnit=concUnit, down=down, MW=MW)

write_csv(conc_nca, "data/results_nca.csv")


########################## WORKS FINE ABOVE ################################

# 1. Mock data: Conc.csv ----

#rtfBE('Conc.rtf', 
#      concData = concData, key = key, colTime = colTime, colConc = colConc)


# BE::be2x2(concData = concData, key = key, colTime = colTime, colConc = colConc)

# rtfBE ----



rtfBE = function(fileName="Temp-NCA.rtf", concData, 
                 key=c('SUBJ', 'GRP', 'PRD', 'TRT'), colTime="TIME", colConc="CONC", 
                 dose=0, adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h",
                 concUnit="ug/L", down="Linear", MW=0)
{
  conc_single <- concData %>% 
    dplyr::group_by_(.dots = key) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(sNCA = purrr::map(data, df_sNCA)) %>% 
    dplyr::mutate(txtNCA = purrr::map(data, df_txtNCA))
  
  conc_nca <- tblNCA(as.data.frame(concData), key = key, colTime = colTime, 
                     colConc = colConc, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, 
                     timeUnit=timeUnit, concUnit=concUnit, down=down, MW=MW)
  
  write.csv(conc_nca, "results_nca.csv", quote=FALSE, row.names=FALSE)
  
  #results_be <- be2x2("results_nca.csv", c("AUCLST", "CMAX", "TMAX"))
  conc_nca_csv <- read.csv('results_nca.csv', as.is = TRUE)
  plot2x2png(conc_nca_csv, 'AUCLST')
  plot2x2png(conc_nca_csv, 'CMAX')
  plot2x2png(conc_nca_csv, 'TMAX')
  
  #  require(rtf)
  rtf = RTF(fileName)
  addHeader(rtf, title="Bioequivalence Test and Individual Noncompartmental Analysis Result")
  addNewLine(rtf)
  addHeader(rtf, "Table of Contents")
  addTOC(rtf)
  setFontSize(rtf, font.size=10)
  addPageBreak(rtf)
  
  addHeader(rtf, title="Bioequivalence Test Result", TOC.level=1)
  addHeader(rtf, title="AUClast", TOC.level=2)
  results_be_sub <- capture.output(results_be[[1]])
  for (j in 1:length(results_be_sub)) addParagraph(rtf, results_be_sub[j])
  addPng(rtf, 'AUCLST-equivalence.png', width = 7, height = 7)
  addPng(rtf, 'AUCLST-box.png', width = 7, height = 7)
  addPageBreak(rtf)
  
  addHeader(rtf, title="Cmax", TOC.level=2)
  results_be_sub <- capture.output(results_be[[2]])
  for (j in 1:length(results_be_sub)) addParagraph(rtf, results_be_sub[j])
  addPng(rtf, 'CMAX-equivalence.png', width = 7, height = 7)
  addPng(rtf, 'CMAX-box.png', width = 7, height = 7)
  addPageBreak(rtf)
  
  addHeader(rtf, title="Tmax", TOC.level=2)
  results_be_sub <- capture.output(results_be[[3]])
  for (j in 1:length(results_be_sub)) addParagraph(rtf, results_be_sub[j])
  addPng(rtf, 'TMAX-equivalence.png', width = 7, height = 7)
  addPng(rtf, 'TMAX-box.png', width = 7, height = 7)
  addPageBreak(rtf)
  
  addHeader(rtf, title="Individual Noncompartmental Analysis Result", TOC.level=1)
  maxx = max(concData[,colTime])
  maxy = max(concData[,colConc])
  miny = min(concData[concData[,colConc]>0,colConc])
  
  for (n in 1:nrow(conc_single)){
    addPageBreak(rtf)
    conc_single_n <- conc_single %>% dplyr::slice(n)
    conc_single_n_data <- as.data.frame(conc_single_n$data[[1]])
    
    x <- conc_single_n_data[, colTime]
    y <- conc_single_n_data[, colConc]
    tabRes <- conc_single_n$sNCA[[1]]
    tRes <- conc_single_n$txtNCA[[1]]
    subj_header <- sprintf('SUBJ %s, GRP %s, PRD %s, TRT %s', 
                           conc_single_n$SUBJ, conc_single_n$GRP,
                           conc_single_n$PRD, conc_single_n$TRT)
    addHeader(rtf, subj_header, TOC.level=2)
    for (j in 1:length(tRes)) addParagraph(rtf, tRes[j])
    
    addPageBreak(rtf)
    addHeader(rtf, subj_header)
    addPlot(rtf, plot.fun=plot, width=6, height=4, res=300, x=x, y=y, type="b", cex=0.7,
            xlim=c(0,maxx), ylim=c(0,maxy),
            xlab=paste0("Time (", timeUnit, ")"), ylab=paste0("Concentration (", concUnit, ")"))
    addPlot(rtf, plot.fun=Plot4rtf, width=6, height=4, res=300, x=x, y=y, type="b", cex=0.7,
            xlim=c(0, maxx), ylim=c(miny, maxy),
            xlab=paste0("Time (", timeUnit, ")"), ylab=paste0("Concentration (log interval) (", concUnit, ")"), tabRes=tabRes)
  }
  done(rtf)
}

plot2x2png = function(bedata, Var)
{
  if(!assert(bedata)) {
    cat("\n Subject count should be balanced!\n");
    return(NULL);
  }
  
  Si11 = bedata[bedata$GRP=="RT" & bedata$PRD==1, "SUBJ"]
  Si21 = bedata[bedata$GRP=="RT" & bedata$PRD==2, "SUBJ"]
  Si12 = bedata[bedata$GRP=="TR" & bedata$PRD==1, "SUBJ"]
  Si22 = bedata[bedata$GRP=="TR" & bedata$PRD==2, "SUBJ"]
  
  Yi11 = bedata[bedata$GRP=="RT" & bedata$PRD==1, Var]
  Yi21 = bedata[bedata$GRP=="RT" & bedata$PRD==2, Var]
  Yi12 = bedata[bedata$GRP=="TR" & bedata$PRD==1, Var]
  Yi22 = bedata[bedata$GRP=="TR" & bedata$PRD==2, Var]
  
  n1 = length(Yi11)
  n2 = length(Yi12)
  
  Y.11 = mean(Yi11)
  Y.21 = mean(Yi21)
  Y.12 = mean(Yi12)
  Y.22 = mean(Yi22)
  
  sY.11 = sd(Yi11)
  sY.21 = sd(Yi21)
  sY.12 = sd(Yi12)
  sY.22 = sd(Yi22)
  
  y.max = max(Y.11 + sY.11, Y.21 + sY.21, Y.12 + sY.12, Y.22 + sY.22, max(bedata[,Var])) * 1.2
  png(sprintf('%s-equivalence.png', Var), width = 960, height = 960)
  par(oma=c(1,1,3,1), mfrow=c(2,2))
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Period",  ylab=Var, main="(a) Individual Plot for Period")
  axis(2)
  axis(1, at=c(1,2))
  drawind(Yi11, Yi21, Yi12, Yi22, Si11, Si12)
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Treatment",  ylab=Var, main="(b) Individual Plot for Treatment")
  axis(2)
  axis(1, at=c(1,2), labels=c("Test", "Reference"))
  drawind(Yi21, Yi11, Yi12, Yi22, Si11, Si12)
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Period",  ylab=Var, main="(c) Mean and SD by Period")
  axis(2)
  axis(1, at=c(1,2))
  drawmeansd(Y.11, sY.11, Y.12, sY.12, Y.21, sY.21, Y.22, sY.22, y.max)
  
  plot(0, 0, type="n", ylim=c(0, y.max), xlim=c(0.5, 2.5), axes=FALSE, xlab="Treatment",  ylab=Var, main="(d) Mean and SD by Treatment")
  axis(2)
  axis(1, at=c(1,2), labels=c("Test", "Reference"))
  drawmeansd(Y.21, sY.21, Y.12, sY.12, Y.11, sY.11, Y.22, sY.22, y.max)
  
  mtext(outer=T, side=3, paste("Equivalence Plot for", Var), cex=1.5)
  dev.off()
  
  png(sprintf('%s-box.png', Var), width = 960, height = 960)
  par(oma=c(1,1,3,1), mfrow=c(2,2))
  
  boxplot(Yi11, Yi21, Yi12, Yi22, names=c("PRD=1", "PRD=2", "PRD=1", "PRD=2"), cex.axis=0.85, main="(a) By Sequence and Period", sub="SEQ=RT           SEQ=TR")
  boxplot(c(Yi11, Yi21), c(Yi12, Yi22), names=c("Sequence=RT", "Sequence=TR"), main="(b) By Sequence")
  boxplot(c(Yi11, Yi12), c(Yi21, Yi22), names=c("Period=1", "Period=2"), main="(c) By Period")
  boxplot(c(Yi12, Yi21), c(Yi11, Yi22), names=c("Treatment=T", "Treatment=R"), main="(d) By Treatment")
  mtext(outer=T, side=3, paste("Box Plots for", Var), cex=1.5)
  dev.off()
}
