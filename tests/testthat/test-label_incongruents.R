test_that("incongruents and warnings are labeled for entire file sets", {
  on.exit(unlink(paste0(
    tempdir(), "\\",
    list.files(tempdir(), pattern = ".vp2")
  )))
  setup_example()
  casts <- read_vp2(directory = tempdir(), ID = 12345)
  casts$temperature[10] <- 100
  output <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    method = "t.student"
  )
  expect_identical(colnames(output), c(
    colnames(casts),
    "incongruent_pressure", "pV_pressure",
    "incongruent_sound.velocity", "pV_sound.velocity",
    "incongruent_temperature", "pV_temperature",
    "incongruent_salinity", "pV_salinity",
    "incongruent_density", "pV_density",
    "incongruent_conductivity", "pV_conductivity",
    "incongruent_optics.1", "pV_optics.1",
    "warning"
  ))

  casts <- read_vp2(directory = tempdir(), ID = 54321)
  casts$sound.velocity[1] <- 15400
  casts$temperature[1] <- 100
  casts$salinity[1] <- 100
  casts$density[1] <- 10220
  casts$conductivity[1] <- 300
  casts$optics.1[1] <- 1000
  casts$optics.2[1] <- 1000
  casts$turbidity[1] <- 900
  output <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    method = "t.student"
  )
  expect_identical(colnames(output), c(
    colnames(casts),
    "incongruent_pressure", "pV_pressure",
    "incongruent_sound.velocity", "pV_sound.velocity",
    "incongruent_temperature", "pV_temperature",
    "incongruent_salinity", "pV_salinity",
    "incongruent_density", "pV_density",
    "incongruent_conductivity", "pV_conductivity",
    "incongruent_optics.1", "pV_optics.1",
    "incongruent_optics.2", "pV_optics.2",
    "incongruent_turbidity", "pV_turbidity",
    "warning"
  ))
})
