library(googlesheets4)
library(tidyverse)
library(dplyr)


paper_data <- read_sheet("https://docs.google.com/spreadsheets/d/1Aoa7DzcldoiGbKYePlBldgHMexyMQqmXkf7_ycwP1yc/edit?resourcekey=&gid=1971851373#gid=1971851373")

glimpse(paper_data)

