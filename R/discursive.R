#' Compute discursive sophistication for a set of open-ended responses
#'
#' This function takes a data frame (`data`) containing a set of open-ended responses (`openends`) to compute the three components of discursive sophistication (size, range, and constraint) and combines them in a single scale. See Kraft (2023) for details.
#'
#' @param data A data frame.
#' @param openends A character vector containing variable names of open-ended responses in `data`.
#' @param meta A character vector containing topic prevalence covariates included in `data`. See [stm::stm()] for details.
#' @param args_textProcessor A named list containing additional arguments passed to [stm::textProcessor()].
#' @param args_prepDocuments A named list containing additional arguments passed to [stm::prepDocuments()].
#' @param args_stm A named list containing additional arguments passed to [stm::stm()].
#' @param keep_stm Logical. If TRUE function returns output of [stm::textProcessor()], [stm::prepDocuments()], and [stm::stm()].
#' @param dictionary A character vector containing dictionary terms to flag conjunctions and exclusive words. May include regular expressions.
#' @param remove_duplicates Logical. If TRUE duplicates in `dictionary` are removed.
#' @param type The method of combining the three components, must be "scale", "average", "average_scale", or "product". The default is "scale", which creates an additive index that is re-scaled to mean 0 and standard deviation 1. Alternatively, "average" creates the same additive index without re-scaling; "average_scale" re-scales each individual component to mean 0 and standard deviation 1 before creating the additive index; "product" creates a multiplicative index.

#'
#' @return A numeric vector with the same length as the number of rows in `data`.
#' @export
#'
#' @examples
#' discursive(data = cces,
#'            openends = c(paste0("oe0", 1:9), "oe10"),
#'            meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
#'            args_prepDocuments = list(lower.thresh = 10),
#'            args_stm = list(K = 25, seed = 12345),
#'            dictionary = dict_sample)
discursive <- function(data, openends, meta,
                       args_textProcessor = NULL,
                       args_prepDocuments = NULL,
                       args_stm = NULL,
                       keep_stm = TRUE,
                       dictionary, remove_duplicates = FALSE,
                       type = c("scale","average","average_scale","product")) {

  oe_size <- discursive_size(data = data,
                             openends = openends,
                             meta = meta,
                             args_textProcessor = args_textProcessor,
                             args_prepDocuments = args_prepDocuments,
                             args_stm = args_stm,
                             keep_stm = keep_stm)

  oe_range <- discursive_range(data = data, openends = openends)

  oe_constraint <- discursive_constraint(data = data, openends = openends, dictionary = dictionary)

  oe_discursive <- discursive_combine(oe_size, oe_range, oe_constraint, type = type)

  ## TODO: output of class discursive, add description of elements in documentation
  list(
    output = data.frame(
      size = oe_size$size,
      range = oe_range,
      constraint = oe_constraint,
      discursive = oe_discursive
    ),
    textProcessor = oe_size$textProcessor,
    prepDocuments = oe_size$prepDocuments,
    stm = oe_size$stm
  )
}

#' Combine three components of discursive sophistication in a single scale
#'
#' This function combines the `size`, `range`, and `constraint` of open-ended responses in a single scale. See Kraft (2023) for details.
#'
#' @param size A numeric vector containing the size component of discursive sophistication. Usually created via [discursive_size()].
#' @param range A numeric vector containing the range component of discursive sophistication. Usually created via [discursive_range()].
#' @param constraint A numeric vector containing the constraint component of discursive sophistication. Usually created via [discursive_constraint()].
#' @param type The method of combining the three components, must be "scale", "average", "average_scale", or "product". The default is "scale", which creates an additive index that is re-scaled to mean 0 and standard deviation 1. Alternatively, "average" creates the same additive index without re-scaling; "average_scale" re-scales each individual component to mean 0 and standard deviation 1 before creating the additive index; "product" creates a multiplicative index.
#'
#' @return A numeric vector with the same length as the number of rows in `data`.
#' @export
#'
#' @examples
#' discursive_combine(size = runif(100), range = runif(100), constraint = runif(100))
discursive_combine <- function(size, range, constraint, type = c("scale","average","average_scale","product")) {
  type <- match.arg(type)
  switch(type,
         scale = as.numeric(scale(size$size + range + constraint)),
         average = (size$size + range + constraint)/3,
         average_scale = as.numeric(scale(size$size) + scale(range) + scale(constraint))/3,
         product = size$size * range * constraint)
  ## TODO: add attributes to save output type
}
