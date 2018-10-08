
report: # `docs/report.rtf`
	Rscript R/final-report.R ;\
	rm Rplots*.pdf

index:
	Rscript index.R
