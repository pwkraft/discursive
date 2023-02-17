#' Compute number of topics based on stm results
#'
#' @param x: stm model result
#' @param docs:
#'
#' @return data.frame: estimated number of topics and distinctiveness of word choice
#' @import stm
#' @export
#'
#' @examples
ntopics <- function(x, docs){
  if(class(x)!="STM") stop("x must be an STM object")

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
  pb <- txtProgressBar(min = 1, max = nwords, style = 3)
  for(w in 1:nwords){
    for(t in 1:ntopics){
      pt_wx[,w,t] <- pw_t[t,w] * pt_x[,t] / pw_x[,w]
    }
    setTxtProgressBar(pb, w)
  }
  close(pb)

  ## compute sophistication components
  cat("\nComputing sophistication components:\n")
  ntopics <- rep(NA, nobs)
  pb <- txtProgressBar(min = 1, max = nobs, style = 3)
  for(n in 1:nobs){
    maxtopic_wx <- apply(pt_wx[n,,],1,which.max) # which topic has the highest probability for each word (given X)
    ntopics[n] <- length(unique(maxtopic_wx[docs$documents[[n]][1,]])) # number of topics in response
    setTxtProgressBar(pb, n)
  }
  cat("\n\n")

  ## return rescaled measure
  return(ntopics/max(ntopics))
}
