#install.packages("camtrapR")
library(camtrapR)

#创建探测历史表格 detection/non-detection matrix

##导入camtraps表格 (自制)
camtraps <- read.csv("data/camtraps_202208-2304.csv",
                     sep=",", header=TRUE, stringsAsFactors = F)

dateFormat <-"%Y/%m/%d"

##生成工作工作历史表格 camop_no_problem
camop_no_problem <- cameraOperation(CTtable = camtraps,
                                    stationCol ="Station",
                                    setupCol = "Setup_date",
                                    retrievalCol = "Retrieval_date",
                                    hasProblems = FALSE,
                                    dateFormat = dateFormat)

##生成实际有效工作历史表格 camop_problem
camop_problem <- cameraOperation(CTtable = camtraps,
                                 stationCol = "Station",
                                 setupCol = "Setup_date",
                                 retrievalCol = "Retrieval_date",
                                 writecsv = FALSE,
                                 hasProblems = TRUE,
                                 dateFormat = dateFormat)
##可视化一下 Plotting camera operation matrices 
camtrapR:::camopPlot(camOp =camop_problem,palette ="Heat",lattice =TRUE)



##导入 recordTable (做的时候默认独立探测是1h)
recordTableSample <- read.csv("data/rectable_202206-08.csv",
                              sep=",", header=TRUE, stringsAsFactors = F)

recordTableSample$DateTimeOriginal1 <- paste(
  recordTableSample$Date, 
  recordTableSample$Time, 
  sep=" ")

##生成探测历史表格 DetHist (不考虑 trapping effort )
##注意是单物种的表格

###荒漠猫
DetHist1 <- detectionHistory (recordTable = recordTableSample,
                              camOp = camop_problem,
                              stationCol = "Station",
                              speciesCol = "Species",
                              recordDateTimeCol = "DateTimeOriginal1",
                              species = "Chinese mountain cat",
                              occasionLength = 7,
                              day1 = "station",
                              includeEffort = FALSE )

write.csv(DetHist1,"data/cmc202206-08.csv")

###赤狐
DetHist1 <- detectionHistory (recordTable = recordTableSample,
                              camOp = camop_problem,
                              stationCol = "Station",
                              speciesCol = "Species",
                              recordDateTimeCol = "DateTimeOriginal1",
                              species = "Red fox",
                              occasionLength = 7,
                              day1 = "station",
                              includeEffort = FALSE )

write.csv(DetHist1,"data/rf202206-08.csv")

###家猫
DetHist1 <- detectionHistory (recordTable = recordTableSample,
                              camOp = camop_problem,
                              stationCol = "Station",
                              speciesCol = "Species",
                              recordDateTimeCol = "DateTimeOriginal1",
                              species = "Domestic cat",
                              occasionLength = 7,
                              day1 = "station",
                              includeEffort = FALSE )

write.csv(DetHist1,"data/dc202206-08.csv")


#下面暂时不用了----

##生成探测历史表格 DetHist
DetHist2 <- detectionHistory(recordTable = recordTableSample,
                             camOp = camop_no_problem,
                             stationCol = "Station",
                             speciesCol = "Species",
                             recordDateTimeCol = "DateTimeOriginal1",
                             species = "Chinese mountain cat",
                             occasionLength = 7,
                             day1 = "station",
                             includeEffort = TRUE,
                             scaleEffort = FALSE)
DetHist2[[1]] #detection history 
DetHist2[[2]] #effort (in days per occasion)

##生成探测历史表格 DetHist (考虑 trapping effort, scale一下 )
DetHist3 <- detectionHistory(recordTable = recordTableSample,
                             camOp = camop_no_problem,
                             stationCol = "Station",
                             speciesCol = "Species",
                             recordDateTimeCol = "DateTimeOriginal1",
                             species = "Chinese mountain cat",
                             occasionLength = 7,
                             day1 = "station",
                             includeEffort = TRUE,
                             scaleEffort = TRUE)
DetHist3[[1]] #detection history
DetHist3[[2]] #effort (scaled)
DetHist3[[3]] #scaling parameters for back-transformation 

# ----
data(camtraps)
data(recordTableSample)

##做个地图显示 Species Richness 
Mapstest1 <- detectionMaps(CTtable = camtraps,
                           recordTable = recordTableSample,
                           Xcol = "utm_x",
                           Ycol = "utm_y",
                           stationCol = "Station",
                           speciesCol = "Species",
                           printLabels = TRUE,
                           richnessPlot = TRUE,
                           speciesPlots = FALSE,
                           addLegend = TRUE)

##单物种独立探测（这里独立探测的界定还是得从头改）
recordTableSample_PBE <- 
  recordTableSample[recordTableSample$Species == "PBE",]

Mapstest2 <- detectionMaps(CTtable = camtraps,
                           recordTable = recordTableSample_PBE,
                           Xcol = "utm_x",
                           Ycol = "utm_y",
                           stationCol = "Station",
                           speciesCol = "Species",
                           speciesToShow = "PBE",
                           printLabels = TRUE,
                           richnessPlot = FALSE,
                           speciesPlots = TRUE,
                           addLegend = TRUE)
