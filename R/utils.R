#' Compute Shannon entropy
#'
#' @param x Numeric vector containing word count percentages across items
#'
#' @return shannon entropy
#'
#' @examples
shannon <- function(x){
  -sum(log(x^x)/log(length(x)))
}
