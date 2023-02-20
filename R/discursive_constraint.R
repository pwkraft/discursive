#' Title
#'
#' @param data
#' @param openends
#' @param dictionary
#'
#' @return
#' @export
#'
#' @examples
discursive_constraint <- function(data, openends, dictionary) {
  ### combine regular survey and open-ended data
  resp <- apply(data[, openends], 1, paste, collapse = " ")

  ## remove potential duplicates from dictionary
  dict <- unique(dictionary)

  count <- rep(0, length(resp))
  for(i in 1:length(dict)){
    count <- count + str_count(resp, dict[i])
  }

  count/max(count)
}


