Validation of Bioequivalence Test Performed by BE R package
================
Sungpil Han <shan@acp.kr>
2018-10-29



# Introduction

To assess bioequivalence, the 90% confidence interval for the difference
in the means of the log-transformed data should be calculated using
appropriate methods to the study design. The antilogs (exponents) of the
confidence limits obtained constitute the 90% confidence interval for
the ratio of the geometric means between the T and R products. (CDER,
FDA 2001; Chow and Liu 2008; Hauschke, Steinijans, and Pigeot 2007) To
establish bioequivalence, the calculated confidence interval should fall
within a bioequivalence limit, usually 80-125% for the ratio of the
product averages. For nonreplicated crossover designs, general linear
model procedures available in PROC GLM in SAS are preferred, although
linear mixed-effects model procedures can also be indicated for
analysis. (CDER, FDA 2001)

`BE` R package (Bae 2018) can analyze bioequivalence study data with
industrial strength. The current version of `BE` performs bioequivalency
tests for several pharmacokinetic parameters of the conventional
two-treatment, two-period, two-sequence (2x2) randomized crossover
design. The statistical model includes factors accounting for the
following sources of variation: sequence (SEQ), subjects nested in
sequences (SUBJ(SEQ)), period (PRD), and treatment (TRT).

In this document, the author performed validation of bioequivalence
tests performed by `BE` R package as compared to bioequivalence tests
performed by PROC GLM or PROC MIXED in SAS.

# Methods

## Dataset

A simulated dataset of the conventional 2×2 crossover study for this
analysis, `BE::NCAResult4BE` is shown in Appendix A. The number of
subjects in the sequence ‘RT’ is 17 and that in the sequence ‘TR’ is 16.
(total N=33) The 4 variables, SUBJ (subject), GRP (group or sequence),
PRD (period), and TRT (treatment), and the 3 pharmacokinetic parameters,
AUC<sub>last</sub>, C<sub>max</sub>, and T<sub>max</sub> are presented
and there is no missing values. (total 66 observations with 7 variables)

## Bioequivalence tests in R

The required R packages are following.

``` r
library(BE)         # install.packages("BE", repos="http://r.acr.kr")
library(dplyr)      # install.packages("dplyr")
library(readxl)      # install.packages("readxl")
```

A function, `tab_r_be_results()` is a wrapper function of
`BE::test2x2()` and returns the 90% confidence interval.

``` r
tab_r_be_results <- function(parameter){
  BE::test2x2(BE::NCAResult4BE, parameter)[[4]] %>% 
  as.data.frame() %>% 
  mutate(Analysis = 'R: BE package') %>% 
  select(Analysis, `Lower Limit`, `Point Estimate`, `Upper Limit`)
}
```

## Bioequivalence tests in SAS

To run BE analysis, PROC GLM and PROC MIXED in SAS version 9.4 were
used. The SAS program statements include the variables, SEQ (sequence),
TRT (treatment), SUBJ (subject), and PRD (period). LNAUCL
(log-transformed AUC<sub>last</sub>) or LNCMAX (log-transformed
C<sub>max</sub>) denotes the response measure. A part of SAS scripts are
shown below and the full SAS scripts are appended in Appendix B.

``` r
PROC GLM DATA=BE OUTSTAT=STATRES; /* GLM use only complete subjects. */
CLASS SEQ PRD TRT SUBJ;
MODEL LNAUCL = SEQ SUBJ(SEQ) PRD TRT;
RANDOM SUBJ(SEQ)/TEST;
LSMEANS TRT /PDIFF=CONTROL('R') CL ALPHA=0.1 COV OUT=LSOUT;
```

``` r
PROC MIXED DATA=BE; /* MIXED uses all data. */
CLASS SEQ TRT SUBJ PRD;
MODEL LNAUCL = SEQ PRD TRT;
RANDOM SUBJ(SEQ);
ESTIMATE 'T VS R' TRT -1 1 /CL ALPHA=0.1;
ODS OUTPUT ESTIMATES=ESTIM COVPARMS=COVPAR;
```

