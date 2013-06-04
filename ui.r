library(shinyGridster)

source('dashwidgets.r', local=TRUE)

shinyUI(bootstrapPage(
  tags$head(
    tags$link(rel = 'stylesheet', type = 'text/css', href = 'styles.css'),
    
    # For JustGage, http://justgage.com/
    tags$script(src = 'js/raphael.2.1.0.min.js'),
    tags$script(src = 'js/justgage.1.0.1.min.js'),
    
    # For Highcharts, http://www.highcharts.com/
    tags$script(src = 'js/highcharts.js'),
    
    # For the Shiny output binding for status text and JustGage
    tags$script(src = 'shiny_status_binding.js'),
    tags$script(src = 'justgage_binding.js')
  ),
  
  h1("El Estado de México: Escenarios Alternativos"),
  
  gridster(width = 250, height = 250,
           gridsterItem(col = 1, row = 1, sizex = 1, sizey = 1,
                        
                        sliderInput("rate", "Homicidios en EdoMex Enero:",
                                    min = 0, max = 500, value = 151, step = 5),
                        
                        sliderInput("volatility", "Homicidios en EdoMex Febrero:",
                                    min = 0, max = 500, value = 136, step = 5),
                        
                        sliderInput("delay", "Homicidios en EdoMex Marzo:",
                                    min = 0, max = 500, value = 98, step = 5),
                        
                        sliderInput("abril", "Homicidios en EdoMex Abril:",
                                    min = 0, max = 500, value = 63, step = 5),
                        
                        tags$p(
                          tags$br(),
                          tags$a(href = "https://github.com/eduardoclark", "Source code")
                        )
           ),
           gridsterItem(col = 2, row = 1, sizex = 2, sizey = 1,
                        htmlOutput("view")
                                 
            ),
           gridsterItem(col = 1, row = 2, sizex = 1, sizey = 1,
                        justgageOutput("live_gauge", width=250, height=200)
           ),
           gridsterItem(col = 2, row = 2, sizex = 1, sizey = 1,
                        tags$div(class = 'grid_title', 'Diciembre-Abril'),
                        statusOutput('status')
           ),
           gridsterItem(col = 3, row = 2, sizex = 1, sizey = 1,
                        plotOutput("plotout", height = 250)
           ),
           gridsterItem(col = 3, row = 1, sizex = 1, sizey = 2, 
                        verbatimTextOutput('summary')
                        
           )
           
  ),
  
  # Can read Javascript code from a separate file
  # This code initializes the dynamic chart
  tags$script(src = "initchart.js")
  
))
