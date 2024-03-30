# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create "Bills Due" table
# 2024-03-22
# 
# I did a fair amount of work on the budget in Google Sheets. My thought was 
# that I would just use the easiest platform to get the job done. It turns out
# that Google Sheets isn't "easy"; although, it still may turn out to be the 
# easiest - we'll see. For now, however, I want to give Shiny another try.
# 
# One of the sheets that I started creating in Google Sheets was the "Bills 
# Due" table. This table/sheet was supposed to be the view I would use for 
# paying bills each pay period. The idea was for it to be similar to my 
# traditional Google Sheets monthly budget, but dynamic.
# 
# In this file, we aren't yet creating a Shiny app. Instead, I just trying to
# create a static version of the bills due table that I want to interact with.
# Doing so requires joining data from a few different data tables and then 
# filtering them based on the date and pay period.
# 
# Wiki about this topic: https://github.com/brad-cannell/budget_app/wiki/Pay-Bills
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Load packages ----

library(dplyr, warn.conflicts = FALSE)
library(googlesheets4)
library(lubridate)

# Import data ----

# Save the sheet id for use below. You can pull it from the sheet's URL. For 
# example, the sheet id for the budget app is: "1153fK76wz8cu4URFM7eidlyv8AEUoSKAAIt-q6uH0ZE"
# It is taken from the budget app's url, which is: "https://docs.google.com/spreadsheets/d/1153fK76wz8cu4URFM7eidlyv8AEUoSKAAIt-q6uH0ZE/edit#gid=1694905897"
test_data_id <- "1UynDArMMcKkiJevSZtW4HJ74zMiqrLuKg0CpDcPtI2c"
test_accounts <- read_sheet(
  test_data_id,
  sheet = "Accounts"
)


# Selection parameters ----
# These will be interactive in the Shiny app

# Get today's date
today <- Sys.Date()

# Set year, month, and pay period
# Originally, I was going to use today's year, but I should really be able to 
# select any arbitrary year. Hopefully, I can set the default value to today's
# year somehow and then change it if needed.
# Again, these will be interactive in Shiny.
selector_year <- 2024
selector_month <- "February"
selector_pay_period <- "Second"


# Step 1: Add a year filter----

# Ideally, I'd like to use this app across years. That means that there will be
# data from across multiple years in the data. So, I will need to be able to
# select a year I'm interested in (should default to the current year) and then
# view the bills that are due for the year and pay period selected.

# So, the the account was opened on or before the selector date year and 
# it was closed on or after the selector date year -- including accounts that 
# are still open (i.e., is.na(account_date_closed)).
accounts_filtered_year <- test_accounts |>
  filter(year(account_date_opened) <= selector_year) |> 
  filter(is.na(account_date_closed) | year(account_date_closed) >= selector_year)

# Lake house should be filtered out. Opened after 2024.
# Old energy company should be filtered out. Closed in 2023.
accounts_filtered_year


# Step 2: Filter by selected month ----

# Now, we have filtered our accounts list so that it only includes payment
# accounts that were open in the currently selected year. However, bills change 
# throughout the year. Now, we only want to further filter the accounts list to 
# only see accounts that are/were open in the currently selected month.

# So, filter out accounts that were: 
# - OPENDED AFTER the selected month (within the year) OR
# - CLOSED BEFORE the selected month (within the year).
# Said another way, KEEP accounts that were:
# - OPENDED BEFORE the selected month (within the year) OR
# - CLOSED AFTER the selected month (within the year).

# Get the month selected by the user as a number 1-12.
selector_month_num <- match(selector_month, month.name)

# In this example, the currently selected month is February. 
# New credit card should be filtered out because it wasn't opened until March.
# Mattress should be filtered out because was closed in January.
accounts_filtered_year |> 
  mutate(
    account_opened_month = month(account_date_opened),
    account_closed_month = month(account_date_closed)
  ) |> 
  select(account_nickname:account_date_opened, account_opened_month:account_closed_month) |> 
  filter(account_opened_month < selector_month_num | account_closed_month > selector_month_num)

## Issue ----

