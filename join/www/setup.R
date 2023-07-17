if(!require('pacman')){
  install.packages('pacman')
}
pacman::p_load(
  tidyverse, formatR, countdown, fontawesome, learnr, 
  DBI, RSQLite, glue, nycflights13
)

knitr::opts_chunk$set(
  echo = TRUE, out.width = "100%", fig.width = 6,  message = FALSE, 
  warning = FALSE, comment = "", cache = FALSE, error = FALSE
)

custom_checker <- function(check_code, evaluate_result, last_value, ...){
   check_result <- eval(parse(text=check_code))
   if(all.equal(last_value, check_result)){
      list(message = learnr::random_praise(), correct = TRUE, location = "append")
   } else {
      list(message = learnr::random_encouragement(), correct = FALSE, location = "append")
   }
}

learnr::tutorial_options(
  exercise.cap = basename(getwd()),
  exercise.checker = custom_checker
)

question <- function(title, ...) {
  learnr::question(
    title, ..., random_answer_order=T, allow_retry=T
  )
}
