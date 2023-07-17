df <- data.frame(a=1:4, b=letters[1:4])
# print the name attributes of df, want to know all
# its attributes? type attributes(df)
names(df)
class(df)
rownames(df)

# remember the difference between [[]] and []? 
# what does df[[c(1,2)]] output?
df[[1]][2] == df[[c(1,2)]]

x <- 1:5 #vector
names(x) #it doesn't have label

# r stretch out, automatically match length
y <- letters[1:5]
y[c(T,F)] # why not just "a" ?
# try typing rep(c(T,F), length.out=3) and see what happens
# (T F) ==> (T,F,T,F,T) to match length(y) = 5
identical(y[c(T,F)], y[rep(c(T,F),length.out=length(y))])

# dataframe -----
# what the following does is to sample 5 data with replacement
# from letters[1:3] = (a b c)
# try type sample(1:3, size=5) and see what will happen
y <- sample(letters[1:3],size=5,replace=T)
df <- data.frame( x = 1:5, y = y, z = c(T,NA,NA,F,F))
# the str (short for structure) and glimpse are really similar
glimpse(df)
str(df)
# c lang print function, not required to know
sprintf('the %s has %d rows and %d columns', class(df), nrow(df), ncol(df))


# tibble ----------
library(tibble)
y <- sample(letters[1:3],5,replace=T); y
df <- tibble(x=1:5, y=y, z=c(T,NA,NA,F,F))

# select row, subsetting via numeric, logical
# why not character, because rownames doesn't make much sense
head(df, 2)
df[1:2, ]
df[df$x < 3, ] # df[c(T,T,F,F,F),]
subset(df, !is.na(z)) #reserve rows where z != NA

# select column, subsetting via character and numeric
# in tibble, automatic stretching is not supported,
# try typing df[,c(T,F)] and expect errors
df[,c('x','z')]
df[,c(1,3)]
df[,c(T,F,T)]

# subset(df, x<3, y=='c') ? why return NA
# sorry i have made a mistake here, apparently according 
# to help('subset'), its 2nd argument is ONE logical expression
# to select rows, its 3rd argument, select is used to select columns
subset(df, x<3, select=1:2) 
subset(df, x<3, select=x:y)
# remember what i taught in the beginning of this class
# it is all about subsetting, which is why knowledge about logical,
# vector, subsetting, indexing are all very important here
df[1:2, c(1,3)]            # subset row by number, subset col by number
df[df$x < 3, c('x','z')]   # subset row by logical, subset col by character

# how to change column name, here i uppercase all characters
# be careful here because it overwrite column name of df
colnames(df)
colnames(df) <- toupper(colnames(df))
df$one = c(1,1)  # expect error here, why? because we are using tibble, thank god
df$new_one <- 1  # only length=1 or length=nrow(df) vectors are allowed
bind_cols(df, list(new_name=1))
# this is how you delete a column you dont want 
df$new_one <- NULL

glimpse(df)
# expect error, why? remember what vector will automatically do?
bind_rows(df, c(6,'c',T))
# expect error, why? type c(x=6,y='c',z=T) and see what it outputs
# x is automatically converted to string, not desired, right?
bind_rows(df, c(x=6,y='c',z=T))
# this looks correct, but type df in the console and why df doesn't change? 
bind_rows(df, list(x=6,y='d',z=T))

# why is this accepted? and notice the missing value
bind_rows(df, c(X=5, y='c'))
bind_rows(df, list(x=6, z=T)) #what about y this row?

# another way to append rows, the new row index has to start at 6, why?
df[6:7,] <- list(X=8:9, Y=c('a','b'), Z=c(T,F))
df <- df[-6:-7, ] # this is how you delete rows, remember adding "," here

# append unconsecutively, this will raise an error
df[10,] = list(X=10,Y='a',Z=F)
# i really like tibble, because it doesn't allow weird R auto-stretching behavior
df[6:10,] = list(X=c(1,2),Y=c('a','b'),Z=c(T,F))
# this is fine, what it does is to assign the same list to each row
# this is okay for me, as long as we don't have that weird auto-stretching thing
df[6:10,] = list(X=10,Y='a',Z=F)

# automatically add missing value for column y
bind_rows(df, list(X=6,Z=T))
# notice a new column with almost all missing value
bind_rows(df, list(X=6,Z=T,Y='c',Y2='d'))

# name mismatch, you can expect what happens, right?
bind_rows(df, list(x=6,y='c',z=T))
# type mismatch, expect an error
bind_rows(df, list(X='6',Y='c',Z=T))

# dplyr -----
# okay, finally we are here to start the data wrangling business# okay, finally we are h# okay, finally we are h
tris <- tibble(iris)
# type ?select to know more about its usage
# : for selecting a range of consecutive variables.
# ! for taking the complement of a set of variables, same as negative "-"
# & and | for selecting the intersection or the union of two sets of variables.
select(tris, -c(Sepal.Length, Species))
select(tris, Sepal.Length:Petal.Length)
select(tris, one_of(c('Species', 'Hello')))
# want to know more about tidy-select?

# select column by column type
select(tris, where(is.numeric))
select(tris, !where(is.factor))

