library(igraph)
library(rPython)

load_python_data <- function(group_id, post_id, access_token){
  id <- paste(group_id, post_id, sep="_")
  python_code <- file("fb.py", "r")
  python.load(python_code)
  python.assign("access_token", access_token)
  python.assign("post_id", id)
  python.exec("tree = get_post_tree(post_id, access_token)")
  post <- python.get("tree")
  return(comment_network(post))
}

comment_network <- function(post){
  el <-data.frame(from=integer(0), to=integer(0))
  
  for(i in 1:length(post)){
    if(length(post[[i]]$likes$id) != 0){
      el_temp <-cbind(post[[i]]$likes$name, post[[i]]$from['name'])
      el <-rbind(el, el_temp)
    }
  }
  
  rownames(el) <-c()
  colnames(el) <-c('from', 'to')
  el[,'from'] <-as.character(el[,'from'])
  el[,'to'] <-as.character(el[,'to'])
  return(as.matrix(el))
}

network_cluster <- function(net, hc, k=2){
    clusters <- as.character(cutree(hc, k=k))
    colors <- unique(clusters)
    
    for (i in colors){
      V(net)$color = gsub(i, as.numeric(i), clusters)
    }
    
    #V(net)$size = degree(net)
    return(net)
}

vertex_label <- function(net, show_labels){
  if (show_labels){
    return(V(net)$name)
  }
  return(NA)
}

size_weight <- function(net, pagerank){
  if(pagerank){
    pr <- page.rank(net, directed=T)$vector
    pr <- 2*pr/max(pr)
    pr[pr < 0.4] <- 0.4
    return(pr)
  }
  return(1)
}