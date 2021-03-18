library(readxl)
library(qicharts2)
library(tidyverse)
library(lubridate)

#Field_Mortality_Crimea <- read_excel("Field Mortality Crimea.xlsx")

crimea <- tibble::tribble(
                ~Month, ~Average.size.of.army, ~Zymotic.diseases, ~`Wounds.&.injuries`, ~All.other.causes,
            "Apr 1854",                 8571L,                1L,                   0L,                5L,
            "May 1854",                23333L,               12L,                   0L,                9L,
            "Jun 1854",                28333L,               11L,                   0L,                6L,
            "Jul 1854",                28722L,              359L,                   0L,               23L,
            "Aug 1854",                30246L,              828L,                   1L,               30L,
            "Sep 1854",                30290L,              788L,                  81L,               70L,
            "Oct 1854",                30643L,              503L,                 132L,              128L,
            "Nov 1854",                29736L,              844L,                 287L,              106L,
            "Dec 1854",                32779L,             1725L,                 114L,              131L,
            "Jan 1855",                32393L,             2761L,                  83L,              324L,
            "Feb 1855",                30919L,             2120L,                  42L,              361L,
            "Mar 1855",                30107L,             1205L,                  32L,              172L,
            "Apr 1855",                32252L,              477L,                  48L,               57L,
            "May 1855",                35473L,              508L,                  49L,               37L,
            "Jun 1855",                38863L,              802L,                 209L,               31L,
            "Jul 1855",                42647L,              382L,                 134L,               33L,
            "Aug_1855",                44614L,              483L,                 164L,               25L,
            "Sep 1855",                47751L,              189L,                 276L,               20L,
            "Oct 1855",                46852L,              128L,                  53L,               18L,
            "Nov 1855",                37853L,              178L,                  33L,               32L,
            "Dec 1855",                43217L,               91L,                  18L,               28L,
            "Jan 1856",                44212L,               42L,                   2L,               48L,
            "Feb 1856",                43485L,               24L,                   0L,               19L,
            "Mar 1856",                46140L,               15L,                   0L,               35L
            )


# Add 01 to the beginning of the character date and then convert to a date

crimea <- crimea %>% 
  mutate(startMonth = paste0("01 ", Month),
         startMonth = dmy(startMonth)) 

# Pivot data to long form from wide 

crimeaLong <- crimea %>% 
  select(-Month,-Average.size.of.army) %>% 
  pivot_longer(cols = Zymotic.diseases:All.other.causes,
               names_to = 'death_cause',
               values_to = 'number') %>% 
  arrange(death_cause,
          startMonth)

glimpse(crimeaLong)


# Using the older verb gather

data_gathered <- crimea %>% 
  select(-Month,-Average.size.of.army) %>% 
  gather(death_cause, number, Zymotic.diseases:All.other.causes) %>% 
  arrange(death_cause,
          startMonth)

glimpse(data_gathered)

