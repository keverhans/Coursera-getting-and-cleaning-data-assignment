---
title: "ReadMe"
author: "Hans De Jonghe"
date: "23 oktober 2016"
output: html_document
---

# Getting-and-Cleaning-Data
Assigment for Coursera Course Getting and Cleaning Data

The script run_analysis.R produces a tidy dataset from the test and train datasets from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

What is a tidy dataset?

* Observations are in rows
* Variables are in columns
* Contained in a single dataset.

The script has explanatory comments, but it goes as follows:

1) Read the data
2) Merge the data
3) Only select columns containing mean() or std()
4) Tidy dataset is now stored in a variable called finalData
5) Calculates the mean for each subject activity and variable and stores it in a data frame called groupData and write to disk TidyMeanData.txt
