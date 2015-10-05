### Sandras ersters App

setwd("107-leaflet-map/")

## Pakete installieren & einbinden
require(xlsx)
require(data.table)
require(devtools)
require(leaflet)
require(htmltools)

## Daten vorbereiten
dbGarra = read.xlsx2(file="data/Garra_DBAll_Koordinaten_20151005.xlsx", sheetName="Garra_DB")
# dbGarra = data.table(dbGarra, keep.rownames=TRUE)

str(dbGarra)
dbGarra$longitude = as.numeric(as.character(dbGarra$longitude))
dbGarra$latitude = as.numeric(as.character(dbGarra$latitude))
dbGarra$altitude = as.numeric(as.character(dbGarra$altitude))
dbGarra$genCode = as.character(dbGarra$genCode)

# dG = subset(dbGarra, select = c(genCode, longitude, latitude, altitude))
dG = dbGarra[!with(dbGarra, is.na(longitude) & is.na(latitude)),]

## Karte erstellen
# Basisinformationen
m = leaflet(data=dG) %>%
  # addTiles() %>% # Das sind die Standardtiles von OpenStreetmap
  addProviderTiles("HERE.satelliteDay") %>%
  addMarkers()
m

# Individuelles Icon
fishIcon <- makeIcon(
  iconUrl = "http://icons.iconarchive.com/icons/martin-berube/flat-animal/256/gold-fish-icon.png",
  iconWidth = 64, iconHeight = 64,
  iconAnchorX = 0, iconAnchorY = 0
)

leaflet(data = dG) %>% addTiles() %>%
  addMarkers(~longitude, ~latitude, icon = fishIcon)

# Verschiedene Icons
fishIcons <- icons(
  iconUrl = ifelse(dG$phenotype == "surface",
                   "http://icons.iconarchive.com/icons/martin-berube/flat-animal/256/gold-fish-icon.png",
                   "http://icons.iconarchive.com/icons/martin-berube/flat-animal/128/fish-icon.png"
  ),
  iconWidth = 64, iconHeight = 64
  # iconAnchorX = 0, iconAnchorY = 0
)

leaflet(data = dG) %>% addTiles() %>%
  addProviderTiles("HERE.satelliteDay") %>%
  addMarkers(~longitude, ~latitude, icon = fishIcons)

# Popups
leaflet(data = dG) %>% addTiles() %>%
  addProviderTiles("HERE.satelliteDay") %>%
  addMarkers(~longitude, ~latitude, icon = fishIcons, popup = ~htmlEscape(genCode))


