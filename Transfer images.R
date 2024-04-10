# 对红外相机照片进行分类保存

my_list <- read.csv(file = "Menyuan_202304-10.csv")

pb <- txtProgressBar(style=3)

n <- dim(my_list)[1]
n

# my_list <- subset(my_list, !is.na(Species))

for(i in 1:n){
  setTxtProgressBar(pb, i/n)
  
  if(my_list$Species[i]=="Empty"){
    next
  }else{
    image.from <- paste(my_list$Directory[i],my_list$FileName[i],sep = "/")
    image.to <- paste("E:/Menyuan_202304-10_species",my_list$Station[i],my_list$Species[i], sep = "/")
    
    ##create station file
    my.file.station.name <- paste("E:/Menyuan_202304-10_species",my_list$Station[i], sep = "/")
    if(file.exists(my.file.station.name)){
      print(my.file.station.name)
    }else{
      dir.create(my.file.station.name)
    }
    
    ##create specie file
    my.file.specie.name <- paste("E:/Menyuan_202304-10_species", my_list$Station[i], my_list$Species[i],sep = "/")
    if(file.exists(my.file.specie.name)){
      print(my.file.specie.name)
    }else{
      dir.create(my.file.specie.name)
    }
    
    file.copy(from = image.from, to = image.to)
  }
}
close(pb)
