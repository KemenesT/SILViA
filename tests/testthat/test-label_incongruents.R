test_that("incongruents and warnings are labeled for entire file sets", {
  on.exit(unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2"))))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts$temp[10] <- 100
  output <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    type = "Chlorophyll"
  )
  expect_identical(colnames(output), c(colnames(casts),
                                       "incongruent_sv", "pV_sv",
                                       "incongruent_temp", "pV_temp",
                                       "incongruent_sal", "pV_sal",
                                       "incongruent_dens", "pV_dens",
                                       "incongruent_cond", "pV_cond",
                                       "incongruent_chla", "pV_chla",
                                       "warning"))

  casts <- read_vp2(directory = tempdir(), type = "Turbidity", ID = 54321)
  casts$sv[1] <- 15400
  casts$temp[1] <- 100
  casts$sal[1] <- 100
  casts$dens[1] <- 10220
  casts$cond[1] <- 300
  casts$neph[1] <- 1000
  casts$obs[1] <- 1000
  casts$turb[1] <- 900
  output <- label_incongruents(
    df1 = casts, W = 1, alpha = 0.0001,
    type = "Turbidity"
  )
  expect_identical(colnames(output), c(colnames(casts),
                                       "incongruent_sv", "pV_sv",
                                       "incongruent_temp", "pV_temp",
                                       "incongruent_sal", "pV_sal",
                                       "incongruent_dens", "pV_dens",
                                       "incongruent_cond", "pV_cond",
                                       "incongruent_neph", "pV_neph",
                                       "incongruent_obs", "pV_obs",
                                       "incongruent_turb", "pV_turb",
                                       "warning"))
})
