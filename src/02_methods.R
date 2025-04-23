"This script performs exploratory data analysis (EDA) and prepares the data for modeling

Usage: src/02-methods.R --input_path=<input_path> --output_path_summary=<output_path_summary> --output_path_image=<output_path_image> --output_path_clean=<output_path_clean>

Options:
--input_path=<input_path>
--output_path_summary=<output_path_summary>
--output_path_image=<output_path_image>
--output_path_clean=<output_path_clean>
" -> doc

library(docopt)
library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)

opt <- docopt::docopt(doc)
data <- readr::read_csv(opt$input_path)

# Summary statistics
dplyr::glimpse(data)
summary <- dplyr::summarise(data, mean_bill_length = mean(bill_length_mm), mean_bill_depth = mean(bill_depth_mm), mean_flipper_length = mean(flipper_length_mm), mean_body_mass = mean(body_mass_g))

# Visualizations
title_size <- 1.5
axis_size <- 3.5
legend_key_size <- 0.5
legend_text_size <- 2
legend_title_size <- 2.5
boxplot_image <- ggplot2::ggplot(data, ggplot2::aes(x = species, y = bill_length_mm, fill = species)) +
  ggplot2::geom_boxplot() +
  ggplot2::theme_minimal() + 
  ggplot2::theme(
        axis.text = ggplot2::element_text(size = axis_size),
        axis.title = ggplot2::element_text(size = axis_size),
        plot.title = ggplot2::element_text(size = title_size, face = "bold"),
        legend.key.size = ggplot2::unit(legend_key_size, "cm"),
        legend.text = ggplot2::element_text(size = legend_text_size),
        legend.title = ggplot2::element_text(size = legend_title_size)
      )

# Prepare data for modeling
data <- dplyr::select(data, species, bill_length_mm, bill_depth_mm, flipper_length_mm, body_mass_g) %>%
  dplyr::mutate(species = as.factor(species))

# Save
readr::write_csv(summary, opt$output_path_summary)
ggplot2::ggsave(opt$output_path_image, boxplot_image, width = 3, height = 1)
readr::write_csv(data, opt$output_path_clean)