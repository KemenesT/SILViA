#' Moving Function
#'
#' Applies a specified function to subsets of a vector sequentially to compute a
#' 'moving window' along the the vector.
#' The window is defined by each element as either the subsequent (right),
#' preceding (left), or neighboring (center) elements.
#'
#' @param x Vector with numeric data.
#' @param w Window length.
#' @param fun Function to apply.
#' @param side Side to take, (c)entre, (l)eft or (r)ight.
#' @param ... Parameters passed on to 'fun'.
#'
#' @return Vector containing the function outputs for each window along the
#' vector x.
#'
#' @export
#'
#' @examples
#' my_data <- rnorm(50, mean = 30, sd = 5)
#' moving_averages <- moving_fn(my_data, w = 5, fun = mean, side = "center")
#'
moving_fn <- function(x, w, fun, side, ...) {
  y <- vector(mode = class(x), length = length(x))
  for (i in seq_len(length(x))) {
    if (side %in% c("c", "centre", "center")) {
      ind <- c((i - floor(w / 2)):(i + floor(w / 2)))
    } else if (side %in% c("l", "left")) {
      ind <- c((i - floor(w) + 1):i)
    } else if (side %in% c("r", "right")) {
      ind <- c(i:(i + floor(w) - 1))
    } else {
      stop("'side' must be one of 'centre', 'left', 'right'", call. = FALSE)
    }
    ind <- ind[ind %in% seq_len(length(x))]
    y[i] <- fun(x[ind], ...)
  }
  return(y)
}
