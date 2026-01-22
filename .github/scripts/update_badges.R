library(googleAnalyticsR)
library(jsonlite)
library(dplyr)

## Helper function to format numbers
format_metric <- function(x) {
    x <- as.numeric(x)
    if (is.na(x)) return("0")
    if (x >= 1e6) return(paste0(round(x / 1e6, 1), "M"))
    if (x >= 1e3) return(paste0(round(x / 1e3, 1), "k"))
    return(as.character(x))
}

## Setup
dir.create("badges", showWarnings = FALSE)
ga_auth(json_file = "ga_auth.json")
property_id <- "519812281" 
start_date  <- "2026-01-01"

## Gather monthly data
monthly <- ga_data(property_id, date_range = c("30daysAgo", "yesterday"), 
                   metrics = c("screenPageViews", "activeUsers"))

write_json(list(schemaVersion=1, label="views / month", message=format_metric(monthly$screenPageViews), color="blue"), "badges/views_monthly.json", auto_unbox=TRUE)
write_json(list(schemaVersion=1, label="users / month", message=format_metric(monthly$activeUsers), color="orange"), "badges/users_monthly.json", auto_unbox=TRUE)

## Gather all-time data
alltime <- ga_data(property_id, date_range = c(start_date, "today"), 
                   metrics = c("screenPageViews", "activeUsers"))

write_json(list(schemaVersion=1, label="all-time views", message=format_metric(alltime$screenPageViews), color="green"), "badges/views_total.json", auto_unbox=TRUE)
write_json(list(schemaVersion=1, label="all-time users", message=format_metric(alltime$activeUsers), color="red"), "badges/users_total.json", auto_unbox=TRUE)
