# 绘制activity pattern图 #

####library####
library(overlap)


####input data####
camera <- read.csv("activity/荒漠猫.csv",stringsAsFactors = F)
head(camera)

####camera####
camera$hour <- NA
camera$min <- NA
camera$RTime <- NA
for(i in 1:nrow(camera)){
  camera$hour[i] <- as.numeric(strsplit(camera$Time[i],split = ":",fixed=T)[[1]][1])
  camera$min[i] <- as.numeric(strsplit(camera$Time[i],split = ":",fixed=T)[[1]][2])
  camera$RTime[i] <- (camera$hour[i] + camera$min[i] / 60) * 2 * pi / 24
}
camera_Date <- as.POSIXct(camera$Date, tz = Sys.timezone())
camera_X <- 101.58; camera_Y <- 37.47
camera_Coord <- matrix(c(camera_X, camera_Y), nrow = 1)
camera_Coord <- sp::SpatialPoints(camera_Coord, 
                                   proj4string = sp::CRS("+proj=longlat +datum=WGS84"))
camera$SunTime <- sunTime(camera$RTime, camera_Date, camera_Coord)

####plot####
densityPlot(camera$SunTime, rug = T, ylim=c(0,0.15), main = "荒漠猫")

?densityPlot
