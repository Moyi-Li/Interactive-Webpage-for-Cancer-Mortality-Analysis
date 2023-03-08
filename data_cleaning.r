library(tidyverse)

## incidence
incidence <- read_delim("incidence.csv")

incidence <- incidence %>%
  gather(key = "key", value = "Incidence", -Time)


incidence <- separate(incidence, key, into = c("State", "Site", "part3", "Gender"), sep = ",")

incidence <- incidence %>%
  select(-part3)

incidence[is.na(incidence)] <- 0

## deaths
deaths <- read_delim("deaths.csv")


deaths <- deaths %>%
  gather(key = "key", value = "Death", -Time)

deaths <- separate(deaths, key, into = c("State", "Site", "part3", "Gender"), sep = ",")

deaths <- deaths %>%
  select(-part3)

deaths[is.na(deaths)] <- 0

## merge
cancer <- merge(incidence, deaths, by=c("Time", "State", "Site", "Gender"))

cancer$Site = str_sub(cancer$Site, 2)
cancer$Gender = str_sub(cancer$Gender, 2)

write.csv(cancer, "cancer.csv")