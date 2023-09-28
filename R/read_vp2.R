#' Read .vp2 Files
#'
#' Read all .vp2 files in a directory given the CTD file ID.
#'
#' @param directory A character string of the directory from which to retrieve
#' .vp2 files.
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
#' casts <- read_vp2(directory = tempdir(), ID = 12345)
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "/", list.files(tempdir(), pattern = ".vp2")))
#'
read_vp2 <- function(directory, ID) {
  files <- sort(dir(path = directory, pattern = ".vp2"))

  for (i in seq_along(files)) {
    fn <- files[i]
    if (substr(fn, nchar(fn) - 2, nchar(fn)) == "vp2" &
        substr(fn, 4, 8) == ID) {
      lns <- readLines(paste0(directory, "/", fn))
      nms <- lns[which(lns == "[DATA]") + 1]
      nms <- strsplit(nms, split = "/|\t")
      nms <- tolower(unlist(nms))
      nms <- gsub(" ", ".", nms)
      break
    }
  }

  M <- as.data.frame(matrix(ncol = length(nms) + 3))

  names(M) <- c(nms, "filename", "lat", "lon")

  for (i in seq_along(files)) {
    fn <- files[i]
    lns <- readLines(paste0(directory, "/", fn))
    nlat <- grep("latitude", lns, ignore.case = TRUE)
    nlon <- grep("longitude", lns, ignore.case = TRUE)
    start <- which(lns == "[DATA]") + 2
    if (substr(fn, nchar(fn) - 2, nchar(fn)) == "vp2" &
        substr(fn, 4, 8) == ID) {
      if (length(lns) > start + 2) {
        if (suppressWarnings(
          is.na(as.numeric(strsplit(lns[nlat], "=")[[1]][2]))
        )
        ) {
          lat <- as.numeric(strsplit(gsub(",", ".", lns[nlat]), "=")[[1]][2])
          lon <- as.numeric(strsplit(gsub(",", ".", lns[nlon]), "=")[[1]][2])
        } else {
          lat <- as.numeric(strsplit(lns[nlat], "=")[[1]][2])
          lon <- as.numeric(strsplit(lns[nlon], "=")[[1]][2])
        }

        d <- read.table(paste0(directory, "/", fn), skip = start)
        names(d) <- nms
        d$filename <- fn
        d$lat <- lat
        d$lon <- lon
        M <- rbind(M, d)
      }
    }
  }

  M <- M[-1, ] # Removes empty row

  return(M)
}


#' Setup Example CTD Files
#'
#' Sets up the files from ctdat.RData in a temporary directory to read with
#' [SILViA::read_vp2()].
#'
#' @export
#' @examples
#' setup_example() # Saves example CTD files in a temporary directory
#'
#' ## These can be read as:
#' casts <- read_vp2(directory = tempdir(), ID = 12345)
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "/", list.files(tempdir(), pattern = ".vp2")))
#'
setup_example <- function() {
  file1 <- tempfile("VL_12345_000000000001",
    fileext = ".vp2"
  )
  file2 <- tempfile("VL_12345_000000000002",
    fileext = ".vp2"
  )
  file3 <- tempfile("VL_12345_000000000003",
    fileext = ".vp2"
  )
  file4 <- tempfile("VL_12345_000000000004",
    fileext = ".vp2"
  )
  file5 <- tempfile("VL_12345_000000000005",
    fileext = ".vp2"
  )
  file6 <- tempfile("VL_54321_000000000006",
    fileext = ".vp2"
  )
  writeLines(ctdat[[1]], con = file1)
  writeLines(ctdat[[2]], con = file2)
  writeLines(ctdat[[3]], con = file3)
  writeLines(ctdat[[4]], con = file4)
  writeLines(ctdat[[5]], con = file5)
  writeLines(ctdat[[6]], con = file6)
}
