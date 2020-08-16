#Leslie Alonzo, 8/15/2020, Daily New Cases in Florida#

library(tidyverse)
library(ggplot2)
library(zoo)

state.of.interest = "Florida"
covid %>%
  filter(state == state.of.interest) %>%
  group_by(date) %>%
  summarise(cases = sum(cases)) %>%
  ungroup() %>%
  mutate(newcases = cases - lag(cases),
         roll7 = rollmean(newcases, 7, fill = NA, align = "right")) %>%
  ggplot(aes(x = date)) +
  geom_col(aes(y = newcases), col = NA, fill = "green") +
  geom_line(aes(y = roll7), col = "blue", size = 1)+
  theme_dark()+
  labs(title = "Daily COVID Cases in Florida",
       subtitle = "7-day Average (Blue)",
       caption = "Daily Exercise 8",
       x = "",
       y = "") ->
  plot2
ggsave(plot2, file = "R/img/plot2.png",
       width = 8,
       unit = "in")


