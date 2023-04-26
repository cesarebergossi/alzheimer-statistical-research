###Loading required packages
#install.packages("fastDummies")
#install.packages("tidyverse")
#install.packages("glmnet")
#install.packages("ggplot2")
#install.packages("stats")
library(fastDummies)
library(tidyverse)
library(glmnet)
library(ggplot2)
library(stats)

###Loading Dataset: Dataset_BergossiPezzani.csv
data = read.csv(file.choose(), header = TRUE)
data <- subset(data, select = c(M.F, Age, EDUC, SES, MMSE, CDR, eTIV, nWBV, ASF))
attach(data)
names(data)

###Substitute missing values with mean
data <- data %>%
  mutate_if(is.numeric, funs(ifelse(is.na(.), mean(., na.rm = TRUE), .)))

###Dummy Variables
data <- dummy_cols(data, select_columns = "M.F")
attach(data)

### Explore data
summary(data)

###Plots
plot(data$Age, data$CDR, type="p", xlab = "Age", ylab = "Clinical Dementia Rating")
plot(data$EDUC, data$CDR, type="p", xlab = "Years of Education", ylab = "Clinical Dementia Rating")
plot(data$SES, data$CDR, type="p", xlab = "Socioeconomic Status", ylab = "Clinical Dementia Rating")
plot(data$MMSE, data$CDR, type="p", xlab = "Mini Mental State Examination", ylab = "Clinical Dementia Rating")
plot(data$eTIV, data$CDR, type="p", xlab = "Estimated Total Intracranial Volume", ylab = "Clinical Dementia Rating")
plot(data$ASF, data$CDR, type="p", xlab = "Atlas Scaling Factor", ylab = "Clinical Dementia Rating")
ggplot(data) + geom_boxplot(aes(x=M.F, y=MMSE, color = M.F))


###Outliers Exclusion
data <- subset(data, CDR < 2.0)
data <- subset(data, Age <= 96)
data <- subset(data, EDUC <= 20)
data <- subset(data, MMSE > 10)
attach(data)

###Multiple Linear Regression
fit <- lm(CDR ~ EDUC + Age + SES + MMSE + eTIV + nWBV + ASF + M.F_M)
summary(fit)

predictors <- names(data)
predictors <- setdiff(predictors, 'M.F')
predictors <- setdiff(predictors, 'CDR')
predictors <- setdiff(predictors, 'M.F_F')

###Step Down Method
pvalues <- summary(fit)$coefficients[-1, 4]
# Iteratively remove the least significant predictor
while (max(pvalues) > 0.05) {
  # Find the index of the least significant predictor
  remove_index <- which.max(pvalues)
  # Remove the least significant predictor from the model
  predictors <- names(pvalues)[-remove_index]
  model <- lm(CDR ~ ., data = data[, c("CDR", predictors)])
  # Update the p-values
  pvalues <- summary(model)$coefficients[-1, 4]
}
# The final model contains only the significant predictors
fit_SD <- model
coef(fit_SD)
summary(fit_SD)
#F-test
intercept_model <- lm(CDR ~ 1, data = data)
anova(fit_SD, intercept_model)

#LASSO
predictors <- names(data)
predictors <- setdiff(predictors, 'M.F')
predictors <- setdiff(predictors, 'CDR')
predictors <- setdiff(predictors, 'M.F_F')
x <- as.matrix(data[, predictors])
y <- CDR
lasso <- cv.glmnet(x, y, nfolds=10)
best_lambda <- lasso$lambda.min
fit_LASSO <- glmnet(x, y, lambda = best_lambda)
coef(fit_LASSO)

###Normality and Homoscedasticity
##Step Down
res1 = residuals(fit_SD)
#Graphical Methods
qqnorm(res1, xlab="Normal Distribution", ylab="Step-Down Residuals")
qqline(res1, col='red', main = 'With coloring')
#Normality Tests
ks.test(res1, "pnorm")
shapiro.test(res1)
#Homoscedasticity
plot(res1,  xlab = "Step-Down Fitted", ylab="Step-Down Residuals")

##LASSO
lasso_model = cv.glmnet(x, y, nfolds=10)
fitted_values <- predict(lasso_model, x)
res2 <- y - fitted_values
#Graphical Methods
qqnorm(res2, xlab="Normal Distribution", ylab="LASSO Residuals")
qqline(res2, col='red', main = 'With coloring')
#Normality Tests
shapiro.test(res2)
#Homoscedasticity
plot(res2,  xlab = "LASSO Fitted", ylab="LASSO Residuals")

###Hypothesis Testing
#Divide the data into two groups based on years of education
group1 <- subset(data, EDUC < mean(EDUC))
group2 <- subset(data, EDUC >= mean(EDUC))
#Check that normality is not attained in the two gropus
with(group1, shapiro.test(CDR))
with(group2, shapiro.test(CDR))
#Compare variances and check the number of elements of the two groups
var(group1$CDR)
var(group2$CDR)
length(group1$CDR)
length(group2$CDR)
#t-test
t.test(group1$CDR, group2$CDR, alternative = "greater", var.equal = FALSE)
