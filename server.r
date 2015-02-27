library(shiny)
source('comment_network.R')
library(igraph)

load_facebook_data <- function(group_id, post_id, access_token){  
  # Load the data about the post from Facebook's graph API. 
  # Currently only works on posts in groups.
  
  post_id = paste(group_id, post_id, sep='_')
  interactions = data.frame(from=integer(0), to=integer(0)) # return me!
  
  # Read the post from facebook
  post  <- getPost(post_id, access_token)
  comments <- post$comments
  likes <- post$likes
  
  # Handle the likes on the comment
  if (length(likes) == 0) { next; }
  for(i in 1:length(likes))
  {
    interactions <- rbind(interactions, cbind(likes$from_name[i], post$post$from_name))
  }
  
  # handle the subcomments
  for (i in 1:length(comments$from_name))  # i indexes comments
  {
    likes <- getCommentLikes(paste(post_id, comments$id[i], sep='_'), access_token)
    
    if (length(likes) == 0)
      { next; } # equivalent of "continue" in most languages. 
    for(j in 1:length(likes)) # j indexes likes
    {
      #print(paste(comments$from_name[i], likes[[j]]$name, sep=" liked by ")) 
      interactions <- rbind(interactions, cbind(likes[[j]]$name, comments$from_name[i]))
    }
  }
  
  rownames(interactions) <- c()
  colnames(interactions) <- c('from', 'to')
  interactions[,'from'] <- as.character(interactions[,'from'])
  interactions[,'to'] <- as.character(interactions[,'to'])
  
  return(as.matrix(interactions))
}

shinyServer(function(input, output) {
    dataInput <- reactive({
      load_facebook_data(input$group_id, input$post_id, input$access_token)
    })
    
    output$netvis <- renderPlot({
    data <- dataInput()
    if(length(data) != 0){
      if(input$remove_only_likes)
        net_matrix <- data[data[,1] %in% data[,2],]
      else
        net_matrix <- data
      
      net <- graph.edgelist(net_matrix)
      label <- vertex_label(net, input$show_labels)
      pagerank <- size_weight(net, input$pagerank)
      size <- input$vertex_size * pagerank
      
      if (input$algorithm == 'Hierarchal Clustering'){
        net.hc <- hclust(dist(shortest.paths(net)))
        net <- network_cluster(net, net.hc, input$num_clusters)
        plot(net, vertex.label=label, vertex.size=size, edge.arrow.size=0.2)
      }
      else{
        wc <- walktrap.community(net)
        plot(wc, net, vertex.label=label, vertex.size=size, edge.arrow.size=0.2)
      }
    }
    
  }, height=900, width=900)
})