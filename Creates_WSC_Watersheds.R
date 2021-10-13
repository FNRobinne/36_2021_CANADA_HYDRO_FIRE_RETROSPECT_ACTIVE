## ---------------------------
##
## Script name: Mosaic_HYDRO-MERIT_DEM
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

# set working directory ---------------------------------------------------


# Options -----------------------------------------------------------------

options(scipen = 6, digits = 4) # I prefer to view outputs in non-scientific notation
memory.limit(30000000)     # this is needed on some PCs to increase memory allowance, but has no impact on macs.

# Load packages -----------------------------------------------------------

library(whitebox)

# Load data ---------------------------------------------------------------

  acc_raster <-
  dir_raster <- 
