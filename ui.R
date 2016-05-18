
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(rCharts)
library(shinyBS)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("LEo's weight through time"),
  showOutput("plot_weight", "highcharts"),
  
  bsCollapse(id = "collapseExample",
             bsCollapsePanel("Other example",
                             showOutput("other_weight", "highcharts"),
                             style = "info")),

  
  bsCollapse(id = "collapseExample", 
             bsCollapsePanel("More info", 
                             tableOutput("tabla"),
                             textOutput("chance"),
                             plotOutput("peso_leo"),
                             style = "info"))
  
  
))
