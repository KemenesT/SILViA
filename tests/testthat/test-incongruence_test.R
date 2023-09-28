test_that("the incongruence test returns expected structure", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), ID = 12345)
  casts <- casts[casts$filename == unique(casts$filename)[1], ]

  output <- incongruence_test(
    point_time = casts$time[2], column = "optics.1", subdf = casts, W = 0.3,
    alpha = 0.1, casts = unique(casts$filename), cast = 1,
    method = "t.student"
  )

  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruence", "pV"))
  expect_type(output$incongruence, "character")
  expect_type(output$pV, "double")

  expect_message(incongruence_test(
    point_time = casts$time[2], column = "optics.1", subdf = casts, W = 0.01,
    alpha = 0.1, casts = unique(casts$filename), cast = 1,
    method = "t.student"
  ))
})

test_that("the incongruence test returns expected structure", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), ID = 12345)
  casts <- data.frame(casts,
    incongruent_pressure = "No", incongruent_sound.velocity = "No",
    incongruent_temperature = "No", incongruent_salinity = "No",
    incongruent_denssity = "No", incongruent_conductivity = "No",
    incongruent_optics.1 = "No",
    pV_pressure = NA, pV_sound.velocity = NA,
    pV_temperature = NA, pV_salinity = NA,
    pV_denssity = NA, pV_conductivity = NA,
    pV_optics.1 = NA,
    warning = NA
  )

  output <- run_inc_test(
    column = "optics.1", iterations = 1, df1 = casts,
    W = 0.3, alpha = 0.0001, method = "t.student"
  )

  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_optics.1", "pV_optics.1"))
  expect_type(output$incongruent_optics.1, "character")
  expect_type(output$pV_optics.1, "double")
})

test_that("all outlier detection methods work", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), ID = 12345)
  casts <- data.frame(casts,
    incongruent_pressure = "No", incongruent_sound.velocity = "No",
    incongruent_temperature = "No", incongruent_salinity = "No",
    incongruent_denssity = "No", incongruent_conductivity = "No",
    incongruent_optics.1 = "No",
    pV_pressure = NA, pV_sound.velocity = NA,
    pV_temperature = NA, pV_salinity = NA,
    pV_denssity = NA, pV_conductivity = NA,
    pV_optics.1 = NA,
    warning = NA
  )

  output <- run_inc_test(
    column = "optics.1", iterations = 1, df1 = casts,
    W = 0.3, alpha = 0.0001, method = "t.student"
  )
  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_optics.1", "pV_optics.1"))
  expect_type(output$incongruent_optics.1, "character")
  expect_type(output$pV_optics.1, "double")

  output <- run_inc_test(
    column = "optics.1", iterations = 1, df1 = casts,
    W = 0.3, alpha = 0.0001, method = "max.residual"
  )
  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_optics.1", "pV_optics.1"))
  expect_type(output$incongruent_optics.1, "character")
  expect_type(output$pV_optics.1, "logical")

  output <- run_inc_test(
    column = "optics.1", iterations = 1, df1 = casts,
    W = 0.3, alpha = 0.05, method = "chisq"
  )
  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_optics.1", "pV_optics.1"))
  expect_type(output$incongruent_optics.1, "character")
  expect_type(output$pV_optics.1, "double")

  output <- run_inc_test(
    column = "optics.1", iterations = 1, df1 = casts,
    W = 0.3, alpha = 0.0001, method = "dixon"
  )
  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_optics.1", "pV_optics.1"))
  expect_type(output$incongruent_optics.1, "character")
  expect_type(output$pV_optics.1, "double")

  output <- run_inc_test(
    column = "optics.1", iterations = 1, df1 = casts,
    W = 0.3, alpha = 0.0001, method = "grubbs"
  )
  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_optics.1", "pV_optics.1"))
  expect_type(output$incongruent_optics.1, "character")
  expect_type(output$pV_optics.1, "double")
})
