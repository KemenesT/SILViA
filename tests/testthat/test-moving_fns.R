test_that("error message work", {
  testvector <- c(1:10)
  expect_error(moving_fn(testvector, w = 5, fun = mean, side = "top"))
})

test_that("averaging windows work", {
  testvector <- c(1:10)

  result <- moving_fn(testvector, w = 5, fun = mean, side = "right")
  expect_identical(length(result), length(testvector))
  expect_type(result, "double")
  testresult <- c(
    mean(testvector[1:5]), mean(testvector[2:6]),
    mean(testvector[3:7]), mean(testvector[4:8]),
    mean(testvector[5:9]), mean(testvector[6:10]),
    mean(testvector[7:10]), mean(testvector[8:10]),
    mean(testvector[9:10]), mean(testvector[10:10])
  )
  expect_identical(result, testresult)

  result <- moving_fn(testvector, w = 5, fun = mean, side = "left")
  expect_identical(length(result), length(testvector))
  expect_type(result, "double")
  testresult <- c(
    mean(testvector[1:1]), mean(testvector[1:2]),
    mean(testvector[1:3]), mean(testvector[1:4]),
    mean(testvector[1:5]), mean(testvector[2:6]),
    mean(testvector[3:7]), mean(testvector[4:8]),
    mean(testvector[5:9]), mean(testvector[6:10])
  )
  expect_identical(result, testresult)

  result <- moving_fn(testvector, w = 5, fun = mean, side = "c")
  expect_identical(length(result), length(testvector))
  expect_type(result, "double")
  testresult <- c(
    mean(testvector[1:3]), mean(testvector[1:4]),
    mean(testvector[1:5]), mean(testvector[2:6]),
    mean(testvector[3:7]), mean(testvector[4:8]),
    mean(testvector[5:9]), mean(testvector[6:10]),
    mean(testvector[7:10]), mean(testvector[8:10])
  )
  expect_identical(result, testresult)
})

test_that("summing windows work", {
  testvector <- c(1:10)

  result <- moving_fn(testvector, w = 5, fun = sum, side = "right")
  expect_identical(length(result), length(testvector))
  expect_type(result, "integer")
  testresult <- c(
    sum(testvector[1:5]), sum(testvector[2:6]),
    sum(testvector[3:7]), sum(testvector[4:8]),
    sum(testvector[5:9]), sum(testvector[6:10]),
    sum(testvector[7:10]), sum(testvector[8:10]),
    sum(testvector[9:10]), sum(testvector[10:10])
  )
  expect_identical(result, testresult)

  result <- moving_fn(testvector, w = 5, fun = sum, side = "left")
  expect_identical(length(result), length(testvector))
  expect_type(result, "integer")
  testresult <- c(
    sum(testvector[1:1]), sum(testvector[1:2]),
    sum(testvector[1:3]), sum(testvector[1:4]),
    sum(testvector[1:5]), sum(testvector[2:6]),
    sum(testvector[3:7]), sum(testvector[4:8]),
    sum(testvector[5:9]), sum(testvector[6:10])
  )
  expect_identical(result, testresult)

  result <- moving_fn(testvector, w = 5, fun = sum, side = "c")
  expect_identical(length(result), length(testvector))
  expect_type(result, "integer")
  testresult <- c(
    sum(testvector[1:3]), sum(testvector[1:4]),
    sum(testvector[1:5]), sum(testvector[2:6]),
    sum(testvector[3:7]), sum(testvector[4:8]),
    sum(testvector[5:9]), sum(testvector[6:10]),
    sum(testvector[7:10]), sum(testvector[8:10])
  )
  expect_identical(result, testresult)
})

test_that("pasting windows work", {
  testvector <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j")

  result <- moving_fn(testvector,
    w = 5, fun = paste0, side = "right",
    collapse = ""
  )
  expect_identical(length(result), length(testvector))
  expect_type(result, "character")
  testresult <- c(
    paste0(testvector[1:5], collapse = ""),
    paste0(testvector[2:6], collapse = ""),
    paste0(testvector[3:7], collapse = ""),
    paste0(testvector[4:8], collapse = ""),
    paste0(testvector[5:9], collapse = ""),
    paste0(testvector[6:10], collapse = ""),
    paste0(testvector[7:10], collapse = ""),
    paste0(testvector[8:10], collapse = ""),
    paste0(testvector[9:10], collapse = ""),
    paste0(testvector[10:10], collapse = "")
  )
  expect_identical(result, testresult)

  result <- moving_fn(testvector,
    w = 5, fun = paste0, side = "left",
    collapse = ""
  )
  expect_identical(length(result), length(testvector))
  expect_type(result, "character")
  testresult <- c(
    paste0(testvector[1:1], collapse = ""),
    paste0(testvector[1:2], collapse = ""),
    paste0(testvector[1:3], collapse = ""),
    paste0(testvector[1:4], collapse = ""),
    paste0(testvector[1:5], collapse = ""),
    paste0(testvector[2:6], collapse = ""),
    paste0(testvector[3:7], collapse = ""),
    paste0(testvector[4:8], collapse = ""),
    paste0(testvector[5:9], collapse = ""),
    paste0(testvector[6:10], collapse = "")
  )
  expect_identical(result, testresult)

  result <- moving_fn(testvector,
    w = 5, fun = paste0, side = "c",
    collapse = ""
  )
  expect_identical(length(result), length(testvector))
  expect_type(result, "character")
  testresult <- c(
    paste0(testvector[1:3], collapse = ""),
    paste0(testvector[1:4], collapse = ""),
    paste0(testvector[1:5], collapse = ""),
    paste0(testvector[2:6], collapse = ""),
    paste0(testvector[3:7], collapse = ""),
    paste0(testvector[4:8], collapse = ""),
    paste0(testvector[5:9], collapse = ""),
    paste0(testvector[6:10], collapse = ""),
    paste0(testvector[7:10], collapse = ""),
    paste0(testvector[8:10], collapse = "")
  )
  expect_identical(result, testresult)
})