# Trying to filter on the month number alone (as we did above) doesn't work. It
# filters out too many rows. For example, Therapy is filtered out because its 
# open date month is 09, which is greater than 02. And if this account had been
# opened in the ninth month of 2024, that would be exactly what we want to 
# happen. However, Therapy was opened in 2021-09, so we don't want to filter it
# out. 
# So, we need to filter by the month AND year the account was opened. If the 
# selector year is 2024 and the selector month is February, then we want to 
# keep all accounts that were open at any point during 2024-02. We will worry
# about filtering the pay period later. So,
# - Account open date before 2024-02-01 AND 
# - Account closed date on or after 2024-02-29

## Year-Month filters ----

selector_month <- "February" # Adding again here for testing
# Build selection date value from the selection parameters entered by the user
# Get the month selected by the user as a number 1-12. This will help us build 
# a completed sector date (Y-M-D) below.
selector_month_num <- match(selector_month, month.name)
# Merge together the year and month selected by the user as a date. We will
# use the first day of the month (i.e., "1") for now.
selector_year_month_first_day <- paste(selector_year, selector_month_num, "1", sep = "-") |> as.Date()
# Also determine what the last day of the selected month is.
selector_year_month_last_day <- ceiling_date(selector_year_month_first_day, "month") - days(1)

## Filter by selected year and month ----

# In this example, the currently selected month is February (2024). 
# New credit card should be filtered out because it wasn't opened until March.
# Mattress should be filtered out because was closed in January.
accounts_filtered_year_month <- accounts_filtered_year |> 
  # Keep accounts opened before the last day of the selected year and month.
  # This should remove New credit card.
  filter(account_date_opened <= selector_year_month_last_day) |> 
  # Keep accounts that haven't been closed yet OR were closed after the first
  # day of the selected year and month.
  # This should remove Mattress.
  filter(is.na(account_date_closed) | (account_date_closed >= selector_year_month_first_day))

accounts_filtered_year_month

# This works. 
# If we change selector_month to January, Mattress should not be removed. I 
# did a test and it works.


# Step 3: Filter by pay period ----

# At this point, every account remaining was open at some point during the 
# currently selected year and month. Now, we need to filter for the selected
# pay period.
selector_pay_period <- "First" # Adding again here for testing

accounts_filtered_year_month |> 
  filter(account_pay_period_manual == selector_pay_period)

## Issue ----

# The code above works just fine if we only have accounts that need to be paid
# in the first OR second pay period, MONTHLY. However, we have some accounts 
# that need to be paid twice a month and other accounts that need to be paid
# annually. How do we handle them?


  
  
  
  

# Older stuff ----
# Keeping around until I'm sure I don't need it anymore.




# Scenario X: Pay period 1 and 2 only ----

# Let's start with the simplest scenario:
# - We are only storing data from one year in the table, so we don't need to 
#   worry about the year.
# - All bills are paid in the same pay period as their due date, so we don't 
#   need to worry about account_pay_period_manual

# If the user selects pay period 1, then should accounts with a due date
# between 1 and 15 inclusive should be returned.
if (pay_period == "First") {
  accounts_filtered <- test_accounts |> 
    filter(account_date_monthly_payment_due %in% 1:15)
} else if (pay_period == "Second") {
  accounts_filtered <- test_accounts |> 
    filter(account_date_monthly_payment_due %in% 16:31)
}

# View results
accounts_filtered


# Scenario X: Add a year filter----

# Ideally, I'd like to use this app across years. That means that there will be
# data from across multiple years in the data. So, I will need to be able to
# select a year I'm interested in (should default to the current year) and then
# view the bills that are due for the year and pay period selected.

# So, the the account was opened on or before the selector date year and 
# it was closed on or after the selector date year -- including accounts that 
# are still open (i.e., is.na(account_date_closed)).
accounts_filtered <- test_accounts |>
  filter(year(account_date_opened) <= selector_year) |> 
  filter(is.na(account_date_closed) | year(account_date_closed) >= selector_year)

# Lake house should be filtered out. Opened after 2024.
# Old energy company should be filtered out. Closed in 2023.
accounts_filtered 

# If the user selects pay period 1, then should accounts with a due date
# between 1 and 15 inclusive should be returned.
if (pay_period == "First") {
  accounts_filtered <- accounts_filtered |> 
    filter(account_date_monthly_payment_due %in% 1:15)
} else if (pay_period == "Second") {
  accounts_filtered <- test_accounts |> 
    filter(account_date_monthly_payment_due %in% 16:31)
}

# View results
accounts_filtered

