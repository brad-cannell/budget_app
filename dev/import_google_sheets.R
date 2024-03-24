# =============================================================================
# Import Google Sheets
# 2024-03-22
# 
# I did a fair amount of work on the budget in Google Sheets. My thought was 
# that I would just use the easiest platform to get the job done. It turns out
# that Google Sheets isn't "easy"; although, it still may turn out ot be the 
# easiest - we'll see. For now, however, I want to give Shiny another try.
# 
# While working on the Google Sheets development, I may a bunch of additions 
# and changes to the data tables. I want to try to import them in this file.
# I may even want to use Google Sheets as the back end for my budget app.
# https://shiny.posit.co/r/articles/build/persistent-data-storage/
# =============================================================================

# Useful websites
# https://googlesheets4.tidyverse.org/articles/googlesheets4.html
# https://shiny.posit.co/r/articles/build/persistent-data-storage/#gsheets

# Load packages
library(dplyr, warn.conflicts = FALSE)
library(googlesheets4)
library(googledrive)

# Import data
# -----------------------------------------------------------------------------
# Save the sheet id for use below. You can pull it from the sheet's URL. For 
# example, the sheet id for the budget app is: "1153fK76wz8cu4URFM7eidlyv8AEUoSKAAIt-q6uH0ZE"
# It is taken from the budget app's url, which is: "https://docs.google.com/spreadsheets/d/1153fK76wz8cu4URFM7eidlyv8AEUoSKAAIt-q6uH0ZE/edit#gid=1694905897"
budget_app_id <- "1153fK76wz8cu4URFM7eidlyv8AEUoSKAAIt-q6uH0ZE"

# View the Google Sheet in the browser (optional)
gs4_browse(budget_app_id)

# The first time you run this code, you will have to authorize the package to
# access your Google Drive. MAKE SURE TO CLICK THE CHECKBOX. Don't just hit
# continue.
entities <- read_sheet(ss = budget_app_id, sheet = "Entities")

# Alternative method using the googledrive package and the sheet's name
entities <- drive_get("Budget App Prototype") |>
  read_sheet("Entities")

# View metadata (optional)
gs4_get(budget_app_id)
# View properties (optional)
sheet_properties(budget_app_id)


# Add new data to the entities sheet
# -----------------------------------------------------------------------------
# Method 1: Add data locally and then write to Google Sheets
entities_update <- entities |>
  add_row(pk_entity = 999, entity_name = "Test")

# Write to Google Sheets
sheet_write(entities_update, budget_app_id, sheet = "Test")
# It worked. Now, delete the test sheet.
sheet_delete(budget_app_id, "Test")

# Method 2: Add directly to Google Sheets (almost like a database)
entities_empty <- slice(entities, 0)
entities_update <- entities_empty |>
  add_row(pk_entity = 999, entity_name = "Test")

# Append to Google Sheet
sheet_append(budget_app_id, entities_update, sheet = "Entities")
# It worked! Now, delete the test row.
range_delete(budget_app_id, sheet = "Entities", range = "30", shift = NULL)


# One thing I think I like about this method is that I can read/write data 
# to/from R/Shiny, but I can also still easily interact with the data directly
# in Google Sheets.
