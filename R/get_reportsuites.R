#' Get list of report suites
#'
#' Retrieve a list of report suites and meta data about each one.
#'
#' @param company_id Company ID. If an environment variable called `AW_COMPANY_ID` exists in `.Renviron` or
#' elsewhere and no `company_id` argument is provided, then the `AW_COMPANY_ID` value will be used.
#' Use \code{\link{get_me}} to get a list of available `company_id` values.
#' @param rsids Filter the results to include one or more specific report suites. Specify multiple RSIDs as
#' a vector (i.e., "`rsids = c("rsid_1", rsid_2",...rsid_n")`").
#' @param rsidContains Filter the results list to only include suites that contain the specified string
#' within the RSID. This is case-insensitive and is a simple, single string match.
#' @param limit The number of results to return per page. This argument works in conjunction with the
#' `page` argument. The default is 10.
#' @param page The "page" of results to display. This works in conjunction with the `limit` argument and is
#' zero-based. For instance, if `limit = 20` and `page = 1`, the results returned would be 21 through 40.
#' @param expansion Additional segment metadata fields to include in the results: `name`, `parentRsid`,
#' `currency`, `calendarType`, `timezoneZoneinfo`. This argument takes a single value (e.g., `expansion = "name"`)
#' or a vector of values (e.g., `expansion = c("name", "currency")`).
#' @param debug Include the output and input of the api call in the console for debugging. Default is FALSE
#'
#' @return A data frame of report suites and their meta data.
#'
#' @import stringr
#' @export
#'
aw_get_reportsuites <- function(company_id = Sys.getenv("AW_COMPANY_ID"),
                            rsids = '',
                            rsidContains = '',
                            limit = 10,
                            page = 0,
                            expansion = NA,
                            debug = FALSE)
  {

  #remove spaces from the list of expansion tags
  if(length(rsids) > 1) {rsids = URLencode(paste0(rsids, collapse = ',')) }
  if(length(rsidContains) > 1) {rsidContains = (paste0(rsidContains, collapse = ',')) }
  if(length(expansion) > 1) {expansion = paste(expansion, collapse = ',', sep = '') }

  #create the URL to send with the query
  urlstructure <- sprintf("collections/suites?rsids=%s&rsidContains=%s&limit=%s&page=%s&expansion=%s",
                 rsids,rsidContains,limit,page,expansion)

  res <- aw_call_api(req_path = urlstructure, debug = debug, company_id = company_id)

  res <- jsonlite::fromJSON(res)

  if (res$empty  == TRUE) {
    warning('No Report Suites weere returned!')
  } else {
  #Just need the content of the returned json
  res <- res$content

  res
  }
}
