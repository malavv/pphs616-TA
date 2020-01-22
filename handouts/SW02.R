# Title     : R Handout for Programming Skills 02
# Objective : Familiarization with R Concepts
# Created by: Maxime Lavigne (malavv) <maxime.lavigne@mail.mcgill.ca>
# Created on: 2020-01-21

library(tidyverse)
library(lubridate)
# install.packages("lubridate") # Example of how to install package


# -- Revision of material from last session --

# Integer (a 1 el array)
5

# Confirmation
el(5, 1) == 5 # First element of the array

# "Numeric"
5.5

# Seems same, verify type
class(5.5) == "numeric"

# But what about "reals" and "double precision floating point" numbers
is.double(5.5)

delta <- pi^-32
ifelse(5.5 + delta == 5.5, "Incorrectly Equal", "Not Equal")

# Check equality at a certain precision
ifelse(abs(5.5 + delta - 5.5) < 1E-06, "Correctly Equal", "Not Equal")

# Character (still a 1 element array (but contains a string))
"Hello World"

# Although, you can explode the string into vector of letters
el(strsplit("Hello World", ""), 1)

# State of Matter at common energy levels
states <- as.factor(rep(c("solid", "liquid", "gas", "plasma"), 5)); states

# -- More complex Cases --

# Description of some function
div_remainder <- function (number, divisor) {
  return (number %% divisor)
}
is_divisible <- function(num, div) {
  div_remainder(number = num, divisor = div) == 0
}

is_divisible(10, 5) # Should be divisible

## Control Flow
temp_in_celsius <- 23.5
set_temp_in_celsius <- 22.0
is_powered <- TRUE

if (temp_in_celsius > set_temp_in_celsius) { "too hot" } else { "too cold" }
if (is_powered) { "is powered" }

# Please never !!
if ((temp_in_celsius > set_temp_in_celsius) == TRUE) { "too hot" } else { "too cold" }
if (is_powered == TRUE) { "is powered" }

# When creating function, if else can be placed and used to simplify
bad_form_bmi <- function(height_in_m, weight_in_kg) {
  cond <- ""
  if (!is.na(height_in_m)) {
    if (!is.na(weight_in_kg)) {
        if ((weight_in_kg / height_in_m^2) < 18.5) {
          cond <- "underweight"
        }
        if ((weight_in_kg / height_in_m^2) >= 18.5 & (weight_in_kg / height_in_m^2) < 25) {
          cond <- "Normal  managed"
        }
        return(cond)
    }
  }
  return(NA)
}

good_form_bmi <- function(height_in_m, weight_in_kg) {
  if (is.na(height_in_m)) { return(NA) }
  if (is.na(weight_in_kg)) { return(NA) }

  bmi <- weight_in_kg / height_in_m^2
  if (bmi < 18.5) { return("underweight") }
  if (bmi < 25) { return("Normal") }
}

# Data Structure Example

## Vectors, subsetting, and selection
df <- read_csv("https://raw.githubusercontent.com/malavv/pphs616-TA/master/data/diabetes_hochelaga.csv")

years <- df$Year; years

# Structure
str(years)
# Summary
summary(years)

# First year
years[1] # not 0

# Select first 2
years[1:2]

# Select all but first
years[-1]

# Select with logical array
years[is_divisible(years, 2)]
# Useful to find something
years[years == 2002]
# If named, can use name
names(years) <- letters[seq_along(years)]; years
years[c("a", "k", "y")]

# Couple of way to generate sequences
1:10 # inclusive
seq(1, 10)
seq(1, 10, by=2) # Useful for fine grain X axis for example
c(1, 2, 3)
c(1, c(2, c(3)))
1:-5
(function(x) plot(x, sin(x))) (seq(1, 20, by= 0.1))

# Basic data frame
df

head(df)

# Cell access is [row, column] and accept missing values
df[,]
df[1:10,] # Select 10 rows
df[!is.na(df$ID),] # Select row with ID not NAs
df[,"ID"]
df[,-c(1:3)]
# Rename column to something easier to type, but changing data object
dm <- df
names(dm)[4:6] <- c("val", "lo", "hi"); dm

# From now on, I'll use tidy function when manipulating Data Frame.
# There are other ways, but at this point, if you have to learn one, learn this way

# First, the Pipe %>%
# In dplyr the following are the same
filter(dm, val == 44)
# and
dm %>% filter(val == 44)
# why do it then? because the following is hard to read
summarise(filter(group_by(dm, CLSC), val == 44), avg_prev = mean(val)) # Don't do this

# Finding count of CLSC per year
dm %>% group_by(Year) %>% count()

# Getting average prevalence per CLSC group (average of val for each year)
dm %>% group_by(CLSC) %>% summarise(avg_prev = mean(val))

# Finding worst year in hochelaga
dm %>%
  group_by(CLSC) %>%
  filter(CLSC == "Hochelaga-Maisonneuve") %>%
  summarise(worst = min(val))

# Removing unused columns
dm <- dm %>% select(-c("ID"))

# Looking at exercise from students!

# Review of functions
# Convert var to date type
as.Date()
# Convert var to factor type
as.factor()
# Returns element at the start of an iterable
head(x, n)
# Returns element at the end of an iterable
tail(x, n)
# Create sequence
seq(from, to, by)
# Add all numbers in array
sum()
# Format textually with config, ex: %b in doc means "Abbreviated month name in the current locale on this platform"
format(ymd("2019-01-21"), format="%b") # [1] "Jan"
# Count number of row in data.frame
nrow(dm) # No, length(dm) *will not work* it will give you number of element in list (ie. columns)
# Repeat an array, a number of times
rep(x, times)
# Generalized Linear Model, for regression (see doc for more)
glm(formula, data)
# For a model previously fitted, to predict using provided data.
# (warning, be aware of prediction domain log vs identity link) (hint: type="response" for link log)
predict(fitted_model,data_for_predication)
# Starts a visualization context
plot(x, y, ...) # lots of configuration possible, check doc.
# Creates a line series for the current plot
lines()
# Creates a point series for the current plot
points()
# Creates a Box-Whisker visualization
bwplot()