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
plot(us_combined)

us_united = st_union(conus) %>%
  st_cast("MULTILINESTRING")
plot(us_united)