A function, `tab_sas_proc_results()` reads SAS analysis results exported
to Microsoft Excel files (`.xls`) and converted to comma separated
version file (`.csv`). It returns a data frame of 90% confidence
interval calculated either `PROC GLM` or `PROC MIXED` in SAS.

``` r
tab_sas_proc_results <- function(analysis_name, skip_no){
  read_excel('sas/sas-be-macro-results.xlsx', skip = skip_no, n_max = 2) %>% 
  mutate(Analysis = analysis_name) %>% 
    select(Analysis, `Lower Limit` = LL, `Point Estimate` = PE, `Upper Limit` = UL)
}
```

# Results

## AUC<sub>last</sub>

Comparison of 90% confidence interval for the ratio of the geometric
means of AUC<sub>last</sub> between the T and R products is shown in
Table @ref(tab:tabauclast).

``` r
AUClast_R_BE <- tab_r_be_results("AUClast")

AUClast_proc_glm <- tab_sas_proc_results('SAS: PROC GLM', skip = 108)
AUClast_proc_mixed <- tab_sas_proc_results('SAS: PROC MIXED', skip = 180)

# Combine all analyses of AUClast
AUClast_all_analyses <- bind_rows(AUClast_R_BE, AUClast_proc_glm, AUClast_proc_mixed)
```

| Analysis        | Lower Limit | Point Estimate | Upper Limit |
| :-------------- | ----------: | -------------: | ----------: |
| R: BE package   |     0.88944 |        0.95408 |     1.02341 |
| SAS: PROC GLM   |     0.88944 |        0.95408 |     1.02341 |
| SAS: PROC MIXED |     0.88944 |        0.95408 |     1.02341 |

Comparison of 90% confidence interval for the ratio of the geometric
means of AUClast

## C<sub>max</sub>

Comparison of 90% confidence interval for the ratio of the geometric
means of AUC<sub>last</sub> between the T and R products is shown in
Table @ref(tab:tabcmax).

``` r
Cmax_R_BE <- tab_r_be_results("Cmax")

Cmax_proc_glm <- tab_sas_proc_results('SAS: PROC GLM', skip = 294)
Cmax_proc_mixed <- tab_sas_proc_results('SAS: PROC MIXED', skip = 366)

# Combine all analyses of Cmax
Cmax_all_analyses <- bind_rows(Cmax_R_BE, Cmax_proc_glm, Cmax_proc_mixed)
```

| Analysis        | Lower Limit | Point Estimate | Upper Limit |
| :-------------- | ----------: | -------------: | ----------: |
| R: BE package   |     0.90136 |        0.97984 |     1.06515 |
| SAS: PROC GLM   |     0.90136 |        0.97984 |     1.06515 |
| SAS: PROC MIXED |     0.90136 |        0.97984 |     1.06515 |

Comparison of 90% confidence interval for the ratio of the geometric
means of Cmax

# Conclusion

*There is no discrepancy* between bioequivalence tests performed by `BE`
R package and those performed by PROC GLM or PROC MIXED in SAS. We also
performed multiple analyses with the actual clinical trial datasets and
have found no differences (data not shown: confidential).

Bioequivalence tests performed by the open-source `BE` R package for the
conventional two-treatment, two-period, two-sequence (2x2) randomized
crossover design can be **qualified and validated** enough to acquire
the identical results of the commercial statistical software, SAS.

*Please report issues regarding validation of the R package to
<https://github.com/asancpt/BE-validation/issues>.*

-----

**Affiliation**:  
Sungpil Han M.D/Ph.D  
Resident,  
Department of Clinical Pharmacology and Therapeutics,  
Asan Medical Center, University of Ulsan,  
Seoul 05505, Republic of Korea  
E-mail: <shan@acp.kr>  
URL: www.github.com/shanmdphd

