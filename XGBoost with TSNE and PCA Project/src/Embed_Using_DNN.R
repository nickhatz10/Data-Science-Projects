rm(list = ls())
library(httr)
library(data.table)




getEmbeddings <- function(text){
  input <- list(
    instances = list( text)
  )
  res <- POST("https://dsalpha.vmhost.psu.edu/api/use/v1/models/use:predict", body = input,encode = "json", verbose())
  emb<-unlist(content(res)$predictions)
  emb
}



train_data <- fread('./project/volume/data/interim/train_data_final.csv')
test_data <- fread('./project/volume/data/interim/test_data_final.csv')

emb_dt <- NULL
emb_dt_test <- NULL

for (i in 1:nrow(train_data)) {
  
  embedded <- getEmbeddings(train_data[i] $text)
  emb_dt <- rbind(emb_dt, embedded)
  
}

for (i in 1:nrow(test_data)) {
  
  embedded_test <- getEmbeddings(test_data[i] $text)
  emb_dt_test <- rbind(emb_dt_test, embedded_test)
  
}

#embedded_done <- data.table(emb_dt)

#fwrite(embedded_done,"./project/volume/data/interim/train_embedded.csv")


embedded_test_done <- data.table(emb_dt_test)

fwrite(embedded_test_done,"./project/volume/data/interim/test_embedded_final.csv")
