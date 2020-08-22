library(tidyverse)
library(sf)
library(stars)
library(units)
library(raster)
library(mapview)
library(leaflet)
library(gdalUtilities)


conus = USAboundaries::us_states() %>%
  filter(!state_name %in% c("Puerto Rico",
                            "Alaska",
                            "Hawaii"))

us_combined = st_combine(conus) %>%
  st_cast("MULTILINESTRING")

ala = conus %>%
  st_as_sf(coords = c("lng","lat"), crs = 4326) %>%
  filter(state_name == "Alabama")

alatouch = st_filter(conus, ala, .predicate = st_touches) %>%
  st_cast("MULTILINESTRING")

alaplot = us_combined %>%
  ggplot() +
  geom_sf(data = conus, fill = NA, size = 1) +
  geom_sf(data = alatouch, col = 'red', alpha = .5) +
  theme_dark() +
  labs(title = "States that touch Alabama (Red)",
       subtitle = "Daily Exercise 12",
       caption = "GEOG 176A")

ggsave(alaplot, file = "R/img/alaplot.png",
       width = 8,
       unit = "in" )

