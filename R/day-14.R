library(tidyverse)
library(sf)
library(stars)
library(units)
library(raster)
library(mapview)
library(leaflet)
library(gdalUtilities)
library(rmapshaper)
library(dplyr)

conus = USAboundaries::us_states() %>%
  st_as_sf(coords = c("lng", "lat"), crs = 4326)

get_conus = function(data, var){
  conus = filter(data, !get(var) %in% c("Hawaii", "Puerto Rico", "Alaska"))
  return(conus)
}

cities = readr::read_csv("../geog-176A-labs/data/uscities.csv") %>%
  st_as_sf(coords = c("lng", "lat"), crs = 4326) %>%
  get_conus("state_name") %>%
  dplyr::select(city, county_fips)

polygon = get_conus(conus, "name") %>%
  dplyr::select(name)

join1 = st_join(polygon, cities) %>%
  st_drop_geometry() %>%
  count(name) %>%
  left_join(polygon, by = 'name') %>%
  st_as_sf()

point_in_polygon3 = function(points, polygon, group){
  st_join(polygon, points) %>%
    st_drop_geometry() %>%
    count(get(group)) %>%
    setNames(c(group, "n")) %>%
    left_join(polygon, by = group) %>%
    st_as_sf()
}

counties = get_conus(USAboundaries::us_counties(), "state_name") %>%
  st_transform(st_crs(cities)) %>%
  dplyr::select(geoid)

pip_city = point_in_polygon3(cities, counties, "geoid") %>%
  dplyr::select(n)

plot_pip = function(data){
  ggplot() +
    geom_sf(data = data, aes(fill = log(n)), alpha = .9, size = .2) +
    scale_fill_gradient(low = "white", high = "darkgreen") +
    theme_void() +
    theme(legend.position = 'none',
          plot.title = element_text(face = "bold", color = "darkgreen", hjust = .5, size = 24)) +
    labs(title = "Cities in Each County",
         caption = paste0(sum(data$n), " Counties represented"))
}

plot_pip(pip_city) ->
  pip_cityplot

ggsave(pip_cityplot, file = "R/img/pip_cityplot.png",
       width = 8,
       units = "in")



