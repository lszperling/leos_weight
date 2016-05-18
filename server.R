
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(rCharts)
library(ggplot2)

peso_leo <- tbl_df(read.csv("/home/leonel/Downloads/Vitacora de peso - Sheet1.csv")) 

shinyServer(function(input, output) {

  dailyWeight <- peso_leo %>% mutate(game_date = as.numeric(as.POSIXct(as.Date(time, "%m/%d/%Y")))*1000 ,
                                     Dani = Dani / mean(peso_leo$Dani) * mean(peso_leo$Leo))
  quantiles = quantile(dailyWeight$Leo, probs = c(.025,.5,.975))
  
  output$plot_weight <- renderChart2({

    coso <- hPlot(Leo ~ game_date  , data = dailyWeight)
    
    
    coso$xAxis(type = 'datetime', labels = list(
      format = '{value:%Y-%m-%d}'  
    ))
    
    
    coso$yAxis(title = list(text = "Leo's weight") , plotLines = list(
      list(color = 'red', 
           # dashStyle = 'longdashdot',
           value= mean(dailyWeight$Leo), 
           width= 2 ), 
      list(color = 'blue', 
           # dashStyle = 'longdashdot',
           value= quantiles[[1]], 
           width= 2 ), 
      list(color = 'blue', 
           # dashStyle = 'longdashdot',
           value= quantiles[[3]], 
           width= 2 )
      ))
      coso
    
    return(coso)
  })
  
  output$tabla <- renderTable({
    tablita <- as.data.frame(quantiles[-2])
    # tablita$quatiles <- rownames(tablita)
    names(tablita) <- c("weight")
    tablita
    
  })
    
  output$peso_leo <- renderPlot({
    
    
  qplot(peso_leo$Leo, bins = 100) + geom_vline(xintercept = mean(peso_leo$Leo), color = "red") +
    geom_vline(xintercept = quantiles[[1]], color = "blue") +
    geom_vline(xintercept = quantiles[[3]], color = "blue") + 
    xlab("Weight") + 
    ylab("Ocurrences")
  })
  
  output$chance <- renderText({
    paste0("The best chance of guessing right is " , 
          round(sum(peso_leo$Leo == 74.7) / length(peso_leo$Leo) * 100,2), "%. The meassurement 74.7 happened ",
          sum(peso_leo$Leo == 74.7) , " out of ", length(peso_leo$Leo), " times.
          The mean weight is ", mean(peso_leo$Leo))
    })
  
  
  
  output$other_weight <- renderChart2({

    coso <- hPlot(Dani ~ game_date  , data = dailyWeight)
    quantiles_other = quantile(dailyWeight$Dani, probs = c(.025,.5,.975))


    coso$xAxis(type = 'datetime', labels = list(
      format = '{value:%Y-%m-%d}'
    ))


    coso$yAxis(title = list(text = "Other's weight") , plotLines = list(
      list(color = 'red',
           # dashStyle = 'longdashdot',
           value= mean(dailyWeight$Dani),
           width= 2 ),
      list(color = 'blue',
           # dashStyle = 'longdashdot',
           value= quantiles_other[[1]],
           width= 2 ),
      list(color = 'blue',
           # dashStyle = 'longdashdot',
           value= quantiles_other[[3]],
           width= 2 )
    ))
    coso

    return(coso)
  })
  
  
})
