library(tidyverse)
library(sf)
library(units)

homecity = readr::read_csv("../geog-176A-labs/data/uscities.csv") %>%
  st_as_sf(coords = c("lng","lat"), crs = 4326) %>%
  filter(city %in% c("Santa Barbara", "Escondido"))

st_distance(homecity)

st_distance(st_transform(homecity, 5070))

st_distance(st_transform(homecity, '+proj=eqdc +lat_0=40 +lon_0=-96 +lat_1=20 +lat_2=60 +x_0=0 +y_0=0 +NAD83 +units=m +nodefs'))

st_distance(homecity)

(st_distance(homecity) %>%
    set_units("km") %>%
    drop_units())
