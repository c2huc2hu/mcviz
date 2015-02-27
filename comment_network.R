library(igraph)

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