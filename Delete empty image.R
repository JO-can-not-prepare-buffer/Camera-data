# 好多空拍啊可恶！！！
# 存这么多空拍硬盘也得花不少钱呢，不如删了没用的部分

my_list <- read.csv(file = "data/Menyuan_202206-08.csv")


pb <- txtProgressBar(style=3)

n <- dim(my_list)[1]-3

for(i in 4:n){
  
  setTxtProgressBar(pb, i/n)
  
  if(my_list$Species[i] != "Empty"){
    next
  }
  else{
    if((my_list$Species[i-1] == "Empty")&
       (my_list$Species[i-2] == "Empty")&
       (my_list$Species[i-3] == "Empty")){

      file.remove(paste(my_list$Directory[i],my_list$FileName[i],sep = "/"))
    }
  }
}

close(pb)