# select rows using filter
# If multiple expressions are included, they are combined with the & operator. 
filter(tris, Sepal.Length > 6)  # same as tris[tris$Sepal.Length > 6, ]
# the below is the same as tris[tris$Sepal.Length > 6 & tris$Sepal.Length < 7, ]:
filter(tris, Sepal.Length >=6, Sepal.Length < 7)
# the below is the same as tris[tris$Sepal.Length > 6 | tris$Sepal.Length < 2, ]
filter(tris, Sepal.Length >=6 | Sepal.Length < 2)
# remember why we require toupper here? 
# virginica ==> VIRGINICA
# Virginica ==> VIRGINICA
# VirGinica ==> VIRGINICA
filter(tris, toupper(Species)=='VIRGINICA')  

# this will help remove rows where its Sepal.Length is missing
filter(tris, !is.na(Sepal.Length))

# missing value to filter column is not accepted, expect an error
select(tris, !is.na(Sepal.Length))
# where(): Applies a function to each column and select thoese column the return is TRUE
# there the following will raise an error? why, check is.na(tris$Species)
# it returns a vector instead of A LOGICAL VALUE
select(tris, where(is.na))
# instead, why where(is.numeric) works? check the following
is.numeric(tris$Sepal.Length)
select(tris, where(is.numeric))
  

## mutate: revise current column or add a new column ------
mutate(tris, Sepal.Length = Sepal.Length * 2)
# what actually did was
# new_column <- tris$Sepal.Length * 2
# new_tris <- tris
# new_tris$Sepal.Length <- new_column
# return(new_tris)

# in addition to revision, we can create a new column
mutate(tris, New.Sepal.Length = Sepal.Length * 2)
# remember tibble is really good because it cannot tolerate weird stretching behavior
# however, 1 or nrow(tris) is accepted
mutate(tris, new_c = 1) # one column named new_c full of ONE
mutate(tris, new_c = rep(1,times=150)) # one value
# what actually did was
# new_c <- rep(1, times=nrow(tris))
# new_tris <- tris
# new_tris$new_c <- new_c



# how to sort age increasingly and when age is the same, sort score decreasingly
test_data <- tibble(
  name  = c("Alice", "Bob", "Charlie", "David", "Emma"),
  age   = c(28, 35, 28, 31, 31),
  score = c(85, 92, NA, 81, 84)
)
test_data
# desc stands for descending
arrange(test_data, age, desc(score))


## dplyr pipe ------
# old dplyr: %>%
# new dplyr: |>
# how to change? go to options -> code -> opt in native pipe operator

# dplyr::groupby -----
# the story here is we want to categorize virginica flower based on its Sepal.Length
# we are going to further divide it into three groups: 
#           too short (<q1), medium (q1->q3) and too long (>q3)

# this is what i did on PPT, using the old fashion way
summary(tris[tris$Species=='virginica', ]$Sepal.Length)[c(2,5)]

# let's do the same using what we learnt 
quant <- tris |> 
  filter(Species=='virginica') |>
  select(Sepal.Length) |>
  summarise(
    q1 = quantile(Sepal.Length, 0.25),
    q3 = quantile(Sepal.Length, 0.75),
  )
# segment data into (~,q1), [q1,q3], (q3, ~)
tris |> 
  filter(Species=='virginica') |> 
  mutate(category = case_when(
    Sepal.Length < quant$q1 ~ 1,
    Sepal.Length >= quant$q1 & Sepal.Length < quant$q3 ~ 2,
    .default = 3
  )) |> 
  glimpse()

# everything looks right, now let's 
new_tris <- tris |> 
  filter(Species=='virginica') |> 
  mutate(category = case_when(
    Sepal.Length < quant$q1 ~ 1,
    Sepal.Length >= quant$q1 & Sepal.Length < quant$q3 ~ 2,
    .default = 3
  ))

new_tris |> 
  group_by(category) |> 
  count()


## Practice Problem ------

# problem 1: farm and pet data

farm_animal <- tibble(
  name   = c("cow", "horse"),
  sound  = c("moo", "neigh"),
  weight = c(2000, 1500),
  life   = c(20, 25)
)
pet_animal <- tibble(
  name   = c("dog", "cat"),
  sound  = c("bark", "meow"),
  weight = c(40, 10),
  life   = c(10, 15)
)
mammal <- bind_rows(farm_animal, pet_animal)
names(mammal) <- str_to_title(names(mammal))
mammal$type <- rep(c("farm", "pet"), each=2)
bind_cols(mamal, rep(c("farm", "pet"), each=2))

# problem 2: mtcars 

mtcars$name <- rownames(mtcars)
tcar <- tibble(mtcars)
dim(tcar)
tcar$make <- word(tcar$name, 1)
tcar |> filter(gear >= 4)
tcar[tcar$gear >= 4, ]
new_tcar <- subset(tcar, gear>=4)

new_tcar |> group_by(make) |> select(mpg) |> summarise(mean=mean(mpg))

# problem 3: mtcars continue

tcar2 <- tcar %>%
  mutate(
    power = case_when(
      between(hp, 0, 100) ~ "low",
      between(hp, 100, 180) ~ "medium",
      between(hp, 180, 400) ~ "high"
    )
  )
tcar2 |> 
  filter(power=='high', str_to_lower(make) %in% c('ford', 'lincoln')) |>
  count()


