getCommentLikes <- function (comment, token, n = 500) 
{
  # Gets the likes on a comment. Works with graph API v2.2 for sure. 
  # Source code modified from https://github.com/pablobarbera/Rfacebook
  
  # comment: a numeric ID for a post in the form "1234567890_1234567890"
  #          OR a comment in the form "1234567890_1234567890_1234567890"
  # token: access token
  # n: maximum number of likes. Hard capped to 500. 
  #
  # Returns: 
  #  the data given by the graph query. 
  
  url <- paste0("https://graph.facebook.com/", comment, "/likes?")
  if (n >= 500) {
    url <- paste0(url, ".limit(500)")
  }
  else if (n < 500) {
    url <- paste0(url, ".limit(", n, ")")
  }
  
  content <- callAPI(url = url, token = token)
  error <- 0
  while (length(content$error_code) > 0) {
    cat("Error!\n")
    Sys.sleep(0.5)
    error <- error + 1
    content <- callAPI(url = url, token = token)
    if (error == 3) {
      stop(content$error_msg)
    }
  }
  return (content$data)
}

# Source code directly copied from: https://github.com/pablobarbera/Rfacebook
callAPI <- function(url, token){
  if (class(token)[1]=="config"){
    url.data <- GET(url, config=token)
  }
  if (class(token)[1]=="Token2.0"){
    url.data <- GET(url, config(token=token))
  }	
  if (class(token)[1]=="character"){
    url <- paste0(url, "&access_token=", token)
    url <- gsub(" ", "%20", url)
    url.data <- GET(url)
  }
  if (class(token)[1]!="character" & class(token)[1]!="config" & class(token)[1]!="Token2.0"){
    stop("Error in access token. See help for details.")
  }
  content <- fromJSON(rawToChar(url.data$content))
  if (length(content$error)>0){
    stop(content$error$message)
  }	
  return(content)
}