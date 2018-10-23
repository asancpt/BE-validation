# 0. setup ----

library(BE) # install.packages("BE", repos="http://r.acr.kr")

knitr::kable(head(NCAResult4BE))

BE::test2x2(NCAResult4BE, "AUClast")
BE::test2x2(NCAResult4BE, "Cmax")
BE::test2x2(NCAResult4BE, "Tmax")

# BE::be2x2(NCAResult4BE, c("AUClast", "Cmax", "Tmax"), rtfName="docs/report.rtf")
