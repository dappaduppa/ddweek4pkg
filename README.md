---
output: Fatality Analysis Reporting System
---

<!-- README.md is generated from README.Rmd. Please edit that file -->



# ddweek4pkg

The goal of ddweek4pkg is to Fatality Analysis Reporting System...

## Installation

You can install ddweek4pkg from github with:


```r
# install.packages("devtools")
devtools::install_github("dappaduppa/ddweek4pkg")
```

## Example

This is a basic example which shows you how to solve a common problem:


```r
## basic example code
fars_map_state(1,"2013")
#> Error in fars_read(filename): file 'accident_2013.csv.bz2' does not exist

fars_summarize_years(c("2013", "2014"))
#> Warning in value[[3L]](cond): invalid year: 2013
#> Warning in value[[3L]](cond): invalid year: 2014
#> Error in dplyr::bind_rows(dat_list) %>% dplyr::group_by(year, MONTH) %>% : could not find function "%>%"
```
