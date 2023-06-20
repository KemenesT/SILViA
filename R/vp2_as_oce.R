#' Convert Cast Data to oce Object
#'
#' For a data-frame as obtained by [SILViA::read_vp2()], converts a single cast
#' file into an oce object applying [oce::as.ctd].
#'
#' @param data A data-frame with .vp2 CTD data as returned by
#' [SILViA::read_vp2()].
#'
#' @param file Filename of the cast to be converted into an oce object.
#'
#' @param directory Directory where the raw .vp2 file corresponding to the cast
#' to be converted is stored. This is necessary to extract the meta-data that
#' is included for the file in the oce object.
#'
#' @param type A character string. Either "Chlorophyll" or "Turbidity" for the
#' appropriate CTD measurement type.
#'
#'
#' @importFrom oce as.ctd
#'
#' @importFrom oce oceSetData
#'
#' @return An oce object of class "ctd" containing the data for a single .vp2
#' file.
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
#' ## Subset single cast:
#' file_name <- unique(casts$filename)[1]
#' cast <- casts[which(casts$filename == file_name), ]
#'
#' ## Convert single cast to oce object:
#' object <- vp2.as.oce(data = cast, file = file_name, directory = tempdir(),
#'                      type = "Chlorophyll")
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "/", list.files(tempdir(), pattern = ".vp2")))
#'
vp2.as.oce <- function(data, file, directory,
                       type = c("Chlorophyll", "Turbidity")) {

  if (type == "Chlorophyll") {
    nms <- c("chlorophyll")
    lines <- readLines(paste0(directory, "/", file))[c(20, 44:52)]
  } else if (type == "Turbidity") {
    nms <- c("Nephelometer", "OBS", "turbidity")
    lines <- readLines(paste0(directory, "/", file))[c(20, 44:54)]
  } else {
    stop("'type' must be one of 'Chlorophyll' or 'Turbidity'",
         call. = FALSE)
  }

  cast <- data[which(data$filename == file), ]

  cast$time <- strptime(cast$time, format = "%H:%M:%OS")

  getunit <- function(var){
    variable <- grep(var, lines, value = TRUE, ignore.case = TRUE)
    unit <- gsub(".*;(.+);.*", "\\1", variable)
    if(!identical(grep(";;", unit), integer(0))) {unit <- ""}
    return(unit)
  }

  object <- as.ctd(
    salinity = cast$sal,
    temperature = cast$temp,
    pressure = cast$pressure,
    conductivity = cast$cond,
    time = cast$time,
    units = unlist(lapply(c("sal", "temp", "press", "cond", "time"), getunit)),
    missingValue = NULL,
    serialNumber = gsub(".*=", "\\1", lines[1]),
    startTime = cast$time[1],
    longitude = cast$lon,
    latitude = cast$lat,
    deploymentType = "profile"
  )

  object@metadata$filename <- unique(cast$filename)

  add.data <- function(object, name, value) {
    object <- oceSetData(object,
                         name = name,
                         value = value)
    object@metadata$units <- append(object@metadata$units, getunit(name))
    return(object)
  }

  if (type == "Chlorophyll") {
    missing_data <- list(
      name = c("date", "depth", "velocity", "density", nms),
      value = list(cast$date, cast$depth, cast$sv, cast$dens,
                   cast$chla))
  } else if (type == "Turbidity") {
    missing_data <- list(
      name = c("date", "depth", "velocity", "density", nms),
      value = list(cast$date, cast$depth, cast$sv, cast$dens,
                   cast$neph, cast$obs, cast$turb))
  }

  for(n in 1:length(missing_data$name)) {
    object <- add.data(object, missing_data$name[n], missing_data$value[n])
  }

  return(object)
}
