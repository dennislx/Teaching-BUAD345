# Q1

# i=1: 1 
# i=2: --2
# i=3: 3
# i=4: ----4
# i=5: 5

for (i in 1:5){
  cat('i=',i,': ',sep='')
  if (i%%2 == 0){
    cat(rep('-',i),sep='')
  }
  cat(i, '\n')
}

# Q2

rangeSum <- function(x, y) {
  total <- 0
  for(i in seq(x, y, by=2)){
    total = total + i
  }
  return(total)
}
rangeSum(1, 10)
rangeSum(-2, 6)
rangeSum(5, 5)

# Q3

# *   | i= 1 j= 5
# **  | i= 2 j= 5
# *** | i= 3 j= 5

for (i in 1:3) {
  for (j in 1:5) {
    if (j > i){
      next
    }
    cat('*')
  }
  cat(rep(' ',3-i), '|', sep='')
  cat(' i=', i, 'j=', j, '\n')
}

# Q4

isPrime <- function(n) {
  if (n <= 1) { return(FALSE) }
  if (n == 2) { return(TRUE) }
  for (i in seq(2,n-1)){
    if (n %% i == 0){
      return(FALSE)
    }
  }
  return(TRUE)
}

# alt + - ==> assign symbol <-

isPrime <- function(n){
  if (n <= 1) { return(FALSE) }
  if (n == 2) { return(TRUE) }
  # is there any num in between 2 ~ n-1, n is divisble by num
  isDivisble <- (n %% seq(2,n-1)) == 0 
  # if(any(isDivisble)){
  #   return(FALSE)
  # }
  # return(TRUE)
  return(!any(isDivisble))
}

isPrime(7) # 7%%1 == 0 && 7%%7 == 0
isPrime(14)

# Q5

alterSum <- function(nums) {
  n <- length(nums)
  ones <- rep(c(1,-1), n)
  ones <- ones[1:n]
  return(sum(ones*nums))
}
alterSum(1:4)
alterSum(rep(0,3))
alterSum(seq(1,5,by=2))