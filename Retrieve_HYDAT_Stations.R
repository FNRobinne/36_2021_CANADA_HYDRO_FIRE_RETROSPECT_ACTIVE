## ---------------------------
##
## Script name: Retrieve_HYDAT_Stations
##
## Purpose of script: Search and fetch HYDAT stations ID and location
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

## set working directory for Mac and PC

setwd("D:/PROJECTS/36_2021_CANADA_HYDRO_FIRE_RETROSPECT_ACTIVE")

# Options -----------------------------------------------------------------

options(scipen = 6, digits = 4) # I prefer to view outputs in non-scientific notation
memory.limit(30000000)     # this is needed on some PCs to increase memory allowance, but has no impact on macs.

# Load packages -----------------------------------------------------------

library(tidyverse)
library(tidyhydat)

# Load data ---------------------------------------------------------------



# Retrieve HYDAT stations -------------------------------------------------

# Get stations for western Canadian provinces and territories
# Namely: British Columbia (BC), Alberta (AB), Yukon (YK), and Northwest Territories (NT)
west_stns <- hy_stations() %>%
  filter(PROV_TERR_STATE_LOC == "BC" | PROV_TERR_STATE_LOC == "BC" | PROV_TERR_STATE_LOC == "YK" | PROV_TERR_STATE_LOC == "NT" ) %>%
  pull_station_number() %>%
  hy_stn_data_range() %>%
  filter(DATA_TYPE == "Q") %>%
  filter(Year_from <= 1981 & Year_to >= 1987) %>% # 5 year window before and 3 year window after fire severity data are available (1985)
  pull_station_number() %>%
  hy_stn_regulation() %>%
  filter(REGULATED == "FALSE") %>%
  pull_station_number() # This gets the list of station ID of interest

west_stns_lonlat <- hy_stations(west_stns) %>%
  select(STATION_NUMBER, STATION_NAME, LATITUDE, LONGITUDE) # This fetches the location in longitude/latitude of stations 


