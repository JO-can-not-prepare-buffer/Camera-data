library(sf)
library(rgdal)

#导入1000个随机点的位点shp ----
##注意在门源的投影坐标系用的是UTM47
fecal <- st_read(choose.files())
str(fecal)
colnames(fecal) <- c("label","lon", "lat","x","y", "geometry")

plot(subset(fecal, select = "geometry"))


#围绕相机位点生成直径为50米的圆形缓冲区 ----
buffer400 <- st_buffer(fecal$geometry, dist = 1000)
st_write(buffer400, "buffer1000.shp")


#导入plantation造林地的shp ----
##注意在门源的投影坐标系用的是UTM47，下同
pl <- read_sf(choose.files())
plot(subset(pl, select = "geometry"))

fecal$area_pl <- NA
union_pl <- st_union(pl)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_pl)
  if(length(st_area(tmp)) == 0){
    fecal$area_pl[i] <- 0
  }else{
    fecal$area_pl[i] <- st_area(tmp)
  }
}


#导入cropland农田的shp ----
cp <- read_sf(choose.files())
plot(subset(cp, select = "geometry"))

fecal$area_cp <- NA
union_cp <- st_union(cp)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_cp)
  if(length(st_area(tmp)) == 0){
    fecal$area_cp[i] <- 0
  }else{
    fecal$area_cp[i] <- st_area(tmp)
  }
}


#导入Bushwoods灌丛的shp ----
bw <- read_sf(choose.files())
plot(subset(bw, select = "geometry"))

fecal$area_bw <- NA
union_bw <- st_union(bw)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_bw)
  if(length(st_area(tmp)) == 0){
    fecal$area_bw[i] <- 0
  }else{
    fecal$area_bw[i] <- st_area(tmp)
  }
}


#导入Pasture Low低草牧场的shp ----
psL <- read_sf(choose.files())
plot(subset(psL, select = "geometry"))

fecal$area_psL <- NA
union_psL <- st_union(psL)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_psL)
  if(length(st_area(tmp)) == 0){
    fecal$area_psL[i] <- 0
  }else{
    fecal$area_psL[i] <- st_area(tmp)
  }
}


#导入Pasture High高草牧场的shp ----
psH <- read_sf(choose.files())
plot(subset(psH, select = "geometry"))

fecal$area_psH <- NA
union_psH <- st_union(psH)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_psH)
  if(length(st_area(tmp)) == 0){
    fecal$area_psH[i] <- 0
  }else{
    fecal$area_psH[i] <- st_area(tmp)
  }
}

#导入Settlements人居的shp ----
sm <- read_sf(choose.files())
plot(subset(sm, select = "geometry"))

fecal$area_sm <- NA
union_sm <- st_union(sm)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_sm)
  if(length(st_area(tmp)) == 0){
    fecal$area_sm[i] <- 0
  }else{
    fecal$area_sm[i] <- st_area(tmp)
  }
}

#导入Water水源的shp ----
wt <- read_sf(choose.files())
plot(subset(wt, select = "geometry"))

fecal$area_wt <- NA
union_wt <- st_union(wt)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_wt)
  if(length(st_area(tmp)) == 0){
    fecal$area_wt[i] <- 0
  }else{
    fecal$area_wt[i] <- st_area(tmp)
  }
}


#导入Bareland荒滩的shp ----
bl <- read_sf(choose.files())
plot(subset(bl, select = "geometry"))

fecal$area_bl <- NA
union_bl <- st_union(bl)

for(i in 1:length(buffer400)){
  tmp <- st_intersection(buffer400[i],union_bl)
  if(length(st_area(tmp)) == 0){
    fecal$area_bl[i] <- 0
  }else{
    fecal$area_bl[i] <- st_area(tmp)
  }
}



fecal_df <- fecal %>% data.frame()

fecal_df$sum <- NA
fecal_df$sum <- apply(fecal_df[,7:14], MARGIN = 1,sum)

plot(subset(subset(fecal_df,fecal_df$sum>7860), select = "geometry"))

write.csv(fecal_df,"camBuffer1000_landcover_area.csv")


# HFI & NDVI ----
library(raster)

hfi <- raster(choose.files())
plot(hfi)
ndvi <- raster(choose.files())
plot(ndvi)

for(i in 1:length(buffer400)){
  fecal$HFI[i] <- 
    mean(na.omit(values(raster::mask(hfi, buffer400[i]))))
  fecal$NDVI[i] <- 
    mean(na.omit(values(raster::mask(ndvi, buffer400[i]))))
}




