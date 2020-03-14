library(testthat)
library(here)
library(tidyverse)
context("Testing library")

# test that data is created
test_that("data is in the data directory", {
  expect_true(file.exists("../../data/youtube_data.csv"))
  expect_true(file.exists("../../data/youtube_processed.csv"))
})


test_that("Images from EDA are created", {
  expect_true(file.exists("../../images/views_likes.png"))
  expect_true(file.exists("../../images/corr_plot.png"))
  expect_true(file.exists("../../images/num_vids_category.png"))
  expect_true(file.exists("../../images/top10_mean_views_likes.png"))
})

test_that("RDS objects and plots are created", {
  expect_true(file.exists("../../rds/lm.rds"))
  expect_true(file.exists("../../rds/glm.rds"))
  expect_true(file.exists("../../images/lm_status_views.png"))
  expect_true(file.exists("../../images/pois_status_views.png"))
})

test_that("final report is created", {
  expect_true(file.exists("../../docs/finalreport.html"))
  expect_true(file.exists("../../docs/finalreport.pdf"))
})