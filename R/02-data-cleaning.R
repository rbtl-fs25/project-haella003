# spreadsheet

library(tidyverse)
library(googlesheets4)
library(dplyr)

survey <- read_sheet("https://docs.google.com/spreadsheets/d/1Aoa7DzcldoiGbKYePlBldgHMexyMQqmXkf7_ycwP1yc/edit?resourcekey=&gid=1971851373#gid=1971851373")

glimpse(survey)


# process data

clean_data_1 <- survey |>
  select("date" = "Timestamp",
         "degree" = "Are you enrolled in a bachelor's or master's degree at ETH Zurich?",
         "semester" = "Which semester are you currently in?",
         "course" = "What is your field of study?",
         "age" = "How old are you?",
         "lectures_completed" = "How many lectures did you successfully complete last semester?",
         "device_usage" = "Which device do you use most for studying?",
         "notes" = "Do you prefer to take notes digitally or on paper?",
         "side_usage" = "Do you print your paper on average one-sided or double-sided?",
         "pages_usage" = "How many pages per one side of a sheet do you print on average?",
         "color" = "Do you generally print your papers black-and-white or in colors?",
         "color_usage" = "What kind of papers do you prefer to print in color?",
         "printing_reason" = "What is your primary reason for printing?",
         "printing_location" = "Where do you print your papers?",
         "printing_decision" = "Are there any factors that influence your decision to print (cost, convenience, environmental concerns)?",
         "printing_amount" = "If you need to estimate the broad amount of number of sheets of paper you printed in your last semester. what would you guess?"
  ) |>
  mutate(id = seq(1:n())) %>%
  relocate(id) %>% 
  mutate(date = as.Date(date))

#rename_1
clean_data_2 <- clean_data_1 %>%
  mutate(course = recode(course, "Business, Finance & Management" = "Economics",
                         "Healthcare & Medicine" = "Medicine",
                         "Agriculture, Environment & Natural Sciences" = "Natural Science",
                         "IT & Computer Science" = "Computer Science",
                         "Sales, Marketing & Customer Service" = "Marketing"))

#delete rows with random answers
clean_data_3 <- clean_data_2[-c(2, 6, 16, 18), ]

#rename_2
clean_data_4 <- clean_data_3 %>%
  mutate(notes = recode(notes, "on paper" = "paper"),
         printing_location = recode(printing_location, "at work" = "work"))
  
#rename_3
clean_data_5 <- clean_data_4 %>%
  separate_rows(color_usage, sep = ", ") %>%
  filter(!is.na(color_usage))

#rename_4
clean_data_6 <- clean_data_5 %>%
  separate_rows(printing_location, sep = ", ") %>%
  filter(!is.na(printing_location))

#rename_5
clean_data_7 <- clean_data_6 %>%
  separate_rows(printing_decision, sep = ", ") %>%
  filter(!is.na(printing_decision))
  
#datatype
clean_data_8 <- clean_data_7 %>%
  mutate(semester = as.numeric(semester),
         lectures_completed = as.numeric(lectures_completed))


#average_number
library(dplyr)
library(stringr)


clean_data_9 <- clean_data_8 %>%
  mutate(
    printing_amount = sapply(
      str_extract_all(printing_amount, "\\d+"),
      function(x) round(mean(as.numeric(x)))
    )
  )


clean_data <- clean_data_9


glimpse(clean_data)


data_out <- clean_data

write_csv(data_out, "data/processed/survey-cleaned-data.csv")
write_rds(data_out, "data/processed/survey-cleaned-data.rds")


#dictionary

dictionary <- read_sheet("https://docs.google.com/spreadsheets/d/11O0w2RbF1AtFiIvma9daU8_FgiW7mJ38iymM49iDVhg/edit?gid=567079855#gid=567079855")
write_csv(dictionary, "data/processed/dictionary.csv")
