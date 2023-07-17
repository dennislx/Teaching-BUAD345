# Here, I'll show how you can use what you've learned to create a fun animation plot. 

# The "pacman" package in R simplifies the process of installing, loading, and managing multiple packages
# We'll make sure it's installed if it isn't already
# The "p_load" function in R allows you to efficiently load multiple package and install them if they aren't already

if(!require('pacman')){ install.packages('pacman') }
p_load(dplyr, ggplot2, nycflights13, gganimate)

# Let's take a concise overview of the flight data
flights %>% glimpse()

# We have in total 16 different airplane companies
flights %>% select(carrier) %>% n_distinct()

flights %>% # Group the "flights" data by month and carrier
  group_by(month, carrier) %>% # Calculate the average delay for each month and carrier
  summarise(avg_delay=mean(dep_delay, na.rm=T)) %>%  # Group the data by month
  group_by(month) %>% # Obtain the ranking of different airplane companies based on average delay 
  mutate(rank_delay=rank(avg_delay)) %>% # Only consider the top 10 companies each month
  filter(rank_delay<=10) %>%  # Sort the data on month and ranking
  arrange(month, rank_delay) -> # Assign the resulting data frame to `ranked_by_month`
  ranked_by_month

# Let's define a custom plotting theme that features a light gray background and no legends, y-axis, ticks, line
# Don't worry about it, we will talk about these starting from the 5th week
gg_theme <- theme_classic(base_family = "Times") +
  theme(axis.text.y = element_blank()) +
  theme(axis.ticks.y = element_blank()) +
  theme(axis.line.y = element_blank()) +
  theme(legend.position = "none") +
  theme(plot.background = element_rect(fill = "gainsboro")) +
  theme(panel.background = element_rect(fill = "gainsboro"))

ranked_by_month %>% # Remove the grouping variable, otherwise you will see max/min of each month
  ungroup() %>% # Calculate statistics of average delay (remember only top10 companies with least deay are considered)
  summarize(min=min(avg_delay), max=max(avg_delay)) 

ranked_by_month %>%   # Create a ggplot object
  ggplot() +  # Restrict the range of x-axis
  aes(xmin=0, xmax = avg_delay) + # Restrict the y-axis
  aes(ymin=rank_delay-.45, ymax=rank_delay+.45, y=rank_delay) +  # Create a subplot for each month
  facet_wrap(~ month) +  # Add data (vertical bar plot) on ggplot
  geom_rect(alpha=0.7) +  # Color the bars based on the first character of the carrier name
  aes(fill = substr(carrier,1,1)) + # Set x-axis limits and breaks
  scale_x_continuous(limits=c(-8, 30), breaks = c(0, 10, 20, 30)) + # Reverse the y-axis
  scale_y_reverse() + # Add y-tick label for different carriers
  geom_text(col="gray13", hjust="right", aes(label=carrier), x=-6, size=6) + # Remove global y-label and set x-label
  labs(x="Average Delay (minutes)") + labs(y="") + # Apply the gg_theme to this ggplot
  gg_theme -> # Assign the resulting list of data/subplot to `monthly_deplay_plot`
monthly_delay_plot

monthly_delay_plot +  # Put all subplot into one single plot
  facet_null() +      # Further restrict x-axis limit
  scale_x_continuous(limits=c(-5.5, 29), breaks=c(0, 10, 20)) + # Display a month name in the figure
  geom_text(
    x=28, y=-2, family="Times", aes(label=month.abb[month]), size=12, col="grey18"
  ) +  # Separate animation per each airplane company
  aes(group=carrier) + # Create an animated plot and transit with month
  transition_time(month) -> # Assign the resulting animated plot to "monthly_delay_animate".
monthly_delay_animate

# fps control framerate, and duration controls how long you want to display the entire animation
# check ?animate to know more about its usage, it will take longer to render if you set these number to be larger
animate(monthly_delay_animate, fps=10, duration=15, width=1200) -> p
# save the gif plot to your working directory
anim_save('flight_delay_animate.gif', p)