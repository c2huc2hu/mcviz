# server.r
library(shiny)
source('comment_network.R')
library(igraph)
library(rPython)

shinyServer(function(input, output) {
  
    dataInput <- reactive({
      load_python_data(input$group_id, input$post_id, input$access_token)
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