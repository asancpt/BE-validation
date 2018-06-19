rtfBE = function(fileName="Temp-NCA.rtf", concData, 
                 key=c('SUBJ', 'GRP', 'PRD', 'TRT'), colTime="TIME", colConc="CONC", 
                 dose=0, adm="Extravascular", dur=0, doseUnit="mg", timeUnit="h",
                 concUnit="ug/L", down="Linear", MW=0)
{
  df_sNCA <- function(df) {
    df <- as.data.frame(df)
    NonCompart::sNCA(x = df[, colTime], y = df[, colConc])
  }
  
  df_txtNCA <- function(df) {
    df <- as.data.frame(df)
    suppressWarnings(ncar::txtNCA(x = df[, colTime], y = df[, colConc]))
  }
  
  conc_single <- concData %>% 
    dplyr::group_by_(.dots = key) %>% 
    tidyr::nest() %>% 
    dplyr::mutate(sNCA = purrr::map(data, df_sNCA)) %>% 
    dplyr::mutate(txtNCA = purrr::map(data, df_txtNCA))
  
  conc_nca <- tblNCA(as.data.frame(concData), key = key, colTime = colTime, 
                     colConc = colConc, dose=dose, adm=adm, dur=dur, doseUnit=doseUnit, 
                     timeUnit=timeUnit, concUnit=concUnit, down=down, MW=MW)
  
  write.csv(conc_nca, "results_nca.csv", quote=FALSE, row.names=FALSE)
  results_be <- be2x2("results_nca.csv", c("AUCLST", "CMAX", "TMAX"), Plot = FALSE)
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
