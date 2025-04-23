"This script loads, cleans, and saves `penguins` dataset

Usage: src/01-load_clean.R --output_path=<output_path>

Options:
--output_path=<output_path>
" -> doc

library(docopt)
library(tidyverse)
library(readr)
library(tidyr)
library(palmerpenguins)

opt <- docopt::docopt(doc)
data <- penguins

# Initial cleaning: Remove missing values
data <- data %>% tidyr::drop_na()

readr::write_csv(data, opt$output_path)