
install.packages("readxl")

# Load Packages -----------------------------------------------------------

library(tidyverse)
library(readxl)
library(janitor)
library(skimr)

# Download Files -------------------------------------------------------

# download.file(url = "https://github.com/rfortherestofus/going-deeper/raw/master/data-raw/enrollment-18-19.xlsx",
#               destfile = "data-raw/enrollment-18-19.xlsx", mode ="wb")
# 
# download.file(url = "https://github.com/rfortherestofus/going-deeper/raw/master/data-raw/enrollment-17-18.xlsx",
#               destfile = "data-raw/enrollment-17-18.xlsx", mode = "wb")


# Import Data -------------------------------------------------------------

enrollment_18_19 <- read_excel(path ="data-raw/enrollment-18-19.xlsx",
                               sheet = "Sheet 1")

enrollment_17_18 <- read_excel(path ="data-raw/enrollment-17-18.xlsx",
                               sheet = "Sheet 1")

# Reviewing Data for Tidyness ---------------------------------------------

# only covering 1 topic, 
# multiple variables stored in one column (year and ethnicity and number of 
# students in the group, year and grade)
# need for multiple data frames (there is grade and race data)
# 

# Clean Data --------------------------------------------------------------

enrollment_by_race_ethnicity_18_19 <- enrollment_18_19 %>%
  select(-contains("grade")) %>%
  select(-contains("kindergarten")) %>%
  select(-contains("percent")) %>%
  pivot_longer(cols = -district_id,
               names_to = "race_ethnicity",
               values_to = "number_of_students") %>%
  mutate(number_of_students = na_if(number_of_students, "-")) %>%
  mutate(number_of_students = replace_na(number_of_students, 0)) %>%
  mutate(number_of_students = as.numeric(number_of_students)) %>%
  mutate(race_ethnicity = case_when
          (race_ethnicity == "x2018_19_american_indian_alaska_native" ~ "American Indian Alaska Native",
           race_ethnicity == "x2018_19_asian" ~ "Asian",
           race_ethnicity == "x2018_19_native_hawaiian_pacific_islander" ~ "Native Hawaiian Pacific Islander",
           race_ethnicity == "x2018_19_black_african_american" ~ "Black African American",
           race_ethnicity == "x2018_19_hispanic_latino" ~ "Hispanic Latino",
           race_ethnicity == "x2018_19_white" ~ "White",
           race_ethnicity == "x2018_19_multiracial" ~ "Multiracial")) %>% 
  group_by(district_id) %>% 
  mutate(pct = number_of_students / sum(number_of_students)) %>% 
  ungroup %>% 
  mutate(year = "2018-2019")


enrollment_by_race_ethnicity_17_18 <- enrollment_17_18 %>%
  select(-contains("grade")) %>%
  select(-contains("kindergarten")) %>%
  select(-contains("percent")) %>%
  pivot_longer(cols = -district_id,
               names_to = "race_ethnicity",
               values_to = "number_of_students") %>%
  mutate(number_of_students = na_if(number_of_students, "-")) %>%
  mutate(number_of_students = replace_na(number_of_students, 0)) %>%
  mutate(number_of_students = as.numeric(number_of_students)) %>%
  mutate(race_ethnicity = str_remove(race_ethnicity, "x2017_2018_")) %>% 
  mutate(race_ethnicity = case_when
         (race_ethnicity == "american_indian_alaska_native" ~ "American Indian Alaska Native",
           race_ethnicity == "asian" ~ "Asian",
           race_ethnicity == "native_hawaiian_pacific_islander" ~ "Native Hawaiian Pacific Islander",
           race_ethnicity == "black_african_american" ~ "Black African American",
           race_ethnicity == "hispanic_latino" ~ "Hispanic Latino",
           race_ethnicity == "white" ~ "White",
           race_ethnicity == "18_multiracial" ~ "Multiracial")) %>% 
  group_by(district_id) %>% 
  mutate(pct = number_of_students / sum(number_of_students)) %>% 
  ungroup %>% 
  mutate(year = "2017-2018")

enrollment_by_race_ethnicity <- bind_rows(enrollment_by_race_ethnicity_17_18,
                                          enrollment_by_race_ethnicity_18_19)


##figure out why this code was not working

mutate(race_ethnicity = str_remove(race_ethnicity, "x2017_2018_"))
  
  summarize(total = sum(number_of_students))



enrollement_by_race_ethnicity_18_19 %>%
  summarize(total = sum(number_of_students))
