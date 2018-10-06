library(testthat)
library(ddweek4pkg)

res <- fars_summarize_years(c("2013", "2014"))

#res
# # A tibble: 12 x 3
# MONTH `2013` `2014`
# <int>  <int>  <int>
#   1     1   2230   2168
# 2     2   1952   1893
# 3     3   2356   2245
# 4     4   2300   2308
# 5     5   2532   2596
# 6     6   2692   2583
# 7     7   2660   2696
# 8     8   2899   2800
# 9     9   2741   2618
# 10    10   2768   2831
# 11    11   2615   2714
# 12    12   2457   2604

expect_that(any(res==25961), is_true())
