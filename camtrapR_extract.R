install.packages('RSQLite')
install.packages("camtrapR")
library(RSQLite)
library(camtrapR)

#Sys.getenv("PATH")
#Sys.which("exiftool")
#exiftool_dir <- "C:/exiftool.exe"        
#exiftoolPath(exiftoolDir = exiftool_dir)

rec_table5 <- recordTable(inDir = "E:/Menyuan_202304-10",
                          ## input file name
                          
                          removeDuplicateRecords = FALSE,
                          IDfrom = "metadata",
                          timeZone = "Asia/Taipei",
                          metadataSpeciesTag = "Species",
                          video = list(file_formats = c("jpg", "mp4", "avi", "mov"),
                                       dateTimeTag = "FileModifyDate",
                                       db_directory = "C:/Users/Kongy/Pictures",
                                       ## Database storage location
                                       db_filename = "digikam4.db")
)
write.csv(x = rec_table5, file = "Menyuan_202304-10.csv")
## output-file-name