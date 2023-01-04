# =============================================================================
# My Personal Budget Shiny App
# Created: 2023-01-03
# =============================================================================

# How do I write comments so that they show up in outline view?

# Load packages
library(shiny)
library(readr)
library(dplyr)


# Load data tables
# accounts      <- read_csv("../tables/accounts.csv")
# payee_details <- read_csv("../tables/payee_details.csv")
# payees        <- read_csv("../tables/payees.csv")
# payments      <- read_csv("../tables/payments.csv")


# Data processing (eventually move to separate file)

## Get current date
## We will use this to filter table elements to display
# today <- Sys.Date()

## Merge the various tables I need together to pay bills
# pay_bills <- payees |> 
#   left_join(payee_details, by = c("pk_payees" = "fk_payees"))

ui <- fluidPage(
  titlePanel("My Personal Budget App"),
  # Create space to display data
  tableOutput("payments_tbl")
)


server <- function(input, output, session) {
  # The left-hand side of the assignment operator (<-), output$ID, indicates 
  # that you’re providing the recipe for the Shiny output with the matching ID.
  # The right-hand side of the assignment uses a specific render function to 
  # wrap some code that you provide.
  output$payments_tbl <- renderTable({ 
    payments
  })
}


shinyApp(ui, server)