#' Incongruence Test
#'
#' Tests each point in the input vector for incongruence with the other elements
#' within the specified depth window.
#'
#' @param point_time Time measurement of the data point to be tested for
#' incongruence.
#'
#' @param column Name of the variable being labeled for incongruents in the
#' input data-frame "df1".
#'
#' @param subdf Subset data.frame inherited from [SILViA::run_inc_test()].
#'
#' @param W Halved window-length; inherited from [SILViA::label_incongruents()].
#'
#' @param alpha Level of significance used to test the incongruence of
#' data-points. Larger alpha-values make the function more sensitive in the
#' identification of incongruents.
#'
#' @param casts Vector of all cast names in the data-frame being processed;
#' inherited from [SILViA::run_inc_test()].
#'
#' @param cast Name of the active cast; inherited from
#' [SILViA::run_inc_test()].
#'
#' @importFrom stats sd
#' @importFrom stats pt
#'
#' @return Data frame containing the p-value and incongruence labeling for each
#' data point in the active cast.
#'
incongruence_test <- function(point_time, column, subdf, W,
                              alpha, casts, cast) {
  u <- which(subdf$time == point_time)
  active_depth <- subdf$depth[u]
  depth_range <- vector()
  depth_range[1] <- active_depth - W
  depth_range[2] <- active_depth + W
  window1 <- which(subdf$depth > depth_range[1] & subdf$depth < depth_range[2])

  if (length(window1) < 3) {
    message(paste0(
      "Window width is too narrow for point ", u, " in file ",
      casts[cast]
    ))
  }

  window1 <- window1[-which(window1 == u)]

  S <- sd(subdf[window1, column])
  Mean <- mean(subdf[window1, column])
  Tv <- (subdf[u, column] - Mean) / S
  pV <- pt(q = Tv, df = length(window1), lower.tail = FALSE)

  ###############################################################



  ###############################################################

  if (is.na(pV < alpha)) {
    incongruence <- "Error"
    pV <- "Error"
  } else if (pV < alpha) {
    incongruence <- "Yes"
  } else {
    incongruence <- "No"
  }

  output <- data.frame(incongruence = incongruence, pV = pV)
  return(output)
}


#' Run Incongruence Test
#'
#' Applies [SILViA::incongruence_test()] to each cast in a specified column from
#' the input data frame. This is done for the specified number of iterations.
#'
#' @param column Name of the variable being labeled for incongruents in the
#' input data-frame "df1".
#'
#' @param iterations Number of iterations for applying the incongruence labeling
#' test. Points labeled "incongruent" are ignored in subsequent iterations.
#'
#' @param df1 Data frame containing data from .vp2 files as obtained from
#' [SILViA::read_vp2()].
#'
#' @param W Halved window-length; inherited from [SILViA::label_incongruents()].
#'
#' @param alpha Level of significance used to test the incongruence of
#' data-points. Larger alpha-values make the function more sensitive in the
#' identification of incongruents.
#'
#' @return Data frame containing the original input data, followed by columns
#' indicating the incongruent labeling and p-value outcomes of each data point
#' for each variable.
#'
run_inc_test <- function(column, iterations, df1, W, alpha) {
  filename <- NULL

  for (iterate in 1:iterations) {
    subdf_all <- subset(df1, df1[, paste0("incongruent_", column)] == "No")

    active_df <- which(df1[, paste0("incongruent_", column)] == "No")

    casts <- unique(subdf_all$filename)

    for (cast in seq_along(casts)) {
      subdf <- subset(subdf_all, filename == casts[cast])
      active <- which(subdf_all$filename == casts[cast])

      output <- do.call(rbind.data.frame, lapply(
        X = subdf$time,
        FUN = incongruence_test,
        column, subdf, W, alpha,
        casts, cast
      ))

      df1[active_df[active], paste0(
        "incongruent_",
        column
      )] <- output$incongruence
      df1[active_df[active], paste0("pV_", column)] <- output$pV

      output <- df1[, c(paste0("incongruent_", column), paste0("pV_", column))]
    }
  }
  return(output)
}