# What should be next? Viewing annual bills or viewing bills that have to be 
# paid in both pay periods? I think the next step is filtering bills by 
# manually selected bill pay period instead of due date. Annual adds a 
# completely new type of bill to deal with.


# Scenario X: Filter by manually selected pay period ----

# I don't always choose to pay a bill during the pay period it is due. For 
# example, car insurance might be due on the 22nd (second pay period), but I 
# might choose to pay it when I make my first pay period payments. Why? 
# Sometimes I do this to more evenly distribute the amount of money I'm paying 
# from each paycheck.

# First, filter by year.
# So, the the account was opened on or before the selector date year and 
# it was closed on or after the selector date year -- including accounts that 
# are still open (i.e., is.na(account_date_closed)).
accounts_filtered <- test_accounts |>
  filter(year(account_date_opened) <= selector_year) |> 
  filter(is.na(account_date_closed) | year(account_date_closed) >= selector_year)

# Lake house should be filtered out. Opened after 2024.
# Old energy company should be filtered out. Closed in 2023.
accounts_filtered 

# Next, filter to 

# Next, filter by pay period.
# Create a calculated variable that captures whether or not the due date for
# the bill falls within the pay period the user manually selected paying the 
# bill in. Why? Why not just always go by account_pay_period_manual?
# Let's don't create a solution for a problem that doesn't exist.
accounts_filtered |> 
  filter(account_pay_period_manual == pay_period)









# Build selection date value from the selection parameters entered by the user
# -----------------------------------------------------------------------------
# Get the month selected by the user as a number 1-12. This will help us build 
# a completed sector data (Y-M-D) below.
month_num <- match(month, month.name)
# Merge together the year and month selected by the user as a date. We will
# use the first day of the month (i.e., "1") for now.
date_selector_first <- paste(year, month_num, "1", sep = "-") |> as.Date()
# Also determine what the last day of the selected month is. We will need this 
# for the filter period if the user chooses the "Second" period or "Both" 
# period.
last_day_of_month <- lubridate::ceiling_date(date_selector_first, "month") - lubridate::days(1)
last_day_of_month <- lubridate::day(last_day_of_month)
# Choose the day to use in the selector date based on the period the user
# selects.
selector_day_num <- case_when(
  period == "First"  ~ 16L,
  period == "Second" ~ last_day_of_month,
  period == "Both"   ~ last_day_of_month,
  period == "Annual" ~ last_day_of_month
)
# Create selector date based on the year, month, and period the user selected.
# This date will be used to filter the accounts table, which will be used to
# build the bill pay screen.
selector_date <- paste(year, month_num, selector_day_num, sep = "-") |> as.Date()
# Helpful for filtering the "Annual" period
selector_year <-year(selector_date)


# Filter the accounts table to see the bills that need to be paid, or needed to
# be paid, in the selected pay period and year (filtered above).
# -----------------------------------------------------------------------------
# Only monthly bills right now. We will add in annual bills later.

# IF I select pay period 1, THEN show bills that are due 1-15 
# (account_date_monthly_payment_due) or "First" (account_pay_period_manual). 
# It seems like account_pay_period_manual should probably be given preference.

# IF I select pay period 2, THEN show bills that are due 16-EOM 
# (account_date_monthly_payment_due) or "Second" (account_pay_period_manual). 
# It seems like account_pay_period_manual should probably be given preference.

if (period == "First") {
  accounts_filtered
}
  



# Create a table that will tell me what is due when I log in to pay bills.
# -----------------------------------------------------------------------------
# Eventually, we will interact with this table in Shiny.
# - Inputs: Month and pay period
# - Result: list of bills that need to be paid
bills_due <- tibble(
  payee = vector("character"),
  balance = vector("numeric"),
  projected = vector("numeric"),
  actual = vector("numeric"),
  difference = vector("numeric"),
  credit_card = vector("logical"),
  transfer_to_bp_checking = vector("logical"),
  submitted = vector("logical"),
  pending = vector("logical"),
  date_due = vector("numeric"),
  notes = vector("character")
)




# Conditionally add data to the bills due table
# -----------------------------------------------------------------------------
# Conditions
# - The account is open in the year-month-period selected.
#   - The account_date_open is after the year-month-period and the 
#     account_date_closed date is after the year-month-period selected.
# - The account is due in the currently selected period.


