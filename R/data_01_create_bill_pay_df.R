#' ---
#' title: "data_01_create_bill_pay_df"
#' date: "2023-01-03"
#' ---
#' 
#' # Overview
#' 
#' Before creating the Shiny app, I want to work through some of the code that will be used on the back end to merge together and update the data tables.
#' 
#' In this file, I'm preprocessing and merging the separate data tables needed to create the `bill_pay` data frame. I'm thinking this will be the table I use when I'm paying bills.
#' 
#' [Here is a link](https://drawsql.app/teams/brad-cannells-team/diagrams/budget-bill-pay-view) to the SQL diagram.
#' 
#' I find using Qmd files easier to work with while developing than R scripts. However, the code used by the Shiny app will be in an R script. 
#' 
#' # Load packages
#' 
## ---------------------------------------------------------------------------------
library(dplyr, warn.conflicts = FALSE)
library(readr)

#' 
#' 
#' # Load data tables
#' 
## ----message=FALSE----------------------------------------------------------------
entity          <- read_csv("../tables/entity.csv")
account         <- read_csv("../tables/account.csv")
interest_rate   <- read_csv("../tables/interest_rate.csv")
payment_method  <- read_csv("../tables/payment_method.csv")
period_payment  <- read_csv("../tables/period_payment.csv")

#' 
#' 
#' # Get current date
#' 
#' We will use this to filter table elements to display
#' 
## ---------------------------------------------------------------------------------
today <- Sys.Date()

#' 
#' 
#' # Data management
#' 
#' ## Merge the data frames for bill payment together
#' 
## ---------------------------------------------------------------------------------
pay_bills <- entity |> 
  left_join(account, by = c("pk_entity" = "fk_entity"), keep = TRUE) |> 
  left_join(interest_rate, by = c("pk_account" = "fk_account"), keep = TRUE) |> 
  left_join(payment_method, by = c("pk_account" = "fk_account"), keep = TRUE) |> 
  left_join(period_payment, by = c("pk_account" = "fk_account"), keep = TRUE)

#' 
## ---------------------------------------------------------------------------------
dim(pay_bills) # 5 52

