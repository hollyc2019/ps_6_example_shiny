#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(ggplot2)

shiny1 <- read_rds("for_shiny.rds")

shiny2 <- shiny1 %>%
  mutate(age = fct_relevel(age, c("18-24", "25-34", "35-44", "45-54", "55-64", "65+"))) %>%
  mutate(racethn = fct_relevel(racethn, c("Hispanic", "White, non-Hisp", "Black, non-Hisp", "Other")))

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Political Landscape Survey, Summer 2017"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        selectInput(
          inputId = "demographics",
          label = "Choose a Demographic Characteristic:",
          choices = c("Age" = "shiny2$age", "Sex" = "shiny1$sex", "Race/Ethnicity" = "shiny2$racethn"),
          selected = "shiny2$age"
        )),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("barPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) { 

   
   output$barPlot <- renderPlot({
    
     
     shiny1 %>%
       ggplot(aes_string(x = "cregion")) + 
       geom_bar(aes_string(fill= input$demographics)) +
       xlab("Region") + ylab("Number of Interviewees") + 
       ggtitle("Age, Sex, and Race/Ethnicity Breakdowns of Interview Respondents by Region:") + 
       labs(subtitle = "A look at demographics for the Pew Research Center's 2017 Political Landscape Survey.") + 
       theme_minimal() + labs(fill = "")
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

