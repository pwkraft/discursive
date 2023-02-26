#' Compute the constraint component of discursive sophistication
#'
#' This function takes a data frame (`data`) containing a set of open-ended responses (`openends`) and a `dictionary` to identify terms that signal a higher level of constraint between different considerations (usually conjunctions and exclusive words). It returns a numeric vector of dictionary counts re-scaled to range from 0 to 1. See Kraft (2023) for details.
#'
#' @param data A data frame.
#' @param openends A character vector containing variable names of open-ended responses in `data`.
#' @param dictionary A character vector containing dictionary terms to flag conjunctions and exclusive words. May include regular expressions.
#' @param remove_duplicates Logical. If TRUE duplicates in `dictionary` are removed.
#'
#' @return A numeric vector with the same length as the number of rows in `data`.
#' @import stringr
#' @export
#'
#' @examples
#' discursive_constraint(data = cces,
#'                       openends = c(paste0("oe0", 1:9), "oe10"),
#'                       dictionary = dict_constraint)
discursive_constraint <- function(data, openends, dictionary, remove_duplicates = FALSE) {

  ## Check input
  if(!is.data.frame(data)) stop("data must be a data frame.")
  if(!is.character(openends)) stop("openends must be a character vector.")
  if(!is.character(dictionary)) stop("dictionary must be a character vector.")

  ## Combine open-ended items
  resp <- apply(data[, openends], 1, paste, collapse = " ")

  ## Optional: remove potential duplicates from dictionary
  if(remove_duplicates) dictionary <- unique(dictionary)

  ## Count dictionary occurrences
  count <- rowSums(sapply(dictionary, function(x) stringr::str_count(resp, x)))

  ## Re-scale to 0-1
  count/max(count)
}
