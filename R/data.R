#' Cooperative Congressional Election Study 2018
#'
#' A subset of data from the UWM Team Content of the 2018 CCES wave. See Kraft (2023) for details.
#'
#' @format ## `cces`
#' A data frame with 1,000 rows and 15 columns:
#' \describe{
#'   \item{age}{Age (in years)}
#'   \item{female}{Gender (1 = female)}
#'   \item{educ_cont}{Education level (1-6)}
#'   \item{pid_cont}{Party identification (1-7)}
#'   \item{educ_pid}{educ_cont * pid_cont}
#'   \item{oe01-oe10}{Open-ended responses}
#' }
#' @source <https://cces.gov.harvard.edu/>
"cces"


#' Constraint Dictionary
#'
#' A sample of terms that signal a higher level of constraint between different considerations (combining conjunctions and exclusive words). See Kraft (2023) for details.
#'
#' @format ## `cces`
#' A data character vector with 4 elements:
#' \describe{
#'   \item{conjunctions}{also, and}
#'   \item{exclusive}{but, without}
#' }
"dict_sample"
