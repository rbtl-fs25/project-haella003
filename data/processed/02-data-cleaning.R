# spreadsheet

library(tidyverse)
library(googlesheets4)

survey <- read_sheet("https://docs.google.com/spreadsheets/d/1Aoa7DzcldoiGbKYePlBldgHMexyMQqmXkf7_ycwP1yc/edit?resourcekey=&gid=1971851373#gid=1971851373")

glimpse(survey)


# process data

clean_data <- survey |>
  
