# function to extract record every 30 min
# Luoyuan 202302

library(dplyr);library(readr);library(data.table);library(stringr);

# one csv.
test <- read_csv(choose.files())

# batch csv.
# library(purrr)
# tt2 <- list.files("data",
#                   pattern = "rectable.*[.]csv", full.names = T) %>% 
# map_df(~read.csv(.x,fileEncoding = "GBK"), .id = "file") 
# ttt <- test %>% group_by(file, Station, Species) %>% 
#   arrange(Date) %>% 
#   mutate(time_diff = - as.numeric(difftime(lag(DateTimeOriginal),DateTimeOriginal), units = "mins"))
# ……

ttt <- test %>% group_by(Station, Species) %>% 
  arrange(Date) %>% 
  mutate(time_diff = - as.numeric(difftime(lag(DateTimeOriginal),DateTimeOriginal), units = "mins"))

ttt[is.na(ttt$time_diff) , "time_diff"] <- 0

nt <- ttt %>% 
  mutate(label = kls(time_diff, 30))

write_csv(nt, "data2023/indep_202208-2304.csv")


# Function ----------------------------------------------------------------

kls <- function(value, threshold){
  res <- c()
  res[1] <- T
  old_w <- 1
  w = 2
  while ( w < length(value) ) {
    while(sum(value[old_w:w]) < threshold & w < length(value) ){
      res[w] <- F
      w <- w + 1
    }
    if(w != length(value)){
      old_w <- w
      res[w] <- T
      value[w] <- 0
      w <- w + 1
    }
    if(w == length(value) & sum(value[old_w:w]) > threshold){
      res[w] <- T
    }else{
      res[w] <- F
    }
  }
  return(res)
}
