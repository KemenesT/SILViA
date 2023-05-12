test_that("read_vp2 reads files correctly", {
  on.exit(unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2"))))
  setup_example()
  output <- read_vp2(tempdir(), type = "Chlorophyll", ID = 12345)
  expect_s3_class(output, class = "data.frame")
  expect_length(output, 13)
  expect_gt(nrow(output), 1615)
  expect_identical(colnames(output),
                   c("date", "time", "depth", "pressure", "sv", "temp", "sal",
                     "dens", "cond", "chla", "filename", "lat", "lon"))
  expect_type(output$lat, "double")
  expect_type(output$lon, "double")
  expect_false(any(is.na(output)))

  output <- read_vp2(tempdir(), type = "Turbidity", ID = 54321)
  expect_s3_class(output, class = "data.frame")
  expect_length(output, 15)
  expect_gt(nrow(output), 7)
  expect_identical(colnames(output),
                   c("date", "time", "depth", "pressure", "sv", "temp", "sal",
                     "dens", "cond", "neph", "obs", "turb", "filename", "lat",
                     "lon"))
  expect_type(output$lat, "double")
  expect_type(output$lon, "double")
  expect_false(any(is.na(output)))

  expect_error(read_vp2(tempdir(), type = "other", ID = 54321),
               regexp = "'type' must be one of 'Chlorophyll' or 'Turbidity'")
  expect_error(read_vp2(tempdir(), type = "Chlorophyll", ID = 54321),
    regexp = "Data type 'Chlorophyll' chosen for a device measuring Turbidity.")
  expect_error(read_vp2(tempdir(), type = "Turbidity", ID = 12345),
    regexp = "Data type 'Turbidity' chosen for a device measuring Chlorophyll.")
})

test_that("setup_example stores the example files in the temporary directory", {
  expect_type(ctdat, "list")
  on.exit(unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2"))))
  setup_example()
  expect_gt(length(sort(dir(path = tempdir(), pattern = ".vp2"))), 3)
  expect_identical(ctdat[[1]],
                   readLines(paste0(tempdir(), "\\",
                                    sort(dir(path = tempdir(),
                                             pattern = ".vp2"))[1])))
})
