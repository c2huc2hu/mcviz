# UI 
library(shiny)

shinyUI(
  pageWithSidebar(
    
    headerPanel("Facebook Network Visualization"),
    
    sidebarPanel(
      #insert ui things here

    
      textInput('access_token', "Facebook access token"),
      helpText("This app needs access to 'user_groups'"), 
      tags$a("href"="https://developers.facebook.com/tools/explorer/145634995501895/", "Generate an access token here"),
      br(), br(), 
    
      textInput('group_id', "Numeric Facebook ID of the group"),
      helpText("This only works with the numeric ID. If you only have the name, use the graph explorer to find the group"),
      tags$a("href"="https://developers.facebook.com/tools/explorer/145634995501895/?method=GET&path=me%2Fgroups%3Flimit%3D100&version=v2.2&", "Graph explorer"),
      br(), br(), 
      
      textInput('post_id', "Numeric ID of the post"),
      helpText("Click on the post's timestamp to get its ID number"),
      br(),
      selectInput('algorithm', "Clustering algorithm", c('Hierarchal Clustering', 'Walktrap Community')),
      
      conditionalPanel(
        condition="input.algorithm == 'Hierarchal Clustering'",
        sliderInput("num_clusters", "Number of clusters", 2, 10, 2, ticks=FALSE, animate=TRUE)
      ),
      
      sliderInput("vertex_size", "Size of Vertex", 0, 10, 5, ticks=FALSE, animate=TRUE),
      checkboxInput("pagerank", "Change Size Based on PageRank of User"),
      
      br()
      checkboxInput("remove_only_likes", "Remove people who never commented"),
      checkboxInput("show_labels", "Show Labels")
    ),
    
    mainPanel(
      # output things go here
        plotOutput("netvis", width="100%")
      )
  )
)
    
  