
test_that("recall_date returns expected columns", {
  test_data <- foodRecall::recall_date(api_key = "r1CN5Cxbk6UgmZ3d8s2DCT2YCxw0dU7JIrP5FzA6",
                                       limit = 1,
                                       recall_initiation_date = "January 1, 2023")

  expected_cols <- c("recall_number", "recalling_firm", "recall_initiation_date",
                     "center_classification_date", "report_date", "termination_date",
                     "voluntary_mandated", "classification", "initial_firm_notification",
                     "status", "country", "state", "city", "address_1", "address_2",
                     "postal_code", "reason_for_recall", "product_description",
                     "product_quantity", "code_info", "distribution_pattern", "event_id")

  expect_equal(colnames(test_data), expected_cols)
})
test_that("recall_date limit is too large", {
  expect_warning(test_data <- foodRecall::recall_date(api_key = "r1CN5Cxbk6UgmZ3d8s2DCT2YCxw0dU7JIrP5FzA6",
                                                      limit = 1001,
                                                      recall_initiation_date = "January 1, 2023"),
                 "The openFDA API is limited")
})

test_that("recall_date incomplete representation of data", {
  expect_warning(test_data <- foodRecall::recall_date(api_key = "r1CN5Cxbk6UgmZ3d8s2DCT2YCxw0dU7JIrP5FzA6",
                                                      recall_initiation_date = "January 1, 2022"),
                 "The total number of results is greater than the number")
})


