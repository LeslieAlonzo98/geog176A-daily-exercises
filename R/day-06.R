#Leslie Alonzo, 8/12/2020, Daily Exercise 6#

library(tidyverse)
library(ggplot2)

url = 'https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties.csv'

covid = read_csv(url)

covid %>%
  filter(date == max(date)) %>%
  group_by(state) %>%
  summarize(cases = sum(cases,na.rm = TRUE)) %>%
  ungroup() %>%
  slice_max(cases, n = 6) %>%
  pull(state) ->
  states
covid %>%
  filter(state %in% states, cases > 0) %>%
  group_by(state, date) %>%
  summarise(cases = sum(cases)/1000) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = cases)) +
  geom_line(aes(col = state)) +
  labs(title = "States with Most COVID Cases",
       x = "Date",
       y = "# of cases (thousands)",
       subtitle = "Daily Exercise 6",
       color = "") +
  facet_wrap(~state) +
  theme_dark() ->
  gg
ggsave(gg, file = "R/img/chart.png",
         width = 8,
         units = c("in"))
covid %>%
  group_by(date) %>%
  summarise(cases = sum(cases)/1000) %>%
  ungroup() %>%
  ggplot(aes(x = date, y = cases)) +
  geom_line(col = "blue") +
  labs(title = "Total COVID Cases in U.S.",
       x = "Date" ,
       y = "# of cases (Thousands)" ,
       subtitle = "Daily Exercise 6") +
  theme_dark() ->
  test
ggsave(test, file = "R/img/chart3.png",
       width = 8,
       units = c("in"))
