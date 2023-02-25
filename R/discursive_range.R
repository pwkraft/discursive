#' Compute the range component of discursive sophistication
#'
#' @param data Data frame containing open-ended responses
#' @param openends Character vector containing variable names of open-ended items
#'
#' @return Numeric vector of shannon entropy in topic proportions
#' @export
#' @import stringr
#'
#' @examples
discursive_range <- function(data, openends) {
  if(!inherits(openends, "character")) stop("openends must be a character vector")
  ## TODO: add if condition in case openends are only length 1!

  if(length(openends == 1))

  range <- apply(data[, openends], 1, oe_shannon)
  return(range)
}



#' Compute Shannon entropy
#'
#' @param x Character vector containing open-ended responses
#'
#' @return shannon entropy
#'
#' @examples
oe_shannon <- function(x){
  item_word_n <- stringr::str_count(x, "\\w+")
  item_word_p <- item_word_n / sum(item_word_n)
  shannon <- -sum(log(item_word_p^item_word_p))/log(length(item_word_p))
}

