# step 1:read data -----
prius_price <- 28879
camry_price <- 26320
prius_mpg <- 57
camry_mpg <- 28
gas_price <- 3.5
annual_distance <- 10000

# step 2: annual gas price = annual consumption of gas x unit gas price -----
camry_annual_gas <- annual_distance / camry_mpg
prius_annual_gas <- annual_distance / prius_mpg
camry_annual_cost <- camry_annual_gas * gas_price
prius_annual_cost <- prius_annual_gas * gas_price

camry_annual_cost
prius_annual_cost

# step 3: [x many more year] x annual saving of each year = price premium -----
price_premium <- prius_price - camry_price
annual_saving <- camry_annual_cost - prius_annual_cost
years_saving <- price_premium / annual_saving
years_saving

# step 4:  2 <- price_premium / (diff_annual_gas x [gas_price]) ----
diff_annual_gas <- camry_annual_gas - prius_annual_gas
new_gas_price <- price_premium / 2 / diff_annual_gas
new_gas_price



# isValidTriangle question -----
# (a+b>d) & (a+d>b) & (b+d>a)

isValidSide <- function(a,b,d){
  # a is current side, b/d is the other two sides
  return(b+d>a)
}

isValidTriangle <- function(a,b,d){
  flag <- isValidSide(a,b,d) & isValidSide(b,a,d) & isValidSide(d,a,b)
  return(flag)
}


# oneDigit question ----
# alt -  <=== assign symbol
oneDigit <- function(x) {
  return(abs(x) %% 10)
}
# tenDigit question ----
tenDigit <- function(x) {
  x <- abs(x)
  x <- x %/% 10
  x <- oneDigit(x)
  return(x)
}

# isMultiple question ----
# isMultiple(6, 2) --> TRUE
# isMultiple(6, 3) --> TRUE
# isMultiple(6, 4) --> FALSE
# isMultiple(6, 0) --> FALSE
# isMultiple(0, 6) --> TRUE

isMultiple <- function(x, y) {
  # is x a multiple of y 
  if(y == 0){
    return(FALSE)
  }
  return((x %% y) == 0)
}
isMultiple <- function(x,y){
  as.logical(x %% y)
}
isMultiple(6,3)
























