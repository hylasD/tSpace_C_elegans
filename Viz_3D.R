
library(shiny)
library(plotly)
library(colorRamps)

#object worm has to be in R environment 
bm <- worm


colors.selection <- colorRamps::matlab.like2(13)
colors.selection2 <- c(colors.selection[1], colors.selection[12], colors.selection[2:11])

nms <- names(bm)

ui <- fluidPage(#theme = shinytheme("cyborg"),
  
  headerPanel("Parameters Explorer"),
  sidebarPanel(width = 2,
               #sliderInput('sampleSize', 'Sample Size', min = 1, max = nrow(nolan3),
               #            value = 1000, step = 500, round = 0),
               selectInput('x', 'X', choices = nms, selected = "tPC1_t50"),
               selectInput('y', 'Y', choices = nms, selected = "tPC2_t50"),
               selectInput('z', 'Z', choices = nms, selected = "tPC3_t50"),
               selectInput('color', 'Color', choices = nms, selected = "raw.embryo.time.bin")
               
  ),
  mainPanel(
    plotlyOutput('trendPlot', width = '1200px', height = "1000px")
  )
)

server <- function(input, output) {
  
  
  scene = list(aspectmode = 'manual', aspectratio = list(x=1, y=1, z=1), camera = list(eye = list(x = 1.05, y = -1.7, z = 0.8)))
  output$trendPlot <- renderPlotly({
    # build graph with ggplot syntax
    p <- plot_ly(bm, x = bm[,input$x], y = bm[,input$y], z = bm[,input$z],  color = ~bm[,input$color], 
                colors = colors.selection2, 
                 size=I(30),
                 type = 'scatter3d', text = ~paste("Pop: ", bm$cell.type, "<br>Subtype: ", bm$cell.subtype, "<br>Lineage: ", bm$lineage) ) %>%  
      
      layout(paper_bgcolor='transparent', scene = scene)
  })
 
}

shinyApp(ui, server)
