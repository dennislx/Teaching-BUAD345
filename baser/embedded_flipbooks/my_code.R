pacman::p_load(ggplot2)
cars %>% 
  ggplot() +
  aes(x = dist) +
  aes(y = speed) +
  geom_point() -> 
g
