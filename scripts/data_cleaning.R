#Clear Cache
rm(list = ls()); cat("\014")

#Libraries
library(tidyr)
library(dplyr)
library(haven)
#Data
# Set working directory to the 'scripts' folder before running
# e.g., setwd("path/to/Econ114-FinalProject/scripts")
OGdata<-read.csv("../data/raw/SurveyData1.csv")
data<-read.csv("../data/processed/clean_data.csv")

#Add ID Variable
data$ID <- seq.int(nrow(data))


data_collapsed <- data %>%
  mutate(collapsed_1 = paste(Q22_1, Q23_1, Q24_1, Q31_1, Q32_1, Q35_1, Q25_1, Q26_1, Q27_1, Q28_1, Q29_1, Q30_1, sep = "-"),
         collapsed_2 = paste(Q22_2, Q23_2, Q24_2, Q31_2, Q32_2, Q35_2, Q25_2, Q26_2, Q27_2, Q28_2, Q29_2, Q30_2, sep = "-"),
         collapsed_3 = paste(Q22_3, Q23_3, Q24_3, Q31_3, Q32_3, Q35_3, Q25_3, Q26_3, Q27_3, Q28_3, Q29_3, Q30_3, sep = "-"),
         collapsed_4 = paste(Q22_4, Q23_4, Q24_4, Q31_4, Q32_4, Q35_4, Q25_4, Q26_4, Q27_4, Q28_4, Q29_4, Q30_4, sep = "-"),
         collapsed_5 = paste(Q22_5, Q23_5, Q24_5, Q31_5, Q32_5, Q35_5, Q25_5, Q26_5, Q27_5, Q28_5, Q29_5, Q30_5, sep = "-"),
         collapsed_6 = paste(Q22_6, Q23_6, Q24_6, Q31_6, Q32_6, Q35_6, Q25_6, Q26_6, Q27_6, Q28_6, Q29_6, Q30_6, sep = "-"),
         collapsed_7 = paste(Q22_7, Q23_7, Q24_7, Q31_7, Q32_7, Q35_7, Q25_7, Q26_7, Q27_7, Q28_7, Q29_7, Q30_7, sep = "-"),
         collapsed_8 = paste(Q22_8, Q23_8, Q24_8, Q31_8, Q32_8, Q35_8, Q25_8, Q26_8, Q27_8, Q28_8, Q29_8, Q30_8, sep = "-"),
         collapsed_9 = paste(Q22_9, Q23_9, Q24_9, Q31_9, Q32_9, Q35_9, Q25_9, Q26_9, Q27_9, Q28_9, Q29_9, Q30_9, sep = "-"),
         collapsed_10 = paste(Q22_10, Q23_10, Q24_10, Q31_10, Q32_10, Q35_10, Q25_10, Q26_10, Q27_10, Q28_10, Q29_10, Q30_10, sep = "-")) %>%
  select(ID, starts_with("collapsed"))

data_long <- data_collapsed %>%
  pivot_longer(
    cols = starts_with("collapsed"),  # Select columns that start with 'collapsed'
    names_to = "day",                 # New column for storing the day
    names_prefix = "collapsed_",      # Remove the prefix to just have the day number
    values_to = "daily_data"          # The name of the new column that will store the daily data
  )

data_separated <- data_long %>%
  separate(
    col = daily_data,                # Column to separate
    into = c("Q22", "Q23", "Q24", "Q31", "Q32", "Q35", "Q25", "Q26", "Q27", "Q28", "Q29", "Q30"), # Names of the new columns
    sep = "-",                       # Separator used in the concatenated data
    remove = TRUE,                   # Whether to remove the original column after separating
    convert = FALSE                  # Set to TRUE if you need automatic conversion of types
  )


control_data<-data[,c(3:21,142:158)]
data_with_controls <- left_join(data_separated, control_data, by = "ID")

data_with_controls <- data_with_controls %>%
  rename(
    Q3_NativeAm_AK_Native = Q3_Native_American_or_Alaska_Native,
    Q20_Cardio = Q20_Cardiovascular_activities_eg_running_cycling,
    Q20_Flex = Q20_Flexibility_exercises_eg_yoga,
    Q20_StrengthTrain = Q20_Strength_training_eg_weight_lifting,
    Q20_TeamSports = Q20_Team_sports_eg_basketball_soccer
  )

write_dta(data_with_controls, path = "../data/processed/panel_data.dta")