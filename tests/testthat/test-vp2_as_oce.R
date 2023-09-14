test_that("vp2_as_oce outputs the right format object (formal class ctd)", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), ID = 12345)
  file_name <- unique(casts$filename)[1]
  cast <- casts[which(casts$filename == file_name), ]

  object <- vp2.as.oce(data = cast, file = file_name, directory = tempdir())

  expect_true(inherits(object, "ctd"))
})


test_that("vp2_as_oce outputs an object with all the expected components", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), ID = 12345)
  file_name <- unique(casts$filename)[1]
  cast <- casts[which(casts$filename == file_name), ]

  object <- vp2.as.oce(data = cast, file = file_name, directory = tempdir())

  units <- c("PSU", "DegC", "dBar", "mS/cm", "unknown/undefined",
             "unknown/undefined", "m", "Ms-1", "kg/M3", "unknown/undefined")

  names <- c("scan", "salinity", "temperature", "pressure", "conductivity",
             "time", "latitude", "longitude", "date", "depth", "sound.velocity",
             "density", "optics.1")

  expect_true(length(object@metadata$units) == 10)
  expect_identical(object@metadata$units, units)
  expect_true(object@metadata$serialNumber == "12345")
  expect_true(object@metadata$deploymentType == "profile")
  expect_true(object@metadata$filename == file_name)
  expect_identical(names(object@data), names)

  casts <- read_vp2(directory = tempdir(), ID = 54321)
  file_name <- unique(casts$filename)[1]
  cast <- casts[which(casts$filename == file_name), ]

  object <- vp2.as.oce(data = cast, file = file_name, directory = tempdir())

  units <- c("PSU", "DegC", "dBar", "mS/cm", "unknown/undefined",
             "unknown/undefined", "m", "Ms-1", "kg/M3", "unknown/undefined",
             "unknown/undefined", "ntu")

  names <- c("scan", "salinity", "temperature", "pressure", "conductivity",
             "time", "latitude", "longitude", "date", "depth", "sound.velocity",
             "density", "optics.1", "optics.2", "turbidity")

  expect_true(length(object@metadata$units) == 12)
  expect_identical(object@metadata$units, units)
  expect_true(object@metadata$serialNumber == "54321")
  expect_true(object@metadata$deploymentType == "profile")
  expect_true(object@metadata$filename == file_name)
  expect_identical(names(object@data), names)
})
