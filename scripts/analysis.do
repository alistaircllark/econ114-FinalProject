* Set working directory to the project root (e.g., Econ114-FinalProject/) before running
log using "results/analysis_log.txt", text append

use "data/processed/panel_data.dta", clear

// Formatting
destring ID, replace ignore("$,")
destring day, replace ignore("$,")
destring Q22, replace ignore("$,")
destring Q23, replace ignore("$,")
destring Q24, replace ignore("$,")
destring Q31, replace ignore("$,")
destring Q32, replace ignore("$,")
destring Q35, replace ignore("$,")
destring Q25, replace ignore("$,")
destring Q26, replace ignore("$,")
destring Q27, replace ignore("$,")
destring Q28, replace ignore("$,")
destring Q29, replace ignore("$,")
destring Q30, replace ignore("$,")

* Variable renaming
rename Q1 age
rename Q4 exercise_days
rename Q5 exercise_minutes
rename Q6 exercise_intensity
rename Q7 meals_per_day
rename Q8 fruits_veggies_per_day
rename Q9 sleep_hours
rename Q10 sleep_consistency
rename Q11_1 physical_health
rename Q34_1 mental_health
rename Q13 happiness
rename Q14 stress
rename Q15 social_satisfaction
rename Q16 social_support
rename Q17 loneliness
rename Q18 friends_exercise
rename Q19 friends_exercise_intensity
rename Q21 join_friends_exercise
rename Q22 daily_exercise
rename Q23 daily_exercise_minutes
rename Q24 daily_exercise_intensity
rename Q31 daily_exercise_with_friends
rename Q32 daily_exercise_encouragement
rename Q35 daily_exercise_motivation
rename Q25 daily_meals
rename Q26 daily_fruits_veggies
rename Q27 daily_sleep_hours
rename Q28 daily_mental_health
rename Q29 daily_physical_health
rename Q30 daily_stress
rename Q2_Female gender_female
rename Q2_Male gender_male
rename Q2_Nonbinary__third_gender gender_nonbinary
rename Q2_Prefer_not_to_say gender_prefer_not_say
rename Q3_Asian race_asian
rename Q3_Black_or_African_American race_black
rename Q3_Hispanic_or_Latino race_hispanic
rename Q3_NativeAm_AK_Native race_native_am
rename Q3_Other_please_specify race_other
rename Q3_White race_white
rename Q20_Cardio friends_exercise_cardio
rename Q20_Flex friends_exercise_flex
rename Q20_Never friends_exercise_never
rename Q20_Other friends_exercise_other
rename Q20_StrengthTrain friends_exercise_strength
rename Q20_TeamSports friends_exercise_teamsports

* Standardizing variables
egen exercise_days_z = std(exercise_days)
egen exercise_minutes_z = std(exercise_minutes)
egen exercise_intensity_z = std(exercise_intensity)

* Generating composite score for exercise variables
gen exercise_composite = (exercise_days_z + exercise_minutes_z + exercise_intensity_z) / 3

* Standardizing daily variables
egen daily_exercise_z = std(daily_exercise)
egen daily_exercise_minutes_z = std(daily_exercise_minutes)
egen daily_exercise_intensity_z = std(daily_exercise_intensity)

* Generating composite score for daily exercise variables
gen daily_exercise_composite = (daily_exercise_z + daily_exercise_minutes_z + daily_exercise_intensity_z) / 3

* Method 1
xtset ID day

* Fixed effects regression for mental health
xtreg daily_mental_health daily_exercise daily_exercise_minutes daily_exercise_intensity daily_exercise_with_friends daily_exercise_encouragement daily_exercise_motivation daily_meals daily_fruits_veggies daily_sleep_hours daily_physical_health, fe


* Fixed effects and random effects comparison
xtreg daily_mental_health daily_exercise daily_exercise_minutes daily_exercise_intensity daily_exercise_encouragement daily_meals daily_fruits_veggies daily_sleep_hours daily_physical_health daily_stress daily_exercise_with_friends daily_exercise_motivation, fe 
estimates store fe

xtreg daily_mental_health daily_exercise daily_exercise_minutes daily_exercise_intensity daily_exercise_encouragement daily_meals daily_fruits_veggies daily_sleep_hours daily_physical_health daily_stress daily_exercise_with_friends daily_exercise_motivation, re 
estimates store re

hausman fe re

xtreg daily_mental_health daily_exercise daily_exercise_minutes daily_exercise_intensity daily_exercise_encouragement daily_meals daily_fruits_veggies daily_sleep_hours daily_physical_health daily_stress daily_exercise_with_friends daily_exercise_motivation, fe cluster(ID)

* Method 2

* OLS regression for overall mental health
reg mental_health exercise_composite friends_exercise friends_exercise_intensity age gender_female gender_male gender_nonbinary gender_prefer_not_say race_asian race_black race_hispanic race_native_am race_other race_white meals_per_day fruits_veggies_per_day sleep_hours sleep_consistency happiness stress social_satisfaction social_support loneliness
estimates store ols_model
estat hettest
* IV regression for overall mental health with friends exercise as instruments
ivregress 2sls mental_health (exercise_composite = friends_exercise friends_exercise_intensity) age gender_female gender_male gender_nonbinary gender_prefer_not_say race_asian race_black race_hispanic race_native_am race_other race_white meals_per_day fruits_veggies_per_day sleep_hours sleep_consistency happiness stress social_satisfaction social_support loneliness
estimates store iv_model

* Hausman test to compare OLS and IV estimates
hausman iv_model ols_model

* First-stage regression
reg exercise_composite friends_exercise friends_exercise_intensity age gender_female gender_male gender_nonbinary gender_prefer_not_say race_asian race_black race_hispanic race_native_am race_other race_white meals_per_day fruits_veggies_per_day sleep_hours sleep_consistency physical_health happiness stress social_satisfaction social_support loneliness

* Second IV regression with additional instrument
ivregress 2sls mental_health (exercise_composite = friends_exercise friends_exercise_intensity) age gender_female gender_male gender_nonbinary gender_prefer_not_say race_asian race_black race_hispanic race_native_am race_other race_white meals_per_day fruits_veggies_per_day sleep_hours sleep_consistency happiness stress social_satisfaction social_support loneliness

* Obtain first-stage statistics
estat firststage

* Obtain over-identification test statistics
estat overid

estat endogenous




