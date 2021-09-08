## ---------------------------
##
## Script name: Retrieve_HYDAT_Stations
##
## Purpose of script: Search and fetch HYDAT stations ID and location within Water Tower Units
##
## Author: Dr. François-Nicolas Robinne
##
## Date Created: 07-09-2021
##
## Copyright (c) François-Nicolas Robinne, 2021
## Email: francois.robinne@nrcan-rncan.gc.ca
##
## ---------------------------
##
## Notes: This script is part of an NRCan project focusing on western Canadian water supply
##        It can be reused to extend the scope of work to the entire country
##   
##
## ---------------------------

## set working directory

setwd("D:/PROJECTS/36_2021_CANADA_HYDRO_FIRE_RETROSPECT_ACTIVE")

# Options -----------------------------------------------------------------

options(scipen = 6, digits = 4) # I prefer to view outputs in non-scientific notation
memory.limit(30000000)     # this is needed on some PCs to increase memory allowance, but has no impact on macs.

# Load packages -----------------------------------------------------------

library(tidyverse)
library(tidyhydat)
library(sf)

# Load data ---------------------------------------------------------------

  # Load and filter Water Tower Units and downstream dependencies
  WTU <- st_read("01_RAW_DATA/WTU_units/basins_vector.shp")
    WTU_CAN <- WTU %>% # Extracting WTUs relevant for Canada only
      filter(WTU_ID == 5 | WTU_ID == 6 | WTU_ID == 7 | WTU_ID == 8 | WTU_ID == 12)
  D_WTU <- st_read("01_RAW_DATA/WTU_units/downstream_vector.shp")
    D_WTU_CAN <- D_WTU %>% # Extracting WTUs relevant for Canada only
      filter(WTU_ID == 5 | WTU_ID == 6 | WTU_ID == 7 | WTU_ID == 8 | WTU_ID == 12)
    # Quick map for data check
    ggplot() +
      geom_sf(data = WTU_CAN) +
      geom_sf(data = D_WTU_CAN)
  # Dissolve and buffer WTUs and D_WTUs
  WTU_Dissolve <- st_union(WTU_CAN, D_WTU_CAN, by_feature = F) %>%
    st_transform(crs=3979) %>%
    st_buffer(dist = 50000) %>% # creation of 50km buffer
    st_union()
    # Quick map for data check
    ggplot() +
      geom_sf(data = WTU_Dissolve)
    
  st_write(WTU_Dissolve, "02_PROCESSED_DATA/WTU/WTU_Downstream_Dissolve_Buffer_EPSG3979.shp", append = F)

# Retrieve HYDAT stations -------------------------------------------------

  # Get stations for western Canadian provinces and territories
  # Namely: British Columbia (BC), Alberta (AB), Yukon (YK), and Northwest Territories (NT)
  west_stns <- hy_stations() %>%
    filter(PROV_TERR_STATE_LOC == "BC" | PROV_TERR_STATE_LOC == "AB" | PROV_TERR_STATE_LOC == "YK" | PROV_TERR_STATE_LOC == "NT" ) %>%
    pull_station_number() %>%
    hy_stn_data_range() %>%
    filter(DATA_TYPE == "Q") %>%
    filter(Year_from <= 1981 & Year_to >= 1987) %>% # 5 year window before and 3 year window after fire severity data are available (1985)
    pull_station_number() %>%
    hy_stn_regulation() %>%
    filter(REGULATED == "FALSE") %>%
    pull_station_number() # This gets the list of station ID of interest
  
  west_stns_sf <- hy_stations(west_stns) %>%
    select(STATION_NUMBER, STATION_NAME, LATITUDE, LONGITUDE) %>% # This fetches the location in longitude/latitude of stations 
    st_as_sf(coords = c("LONGITUDE", "LATITUDE"), crs = "EPSG:4326", dim = "XY") %>%
    st_transform(crs=3979)
    # Quick map of station location
    ggplot() +
      geom_sf(data = west_stns_sf)
  
  st_write(west_stns_sf, "02_PROCESSED_DATA/NRCAN/HYDAT_Western_Stations_EPSG3979.shp")

  # Clip HYDAT to WTUs and supply area
  west_stns_WTUs <- st_intersection(west_stns_sf, WTU_Dissolve)
    # Quick map of station location
    ggplot() +
      geom_sf(data = west_stns_WTUs)
  
  st_write(west_stns_WTUs, "02_PROCESSED_DATA/NRCAN/HYDAT_Western_Stations_EPSG3979_WTUs.shp")
  
## End of this script
## At this stage, manual updates of the HYDAT gauges layer needs to be done in a GIS software
## The reason is that the points must be on a stream and correspond to stream gauges only
