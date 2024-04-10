#overlap of two camera data#


####library####
library(overlap)


####input data####
camera1 <- read.csv("data/indep_Resident.csv",stringsAsFactors = F)
head(camera1)

camera2 <- read.csv("data/indep_Cattle.csv",stringsAsFactors = F)
head(camera2)


####camera1####
camera1$hour <- NA
camera1$min <- NA
camera1$RTime <- NA
for(i in 1:nrow(camera1)){
  camera1$hour[i] <- as.numeric(strsplit(camera1$Time[i],split = ":",fixed=T)[[1]][1])
  camera1$min[i] <- as.numeric(strsplit(camera1$Time[i],split = ":",fixed=T)[[1]][2])
  camera1$RTime[i] <- (camera1$hour[i] + camera1$min[i] / 60) * 2 * pi / 24
}

camera1_Date <- as.POSIXct(camera1$Date, tz = Sys.timezone())
camera1_X <- 101.58; camera1_Y <- 37.47

camera1_Coord <- matrix(c(camera1_X, camera1_Y), nrow = 1)
camera1_Coord <- sp::SpatialPoints(camera1_Coord, 
                                  proj4string = sp::CRS("+proj=longlat +datum=WGS84"))

camera1$SunTime <- sunTime(camera1$RTime, camera1_Date, camera1_Coord)

densityPlot(camera1$SunTime, rug = T, main = "Resident")

####camera2####
camera2$hour <- NA
camera2$min <- NA
camera2$RTime <- NA
for(i in 1:nrow(camera2)){
  camera2$hour[i] <- as.numeric(strsplit(camera2$Time[i],split = ":",fixed=T)[[1]][1])
  camera2$min[i] <- as.numeric(strsplit(camera2$Time[i],split = ":",fixed=T)[[1]][2])
  camera2$RTime[i] <- (camera2$hour[i] + camera2$min[i] / 60) * 2 * pi / 24
}

camera2_Date <- as.POSIXct(camera2$Date, tz = Sys.timezone())
camera2_X <- 101.58; camera2_Y <- 37.47

camera2_Coord <- matrix(c(camera2_X, camera2_Y), nrow = 1)
camera2_Coord <- sp::SpatialPoints(camera2_Coord, 
                                   proj4string = sp::CRS("+proj=longlat +datum=WGS84"))

camera2$SunTime <- sunTime(camera2$RTime, camera2_Date, camera2_Coord)

densityPlot(camera2$SunTime, rug = T, main = "Livestock")

####overlapEst####
min(length(camera1$SunTime), length(camera1$SunTime))
#to choose a better Delta#
camera1VS2 <- overlapEst(camera1$SunTime, camera2$SunTime, type = "Dhat4")
camera1VS2 

overlapPlot(camera1$SunTime,
            camera2$SunTime)
legend('topright', c(" ", " "), lty = c(1, 2), col = c(1, 4), bty = 'n')

par(mfrow = c(1, 1))
densityPlot(camera1$SunTime, main = "cmc")
densityPlot(camera2$SunTime, main = "rf")
