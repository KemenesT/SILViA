#' Example CTD Data from a SWiFT Device
#'
#'
#' @docType data
#'
#' @usage data(ctdat)
#'
#' @format An object of class "list" containing multiple profiles as recorded by
#'  a SWiFT CTD device.
#'
#' @keywords datasets
#'
#' @examples
#' ## Load in example data and set it up in the temporary directory:
#' setup_example()
#'
#' ## Read the example casts:
#' casts <- read_vp2(directory = tempdir(), type = "Chlorophyll", ID = 12345)
#'
"ctdat"
