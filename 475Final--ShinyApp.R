
library(fpp3)
library(shinydashboard)
library(shinyWidgets)
library(shiny)
library(shinythemes)

?shinythemes

load("PWells-BAS475-FinalEnvironment.RData")

ui <- fluidPage(
  setBackgroundColor(
    color = c("#FF8200", "#58595B"),
    gradient = "radial",
    direction = c("top", "left")
  ),
  navbarPage(title="Peyton B Wells",theme = shinytheme("darkly"),
             tabPanel("BAS 475 - Final Shiny App",
                      sidebarLayout(
                        sidebarPanel(
                          radioGroupButtons("PlotChoice", "Choose The Plot You Would Like to Display:", 
                                       choices = c("Mean","Naive",
                                                   "Seasonal","Drift",
                                                   "Exponential Smoothing",
                                                   "Holt", "Holt-Winters",
                                                   "Manual ARIMA", "Auto ARIMA"),
                                       status = "success",direction = "vertical")),
                        mainPanel(plotOutput("SelectedPlot"))
                        ))
             ),  fluid=TRUE
)


server <- shinyServer(function(input, output, session) {
  PlotInput <- reactive({
    switch(input$PlotChoice,
           "Mean" = Mean,
           "Naive" = Naive,
           "Seasonal" = Seasonal,
           "Drift" = Drift,
           "Exponential Smoothing" = ExpSmoothing,
           "Holt" = Holt,
           "Holt-Winters" = HoltWinters,
           "Manual ARIMA" = MANUALARIMA,
           "Auto ARIMA" = AUTOARIMA)
  })
  
  output$SelectedPlot <- renderPlot({ 
    PlotInput()
  })
  }
)

shinyApp(ui = ui, server = server)
