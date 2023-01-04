# =============================================================================
# My Personal Budget Shiny App
# Preprocessing data tables for the bill_pay data frame
# Created: 2023-01-03
# =============================================================================

# How do I write comments so that they show up in outline view?

# Load packages
library(dplyr)
library(readr)


# Load data tables
payee_details <- read_csv("tables/payee_details.csv")
payees        <- read_csv("tables/payees.csv")
payments      <- read_csv("tables/payments.csv")


# Get current date
# We will use this to filter table elements to display
today <- Sys.Date()


# Data management

## Merge the data frames for bill payment together
pay_bills <- payees |> 
  left_join(payee_details, by = c("pk_payees" = "fk_payees")) |> 
  left_join(payments, by = c("pk_payee_details" = "fk_payee_details"))

## Keep only the columns of interest


