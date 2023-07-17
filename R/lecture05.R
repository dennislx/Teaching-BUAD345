## 0. load package ----
if(!require('pacman')){
  install.packages('pacman')
}
p_load(nycflights13, dplyr)

## flights data ----
flights %>% class()
flights %>% colnames()
flights %>% glimpse()
flights
# A tibble: 336,776 × 19

# ctrl+1, ctrl+2 to move cursor between editor and console
# ctrl + shift + M ==> %>%
# alt + - ==> <-

## practice 01: tibble knowledge ------
farm_animal <- tibble(
  name   = c("cow", "horse"),
  sound  = c("moo", "neigh"),
  weight = c(2000, 1500),
  life   = c(20, 25)
)
pet_animal <- tibble(
  name   = c("dog", "cat"),
  # sound  = c("bark", "meow"),
  weight = c(40, 10),
  life   = c(10, 15)
)
# how many rows for farm-animal
nrow(farm_animal)
# how many columns for pet-animal
ncol(pet_animal)
# create a new tibble mammal by combining data
# rbind (row binding), cbind (column binding) 
mammal <- rbind(farm_animal, pet_animal)
# titlecase name column, 
# uppercase: cow ==> COW
# titlecase: cow ==> Cow
library(dplyr)
library(stringr)
mammal$name <- str_to_title(mammal$name)
# whether mammal$name exists in farm_animal$name
is_farm <- mammal$name %in% str_to_title(farm_animal$name)
mammal$is_farm <- ifelse(is_farm, 'farm', 'pet')
# if i want to delete column `is_farm`
mammal$is_farm <- NULL

# create a vector is_farm
is_farm <- rep(c('farm','pet'), each=2)
cbind(mammal, is_farm)


## practice 02: tibble knowledge ------
## mtcars from datasets pakcage
# when you tibble a dataframe, its rowname information is lost
mtcars$name <- rownames(mtcars)
tcar <- tibble(mtcars)
# new column stores first word of tcar$name
#  Mazda RX4 ==> Mazda
tcar$make <- word(tcar$name, 1)
tcar %>% colnames()  # make sure make column is created
tcar %>% glimpse()
# how to verify you did right
tcar %>% filter(gear >= 4) %>% summarise(gear_gt_4 = all(gear >= 4))
tcar %>% filter(gear >= 4) %>% summarise(min_gear = min(gear))
tcar %>% subset(gear >= 4) %>% summarise(min_gear = min(gear))

## practice 03: dplyr knowledge ------
# create a new tibble object includes cars with automatic transimission
tcar1 <- tcar %>% filter(am==0)
# categorize horse power based on the table
tcar2 <- tcar %>% mutate(
  gp = case_when(
    0 <= hp & hp < 100 ~ 'low',
    100 <= hp & hp < 180 ~ 'medium',
    180 <= hp & hp < 400 ~ 'high'
  )
)
# how many ford & lincoln car fall into high power category (gp == 'high')
# make sure both sides are either lowercase or uppercase, be consistent !
tcar2 %>% filter(gp=='high', tolower(make) %in% c('ford', 'lincoln')) %>% count()


## flights data (learn dplyr) -----

library(pacman)
p_load(dplyr, nycflights13)

# suppose i want to view the first 15th rows
flights %>% head(n=15)
flights %>% print(n=15)
flights %>% glimpse()

flights %>% select(year) %>% unique()
# suppose i want to see all flights on 2013.01.01
# & connects all conditions seperated by ,
flights %>% filter(year==2013 & month==1 & day==1 )
flights %>% filter(year==2013, month==1, day==1 )
# which is the same as we did the following
flights[flights$month==1 & flights$day==1, ] 
# A -> B means assign value of A to B
# A <- B means assign value of B to A
# T & T & F ==> F
# suppose i want to see flights on 2013.01.01 or 2013.01.31
flights %>% filter(year==2013, month==1, day==1, day==31)
flights %>% filter(year==2013, month==1, day %in% c(1,31))
# F | F | T ==> T
flights %>% filter(year==2013, month==1, day==1 | day==31)

# missing value is automatially dropped using filter
flights %>% select(dep_time) %>% summarise(avg_time = mean(dep_time))
# flights$dep_time contains missing value
x <- c(1:5, NA, 6:10)
sum(x, na.rm=T)
# if column is pass as the argument for filter 
# its missing value will be automatically dropped
flights %>% 
  filter(dep_time >= 0 | dep_time < 0) %>%
  select(dep_time) %>% summarise(avg_time = mean(dep_time))

# practice 1: arr_delay > 2 hours flights
# flights %>% glimpse()
flights %>% filter(arr_delay > 2 * 60) %>% select(arr_delay, everything())

# flights from NYC to Houston (IAH & HOU)
flights %>% filter(dest %in% c('HOU', 'IAH')) %>% select(dest, everything())

# select flights for UA, AA or DL
flights %>% filter(carrier %in% c('AA', 'DL', 'UA')) %>% select(carrier, everything())

# flights during summer (month = 6,7,8)
flights %>% filter(month %in% 6:8) %>% select(month, everything())

# flights whose arr_delay > 2*60 & dep_delay <= 0
flights %>% 
  filter(arr_delay > 2*60, dep_delay <= 0) %>% 
  select(dep_delay, arr_delay, everything())
