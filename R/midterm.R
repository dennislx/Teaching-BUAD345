# Q1
poll1 %>% select('industry') %>% n_distinct()
poll1 %>% distinct(year)
poll2 %>% select('industry') %>% n_distinct()
poll1 %>% select('year') %>% n_distinct()
poll2 %>% select('year') %>% n_distinct()

# Q2
poll1 %>% filter(industry=='Retail') %>% distinct(company) %>% count()
poll2 %>% filter(industry=='Retail') %>% distinct(company) %>% count()

# Q3
poll1 %>% filter(year==2020) %>% slice_min(rank, n =5)
poll2 %>% filter(year==2020) %>% slice_min(rank, n =5)

# Q4
reputation %>% 
  group_by(company) %>% 
  summarise(avg=mean(score)) %>% 
  filter(avg > 80)

reputation %>% filter(company == 'eBay')

# Q5
poll %>% 
  filter(year %in% c(2021, 2022)) %>%
  group_by(company) %>% 
  summarise(jump = sum(change)) %>%
  slice_min(jump, n=5)

poll %>% group_by(year) %>% slice_max(rank, n=5) %>% print(n=31)
