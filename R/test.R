for (i in 1:5) {
  cat('i = ', i, ': ', sep='')
  if (!(i %% 2)) {
    cat(rep('-',i))
  }
  cat(i, '\n')
}

rangeSum <- function(x, y) {
  total <- 0
  for (i in x:y) {
    total <- total + i
  }
  return(total)
}

for (i in 1:3) {
  for (j in 1:5) {
    cat('*')
    if (j == i) {
      break
    }
  }
  cat(rep(' ',3-i), '|', sep='')
  cat(' i=', i, 'j=', j, '\n')
}

for (i in 1:3) {
  for (j in 1:5) {
    if (j > i) {
      next
    }
    cat('*')
  }
  cat(rep(' ', 4-i), '|', sep='')
  cat(' i=', i, 'j=', j, '\n')
}


n   <- 100
out <- vector("list", n)                             #out is a list with 100 elements
for(i in 1:n){
  dw <- Loblolly[sample(nrow(Loblolly), repl = T),]  #resample the data
  out[[i]] <- coef(lm(height ~ age, data = dw)) #run the model and store the coefficients
}
beta_lst <- c()
coef_lst <- c()
for (res in out) {
  beta_lst <- c(beta_lst, res[1])
  coef_lst <- c(coef_lst, res[2])
}
mean_coef <- mean(coef_lst)
