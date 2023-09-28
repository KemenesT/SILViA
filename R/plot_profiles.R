#' Plot CTD Profiles
#'
#' Plots CTD profiles for all variables measured by the CTD are included. Data
#' identified as incongruent are shown as red points, otherwise they are black.
#' The blue line is computed as the moving average with a window of 5 data
#' points constructed with [SILViA::moving_fn()], ignoring data identified as
#' incongruent.
#'
#' Incongruence is determined with either a t-test or one of the methods
#' available from the package "outliers": with a Chi-squared test, Dixon test,
#' Grubbs test, or by determining if a point has the highest residual from the
#' mean of the window specified.
#'
#' @param data Data frame containing data from .vp2 files as obtained from
#' [SILViA::read_vp2()].
#'
#' @param width Window width against which each data-point is compared along the
#' CTD depth profile. Units should match those expressed in the "depth" column
#' of the input data.
#'
#' @param alpha Level of significance used to test the incongruence of
#' data-points. Larger alpha-values make the function more sensitive in the
#' identification of incongruents.
#'
#' @param iterations Number of iterations for applying the incongruence labeling
#' test. Points labeled "incongruent" are ignored in subsequent iterations.
#'
#' @param min.depth Minimum depth above which points are excluded from the
#' profiles. Units should match those expressed in the "depth" column of the
#' input data.
#'
#' @param directory The directory in which to save the "profiles.pdf" file. The
#' working directory is used by default.
#'
#' @param plots Vector of character strings indicating which variables to use as
#' criteria for selecting profiles to plot in the final pdf. All the profiles
#' from a cast will be plotted if an incongruent data point was labeled for the
#' selected variables. The default "any" only excludes plots from casts that
#' had no incongruent data points for all variables. The option "all" plots
#' all casts regardless of whether they had incongruent data points.
#'
#' @param method Method to be used to determine whether a point is an outlier.
#' Should be one of "t.student", "max.residual", "chisq", "dixon", or "grubbs".
#'
#' @return Data frame containing the input data-frame with columns labeling the
#' incongruence of each point for each variable; the "warning" column indicating
#' whether a certain measurement depth has incongruent values for more than two
#' variables. A "profiles" pdf is also created in the working directory
#' including plotted profiles for which Chlorophyll or Turbidity points were
#' identified as incongruent. Red points indicate those labeled as incongruent.
#'
#' @importFrom grDevices dev.off
#' @importFrom grDevices pdf
#' @importFrom gridExtra grid.arrange
#' @importFrom grid textGrob
#' @importFrom grid gpar
#'
#' @export
#'
#' @examples
#' ## Load in example data and set it up in the temporary directory:
#' setup_example()
#'
#' ## Read the example casts:
#' casts <- read_vp2(directory = tempdir(), ID = 12345)
#'
#' ## Select a few samples to plot quickly:
#' selected_files <- unique(casts$filename)[3:4]
#' casts <- casts[which(casts$filename %in% selected_files), ]
#'
#' ## Label incongruents in the imported data and create a pdf with appropriate
#' ## plots:
#' output <- plot_profiles(
#'   data = casts, width = 0.6, alpha = 0.001,
#'   min.depth = 1.5, directory = tempdir(),
#'   method = "t.student"
#' )
#'
#' ## To delete the example pdf you can run the following:
#' unlink(paste0(tempdir(), "/profiles.pdf"))
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2")))
#'
plot_profiles <- function(data, width, alpha, iterations = 1,
                          min.depth = 0, directory = getwd(), plots = "any",
                          method = c(
                            "t.student", "max.residual", "chisq",
                            "dixon", "grubbs"
                          )) {
  method <- match.arg(method)

  pV_sv <- pV_temp <- pV_sal <- pV_ <- pV_dens <- pV_cond <- pV_chla <-
    pV_neph <- pV_obs <- pV_turb <- NULL

  data <- data[data$depth > min.depth, ]

  data <- label_incongruents(
    df1 = data, W = width, alpha = alpha, iterations = iterations
  )

  if (plots == "all") {
    plots <- grep("incongruent_", colnames(data), value = TRUE)
    files <- unique(data$filename)
  } else if (plots == "any") {
    plots <- grep("incongruent_", colnames(data), value = TRUE)
    files <- unique(data[which(apply(data[plots] == "Yes", 1, any)), ]$filename)
  } else {
    plots <- grep("incongruent_", colnames(data), value = TRUE)
    files <- unique(data[which(apply(data[plots] == "Yes", 1, any)), ]$filename)
  }

  pdf(paste0(directory, "/profiles.pdf"), width = 8.3, height = 11.7)

  for (f in seq_along(files)) {
    do1 <- data[data$filename == files[f], ]

    profiles <- lapply(gsub("incongruent_", "", plots),
      draw_plot,
      data = do1
    )


    suppressWarnings(grid.arrange(
      grobs = profiles,
      left = textGrob("Depth (m)", rot = 90, gp = gpar(fontsize = 13)),
      top = textGrob(files[f], gp = gpar(fontsize = 15)),
      ncol = 3
    ))
  }

  dev.off()
  message(paste0("A pdf with profiles was created in directory: ", directory))

  return(data)
}


