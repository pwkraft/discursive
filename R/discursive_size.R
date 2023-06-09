#' Compute the size component of discursive sophistication
#'
#' This function takes a data frame (`data`) containing a set of open-ended responses (`openends`) and additional arguments passed to [stm::textProcessor()] and [stm::prepDocuments()] to estimate a structural topic model via [stm::stm()]. The results of the the structural topic model are used to compute the relative number of topics raised in each open-ended response. The function returns a numeric vector of topic counts re-scaled to range from 0 to 1. See Kraft (2023) for details.
#'
#' @param data A data frame.
#' @param openends A character vector containing variable names of open-ended responses in `data`.
#' @param meta A character vector containing topic prevalence covariates included in `data`. See [stm::stm()] for details.
#' @param args_textProcessor A named list containing additional arguments passed to [stm::textProcessor()].
#' @param args_prepDocuments A named list containing additional arguments passed to [stm::prepDocuments()].
#' @param args_stm A named list containing additional arguments passed to [stm::stm()].
#' @param keep_stm Logical. If TRUE function returns output of [stm::textProcessor()], [stm::prepDocuments()], and [stm::stm()].
#' @param progress Logical. Shows progress bar if TRUE.
#'
#' @return A list containing the size component of discursive sophistication as well as the output of [stm::textProcessor()], [stm::prepDocuments()], and [stm::stm()].
#' @export
#' @import stm
#' @import tm
#' @import SnowballC
#'
#' @examples
#' \dontrun{discursive_size(data = cces,
#'                 openends = c(paste0("oe0", 1:9), "oe10"),
#'                 meta = c("age", "educ_cont", "pid_cont", "educ_pid", "female"),
#'                 args_prepDocuments = list(lower.thresh = 10),
#'                 args_stm = list(K = 25, seed = 12345))}
discursive_size <- function(data, openends, meta,
                            args_textProcessor = NULL,
                            args_prepDocuments = NULL,
                            args_stm = NULL,
                            keep_stm = TRUE,
                            progress = TRUE){

  ## Check input
  if(!is.data.frame(data)) stop("data must be a data frame.")
  if(!is.character(openends)) stop("openends must be a character vector.")
  if(!is.character(meta)) stop("meta must be a character vector.")

  ## Remove observations with missing values on metadata
  nomis_id <- which(!apply(data[, meta], 1, anyNA))
  nomis <- data[nomis_id, ]

  ## Combine open-ended items
  resp <- apply(nomis[, openends], 1, paste, collapse = " ")

  ## Prepare for stm: textProcessor
  if(is.null(args_textProcessor)) {
    args_textProcessor <- list(documents = resp,
                               metadata = nomis[, meta])
  } else {
    args_textProcessor <- as.list(args_textProcessor)
    if("documents" %in% names(args_textProcessor)) warning("documents in args_textProcessor was replaced internally.")
    if("metadata" %in% names(args_textProcessor)) warning("metadata in args_textProcessor was replaced internally.")
    args_textProcessor$documents <- resp
    args_textProcessor$metadata <- nomis[, meta]
  }
  processed <- do.call(stm::textProcessor, args_textProcessor)

  ## Prepare for stm: prepDocuments
  if(is.null(args_prepDocuments)) {
    args_prepDocuments <- list(documents = processed$documents,
                               vocab = processed$vocab,
                               meta = as.matrix(processed$meta))
  } else {
    args_prepDocuments <- as.list(args_prepDocuments)
    if("documents" %in% names(args_prepDocuments)) warning("documents in args_prepDocuments was replaced internally.")
    if("vocab" %in% names(args_prepDocuments)) warning("vocab in args_prepDocuments was replaced internally.")
    if("meta" %in% names(args_prepDocuments)) warning("meta in args_prepDocuments was replaced internally.")
    args_prepDocuments$documents <- processed$documents
    args_prepDocuments$vocab <- processed$vocab
    args_prepDocuments$meta <- as.matrix(processed$meta)
  }
  out <- do.call(stm::prepDocuments, args_prepDocuments)

  ## Remove discarded observations from nomis_id
  if(length(processed$docs.removed)>0) nomis_id <- nomis_id[-processed$docs.removed]
  if(!is.null(out$docs.removed)) nomis_id <- nomis_id[-out$docs.removed]

  ### Fit stm
  if(is.null(args_stm)) {
    args_stm <- list(documents = out$documents,
                     vocab = out$vocab,
                     prevalence = out$meta)
  } else {
    args_stm <- as.list(args_stm)
    if("documents" %in% names(args_stm)) warning("documents in args_stm was replaced internally.")
    if("vocab" %in% names(args_stm)) warning("vocab in args_stm was replaced internally.")
    if("prevalence" %in% names(args_stm)) warning("prevalence in args_stm was replaced internally.")
    args_stm$documents <- out$documents
    args_stm$vocab <- out$vocab
    args_stm$prevalence <- out$meta
  }
  stm_fit <- do.call(stm::stm, args_stm)

  ### Compute number of considerations
  size <- ntopics(stm_fit, out, progress)

  ### Add NAs for missing observations
  size_na <- rep(NA, nrow(data))
  size_na[nomis_id] <- size

  ## Return output
  if(!keep_stm){
    processed <- NULL
    out <- NULL
    stm_fit <- NULL
  }
  list(size = size_na,
       textProcessor = processed,
       prepDocuments = out,
       stm = stm_fit)
}


