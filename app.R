#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        # radio buttons for color of plots
        radioButtons("rb", "Select Color for Plots:",
                     choiceNames = list(
                       HTML("<p style='color:darkslategray;'>Dark Green</p>"),
                       HTML("<p style='color:gray50;'>Gray</p>"),
                       HTML("<p style='color:purple4;'>Purple</p>")
                     ),
                     choiceValues = list(
                       "darkslategray", "gray50", "purple4"
                     )),
        textOutput("txt"),
        
        # slider for # of bins
        sliderInput("bins",
                     "Select # of Bins for Histogram:",
                     min = 1,
                     max = 30,
                     value = 10),
        
        # select box for icon type
        selectInput("select", label = h3("Select Icon Type for Scatterplot"), 
                    choices = list("Solid Circle" = 19, "Square" = 15, "Plus" = 3), 
                    selected = 19),
        hr(),
        fluidRow(column(3, verbatimTextOutput("value")))
        
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         h4("About the Data"),
         
         p("R includes several dozen built-in datasets available for data exploration. The"), 
         em("faithful"),
         p("dataset includes data on the Old Faithful geyser, a famous geyser at Yellowstone National Park. You can read more about the geyser"),
         tags$a(href="https://www.yellowstonepark.com/things-to-do/about-old-faithful", "at this link"),
         
         img(src='old-faithful-picture.png', 
             align = "center"),
         
         plotOutput("distPlot"),
         plotOutput("distPlot2")
      )
   )
   
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      x    <- faithful[, 'waiting'] 
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      hist(x, 
           breaks = bins, 
           col = input$rb, 
           border = 'black',
           main='Histogram of Waiting Times Between Eruptions',
           xlab='Waiting Times(min)',
           ylab='Frequency')
   })  
   
   output$distPlot2 <- renderPlot({
     # generate bins based on input$bins from ui.R
     x    <- faithful[, 'waiting'] 
     y    <- faithful[, 'eruptions']
     
     plot(x, y, 
          pch = strtoi({ input$select }), 
          frame = FALSE,
          col=input$rb,
          main = "Scatterplot of Waiting Times Between Eruptions \n and Length of Eruption",
          xlab='Waiting Time Between Eruptions (min)',
          ylab='Length of Eruption (min)')
   })   
   })

# Run the application 
shinyApp(ui = ui, server = server)

