#Leslie Alonzo, 8/13/2020, Daily Exercise 7#

library(tidyverse)
library(ggplot2)

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'

covid = read_csv(url)

newcovid <- data.frame(state = state.name, region = state.region)
full_join(covid, newcovid, by = "state") -> covid3
results = covid3 %>%
  group_by(region, date) %>%
  summarise(cases = sum(cases, na.rm = TRUE), deaths = sum(deaths, na.rm = TRUE)) %>%
  pivot_longer(cols = c('cases', 'deaths'))

ggplot(results, aes(x = date, y = value)) +
  geom_col(aes(col = region)) +
  facet_grid(name~region, scales = 'free_y') +
  labs(title = "COVID Cases by Region",
       x = "",
       y = "",
       caption = "Not my favorite exercise",
       subtitle = "COVID Data") +
  theme_dark() +
  theme(legend.position = "NA") ->
  plot1
ggsave(plot1, file = "R/img/plot1.png",
       width = 8,
       units = "in")
