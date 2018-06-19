# 0. setup ----

#install.packages(dplyr) # required by rtfBE()
#install.packages(purrr) # required by rtfBE()
#install.packages(tidyr) # required by rtfBE()

source('R/rtfBE.R')      # Generating the report document
source('R/plot2x2png.R') # Generating figure files

library(magrittr)
library(NonCompart)
library(ncar)
library(BE) # install.packages("BE", repos="http://r.acr.kr")

key <- c('SUBJ', 'GRP', 'PRD', 'TRT')
colTime <- 'TIME'
colConc <- 'CONC'

# 1. Mock data: Conc.csv ----

concData <- read.csv('Conc.csv')
head(concData)

rtfBE('Conc.rtf', 
      concData = concData, key = key, colTime = colTime, colConc = colConc)

