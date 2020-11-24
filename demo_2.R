tl <- list()

tl[['first element']] <- 2

tl$second_element <- "ceu"

tl[["first_vector"]] <- 1:10

tl[["cars"]] <- mtcars

tl$cars  
list_2 <- list("a"=2, b=1:10,c=mtcars)

i <- 2
for (i in 1:length(letters)) {
  tl[[paste0('letters_', i)]] <- letters[i] 
}

names(tl) # not the "tl" name, but the content's names in the list!!!

notenamedlist <- list()
for (i in 1:length(LETTERS)) {
  notenamedlist[[i]] <- letters[i]
}
names(notenamedlist) #with no names!
notenamedlist[[2]] # use index to get the content
# single [ ] gets a list, double [[]] get the content

str(mtcars) # to see the structure 

#install.packages('jsonlite')
library("jsonlite")

tl
toJSON(tl)
toJSON(tl, auto_unbox = TRUE) #eliminate the box[]

toJSON(tl, auto_unbox = TRUE, pretty = TRUE)
write_json(tl, path = "my_res.json", pretty = TRUE, auto_unbox = TRUE)

my_list <- fromJSON('my_res.json')


# the economist -----------------------------------------------------------
library(rvest)
library(data.table)
library(jsonlite)