#' Compute number of topics based on stm results
#'
#' This function takes a structural topic model output estimated via [stm::stm()] as well as the underlying set of documents created via [stm::prepDocuments()] to compute the relative number of topics raised in each open-ended response. The function returns a numeric vector of topic counts re-scaled to range from 0 to 1. See Kraft (2023) for details.
#'
#' @param x A structural topic model estimated via [stm::stm()].
#' @param docs A set of documents used for the structural topic model; created via [stm::prepDocuments()].
#' @param progress Logical. Shows progress bar if TRUE.
#'
#' @return A numeric vector with the same length as the number of documents in `x` and `docs`.
#' @import stm
#' @import utils
#' @export
#'
#' @examples
#' \dontrun{meta <- c("age", "educ_cont", "pid_cont", "educ_pid", "female")
#' openends <- c(paste0("oe0", 1:9), "oe10")
#' cces$resp <- apply(cces[, openends], 1, paste, collapse = " ")
#' cces <- cces[!apply(cces[, meta], 1, anyNA), ]
#' processed <- stm::textProcessor(cces$resp, metadata = cces[, meta])
#' out <- stm::prepDocuments(processed$documents, processed$vocab, processed$meta, lower.thresh = 10)
#' stm_fit <- stm::stm(out$documents, out$vocab, prevalence = as.matrix(out$meta), K=25, seed=12345)
#' ntopics(stm_fit, out)}
ntopics <- function(x, docs, progress = TRUE){
  if(!inherits(x, "STM")) stop("x must be an STM object")

  ## P(t|X): probability of topic t given covariates X [nobs,ntopics]
  pt_x <- x$theta

  ## P(w|t): probability of word w given topic t [ntopics,nwords]
  pw_t <- exp(x$beta$logbeta[[1]])
  # logbeta: list containing the log of the word probabilities for each topic

  ## P(w|X) = sum_j(P(w|t_j)P(t_j|X)): probability of word w across all topics [nobs,nwords]
  pw_x <- pt_x %*% pw_t

  ## P(t_i|w,X) = P(w|t_i)P(t_i|X)/P(w|X): probability of topic t given word w and covariates X
  nobs <- nrow(pt_x)
  nwords <- ncol(pw_t)
  ntopics <- ncol(pt_x)
  pt_wx <- array(NA, c(nobs, nwords, ntopics))

  if(progress) cat("\nComputing P(t_i|w,X):\n")
  if(progress) pb <- utils::txtProgressBar(min = 1, max = nwords, style = 3)
  for(w in 1:nwords){
    for(t in 1:ntopics){
      pt_wx[,w,t] <- pw_t[t,w] * pt_x[,t] / pw_x[,w]
    }
    if(progress) utils::setTxtProgressBar(pb, w)
  }
  if(progress) close(pb)

  ## compute sophistication components
  if(progress) cat("\nComputing relative topic counts:\n")
  ntopics <- rep(NA, nobs)
  if(progress) pb <- utils::txtProgressBar(min = 1, max = nobs, style = 3)
  for(n in 1:nobs){
    maxtopic_wx <- apply(pt_wx[n,,],1,which.max) # which topic has the highest probability for each word (given X)
    ntopics[n] <- length(unique(maxtopic_wx[docs$documents[[n]][1,]])) # number of topics in response
    if(progress) utils::setTxtProgressBar(pb, n)
  }
  if(progress) close(pb)
  if(progress) cat("\n\n")

  ## return rescaled measure
  ntopics/max(ntopics)
}
