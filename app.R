#### RECIPE MASTER LIST ########
library(tidyverse)
library(shiny)
library(googlesheets4)

# shiny app basics from 
# https://stackoverflow.com/questions/73263669/grocery-list-in-shiny

# Pull in a list of recipes and ingredients
# Columns are 
# type: dinner, dessert (not used currently)
# meal: name of recipe
# source: cookbook and page
# section: what section of the grocery store (Fiesta Farms) is this ingredient found in?
# ingredient: name of the ingredient
# amount: how much of this ingredient for this recipe?
# unit: what unit of measurement (this is set up to be consistent within an ingredient)
# notes: shopping notes (not used currently)

master_list = read_csv("master_list.csv")

# Create a small table of recipe names and sources
recipe_names = master_list %>% 
  distinct(meal, source) %>% 
  arrange(meal)

ui <- fluidPage(
  # App title
  titlePanel("What are you making this week?"),
  
  # Sidebar layout
  sidebarLayout(
    # A panel for inputs
    sidebarPanel(
      # Use an input type that allows selection of multiple recipes
      selectInput(
        inputId = "masterclass",
        label = "What are my options?",
        choices  = recipe_names$meal,
        multiple = TRUE
      ),
      tags$a(href="https://github.com/meganbontrager/grocery-list", "edit on github")
    ),
    mainPanel(
    tableOutput(outputId = "recipe_list"),
    tableOutput(outputId = "ingredients")
              )
  )
)


  
# Define the server logic
server <- function(input, output, session) {
  groceries <- eventReactive(input$masterclass, {
    master_list %>% 
      filter(meal %in% input$masterclass) %>%
      group_by(section, ingredient, units) %>% 
      summarize(total = sum(amount)) %>% 
      arrange(section, ingredient) %>% 
      ungroup() %>% 
      # would be nice to get grocery section in as headings
      select(ingredient, total, units) %>% 
      mutate(items = str_c(ingredient, as.character(total), units, sep = " ")) %>%
      select(items)
    

  })
  recipe_list <- eventReactive(input$masterclass, {
    recipe_names %>% 
      filter(meal %in% input$masterclass) %>% 
      select(meal, source) %>% 
      distinct()
    
  })
  
  output$ingredients <- renderTable({
    groceries()
  })
  
  output$recipe_list <- renderTable({
    recipe_list()
  })
  
}

shinyApp(ui, server)


