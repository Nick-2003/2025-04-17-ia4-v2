# start R code
#| converts F temp to C temp
convert_temp <- function(f) {
  return((f - 32) * (5/9))
}


# code to test if the function is implemented as expected
stopifnot(convert_temp(32) == 0)
stopifnot(convert_temp(212) == 100)


print("Done")
# end R code