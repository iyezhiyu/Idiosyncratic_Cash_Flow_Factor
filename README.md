# Idiosyncratic_Cash_Flow_Factor

## Introduction
Inspired by [Idiosyncratic Cash Flows and Systematic Risk](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.661.820&rep=rep1&type=pdf).
This project constructs a Idiosyncratic Cash Flow factor and tests it on the Chinese stock market.

## Modules

### data_tools
* data_reader_step_1.sas and data_reader_step_2.sas are the two data reading steps need to be done at first
* data_describer.sas is the file to see the distributing patterns of cash flows, cash flows growth rates and the idiosyncratic cash flow factor. This program needs to run after the ivol_generator.sas. The result is shown in results/table2.pdf
* the missing data statistics is in results/table1.pdf

### ivol_generator.sas
* ivol_generator.sas generates the idiosyncratic cash flow factor (IVOL)

### ten_groups
* value_weighted_groups.sas generates the result of the stocks divided in 10 groups each month according to the IVOL, the weights of the stocks are the market values of them
* equal_weighted_groups.sas generates the result of the stocks divided in 10 groups each month according to the IVOL, the weights of the stocks are equal
* results are shown in results/table3.pdf for all times, and results/table4.pdf for years respectively

### market_value_conditional_groups
* value_weighted_groups.sas is to divide the stocks into 5 groups according to the market values of them firstly, and then in each of the five groups, divide the stocks into 5 groups in line with the IVOL, and the weithts of the stocks are the market values of them
* equal_weighted_groups.sas is to divide the stocks into 5 groups according to the market values of them firstly, and then in each of the five groups, divide the stocks into 5 groups in line with the IVOL, and the weithts of the stocks are equal
* market_value_averages.sas is to calculate the average logarithmic market values of the 25 groups
* results are in results/table5.pdf

### bm_ratio_conditional_groups
* value_weighted_groups.sas is to divide the stocks into 5 groups according to the BM ratio (book to market ratio) of them firstly, and then in each of the five groups, divide the stocks into 5 groups in line with the IVOL, and the weithts of the stocks are the market values of them
* equal_weighted_groups.sas is to divide the stocks into 5 groups according to the BM ratio of them firstly, and then in each of the five groups, divide the stocks into 5 groups in line with the IVOL, and the weithts of the stocks are equal
* bm_ratio_averages.sas is to calculate the average logarithmic BM ratio of the 25 groups
* results are in results/table6.pdf

## Results

### Result tables
* The tables of the results are described above

### Analytical results
* IVOL has a positive correlation with the stock returns in the Chinese stock market
* After controlling the market values / BM ratio, IVOL still has a positive correlation with the stock returns
* IVOL can not be explained using the CAPM and the Fama-French three factors, which means it can be a valid factor in the stock investment
