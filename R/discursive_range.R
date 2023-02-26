#' Compute the range component of discursive sophistication
#'
#' This function takes a data frame (`data`) containing a set of open-ended responses (`openends`) to compute the Shannon entropy in individual response lengths across items. The function returns a numeric vector of topic counts re-scaled to range from 0 to 1. See Kraft (2023) for details.
#'
#' @param data A data frame.
#' @param openends A character vector containing variable names of open-ended responses in `data`.
#'
#' @return A numeric vector with the same length as the number of rows in `data`.
#' @export
#' @import stringr
#'
#' @examples
#' discursive_range(data = cces,
#'                  openends = c(paste0("oe0", 1:9), "oe10"))
discursive_range <- function(data, openends) {

  ## Check input
  if(!is.data.frame(data)) stop("data must be a data frame.")
  if(!is.character(openends)) stop("openends must be a character vector.")

  ## TODO: add code to handle case where openends is length 1
  if(length(openends) == 1) stop("openends must have length >1.")

  ## Return range
  apply(data[, openends], 1, oe_shannon)
}


#' Compute Shannon entropy
#'
#' Internal function to compute Shannon entropy in relative word counts across a set of elements in a character vecotr. Entropy is re-scaled to range from 0 to 1. Function used in [discursive_range()].
#'
#' @param x Character vector containing open-ended responses.
#'
#' @return Numeric vector with the same length as x.
#'
#' @examples
#' \dontrun{
#' oe_shannon(c(paste(rep("Word", 10), collapse = " "), "Word"))
#' }
oe_shannon <- function(x){
  item_word_n <- stringr::str_count(x, "\\w+")
  item_word_p <- item_word_n / sum(item_word_n)
  -sum(log(item_word_p^item_word_p))/log(length(item_word_p))
}

