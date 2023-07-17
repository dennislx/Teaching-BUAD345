set.seed(853)

num_people <- 500

population <- tibble(
  person = 1:num_people,
  favorite_color = sample(c("Blue", "White"), size = num_people, replace = TRUE),
  prefers_dogs = if_else(favorite_color == "Blue", 
                         rbinom(num_people, 1, 0.9), 
                         rbinom(num_people, 1, 0.1))
)

population |> count(favorite_color, prefers_dogs)

frame <- population |>
  mutate(in_frame = rbinom(n = num_people, 1, prob = 0.8)) |> 
  filter(in_frame == 1)

frame |> count(favorite_color, prefers_dogs)
sample <- frame |>
  select(-prefers_dogs) |>
  mutate( 
    group = sample(x = c("Treatment", "Control"), size = nrow(frame), replace = TRUE
  ))

library(kableExtra)
sample |>
  count(group, favorite_color) |>
  mutate(prop = n / sum(n), .by = group) |>
  kable(
    col.names = c("Group", "Prefers", "Number", "Proportion"),
    digits = 2, format='simple',
  )
