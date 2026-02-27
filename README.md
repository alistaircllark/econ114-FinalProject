# Econ 114 Final Project

This repository contains the data, scripts, and results for my final project in Advanced Quantitative Methods (Econ 114) at UC Santa Cruz. 

## Project Overview
The project investigates the relationship between exercise and mental health using survey data. The analysis employs fixed effects and instrumental variable (IV) regression techniques to account for endogeneity, using friends' exercise habits as an instrument for individual exercise levels.

## Directory Structure
- `data/`: Contains both raw survey data and the processed datasets.
    - `raw/SurveyData1.csv`: The initial survey results.
    - `processed/clean_data.csv`: Cleaned dataset.
    - `processed/panel_data.dta`: Final panel dataset used for regression analysis.
- `scripts/`: Contains the code used for cleaning data and running regressions.
    - `data_cleaning.R`: R script that cleans the raw survey data, collapses daily variables, and generates the panel dataset.
    - `analysis.do`: Stata DO file that analyzes the processed panel data using fixed effects models, simple OLS, and 2SLS (Instrumental Variables).
- `results/`: Output from the Stata analysis, including log files and regression tables.
- `docs/`: Word documents containing the final project write-up and results discussion, as well as the final submitted paper (`Econ114-FinalPaper.pdf`).

## Methodology
The study uses daily survey data. 
- **Data Cleaning:** The R script (`data_cleaning.R`) takes the raw cross-sectional data and pivots it into a longitudinal panel format with multiple daily observations per respondent.
- **Analysis:** The Stata script (`analysis.do`) first implements a fixed-effects model to assess the daily variation in mental health. To address potential omitted variable bias in overall mental health, an IV approach is used, instrumenting the individual's exercise composite score with the level and intensity of their friends' exercise.
