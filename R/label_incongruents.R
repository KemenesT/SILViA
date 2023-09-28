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
#' casts <- read_vp2(directory = tempdir(), ID = 12345)
#' casts <- casts[which(casts$filename %in% unique(casts$filename)[1:2]), ]
#'
#' ## Label incongruents in the imported data:
#' output <- label_incongruents(
#'   df1 = casts, W = 0.6, alpha = 0.0001,
#'   method = "t.student"
#' )
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2")))
#'
label_incongruents <- function(df1, W, alpha, iterations = 1,
                               method = c(
                                 "t.student", "max.residual", "chisq",
                                 "dixon", "grubbs"
                               )) {
  method <- match.arg(method)
  W <- W / 2

  org_names <- colnames(df1)
  tocheck <- colnames(df1)[-which(colnames(df1) %in% c(
    "date", "time", "depth",
    "filename", "lat", "lon"
  ))]
  inc_new <- paste0("incongruent_", tocheck)
  pV_new <- paste0("pV_", tocheck)

  original_length <- length(colnames(df1))

  df1[, seq.int(
    from = original_length + 1,
    by = 1, length.out = length(inc_new) * 2
  )] <- NA

  colnames(df1)[seq.int(
    from = original_length + 1,
    by = 1, length.out = length(inc_new) * 2
  )] <- c(
    inc_new,
    pV_new
  )
  df1$warning <- NA
  df1[, grep("incongruent_", colnames(df1), value = TRUE)] <- "No"
  df1[, grep("pV_", colnames(df1), value = TRUE)] <- NA

  outputs <- do.call(
    cbind.data.frame,
    lapply(
      tocheck,
      run_inc_test, iterations, df1, W, alpha, method
    )
  )

  df1 <- data.frame(df1[, org_names], outputs, warning = df1[, "warning"])

  df1$warning <- rowSums(ifelse(df1[, inc_new] == "Yes", 1, 0))
  df1$warning <- ifelse(df1$warning > 2, "Yes", "No")

  return(df1)
}
