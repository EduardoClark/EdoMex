# Get time with millisecond accuracy
options(digits.secs=6)

library(shiny)
require(googleVis)

shinyServer(function(input, output, session) {
  
  Serie <- read.csv("http://dl.dropboxusercontent.com/s/kaprkqhms9pqg7i/EdoMex.csv?token_hash=AAHYc_-Q0LNw7_kwtBc-9Mch45KkdNszApFxcRZC5XboqA&dl=1%27")
  Serie$Mexico <- Serie$MÉXICO  
  Mes <- c("Enero", "Febrero", "Marzo", "Abril")
  Texto <- c("Selecciona el número de  /n homicidios que desees para cada mes en el lado superior izquierdo de la calculadora")
  Text <- c("Descripción:
Esta herramienta calcula el cambio en el número de
averiguaciones previas por
homicidio doloso en México
para distintos escenarios en
el Estado de México.
Al seleccionar el número de
homicidios por mes, el
recuadro inferior izquierdo muestra el total
cuatrimestral en el EdoMex.
El siguiente recuadro 
calcula la diferencia nacional entre el primer trimestre
de 2012 y el de 2013.
El gráfico de barras muestra
el total nacional de
homicidios por mes para
el primer trimestre de 2013.
También se proporciona la
serie de tiempo desde enero 2012 del total nacional y el
total sin contar al EdoMex.")
   
  values <- reactive({
    
    
    new_value <-  
      (  input$rate + input$volatility + input$delay + input$abril)
    
    
    all_values <<- c(new_value)
    
    
    all_values
  })
  
  values1 <- reactive({
    
    
    
    all_values <<- c( input$rate + 1404 , input$volatility + 1315 , input$delay + 1537 , input$abril + 1500)
    
    
    
    all_values
  })
  
  values2 <- reactive({
    
    
    Serie[13,7] <- input$rate + 1404
    Serie[14,7] <- input$volatility + 1315
    Serie[15,7] <- input$delay + 1537
    Serie[16,7] <- input$abril + 1500
    
    all_values <- data.frame(Original=Serie$MÉXICO, Nacional=Serie$Mexico ,
                             SinEdoMex=Serie$SinEdoMex, Mes=c("Enero 2012",
                            "Febrero 2012", "Marzo 2012", "Abril 2012", "Mayo 2012", 
                            "Junio 2012", "Julio 2012", "Agosto 2012", 
                            "Septiembre 2012", "Octubre 2012", "Noviembre 2012",
                            "Diciembre 2012", "Enero 2013", "Febrero 2013",
                            "Marzo 2013", "Abril 2013"))
    
    
    all_values
  })
  
  values3 <- reactive({
    
    
    
    b <- barplot(values1(),  names.arg=Mes ,col = "#cccccc",
                 main = "1er Cuatrimestre 2013",
                 ylab = "APs Homicidio Doloso",
                 xlab="Mes")
    
    b 
    
    
  })
  
  
  
  # Generate histogram
  output$plotout <- renderPlot({
    barplot(values1(),  names.arg=Mes ,col = "#cccccc",
            main = "Total Nacional 1er Cuatrimestre 2013",
            ylab = "APs Homicidio Doloso",
            xlab="Mes")
          
  })
  
  # Set the value for the gauge
  # When this reactive expression is assigned to an output object, it is
  # automatically wrapped into an observer (i.e., a reactive endpoint)
  output$live_gauge <- reactive({
    running_mean <- mean(last(values(), n = 10))
    round(running_mean, 1)
  })
  
  # Output the status text ("OK" vs "Past limit")
  # When this reactive expression is assigned to an output object, it is
  # automatically wrapped into an observer (i.e., a reactive endpoint)
  output$status <- reactive({
    running_mean <- round(((((values() + 1703 + 5756)  / 8938) * 100) - 100), 1) 
    if (running_mean > 0)
      list(text=paste(running_mean, "%", sep=""), gridClass="alert", subtext="Aumento contra el mismo periodo del año pasado")
    else if (running_mean > 1000)
      list(text="Warn", subtext = "Mean of last 10 approaching threshold (200)",
           gridClass="warning")
    else
      list(text=paste(running_mean, "%", sep=""), subtext="Reducción contra el mismo periodo del año pasado")
  })
  
  output$view <- renderGvis({
    gvisLineChart(data=values2(), xvar="Mes", yvar=c( "Nacional", "SinEdoMex"), 
                  options=list(height=250, width=500, theme="maximized", pointSize=4))
    
  })
  
  output$summary <- renderPrint({
    cat(Text)
  })
  
})




# Return the last n elements in vector x
last <- function(x, n = 1) {
  start <- length(x) - n + 1
  if (start < 1)
    start <- 1
  
  x[start:length(x)]
}
