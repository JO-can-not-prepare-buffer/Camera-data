# batch csv.
library(purrr)

a <- list.files("data",
                 pattern = "indep.*[.]csv", full.names = T) %>% 
  map_df(~read.csv(.x,fileEncoding = "GBK"), .id = "file") %>% 
  subset(label == "TRUE") %>% .[,-c(2,8,9,10,11,12,13,14,15,16,17,18)]

specielist <- unique(a$Species)
specielist

for(i in 1:length(specielist)){
  tmp0 <- a %>% subset(Species == specielist[i])
  tmp1 <- diff_season(tmp0)
  dir_print <- paste("data/indep_", specielist[i], ".csv", sep = "")
  write.csv(tmp1, dir_print)
}

a1 <- diff_season(a)
write.csv(a1, "data/allrecord.csv")

# Function ----------------------------------------------------------------
diff_season <- function(x){
  
  dateA <- as.POSIXlt(as.character("2021/1/15"))$yday
  dateB <- as.POSIXlt(as.character("2021/4/15"))$yday
  dateC <- as.POSIXlt(as.character("2021/7/15"))$yday
  dateD <- as.POSIXlt(as.character("2021/10/15"))$yday
  
  for(i in 1:nrow(x)){
    
    x$date[i] <- as.POSIXlt(x$Date[i])$yday
    
    if((x$date[i] > dateA) & (x$date[i] <= dateB)){
      x$season[i] <- "1"
    }
    if((x$date[i] > dateB) & (x$date[i] <= dateC)){
      x$season[i] <- "2"
    }
    if((x$date[i] > dateC) & (x$date[i] <= dateD)){
      x$season[i] <- "3"
    }
    if((x$date[i] > dateD) | (x$date[i] <= dateA)){
      x$season[i] <- "4"
    }
  }
  return(x)
}