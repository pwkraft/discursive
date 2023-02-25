#' Compute the size component of discursive sophistication
#'
#' @param data
#' @param openends
#' @param meta
#' @param customstopwords
#' @param lower.tresh
#' @param K
#' @param seed
#'
#' @return
#' @export
#' @import stm
#' @import tm
#' @import SnowballC
#'
#' @examples
discursive_size <- function(data, openends, meta, customstopwords = NULL, lower.tresh = 10, K = 0, seed = NULL){

  ### remove missings on metadata
  nomis_id <- which(!apply(data[, meta], 1, anyNA))
  nomis <- data[nomis_id, ]

  ### combine regular survey and open-ended data, remove empty responses
  resp <- apply(nomis[, openends], 1, paste, collapse = " ")

  ### remove additional whitespaces
  resp <- gsub("\\s+"," ", resp)
  resp <- gsub("(^\\s+|\\s+$)","", resp)

  ### process for stm
  processed <- stm::textProcessor(resp, metadata = nomis[,meta],
                                  customstopwords = customstopwords)
  out <- stm::prepDocuments(processed$documents, processed$vocab, processed$meta,
                            lower.thresh = lower.tresh)

  ### remove discarded observations from data
  nomis <- nomis[-c(processed$docs.removed, out$docs.removed), ]
  nomis_id <- nomis_id[-c(processed$docs.removed, out$docs.removed)]

  ### stm fit with 49 topics
  stm_fit <- stm::stm(out$documents, out$vocab, prevalence = as.matrix(out$meta),
                      K = K, seed = seed)

  ### compute number of considerations
  size <- ntopics(stm_fit, out)

  ### add NAs for missing observations
  out <- rep(NA, nrow(data))
  out[nomis_id] <- size

  return(out)
}


#' Compute number of topics based on stm results
#'
#' @param x: stm model result
#' @param docs:
#'
#' @return data.frame: estimated number of topics and distinctiveness of word choice
#' @import stm
#' @import utils
#' @export
#'
#' @examples
ntopics <- function(x, docs){
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

  cat("\nComputing P(t_i|w,X):\n")
  pb <- utils::txtProgressBar(min = 1, max = nwords, style = 3)
  for(w in 1:nwords){
    for(t in 1:ntopics){
      pt_wx[,w,t] <- pw_t[t,w] * pt_x[,t] / pw_x[,w]
    }
    utils::setTxtProgressBar(pb, w)
  }
  close(pb)

  ## compute sophistication components
  cat("\nComputing sophistication components:\n")
  ntopics <- rep(NA, nobs)
  pb <- utils::txtProgressBar(min = 1, max = nobs, style = 3)
  for(n in 1:nobs){
    maxtopic_wx <- apply(pt_wx[n,,],1,which.max) # which topic has the highest probability for each word (given X)
    ntopics[n] <- length(unique(maxtopic_wx[docs$documents[[n]][1,]])) # number of topics in response
    utils::setTxtProgressBar(pb, n)
  }
  cat("\n\n")

  ## return rescaled measure
  return(ntopics/max(ntopics))
}
