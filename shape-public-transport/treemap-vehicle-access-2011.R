# Source: QS701EW, 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/QS416EW
# Licence: Open Government Licence v3.0
# Credit and acknowledgements for code: @TraffordDataLab

library(tidyverse) ; library(treemapify) ; library(ggsci) ; library(scales)
source("https://github.com/traffordDataLab/assets/raw/master/theme/ggplot2/theme_lab.R")

# load data ---------------------------
dfNottinghamshire <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_548_1.data.csv?date=latest&geography=1941962811&rural_urban=0&cell=1...5&measures=20100") %>%   
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, n = OBS_VALUE, group = CELL_NAME) %>% 
  mutate(value = n/sum(n),
         indicator = "Vehicle access according to 2011 census",
         period = "2011-03-27",
         measure = "Proportion",
         unit = "vehicles") %>% 
  filter(group != "Other") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value, group) %>% 
  mutate(rn = row_number())

dfNottingham <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_548_1.data.csv?date=latest&geography=1941962805&rural_urban=0&cell=1...5&measures=20100") %>%   
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, n = OBS_VALUE, group = CELL_NAME) %>% 
  mutate(value = n/sum(n),
         indicator = "Vehicle access according to 2011 census",
         period = "2011-03-27",
         measure = "Proportion",
         unit = "vehicles") %>% 
  filter(group != "Other") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value, group) %>% 
  mutate(rn = row_number())


# plot data ---------------------------
tempNott <- mutate(dfNottingham, 
               info = str_c(group, ": ",  percent(value)))

tempNottinghamshire <- mutate(dfNottinghamshire, 
                   info = str_c(group, ": ",  percent(value)))

nottingham <- ggplot(tempNott,
       aes(area = value, fill = fct_reorder(group, rn, .desc = TRUE), 
           subgroup = group, label = info)) +
  geom_treemap(colour = "#212121") +
  geom_treemap_text(colour = "#FFFFFF", place = "bottomleft", reflow = TRUE, 
                    padding.x = grid::unit(1.5, "mm"),
                    padding.y = grid::unit(2, "mm"),
                    size = 14) +
  scale_fill_d3() +
  labs(x = NULL, y = NULL, 
       title = "Vehicle access",
       subtitle = "Nottingham, 2011",
       caption = "Source: 2011 Census | code adapted from @TraffordDataLab") +
  theme_lab() +
  theme(legend.position = "none") 

nottinghamshire <- ggplot(tempNottinghamshire,
       aes(area = value, fill = fct_reorder(group, rn, .desc = TRUE), 
           subgroup = group, label = info)) +
  geom_treemap(colour = "#212121") +
  geom_treemap_text(colour = "#FFFFFF", place = "bottomleft", reflow = TRUE, 
                    padding.x = grid::unit(1.5, "mm"),
                    padding.y = grid::unit(2, "mm"),
                    size = 14) +
  scale_fill_d3() +
  labs(x = NULL, y = NULL, 
       title = "Vehicle access",
       subtitle = "Nottinghamshire, 2011",
       caption = "Source: 2011 Census | code adapted from @TraffordDataLab") +
  theme_lab() +
  theme(legend.position = "none") 

