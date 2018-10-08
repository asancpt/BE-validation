# 0. setup ----

library(BE) # install.packages("BE", repos="http://r.acr.kr")

head(NCAResult4BE)

BE::be2x2(NCAResult4BE, c("AUClast", "Cmax", "Tmax"), rtfName="")

BE::be2x2(NCAResult4BE, c("AUClast", "Cmax", "Tmax"), rtfName="docs/report.rtf")
