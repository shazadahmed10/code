
# ***** Introduction to Mapping in R using Leaflet ******* 

#Create a list of packages you need for this session
list_of_packages <- c("tidyverse","leaflet","readr","rgdal","sp", 'rgeos', 'RColorBrewer', 'mapview')

#check if packages are installed, if not install missing packages
lapply(list_of_packages, 
       function(x) if(!require(x,character.only = TRUE)) install.packages(x))

library(tidyverse)
library(leaflet)
library(readr)
library(rgdal)
library(sp)
library(rgeos)
library(RColorBrewer)
library(mapview)


# Let's plot a location on a OpenStreet Map with leaflet 
# Create a map with just lat-long


m <- leaflet() %>%
      addTiles() %>%  # Add default OpenStreetMap map tiles
      addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

m

leaflet() %>% 
  addProviderTiles(providers$OpenStreetMap) %>% 
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")


# Change background map
# If you don't assign to an object, the map is not stored in the global environment but directly shows up in the viewer
leaflet() %>% 
  addProviderTiles(providers$Stamen) %>% 
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

leaflet() %>% 
  addProviderTiles(providers$Esri.OceanBasemap) %>% 
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

# change the type of marker
leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R", radius = 10)

#Exercise 1 Create a map with Marker on Latitude: 38.898 Longitude: -77.0425


#--- ANSWER -----

leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lat=38.898, lng=-77.0425)




# Lets works with MSD data and PEPFAR shapefiles

# We will use a subset South Africa's PSNU-IM MSD data and PSNU-level shapefiles -----


df_msd <- read_tsv('RawData_leaflet/MER_Structured_Dataset_PSNU_IM_FY17-18_20181221_v2_1_South Africa.txt')

# facility level data is simulated and not real data
# read in facilities coordinates
fac_xy <- read_tsv('RawData_leaflet/SA_facility_coordinates_training.txt')

# read shape files as Spatial Polygon data for PSNU & OU
# Specify the path inside the working diretory and name of the layer with the .shp extension

sa.psnu <- readOGR(dsn='RawData_leaflet/SouthAfricaDistrictLsib2016July', layer = 'SouthAfricaDistrictLsib2016July')
 

# lets see what the spatial polygon dataframes look like
summary(sa.psnu)

#check if the shape files are right ones 
# quick way to plot it, to see if the shape file look as expected
plot(sa.psnu)


# Let's work with MSD data 

#Plot SA PSNU shape file with Leaflet
m1 <- leaflet(sa.psnu) %>% 
  addTiles() %>%
  addPolygons(color='black', weight=2, opacity=.8, fillOpacity = 0)# Call the map to display it in the viewer
m1 


# Check CRS projection of GoT shape files
proj4string(sa.psnu)

# Set CRS to standard WGS84 
proj4string(sa.psnu)<- CRS("+proj=longlat +datum=WGS84 +no_defs")



m1 <- leaflet(sa.psnu) %>% 
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
  addPolygons(color='black', weight=2, opacity=.8, fillOpacity = 0)
m1



# Create Heatmap or Choropleths 
# First, create a color palette

col_pal <- colorFactor(palette = 'Set3', domain = sa.psnu@data$name ) # this creates a function that 
# has colors assigned based on PSNU names

#check all the color palettes available in RColorBrewer library
display.brewer.all()

leaflet() %>% 
  addPolygons(data=sa.psnu, color='black', weight=2, opacity=.8, 
              fillColor = ~col_pal(name), fillOpacity = 1, label = ~name)


# Create Choropleth based on MSD data
# But the spatial data doesn't have MSD data in it!
# So, merge MSD data with spatial dat

# Both are PSNU level files, so how do we find which variable to use as key?
# use interset() to see which columns name match between sa.psnu@data & df_msd
intersect(names(sa.psnu@data), names(df_msd))
# sa.psnu@data$PSNU <- as.character(sa.psnu@data$PSNU)

names(sa.psnu@data)
View(sa.psnu@data)

