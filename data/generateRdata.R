library(dplyr)

# Create data frame for 34 subjects and dates of birth
subjects <- data.frame(
  subjects = sample(1:34),
  dob = sample(seq(as.Date('1999/01/01'), as.Date('2000/01/01'), by = "day"), 34)
)

# repeat the subjects 3 times (other code can be used to do this like loops)
subjectsRepeated <- subjects %>% 
  union_all(subjects) %>% 
  union_all(subjects) %>% 
  mutate(rowID = row_number())

# sample from the df for changes to be made later to the dob

sample <- sample_n(subjectsRepeated, 3)  
sample <- as.vector(sample$rowID)

# delete some of the dob
subjectsRemoved <- subjectsRepeated %>% 
  mutate(dob = as.character(dob),
         dob = case_when(rowID %in% sample ~ NA_character_,
                         TRUE ~ dob),
         dob = as.Date(dob))


