# Investigating the Relationship Between Education and Alzheimer’s Disease
This repository hosts a Statistical Research Project that investigates the potential relationship between education and the risk of developing Alzheimer’s disease in older adults. The project was completed during the winter of 2022/2023 for the Mathematical Statistics course in the second year of the BSc program, in collaboration with colleague Giulia Pezzani.

The repository contains the final PDF report that presents the main techniques used and the results obtained. Additionally, the dataset and the R code used to derive the conclusions are included as separate files.


## Project Overview

This project investigates whether higher education levels reduce the severity of Alzheimer’s Disease. We work with a dataset containing patient demographics, cognitive test scores, and brain scan data. Alzheimer’s severity is measured via the Clinical Dementia Rating (CDR), and we evaluate correlations through multivariate regression, model selection techniques, and hypothesis testing.

## Methods

### Data Cleaning
- Imputed missing values with column means  
- Encoded categorical variables  
- Removed outliers via visual inspection  

### Exploratory Analysis
- Boxplots, scatterplots, and summary statistics  
- Highlighted MMSE scores and potential gender-based effects  

### Modeling
- Multivariate Linear Regression  
- Model Selection:
  - Step-Down based on p-values  
  - LASSO Regularization (via `glmnet`)  
- Residual analysis and normality testing  
- Hypothesis testing on education groups (asymptotic t-test)

## Key Findings

- The linear models showed limited predictive power (adjusted R² ≈ 0.52)  
- Education level was **not removed** by either Step-Down or LASSO  
- A **two-sample t-test** revealed a statistically significant difference:  
  → Patients with >15 years of education had **lower** CDR scores (p ≈ 0.0025)  
- Suggests that higher education may **delay or lessen** Alzheimer’s severity  


## Files

- `Dataset_BergossiPezzani.csv`: Cleaned dataset  
- `Research_BergossiPezzani.R`: R analysis script  
- `Project_BergossiPezzani.pdf`: Full report with figures and interpretation  

## How to Run

1. Open `Research_BergossiPezzani.R` in R or RStudio  
2. Ensure required libraries are installed (`glmnet`, `ggplot2`, etc.)  
3. Run the script to reproduce plots, models, and tests  

## Dataset Source

[Kaggle: Alzheimer Features Dataset](https://www.kaggle.com/datasets/brsdincer/alzheimer-features)


## Notes

- The analysis focuses on **correlation**, not causation  
- Results are **not generalizable** to the whole population (e.g. younger adults)  
- Residuals deviated from normality, which is a limitation of the regression models

