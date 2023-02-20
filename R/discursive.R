#' Title
#'
#' @param data
#' @param openends
#' @param dictionary
#' @param meta
#' @param customstopwords
#' @param lower.tresh
#' @param K
#' @param seed
#'
#' @return
#' @export
#'
#' @examples
discursive <- function(data, openends, dictionary, meta, customstopwords = NULL, lower.tresh = 10, K = 0, seed = NULL) {

  # data = cces
  # openends = c(paste0("oe0", 1:9), "oe10")
  # dictionary = constraint$constraint
  # meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female")
  # customstopwords = c("dont", "hes", "shes", "that", "etc")
  # K = 25
  # seed = 12345

  oe_size <- discursive_size(data = data, openends = openends,
                             meta = meta,
                             customstopwords = customstopwords,
                             lower.tresh = lower.tresh,
                             K = K, seed = seed)
  oe_range <- discursive_range(data = data, openends = openends)
  oe_constraint <- discursive_constraint(data = data, openends = openends, dictionary = dictionary)

  discursive_combine(oe_size, oe_range, oe_constraint)
}

#' Title
#'
#' @param size
#' @param range
#' @param constraint
#'
#' @return
#' @export
#'
#' @examples
discursive_combine <- function(size, range, constraint) {
  out <- as.numeric(scale(size + range + constraint))
  return(out)
}
