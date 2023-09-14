#' Convert vp2 Cast Data to oce Object
#'
#' For a data-frame as obtained by [SILViA::read_vp2()], converts a single cast
#' file into an oce object.
#'
#' @param data A data-frame with .vp2 CTD data as returned by
#' [SILViA::read_vp2()].
#'
#' @param file  Filename of the cast to be converted into an oce object.
#'
#' @param directory  Directory where the raw .vp2 file corresponding to the cast
#'                   to be converted is stored. This is necessary to extract the
#'                   meta-data included included in the oce object.
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
#' casts <- read_vp2(directory = tempdir(), ID = 12345)
#'
#' ## Subset single cast:
#' file_name <- unique(casts$filename)[1]
#' cast <- casts[which(casts$filename == file_name), ]
#'
#' ## Convert single cast to oce object:
#' object <- vp2.as.oce(data = cast, file = file_name, directory = tempdir())
#'
#' ## To clear the temporary directory after using 'setup_example()':
#' unlink(paste0(tempdir(), "/", list.files(tempdir(), pattern = ".vp2")))
#'
vp2.as.oce <- function(data, file, directory) {

  lines <- readLines(paste0(directory, "/", file))
  serialnumber <- gsub(".*=", "\\1",
                       grep("serialnumber", lines, ignore.case = T, value = T))
  lines <- lines[(which(lines == "[COLUMNS]")+1):(which(lines == "[DATA]")-2)]

  cast <- data[which(data$filename == file), ]

  cast$time <- strptime(cast$time, format = "%H:%M:%OS")

  getunit <- function(var){
    variable <- grep(var, lines, value = TRUE, ignore.case = TRUE)
    unit <- gsub(".*;(.+);.*", "\\1", variable)
    if(!identical(grep(";;", unit), integer(0))) {unit <- "unknown/undefined"}
    if(identical(variable, character(0))) {unit <- "unknown/undefined"}
    return(unit)
  }

  object <- as.ctd(
    salinity = cast$salinity,
    temperature = cast$temperature,
    pressure = cast$pressure,
    conductivity = cast$conductivity,
    time = cast$time,
    units = unlist(lapply(c("salinity", "temperature", "pressure",
                            "conductivity", "time"), getunit)),
    missingValue = NULL,
    serialNumber = serialnumber,
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

  donecols <- c("salinity", "temperature", "pressure", "conductivity", "time",
                "filename", "lat", "lon")
  todocols <- colnames(cast)[-which(colnames(cast) %in% donecols)]

  missing_data <- list(
    name = todocols,
    value = as.list(cast[, todocols]))

  for(n in seq_along(missing_data$name)) {
    object <- add.data(object, missing_data$name[n], missing_data$value[n])
  }

  return(object)
}
