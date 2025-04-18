# author: Jordan Bourak & Tiffany Timbers
# date: 2021-11-22
.PHONY: all clean

# Run this all at once; remember to put code changes in individual rules
all: 
	make clean
	make index.html

# Create index.html with given list of dependencies
index.html: results/horse_pop_plot_largest_sd.png \
	results/horse_pops_plot.png \
	results/horses_spread.csv \
	reports/qmd_example.html \
	reports/qmd_example.pdf 
	cp reports/qmd_example.html docs/index.html # Recreate in docs

# generate figures and objects for report using source/generate_figures.R
# runs if any of the output files are missing or if source/generate_figures.R is newer than the output files
results/horse_pop_plot_largest_sd.png results/horse_pops_plot.png results/horses_spread.csv: source/generate_figures.R
	Rscript source/generate_figures.R --input_dir="data/00030067-eng.csv" \
		--out_dir="results"

# render quarto report in HTML and PDF using results reports/qmd_example.qmd
reports/qmd_example.html: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to html

reports/qmd_example.pdf: results reports/qmd_example.qmd
	quarto render reports/qmd_example.qmd --to pdf

# removes the results directory and the generated report files 
clean:
	rm -rf results
	rm -rf reports/qmd_example.html \
		reports/qmd_example.pdf \
		reports/qmd_example_files 
	rm -rf docs/*
