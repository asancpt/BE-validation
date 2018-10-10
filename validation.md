Validation of Bioequivalence Test Performed by BE R package
================
Sungpil Han <shan@acp.kr>
2018-10-10



# Introduction

BE R package (Bae 2018) can conduct a noncompartmental analysis as
similar as possible to the most widely used commercial software for
pharmacokinetic analysis, i.e. [Phoenix<sup>®</sup>
WinNonlin<sup>®</sup>](https://www.certara.com/software/pkpd-modeling-and-simulation/phoenix-winnonlin/).
This document provides validation of noncompartmental analysis performed
by BE R package version 0.1.1 as compared to the results from the
commercial software, SAS<sup>®</sup> version 9.4.

# Results

A function, `Equal()` will return `TRUE` if there is no difference
between results from NonCompart and
    WinNonlin.

``` r
library(BE) # install.packages("BE", repos="http://r.acr.kr")
```

    ## Loading required package: rtf

``` r
library(tidyverse)
```

    ## -- Attaching packages ---------------------------------- tidyverse 1.2.1 --

    ## √ ggplot2 3.0.0     √ purrr   0.2.5
    ## √ tibble  1.4.2     √ dplyr   0.7.6
    ## √ tidyr   0.8.1     √ stringr 1.3.1
    ## √ readr   1.1.1     √ forcats 0.3.0

    ## -- Conflicts ------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(knitr)
knitr::opts_chunk$set(message = FALSE)
```

## AUClast

``` r
BE::test2x2(NCAResult4BE, "AUClast")
```

    ## $`Analysis of Variance (log scale)`
    ##                          SS DF           MS           F            p
    ## SUBJECT        2.875497e+00 32 8.985928e-02 3.183942248 0.0008742828
    ## GROUP          1.024607e-01  1 1.024607e-01 1.145416548 0.2927731856
    ## SUBJECT(GROUP) 2.773036e+00 31 8.945279e-02 3.169539016 0.0009544080
    ## PERIOD         3.027399e-05  1 3.027399e-05 0.001072684 0.9740824428
    ## DRUG           3.643467e-02  1 3.643467e-02 1.290972690 0.2645764201
    ## ERROR          8.749021e-01 31 2.822265e-02          NA           NA
    ## TOTAL          3.786834e+00 65           NA          NA           NA
    ## 
    ## $`Between and Within Subject Variability`
    ##                                 Between Subject Within Subject
    ## Variance Estimate                    0.03061507     0.02822265
    ## Coefficient of Variation, CV(%)     17.63193968    16.91883011
    ## 
    ## $`Least Square Means (geometric mean)`
    ##                 Reference Drug Test Drug
    ## Geometric Means       5092.098  4858.245
    ## 
    ## $`90% Confidence Interval of Geometric Mean Ratio (T/R)`
    ##                  Lower Limit Point Estimate Upper Limit
    ## 90% CI for Ratio    0.889436      0.9540753    1.023412
    ## 
    ## $`Sample Size`
    ##                       True Ratio=1 True Ratio=Point Estimate
    ## 80% Power Sample Size            6                         7

## Cmax

``` r
BE::test2x2(NCAResult4BE, "Cmax")
```

    ## $`Analysis of Variance (log scale)`
    ##                          SS DF           MS           F          p
    ## SUBJECT        2.861492e+00 32 8.942162e-02 2.237604579 0.01367095
    ## GROUP          9.735789e-05  1 9.735789e-05 0.001054764 0.97429977
    ## SUBJECT(GROUP) 2.861394e+00 31 9.230304e-02 2.309706785 0.01131826
    ## PERIOD         4.717497e-03  1 4.717497e-03 0.118046317 0.73348258
    ## DRUG           6.837756e-03  1 6.837756e-03 0.171101730 0.68198228
    ## ERROR          1.238856e+00 31 3.996310e-02          NA         NA
    ## TOTAL          4.112258e+00 65           NA          NA         NA
    ## 
    ## $`Between and Within Subject Variability`
    ##                                 Between Subject Within Subject
    ## Variance Estimate                    0.02616997      0.0399631
    ## Coefficient of Variation, CV(%)     16.28355371     20.1921690
    ## 
    ## $`Least Square Means (geometric mean)`
    ##                 Reference Drug Test Drug
    ## Geometric Means       825.5206  808.8778
    ## 
    ## $`90% Confidence Interval of Geometric Mean Ratio (T/R)`
    ##                  Lower Limit Point Estimate Upper Limit
    ## 90% CI for Ratio   0.9013625      0.9798396    1.065149
    ## 
    ## $`Sample Size`
    ##                       True Ratio=1 True Ratio=Point Estimate
    ## 80% Power Sample Size            8                         8

``` r
results_Cmax <- BE::test2x2(NCAResult4BE, "Cmax")
ls(results_Cmax)
```

    ## [1] "90% Confidence Interval of Geometric Mean Ratio (T/R)"
    ## [2] "Analysis of Variance (log scale)"                     
    ## [3] "Between and Within Subject Variability"               
    ## [4] "Least Square Means (geometric mean)"                  
    ## [5] "Sample Size"

``` r
results_Cmax$`90% Confidence Interval of Geometric Mean Ratio (T/R)` %>% 
  as.tibble(rownames = row.names(.))
```

    ## # A tibble: 1 x 4
    ##   `90% CI for Ratio` `Lower Limit` `Point Estimate` `Upper Limit`
    ##   <chr>                      <dbl>            <dbl>         <dbl>
    ## 1 90% CI for Ratio           0.901            0.980          1.07

### PROC GLM

``` r
gather_sas <- function(df){
  df %>% 
    gather('parameter', 'value')
}
read_csv('sas/proc-glm.csv') %>% 
  gather_sas()
```

    ## # A tibble: 11 x 2
    ##    parameter    value
    ##    <chr>        <dbl>
    ##  1 Obs         1     
    ##  2 LNPE       -0.0204
    ##  3 DF         31     
    ##  4 SE          0.0492
    ##  5 LNLM        0.0835
    ##  6 LNLL       -0.104 
    ##  7 LNUL        0.0631
    ##  8 PE          0.980 
    ##  9 LL          0.901 
    ## 10 UL          1.07  
    ## 11 WD          0.164

### PROC MIXED

``` r
read_csv('sas/proc-mixed.csv') %>% 
  gather_sas()
```

    ## # A tibble: 16 x 2
    ##    parameter value   
    ##    <chr>     <chr>   
    ##  1 Obs       1       
    ##  2 Label     T VS R  
    ##  3 Estimate  -0.02037
    ##  4 StdErr    0.04924 
    ##  5 DF        31      
    ##  6 tValue    -0.41   
    ##  7 Probt     0.682   
    ##  8 Alpha     0.1     
    ##  9 Lower     -0.1038 
    ## 10 Upper     0.06311 
    ## 11 MSE       0.039963
    ## 12 LNLM      0.083481
    ## 13 PE        0.97984 
    ## 14 LL        0.90136 
    ## 15 UL        1.06515 
    ## 16 WD        0.16379

## Tmax

``` r
BE::test2x2(NCAResult4BE, "Tmax")
```

    ## $`Analysis of Variance (log scale)`
    ##                         SS DF         MS         F          p
    ## SUBJECT         7.52334340 32 0.23510448 1.6924313 0.07317245
    ## GROUP           0.01395806  1 0.01395806 0.0576212 0.81187628
    ## SUBJECT(GROUP)  7.50938534 31 0.24223824 1.7437846 0.06351437
    ## PERIOD          0.48117922  1 0.48117922 3.4638334 0.07223183
    ## DRUG            0.10288377  1 0.10288377 0.7406227 0.39606886
    ## ERROR           4.30637210 31 0.13891523        NA         NA
    ## TOTAL          12.42781245 65         NA        NA         NA
    ## 
    ## $`Between and Within Subject Variability`
    ##                                 Between Subject Within Subject
    ## Variance Estimate                     0.0516615      0.1389152
    ## Coefficient of Variation, CV(%)      23.0259070     38.6039754
    ## 
    ## $`Least Square Means (geometric mean)`
    ##                 Reference Drug Test Drug
    ## Geometric Means        1.15244    1.0649
    ## 
    ## $`90% Confidence Interval of Geometric Mean Ratio (T/R)`
    ##                  Lower Limit Point Estimate Upper Limit
    ## 90% CI for Ratio    0.790851      0.9240393    1.079658
    ## 
    ## $`Sample Size`
    ##                       True Ratio=1 True Ratio=Point Estimate
    ## 80% Power Sample Size           25                        43

# SAS

``` bash
cat sas/sas-be-model-2.sas
```

    ## DATA BE; /* It will load 91 records. */
    ##   INFILE 'c:\Users\mdlhs\asancpt\BEreport\sas\NCAResult4BE.csv' FIRSTOBS=2 DLM=",";
    ##   INPUT SUBJ $ SEQ $ PRD $ TRT $ AUClast Cmax Tmax;
    ##   IF CMAX =< 0 THEN DELETE;
    ##   LNCMAX = LOG(Cmax);
    ##   LNAUCL = LOG(AUClast );
    ## 
    ## PROC PRINT; RUN;
    ## 
    ## PROC GLM DATA=BE OUTSTAT=STATRES; /* GLM use only complete subjects. */
    ##   CLASS SEQ PRD TRT SUBJ;
    ##   MODEL LNCMAX = SEQ SUBJ(SEQ) PRD TRT;
    ##   RANDOM SUBJ(SEQ)/TEST;
    ##   LSMEANS TRT /PDIFF=CONTROL('R') CL ALPHA=0.1 COV OUT=LSOUT;
    ## RUN;
    ## 
    ## PROC PRINT DATA=STATRES; RUN;
    ## PROC PRINT DATA=LSOUT; RUN;
    ## 
    ## DATA STATRES;
    ##   SET STATRES;
    ##   IF _TYPE_='ERROR' THEN CALL SYMPUT('DF', DF);
    ## 
    ## DATA LSOUT;
    ##   SET LSOUT;
    ##   IF TRT='R' THEN CALL SYMPUT('GMR_R', LSMEAN);
    ##   IF TRT='T' THEN CALL SYMPUT('GMR_T', LSMEAN);
    ##   IF TRT='R' THEN CALL SYMPUT('V_R', COV1);
    ##   IF TRT='T' THEN CALL SYMPUT('V_T', COV2);
    ##   IF TRT='T' THEN CALL SYMPUT('COV', COV1);
    ## 
    ## DATA LSOUT2;
    ##   LNPE = &GMR_T - &GMR_R;
    ##   DF = &DF;
    ##   SE = SQRT(&V_R + &V_T - 2*&COV);
    ##   LNLM = TINV(0.95, DF)*SE;
    ##   LNLL = LNPE - LNLM ;
    ##   LNUL = LNPE + LNLM;
    ##   PE = EXP(LNPE);
    ##   LL = EXP(LNLL);
    ##   UL = EXP(LNUL);
    ##   WD = UL - LL;
    ## 
    ## PROC PRINT DATA=LSOUT2; RUN;
    ## 
    ## PROC MIXED DATA=BE; /* MIXED  uses all data. */
    ##   CLASS SEQ TRT SUBJ PRD;
    ##   MODEL LNCMAX = SEQ PRD TRT;
    ##   RANDOM SUBJ(SEQ);
    ##   ESTIMATE 'T VS R' TRT -1 1 /CL ALPHA=0.1; 
    ##   ODS OUTPUT ESTIMATES=ESTIM COVPARMS=COVPAR;
    ## RUN;
    ## 
    ## DATA COVPAR;
    ##   SET COVPAR;
    ##   IF CovParm = 'Residual' THEN CALL SYMPUT('MSE', Estimate);
    ## 
    ## DATA ESTIM;
    ##   SET ESTIM;
    ##   MSE = &MSE;
    ##   LNLM = (Upper - Lower)/2;
    ##   PE = EXP(Estimate);
    ##   LL = EXP(Lower);
    ##   UL = EXP(Upper);
    ##   WD = UL - LL;
    ## 
    ## PROC PRINT Data=ESTIM; RUN;

# (APPENDIX) Appendix

# Raw

| SUBJ | GRP | PRD | TRT |  AUClast |    Cmax | Tmax |
| ---: | :-- | --: | :-- | -------: | ------: | ---: |
|    1 | RT  |   1 | R   | 5018.927 | 1043.13 | 1.04 |
|    1 | RT  |   2 | T   | 6737.507 |  894.21 | 1.03 |
|    2 | TR  |   1 | T   | 4373.970 |  447.26 | 1.01 |
|    2 | TR  |   2 | R   | 6164.276 |  783.92 | 1.98 |
|    4 | TR  |   1 | T   | 5592.993 |  824.42 | 1.97 |
|    4 | TR  |   2 | R   | 5958.160 |  646.31 | 0.97 |
|    5 | TR  |   1 | T   | 3902.590 |  803.70 | 0.80 |
|    5 | TR  |   2 | R   | 4620.156 |  955.30 | 0.74 |
|    6 | RT  |   1 | R   | 3735.274 |  995.34 | 1.02 |
|    6 | RT  |   2 | T   | 4257.802 |  816.33 | 1.00 |
|    7 | RT  |   1 | R   | 4314.993 |  608.99 | 0.95 |
|    7 | RT  |   2 | T   | 5030.372 |  806.57 | 0.74 |
|    8 | RT  |   1 | R   | 6053.098 | 1283.67 | 0.72 |
|    8 | RT  |   2 | T   | 5790.067 |  822.95 | 1.03 |
|    9 | RT  |   1 | R   | 4602.582 |  679.39 | 0.74 |
|    9 | RT  |   2 | T   | 6042.462 |  556.55 | 0.98 |
|   10 | RT  |   1 | R   | 8848.988 | 1136.91 | 1.03 |
|   10 | RT  |   2 | T   | 7349.822 | 1082.79 | 0.97 |
|   11 | TR  |   1 | T   | 3054.096 |  547.73 | 2.02 |
|   11 | TR  |   2 | R   | 4719.175 |  984.69 | 0.54 |
|   13 | RT  |   1 | R   | 4828.682 |  615.17 | 1.00 |
|   13 | RT  |   2 | T   | 4175.434 |  692.26 | 0.97 |
|   14 | RT  |   1 | R   | 4566.275 |  864.56 | 1.03 |
|   14 | RT  |   2 | T   | 5042.649 | 1122.75 | 0.75 |
|   15 | TR  |   1 | T   | 4950.980 |  719.40 | 0.97 |
|   15 | TR  |   2 | R   | 4959.554 |  660.17 | 0.96 |
|   16 | RT  |   1 | R   | 4577.432 |  609.64 | 3.01 |
|   16 | RT  |   2 | T   | 4773.723 |  807.65 | 1.01 |
|   17 | RT  |   1 | R   | 6462.652 |  861.56 | 2.02 |
|   17 | RT  |   2 | T   | 5246.032 | 1187.75 | 0.73 |
|   18 | TR  |   1 | T   | 4754.625 |  919.87 | 0.77 |
|   18 | TR  |   2 | R   | 3214.809 | 1042.84 | 0.53 |
|   19 | TR  |   1 | T   | 7619.304 | 1089.84 | 3.00 |
|   19 | TR  |   2 | R   | 5210.569 | 1127.94 | 2.04 |
|   20 | TR  |   1 | T   | 5063.471 | 1191.46 | 0.71 |
|   20 | TR  |   2 | R   | 6406.634 | 1069.19 | 1.00 |
|   21 | RT  |   1 | R   | 5580.289 |  742.67 | 0.97 |
|   21 | RT  |   2 | T   | 6304.119 |  447.85 | 0.99 |
|   22 | RT  |   1 | R   | 4398.887 |  682.73 | 2.02 |
|   22 | RT  |   2 | T   | 3760.359 |  669.01 | 1.04 |
|   23 | TR  |   1 | T   | 5141.165 |  937.02 | 0.51 |
|   23 | TR  |   2 | R   | 5835.275 |  894.72 | 1.04 |
|   24 | TR  |   1 | T   | 4343.439 |  713.57 | 1.03 |
|   24 | TR  |   2 | R   | 2848.448 |  811.83 | 0.71 |
|   25 | TR  |   1 | T   | 3983.260 | 1160.32 | 0.73 |
|   25 | TR  |   2 | R   | 3476.389 |  769.63 | 0.78 |
|   27 | TR  |   1 | T   | 5772.972 | 1219.56 | 0.99 |
|   27 | TR  |   2 | R   | 7673.260 | 1063.29 | 1.03 |
|   28 | RT  |   1 | R   | 5679.039 |  650.24 | 1.00 |
|   28 | RT  |   2 | T   | 5160.875 |  891.63 | 1.05 |
|   29 | TR  |   1 | T   | 4800.455 |  770.63 | 2.02 |
|   29 | TR  |   2 | R   | 5772.925 |  738.17 | 1.04 |
|   30 | RT  |   1 | R   | 4722.324 | 1034.11 | 0.77 |
|   30 | RT  |   2 | T   | 2896.939 |  569.22 | 1.03 |
|   31 | RT  |   1 | R   | 8032.393 | 1043.82 | 1.98 |
|   31 | RT  |   2 | T   | 6076.359 | 1141.43 | 0.96 |
|   32 | TR  |   1 | T   | 4245.372 |  608.93 | 2.97 |
|   32 | TR  |   2 | R   | 4745.770 |  539.66 | 2.04 |
|   33 | TR  |   1 | T   | 3648.195 |  856.18 | 0.76 |
|   33 | TR  |   2 | R   | 3356.777 |  647.95 | 0.98 |
|   34 | TR  |   1 | T   | 5015.499 |  739.42 | 0.96 |
|   34 | TR  |   2 | R   | 6325.746 |  682.41 | 1.99 |
|   35 | RT  |   1 | R   | 6259.347 | 1020.55 | 1.96 |
|   35 | RT  |   2 | T   | 5802.468 |  835.87 | 2.04 |
|   36 | RT  |   1 | R   | 4669.384 |  682.87 | 3.01 |
|   36 | RT  |   2 | T   | 3783.584 |  729.63 | 1.00 |

Description of settings for the noncompartmental analysis performed in
WinNonlin and links to the raw data

# Session Information

``` r
devtools::session_info()
```

    ##  setting  value                       
    ##  version  R version 3.5.1 (2018-07-02)
    ##  system   x86_64, mingw32             
    ##  ui       RTerm                       
    ##  language (EN)                        
    ##  collate  Korean_Korea.949            
    ##  tz       Asia/Seoul                  
    ##  date     2018-10-10                  
    ## 
    ##  package     * version date       source                             
    ##  assertthat    0.2.0   2017-04-11 CRAN (R 3.5.0)                     
    ##  backports     1.1.2   2017-12-13 CRAN (R 3.5.0)                     
    ##  base        * 3.5.1   2018-07-02 local                              
    ##  BE          * 0.1.1   2018-07-19 CRAN (R 3.5.1)                     
    ##  bindr         0.1.1   2018-03-13 CRAN (R 3.5.0)                     
    ##  bindrcpp      0.2.2   2018-03-29 CRAN (R 3.5.0)                     
    ##  broom         0.5.0   2018-07-17 CRAN (R 3.5.1)                     
    ##  cellranger    1.1.0   2016-07-27 CRAN (R 3.5.0)                     
    ##  cli           1.0.1   2018-09-25 CRAN (R 3.5.1)                     
    ##  colorspace    1.3-2   2016-12-14 CRAN (R 3.5.0)                     
    ##  compiler      3.5.1   2018-07-02 local                              
    ##  crayon        1.3.4   2018-06-08 Github (gaborcsardi/crayon@3e751fb)
    ##  datasets    * 3.5.1   2018-07-02 local                              
    ##  devtools      1.13.6  2018-06-27 CRAN (R 3.5.0)                     
    ##  digest        0.6.17  2018-09-12 CRAN (R 3.5.1)                     
    ##  dplyr       * 0.7.6   2018-06-29 CRAN (R 3.5.0)                     
    ##  evaluate      0.12    2018-10-09 CRAN (R 3.5.1)                     
    ##  fansi         0.4.0   2018-10-05 CRAN (R 3.5.1)                     
    ##  forcats     * 0.3.0   2018-02-19 CRAN (R 3.5.0)                     
    ##  ggplot2     * 3.0.0   2018-07-03 CRAN (R 3.5.1)                     
    ##  glue          1.3.0   2018-07-17 CRAN (R 3.5.1)                     
    ##  graphics    * 3.5.1   2018-07-02 local                              
    ##  grDevices   * 3.5.1   2018-07-02 local                              
    ##  grid          3.5.1   2018-07-02 local                              
    ##  gtable        0.2.0   2016-02-26 CRAN (R 3.5.0)                     
    ##  haven         1.1.2   2018-06-27 CRAN (R 3.5.0)                     
    ##  highr         0.7     2018-06-09 CRAN (R 3.5.0)                     
    ##  hms           0.4.2   2018-03-10 CRAN (R 3.5.0)                     
    ##  htmltools     0.3.6   2017-04-28 CRAN (R 3.5.0)                     
    ##  httr          1.3.1   2017-08-20 CRAN (R 3.5.0)                     
    ##  jsonlite      1.5     2017-06-01 CRAN (R 3.5.0)                     
    ##  knitr       * 1.20    2018-02-20 CRAN (R 3.5.0)                     
    ##  lattice       0.20-35 2017-03-25 CRAN (R 3.5.0)                     
    ##  lazyeval      0.2.1   2017-10-29 CRAN (R 3.5.0)                     
    ##  lubridate     1.7.4   2018-04-11 CRAN (R 3.5.0)                     
    ##  magrittr      1.5     2014-11-22 CRAN (R 3.5.0)                     
    ##  memoise       1.1.0   2017-04-21 CRAN (R 3.5.0)                     
    ##  methods     * 3.5.1   2018-07-02 local                              
    ##  modelr        0.1.2   2018-05-11 CRAN (R 3.5.0)                     
    ##  munsell       0.5.0   2018-06-12 CRAN (R 3.5.0)                     
    ##  nlme          3.1-137 2018-04-07 CRAN (R 3.5.1)                     
    ##  pillar        1.3.0   2018-07-14 CRAN (R 3.5.1)                     
    ##  pkgconfig     2.0.2   2018-08-16 CRAN (R 3.5.1)                     
    ##  plyr          1.8.4   2016-06-08 CRAN (R 3.5.0)                     
    ##  purrr       * 0.2.5   2018-05-29 CRAN (R 3.5.0)                     
    ##  R.methodsS3   1.7.1   2016-02-16 CRAN (R 3.5.0)                     
    ##  R.oo          1.22.0  2018-04-22 CRAN (R 3.5.0)                     
    ##  R6            2.3.0   2018-10-04 CRAN (R 3.5.1)                     
    ##  Rcpp          0.12.19 2018-10-01 CRAN (R 3.5.1)                     
    ##  readr       * 1.1.1   2017-05-16 CRAN (R 3.5.0)                     
    ##  readxl        1.1.0   2018-04-20 CRAN (R 3.5.0)                     
    ##  rlang         0.2.2   2018-08-16 CRAN (R 3.5.1)                     
    ##  rmarkdown     1.10    2018-06-11 CRAN (R 3.5.0)                     
    ##  rprojroot     1.3-2   2018-01-03 CRAN (R 3.5.0)                     
    ##  rstudioapi    0.8     2018-10-02 CRAN (R 3.5.1)                     
    ##  rtf         * 0.4-13  2018-05-17 CRAN (R 3.5.1)                     
    ##  rvest         0.3.2   2016-06-17 CRAN (R 3.5.0)                     
    ##  scales        1.0.0   2018-08-09 CRAN (R 3.5.1)                     
    ##  stats       * 3.5.1   2018-07-02 local                              
    ##  stringi       1.2.4   2018-07-20 CRAN (R 3.5.1)                     
    ##  stringr     * 1.3.1   2018-05-10 CRAN (R 3.5.0)                     
    ##  tibble      * 1.4.2   2018-01-22 CRAN (R 3.5.0)                     
    ##  tidyr       * 0.8.1   2018-05-18 CRAN (R 3.5.0)                     
    ##  tidyselect    0.2.4   2018-02-26 CRAN (R 3.5.0)                     
    ##  tidyverse   * 1.2.1   2017-11-14 CRAN (R 3.5.0)                     
    ##  tools         3.5.1   2018-07-02 local                              
    ##  utf8          1.1.4   2018-05-24 CRAN (R 3.5.0)                     
    ##  utils       * 3.5.1   2018-07-02 local                              
    ##  withr         2.1.2   2018-03-15 CRAN (R 3.5.0)                     
    ##  xml2          1.2.0   2018-01-24 CRAN (R 3.5.0)                     
    ##  yaml          2.2.0   2018-07-25 CRAN (R 3.5.1)

# References

<div id="refs" class="references">

<div id="ref-R-BE">

Bae, Kyun-Seop. 2018. *BE: Bioequivalence Study Data Analysis*.
<https://CRAN.R-project.org/package=BE>.

</div>

</div>
