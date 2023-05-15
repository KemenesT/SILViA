test_that("the incongruence test returns expected structure", {
  on.exit(unlink(paste0(tempdir(), "\\",
                        list.files(tempdir(), pattern = ".vp2"))))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)

  casts <- casts[casts$filename == unique(casts$filename)[1],]
  casts <- data.frame(casts,
                    incongruent_sv = "No", incongruent_temp = "No",
                    incongruent_sal = "No", incongruent_dens = "No",
                    incongruent_cond = "No", incongruent_chla = "No",
                    pV_sv = NA, pV_temp = NA, pV_sal = NA,
                    pV_dens = NA, pV_cond = NA, pV_chla = NA,
                    warning = NA)

  output <- incongruence_test(casts$time[1], "chla", casts, 0.3, 0.0001,
                             unique(casts$filename), 1)
  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruence", "pV"))
  expect_type(output$incongruence, "character")
  expect_type(output$pV, "double")

  expect_message(incongruence_test(casts$time[1], "chla", casts, 0.1, 0.0001,
                              unique(casts$filename), 1))
})

test_that("the incongruence test returns expected structure", {
  on.exit(unlink(paste0(tempdir(), "\\",
                        list.files(tempdir(), pattern = ".vp2"))))
  setup_example()
  casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
  casts <- data.frame(casts,
                      incongruent_sv = "No", incongruent_temp = "No",
                      incongruent_sal = "No", incongruent_dens = "No",
                      incongruent_cond = "No", incongruent_chla = "No",
                      pV_sv = NA, pV_temp = NA, pV_sal = NA,
                      pV_dens = NA, pV_cond = NA, pV_chla = NA,
                      warning = NA)

  output <- run_inc_test(column = "chla", iterations = 1, df1 = casts,
                         W = 0.3, alpha = 0.0001)

  expect_s3_class(output, "data.frame")
  expect_length(output, 2)
  expect_identical(colnames(output), c("incongruent_chla", "pV_chla"))
  expect_type(output$incongruent_chla, "character")
  expect_type(output$pV_chla, "double")
})