#' Plot Profile
#'
#' Plots the profile for a selected variable from the CTD data-set. The plot
#' consists of all data points, with those labeled as incongruent colored red.
#' The moving average for a window length of 5 points constructed with
#' [SILViA::moving_fn()] is shown as a blue line.
#'
#' @param var Name of the variable to be plotted. This should be one of: "sv",
#' "temp", "sal", "dens", "cond", "chla", "neph", "obs", or "turb".
#' @param data Data containing the variable to be plotted. This must be a
#' data-frame as returned by [SILViA::label_incongruents()] or
#' [SILViA::plot_profiles()].
#'
#' @return ggplot object of the selected variable.
#'
#' @importFrom dplyr %>%
#' @importFrom dplyr arrange
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_path
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 theme_linedraw
#' @importFrom ggplot2 element_text
#' @importFrom ggplot2 element_blank
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 ylab
#' @importFrom ggplot2 xlab
#'
#' @export
#'
#' @examples
#' ## Load in example data and set it up in the temporary directory:
#' setup_example()
#'
#' ## Read the example casts:
#' casts <- read_vp2(directory = tempdir(), ID = 12345)
#'
#' ## Select the data for one file:
#' selected_filename <- unique(casts$filename)[5]
#' single_file <- casts[which(casts$filename == selected_filename), ]
#'
#' ## Label incongruents in the data:
#' output <- label_incongruents(
#'   df1 = single_file, W = 1, alpha = 0.0001,
#'   method = "t.student"
#' )
#'
#' ## Plot a single profile:
#' draw_plot(var = "optics.1", data = output)
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2")))
#'
draw_plot <- function(var, data) {
  y <- depth <- NULL

  if (identical(which(data[paste0(
    "incongruent_",
    var
  )] == "Yes"), integer(0))) {
    d <- data
    data <- data[-which(data[paste0("incongruent_", var)] == "No"), ]
  } else {
    d <- data[-which(data[paste0("incongruent_", var)] == "Yes"), ]
    data <- data[-which(data[paste0("incongruent_", var)] == "No"), ]
  }

  sel <- as.numeric(order(d$time))
  sel2 <- as.numeric(order(data$time))
  d <- as.data.frame(d)
  data <- as.data.frame(data)
  moving_results <- data.frame(
    x = moving_fn(
      x = d[sel, var], w = 5, fun = mean, side = "centre",
      na.rm = FALSE
    ),
    y = -moving_fn(
      x = d[sel, "depth"], w = 5, fun = mean, side = "centre",
      na.rm = FALSE
    )
  ) %>% arrange(y)

  profile <- ggplot() +
    geom_point(
      aes(x = data[sel2, var], y = -data[sel2, "depth"]),
      fill = "yellow", pch = 23, cex = 2.5
    ) +
    geom_point(
      aes(x = d[sel, var], y = -d[sel, "depth"]),
      color = "black", pch = 16, cex = 1
    ) +
    geom_path(aes(x = moving_results$x, y = moving_results$y), color = "blue") +
    labs(title = var) +
    theme_linedraw() +
    theme(
      plot.title = element_text(face = "bold", vjust = 0.01),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text.x = element_text(angle = -25, vjust = 0.005, size = 7)
    ) +
    ylab(label = "") +
    xlab(label = "")

  return(profile)
}
