test_that("ggplot objects are returned", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts$temp[10] <- 100
  output <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    type = "Chlorophyll", method = "t.student"
  )
  output <- output[output$filename == unique(output$filename)[1], ]
  p <- draw_plot("chla", output)

  expect_s3_class(p$layers[[1]], "gg")
  expect_identical(class(p$layers[[1]]$mapping$x), c("quosure", "formula"))
  expect_identical(class(p$layers[[1]]$mapping$y), c("quosure", "formula"))
  expect_identical(p$labels$title, "chla")
  expect_no_error(print(p))
})

test_that("plot_profiles returns the same output as label_incongruents", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts$temp[10] <- 100
  output1 <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    type = "Chlorophyll", method = "t.student"
  )
  output2 <- plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Chlorophyll", method = "t.student"
  )
  expect_identical(output1, output2)

  casts <- read_vp2(directory = tempdir(), type = "Turbidity", ID = 54321)
  casts$sv[1] <- 15400
  casts$temp[1] <- 100
  casts$sal[1] <- 100
  casts$dens[1] <- 10220
  casts$cond[1] <- 300
  casts$neph[1] <- 1000
  casts$obs[1] <- 1000
  casts$turb[1] <- 900
  output1 <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    type = "Turbidity", method = "t.student"
  )
  output2 <- plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Turbidity", method = "t.student"
  )
  expect_identical(output1, output2)
  unlink(paste0(getwd(), "/profiles.pdf"))
})

test_that("plot_profiles with 'any' returns plots", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts$temp[10] <- 100

  expect_message(plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Chlorophyll", method = "t.student"
  ))

  expect_true(file.exists(paste0(getwd(), "/profiles.pdf")))
  unlink(paste0(getwd(), "/profiles.pdf"))
  expect_false(file.exists(paste0(getwd(), "/profiles.pdf")))

  casts <- read_vp2(directory = tempdir(), type = "Turbidity", ID = 54321)

  expect_message(plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Turbidity", method = "t.student"
  ))

  expect_true(file.exists(paste0(getwd(), "/profiles.pdf")))
  unlink(paste0(getwd(), "/profiles.pdf"))
  expect_false(file.exists(paste0(getwd(), "/profiles.pdf")))
})

test_that("plot_profiles with 'all' returns plots", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts$temp[10] <- 100

  expect_message(plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Chlorophyll", plots = "all", method = "t.student"
  ))

  expect_true(file.exists(paste0(getwd(), "/profiles.pdf")))
  unlink(paste0(getwd(), "/profiles.pdf"))
  expect_false(file.exists(paste0(getwd(), "/profiles.pdf")))

  casts <- read_vp2(directory = tempdir(), type = "Turbidity", ID = 54321)

  expect_message(plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Turbidity", plots = "all", method = "t.student"
  ))

  expect_true(file.exists(paste0(getwd(), "/profiles.pdf")))
  unlink(paste0(getwd(), "/profiles.pdf"))
  expect_false(file.exists(paste0(getwd(), "/profiles.pdf")))
})

test_that("plot_profiles with a specific variable returns plots", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts$temp[10] <- 100

  expect_message(plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Chlorophyll", plots = "chla", method = "t.student"
  ))

  expect_true(file.exists(paste0(getwd(), "/profiles.pdf")))
  unlink(paste0(getwd(), "/profiles.pdf"))
  expect_false(file.exists(paste0(getwd(), "/profiles.pdf")))

  casts <- read_vp2(directory = tempdir(), type = "Turbidity", ID = 54321)

  expect_message(plot_profiles(
    data = casts, width = 1, alpha = 0.0001,
    type = "Turbidity", plots = "turb", method = "t.student"
  ))

  expect_true(file.exists(paste0(getwd(), "/profiles.pdf")))
  unlink(paste0(getwd(), "/profiles.pdf"))
  expect_false(file.exists(paste0(getwd(), "/profiles.pdf")))
})
