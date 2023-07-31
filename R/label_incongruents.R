#' Label Incongruents
#'
#' Creates additional columns to a data-frame in the format obtained from
#' [SILViA::read_vp2()], indicating for each variable weather a data point is
#' incongruent, and the associated p-value for the observation. Additionally it
#' creates a "warnings" column indicating whether three or more variables for a
#' given measurement depth show incongruent values.
#'
#' Incongruence is determined with either a t-test or one of the methods
#' available from the package "outliers": with a Chi-squared test, Dixon test,
#' Grubbs test, or by determining if a point has the highest residual from the
#' mean of the window specified.
#'
#' @param df1 Data frame containing data from .vp2 files as obtained from
#' [SILViA::read_vp2()].
#'
#' @param W Window width against which each data-point is compared along the CTD
#' depth profile. Units should match those expressed in the "depth" column of
#' the input data.
#'
#' @param alpha Level of significance used to test the incongruence of
#' data-points. Larger alpha-values make the function more sensitive in the
#' identification of incongruents.
#'
#' @param iterations Number of iterations for applying the incongruence labeling
#' test. Points labeled "incongruent" are ignored in subsequent iterations.
#'
#' @param type A character string. Either "Chlorophyll" or "Turbidity" for the
#' appropriate CTD measurement type.
#'
#' @param method Method to be used to determine whether a point is an outlier.
#' Should be one of "t.student", "max.residual", "chisq", "dixon", or "grubbs".
#'
#' @return List. Contains two data-frames. "labeled_data" contains the input
#' data-frame with columns labeling the incongruence of each point for each
#' variable; the "warning" column indicating whether a certain measurement depth
#' has incongruent values for more than two variables.
#'
#' @export
#'
#' @examples
#' ## Load in example data and set it up in the temporary directory:
#' setup_example()
#'
#' ## Read the example casts:
#' casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
#' casts <- casts[which(casts$filename %in% unique(casts$filename)[1:2]),]
#'
#' ## Label incongruents in the imported data:
#' output <- label_incongruents(
#'   df1 = casts, W = 0.6, alpha = 0.0001,
#'   type = "Chlorophyll",
#'   method = "t.student"
#' )
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2")))
#'
label_incongruents <- function(df1, W, alpha, iterations = 1,
                               type = c("Chlorophyll", "Turbidity"),
                               method = c("t.student", "max.residual", "chisq",
                                          "dixon", "grubbs")) {
  type <- match.arg(type)
  method <- match.arg(method)
  qt <- sv <- temp <- sal <- dens <- cond <- chla <- neph <- obs <- turb <- NULL
  W <- W / 2

  if (type == "Chlorophyll") {
    df1 <- data.frame(df1,
      incongruent_sv = "No", incongruent_temp = "No",
      incongruent_sal = "No", incongruent_dens = "No",
      incongruent_cond = "No", incongruent_chla = "No",
      pV_sv = NA, pV_temp = NA, pV_sal = NA,
      pV_dens = NA, pV_cond = NA, pV_chla = NA,
      warning = NA
    )
    outputs <- do.call(
      cbind.data.frame,
      lapply(
        c("sv", "temp", "sal", "dens", "cond", "chla"),
        run_inc_test, iterations, df1, W, alpha, method
      )
    )
    df1 <- data.frame(df1[, c(
      "date", "time", "depth", "pressure", "sv", "temp",
      "sal", "dens", "cond", "chla", "filename", "lat",
      "lon"
    )], outputs, warning = df1[, "warning"])

    for (i in seq_len(nrow(df1))) {
      count <- 0
      if (df1[i, "incongruent_sv"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_temp"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_sal"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_dens"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_cond"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_chla"] == "Yes") {
        count <- count + 1
      }

      if (count > 2) {
        df1[i, "warning"] <- "Yes"
      }
    }

    Warnings <- df1[which(df1$warning == "Yes"), ]

    return(df1)
  } else if (type == "Turbidity") {
    df1 <- data.frame(df1,
      incongruent_sv = "No", incongruent_temp = "No",
      incongruent_sal = "No", incongruent_dens = "No",
      incongruent_cond = "No", incongruent_neph = "No",
      incongruent_obs = "No", incongruent_turb = "No",
      pV_sv = "No", pV_temp = "No", pV_sal = "No",
      pV_dens = "No", pV_cond = "No", pV_neph = "No",
      pV_obs = "No", pV_turb = "No", warning = "No"
    )
    outputs <- do.call(
      cbind.data.frame,
      lapply(
        c(
          "sv", "temp", "sal", "dens", "cond", "neph",
          "obs", "turb"
        ),
        run_inc_test, iterations, df1, W, alpha, method
      )
    )
    df1 <- data.frame(
      df1[, c(
        "date", "time", "depth", "pressure", "sv", "temp",
        "sal", "dens", "cond", "neph", "obs", "turb",
        "filename", "lat", "lon"
      )],
      outputs,
      warning = df1[, "warning"]
    )

    for (i in seq_len(nrow(df1))) {
      count <- 0
      if (df1[i, "incongruent_sv"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_temp"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_sal"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_dens"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_cond"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_neph"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_obs"] == "Yes") {
        count <- count + 1
      }
      if (df1[i, "incongruent_turb"] == "Yes") {
        count <- count + 1
      }

      if (count > 2) {
        df1[i, "warning"] <- "Yes"
      }
    }

    return(df1)
  }
}