# aggregate data to PSNU level, so we have just one row per PSNU
# this required to merge MSD with PSNU level shape file
df_msd_agg <- df_msd %>% 
  gather(period, val, FY2018Q2, FY2018APR) %>% 
  mutate(ind_period=paste(indicator, period, sep = '_')) %>% 
  filter(indicator %in% c('TX_CURR', 'TX_NEW'), standardizedDisaggregate== 'Total Numerator') %>% 
  group_by(OperatingUnit, PSNU, PSNUuid, SNUPrioritization, standardizedDisaggregate, ind_period) %>% 
  summarise(val=sum(val,na.rm = T)) %>% 
  ungroup() %>% 
  spread(ind_period, val)

# PEPFAR OU shapefiles have the uid for PSNUs as PSNUuid in MSD files
sa.psnu.msd <- merge(sa.psnu, df_msd_agg, by.x='uid', by.y='PSNUuid')

#check if the data was merged
head(sa.psnu.msd@data,5)

# Create a choropleth on TX_CURR FY2018APR values by PSNU

# first create a color scale based on TX_CURR values; use colorBin 
col_txcurr <- colorBin(palette = 'YlOrRd', domain = sa.psnu.msd@data$TX_CURR_FY2018APR)

leaflet() %>%  
  addPolygons(data=sa.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018APR), fillOpacity = 1, label = ~PSNU)


# Now show TX_CURR_FY2018Q@ values in label

leaflet() %>%  
  addPolygons(data=sa.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = ~paste(PSNU, 'TX_CURR:',TX_CURR_FY2018Q2,sep="\n"))


# or Create labels separately, using HTML toots

labels <- sprintf(
  "<strong>%s</strong><br/>TX_CURR: %g </sup>",
  sa.psnu.msd@data$PSNU, sa.psnu.msd@data$TX_CURR_FY2018APR
) %>% lapply(htmltools::HTML)

# Then add the labels to the leaflet map
leaflet() %>%  
  addPolygons(data=sa.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018APR), fillOpacity = 1, 
              label = labels)


# Add a Lengend to the map
map_txcurr <- leaflet() %>%  
  addPolygons(data=sa.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018APR), fillOpacity = 1, 
              label = labels) %>% 
  addLegend('bottomright', pal = col_txcurr, values = sa.psnu.msd@data$TX_CURR_FY2018APR, title = 'TX_CURR FY2018APR')

map_txcurr

#### Exercise 2:
# Use TX_NEW FY2018Q2 to create a choropleth


# Add Facility markers in each PSNU
map_txcurr %>% 
  addMarkers(data = fac_xy, lat = ~lat, lng = ~long, popup = ~sitename) # you can use a non saptial df here, just need to point to lat/long variables in the df

# Change Markers
map_txcurr %>% 
  addCircleMarkers(data = fac_xy, lat = ~lat, lng = ~long, popup = ~sitename, radius = 0.7)

# Display Facilities in the North PSNU
map_txcurr %>% 
  addCircleMarkers(data = fac_xy %>% filter(PSNU=='The North'), lat = ~lat, lng = ~long, popup = ~sitename, radius = 1)


# Change the radius of facility markers based on their HTS_TST_POS values 

map_txcurr %>% 
  addCircleMarkers(data = fac_xy , lat = ~lat, lng = ~long, 
                   popup = ~sitename, radius = ~(hts_tst_pos)/50, fillOpacity = .8)


# Exercise 3:
# Display facilities in the southern part of the country i.e. latitude < -29 

# Answer ------
map_txcurr %>% 
  addCircleMarkers(data = fac_xy %>% filter(lat < -29) , lat = ~lat, lng = ~long, 
                   popup = ~sitename, radius = ~(hts_tst_pos)/50, fillOpacity = .8)




# saving Leaflet Maps ----
# Leaflet maps can be saved as PDF, JPEG or interactive HTML files
# HTML files are stored as web pages that can be opened in any browser

htmlwidgets::saveWidget(map_txcurr, 'map_txcurr.html') # you can do the same by clicking on Export in the Viewer window

mapshot(map_txcurr, 'map_txcurr.png')

