"This script evaluates the performance of the model using the test dataset

Usage: src/04-results.R --input_path_train=<input_path_train> --input_path_test=<input_path_test> --input_path_model=<input_path_model> --output_path=<output_path>

Options:
--input_path_train=<input_path_train>
--input_path_test=<input_path_test>
--input_path_model=<input_path_model>
--output_path=<output_path>
" -> doc

library(docopt)
library(tidyverse)
library(readr)
library(dplyr)
library(yardstick)
library(workflows) # To run penguin_fit workflow properly

opt <- docopt::docopt(doc)

train_data <- readr::read_csv(opt$input_path_train) %>%
  dplyr::mutate(species = as.factor(species))
test_data <- readr::read_csv(opt$input_path_test) %>%
  dplyr::mutate(species = as.factor(species))
penguin_fit <- readr::read_rds(opt$input_path_model)

# Predict on test data
predictions <- predict(penguin_fit, new_data = test_data) %>%
  dplyr::bind_cols(test_data)

# Confusion matrix
conf_mat <- yardstick::conf_mat(predictions, truth = species, estimate = .pred_class)

readr::write_rds(conf_mat, opt$output_path)