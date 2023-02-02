#' ---
#' title: My Personal Budget Shiny App
#' author: Brad Cannell
#' date: 2023-01-03
#' ---


# Resources ---------------------------------------------------------------
# How do I write comments so that they show up in outline view?
# https://www.natedayta.com/2019/12/25/owning-outlines-in-rstudio/

# Mastering Shiny
# https://mastering-shiny.org/index.html

# Outstanding User Interfaces with Shiny
# https://unleash-shiny.rinterface.com/index.html

# Adding HTML content (e.g., text)
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson2/


# Load packages -----------------------------------------------------------
library(shiny)
library(fontawesome)


# UI Definition -----------------------------------------------------------
ui <- fluidPage(
  titlePanel("My Personal Budget App"),

# * tabsetPanel -----------------------------------------------------------
  tabsetPanel(

# * * Home Panel ----------------------------------------------------------
    tabPanel(
      title = p(fa("house", fill = "#808080"), "Home"),
      fluidRow(
        column(12,
          p(
            "The homepage should give instructions for use and a brief
            desctiption of each tab.", style = "margin-top: 10px;"
          ),
          tags$ul(
            tags$li("Dashboard"),
            tags$li("Panel 3")
          )
        )
      )
    ),

# ** Panel 2 --------------------------------------------------------------
    tabPanel(
      title = p(fa("gauge", fill = "#808080"),"Dashboard"),
      fluidRow(
        column(12
          # Add content here. I think I just want to add some text here for 
          # now.
        )
      )
    )
  )
)


# Server Definition -------------------------------------------------------
server <- function(input, output, session) {
  # The left-hand side of the assignment operator (<-), output$ID, indicates 
  # that you’re providing the recipe for the Shiny output with the matching ID.
  # The right-hand side of the assignment uses a specific render function to 
  # wrap some code that you provide.
  
  # output$payments_tbl <- renderTable({ 
  #   payments
  # })
}


shinyApp(ui, server)