"This script fits a classification model using `tidymodels` to predict the species of a penguin based on its physical characteristics

Usage: src/03-model.R --input_path=<input_path> --output_path_train=<output_path_train> --output_path_test=<output_path_test> --output_path_model=<output_path_model>

Options:
--input_path=<input_path>
--output_path_train=<output_path_train>
--output_path_test=<output_path_test>
--output_path_model=<output_path_model>
" -> doc

library(docopt)
library(tidyverse)
library(readr)
library(rsample)
library(parsnip)
library(kknn) # For parsnip::set_engine("kknn")
library(dplyr)
library(workflows)

opt <- docopt::docopt(doc)
data <- readr::read_csv(opt$input_path) %>%
  mutate(species = as.factor(species)) # Need to respecify that they are factors

# Split data
set.seed(123)
data_split <- rsample::initial_split(data, strata = species)
train_data <- rsample::training(data_split)
test_data <- rsample::testing(data_split)

# Define model
penguin_model <- parsnip::nearest_neighbor(mode = "classification", neighbors = 5) %>%
  parsnip::set_engine("kknn") # Requires kknn package

# Create workflow
penguin_workflow <- workflows::workflow() %>%
  workflows::add_model(penguin_model) %>%
  workflows::add_formula(species ~ .)

# Fit model
penguin_fit <- penguin_workflow %>%
  parsnip::fit(data = train_data)

# Save for future steps
readr::write_csv(train_data, opt$output_path_train) # new .csv to work with
readr::write_csv(test_data, opt$output_path_test) # new .csv to work with
readr::write_rds(penguin_fit, opt$output_path_model) # Save any arbitrary R object into a file; don't need to rerun model stuff again unless you want additional steps  