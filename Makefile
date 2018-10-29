all: validation.pdf validation.md validation.html

validation.pdf: 
	Rscript -e "rmarkdown::render('validation.Rmd', output_format = 'bookdown::pdf_document2', output_file = 'validation.pdf', encoding = 'UTF-8')" ;\
	magick -density 150 validation.pdf[0] -alpha remove -border 5x5 cover.png

validation.md: 
	Rscript -e "rmarkdown::render('validation.Rmd', output_format = 'github_document', output_file = 'validation.md', encoding = 'UTF-8')" ;\
	rm validation.html ;\
	sed -n '/APPENDIX/q;p' validation.md > README.md

validation.html: 
	Rscript -e "rmarkdown::render('validation.Rmd', output_format = 'bookdown::tufte_html2', output_file = 'validation.html', encoding = 'UTF-8')" ;\
	cp validation.html docs/index.html

validation-tufte.pdf: 
	Rscript -e "rmarkdown::render('validation.Rmd', output_format = 'bookdown::tufte_handout2', output_file = 'validation-tufte.pdf', encoding = 'UTF-8')"
	
	# not working well : 1. delete format = latex , 2. delete mail address

clean:
	rm validation.pdf validation.md validation.html

