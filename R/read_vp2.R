#' Read .vp2 Files
#'
#' Read all .vp2 files in a directory given the CTD file ID and measurement
#' type.
#'
#' @param directory A character string of the directory from which to retrieve
#' .vp2 files.
#'
#' @param type A character string. Either "Chlorophyll" or "Turbidity" for the
#' appropriate CTD measurement type.
#'
#' @param ID Numeric. The ID of the CTD present in each file as:
#' "VL_ID_filenumber.vp2"
#'
#' @importFrom utils read.table
#'
#' @return A data frame containing the data for all .vp2 files in stacked
#' format.
#'
#' @export
#'
#' @examples
#' ## Load in example data and set it up in the temporary directory:
#' setup_example()
#'
#' ## Read the example casts:
#' casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2")))
#'
read_vp2 <- function(directory, type = c("Chlorophyll", "Turbidity"), ID) {
  files <- sort(dir(path = directory, pattern = ".vp2"))

  if (type == "Chlorophyll") {
    nms <- c(
      "date", "time", "depth", "pressure", "sv", "temp", "sal", "dens",
      "cond", "chla"
    )
  } else if (type == "Turbidity") {
    nms <- c(
      "date", "time", "depth", "pressure", "sv", "temp", "sal", "dens",
      "cond", "neph", "obs", "turb"
    )
  } else {
    stop("'type' must be one of 'Chlorophyll' or 'Turbidity'",
         call. = FALSE)
  }

  M <- as.data.frame(matrix(ncol = length(nms) + 3))

  names(M) <- c(nms, "filename", "lat", "lon")

  for (i in seq_along(files)) {
    fn <- files[i]
    if (substr(fn,
               nchar(fn) - 2, nchar(fn)) == "vp2" & substr(fn, 4, 8) == ID) {
      lns <- readLines(paste0(directory, "\\", fn))
      if (length(lns) > 58) {
        if (is.na(as.numeric(strsplit(lns[27], "=")[[1]][2]))) {
          lat <- as.numeric(strsplit(gsub(",", ".", lns[27]), "=")[[1]][2])
          lon <- as.numeric(strsplit(gsub(",", ".", lns[28]), "=")[[1]][2])
        } else {
          lat <- as.numeric(strsplit(lns[27], "=")[[1]][2])
          lon <- as.numeric(strsplit(lns[28], "=")[[1]][2])
        }

        if (lat != 999 | lon != 999) {
          if (type == "Chlorophyll") {
            if ("try-error" %in%
                class(try(read.table(paste0(directory, "/", fn), skip = 56)))) {
      stop("Data type 'Chlorophyll' chosen for a device measuring Turbidity.",
           call. = FALSE)
            }
            d <- read.table(paste0(directory, "/", fn), skip = 56)
          } else if (type == "Turbidity") {
            d <- read.table(paste0(directory, "/", fn), skip = 58)
            if (length(names(d)) != length(nms)) {
              stop("Data type 'Turbidity' chosen for a device measuring Chlorophyll.",
                   call. = FALSE)
            }
          }
          names(d) <- nms
          d$filename <- fn
          d$lat <- lat
          d$lon <- lon
          M <- rbind(M, d)
        }
      }
    }
  }

  M <- M[-1, ] # Removes empty row

  return(M)
}


#' Setup Example CTD Files
#'
#' Sets up the files from ctdat.RData in a temporary directory to read with
#' read_vp2().
#'
#' @export
#' @examples
#' setup_example() # Saves example CTD files in a temporary directory
#'
#' ## These can be read as:
#' casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "\\", list.files(tempdir(), pattern = ".vp2")))
#'
setup_example <- function() {
  VL_12345_000000000001.vp2 <- tempfile("VL_12345_000000000001",
    fileext = ".vp2"
  )
  VL_12345_000000000002.vp2 <- tempfile("VL_12345_000000000002",
    fileext = ".vp2"
  )
  VL_12345_000000000003.vp2 <- tempfile("VL_12345_000000000003",
    fileext = ".vp2"
  )
  VL_12345_000000000004.vp2 <- tempfile("VL_12345_000000000004",
    fileext = ".vp2"
  )
  VL_12345_000000000005.vp2 <- tempfile("VL_12345_000000000005",
    fileext = ".vp2"
  )
  VL_54321_000000000006.vp2 <- tempfile("VL_54321_000000000006",
    fileext = ".vp2"
  )
  writeLines(ctdat[[1]], con = VL_12345_000000000001.vp2)
  writeLines(ctdat[[2]], con = VL_12345_000000000002.vp2)
  writeLines(ctdat[[3]], con = VL_12345_000000000003.vp2)
  writeLines(ctdat[[4]], con = VL_12345_000000000004.vp2)
  writeLines(ctdat[[5]], con = VL_12345_000000000005.vp2)
  writeLines(ctdat[[6]], con = VL_54321_000000000006.vp2)
}
