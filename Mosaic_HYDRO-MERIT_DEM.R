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

## set working directory

setwd("D:/PROJECTS/36_2021_CANADA_HYDRO_FIRE_RETROSPECT_ACTIVE/01_RAW_DATA/HYDRO_MERIT")

# Options -----------------------------------------------------------------

options(scipen = 6, digits = 4) # I prefer to view outputs in non-scientific notation
memory.limit(30000000)     # this is needed on some PCs to increase memory allowance, but has no impact on macs.

# Load packages -----------------------------------------------------------

library(raster)
library(rgdal)

# Load data ---------------------------------------------------------------

  # Load MERIT-HYDRO tiles (DEM, flow direction, flow accumulation) for the area of interest
  merit_dem_list <- list.files("DEM/Tiles") # List all the files in the directory (these are all GeoTiff)
  dir <- "D:/PROJECTS/36_2021_CANADA_HYDRO_FIRE_RETROSPECT_ACTIVE/01_RAW_DATA/HYDRO_MERIT/DEM/Tiles/"
  merit_dem_rasts <- lapply(paste0(dir,merit_dem_list), raster) # Create a list of raster files
  
  merit_acc_list <- list.files("FLOW_ACCUMULATION/Tiles")
  dir <- "D:/PROJECTS/36_2021_CANADA_HYDRO_FIRE_RETROSPECT_ACTIVE/01_RAW_DATA/HYDRO_MERIT/FLOW_ACCUMULATION/Tiles/"
  merit_acc_rasts <- lapply(paste0(dir,merit_acc_list), raster)
  
  merit_dir_list <- list.files("FLOW_DIRECTION/Tiles")
  dir <- "D:/PROJECTS/36_2021_CANADA_HYDRO_FIRE_RETROSPECT_ACTIVE/01_RAW_DATA/HYDRO_MERIT/FLOW_DIRECTION/Tiles/"
  merit_dir_rasts <- lapply(paste0(dir, merit_dir_list), raster)

# Create HYDRO-MERIT mosaics ---------------------------------------------------------------  

  merit_dem_mosaic <- do.call(raster::merge, merit_dem_rasts)
  crs(merit_dem_mosaic) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  writeRaster(merit_dem_mosaic, "DEM/HYDRO_MERIT_dem_Mosaic_WGS84.tif") # Save raster mosaic
  
  merit_acc_mosaic <- do.call(raster::merge, merit_acc_rasts)
  crs(merit_acc_mosaic) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  writeRaster(merit_acc_mosaic, "FLOW_ACCUMULATION/HYDRO_MERIT_acc_Mosaic_WGS84.tif") # Save raster mosaic
  
  merit_dir_mosaic <- do.call(raster::merge, merit_dir_rasts)
  crs(merit_dir_mosaic) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
  writeRaster(merit_dir_mosaic, "FLOW_DIRECTION/HYDRO_MERIT_dir_Mosaic_WGS84.tif") # Save raster mosaic
  
# Clip mosaics (limit processing time) ------------------------------------

  clip_poly <- 
