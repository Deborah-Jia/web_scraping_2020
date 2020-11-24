tl <- list()

tl[['first_elemnt']] <- 2

tl$second_element <- 'ceu'

tl[['first_vector']] <- 1:10
tl[['cars']] <- mtcars

tl$cars

list_2 <- list('a'=2, b=1:10, c=mtcars)
# i <-3

for (i in 1:length(letters)) {
  tl[[ paste0('letters_', i)  ]] <- letters[i]
}

names(tl) #get the title/name of each element in the list

notnamedlist<- list()
for (i in 1:length(letters)) {
  notnamedlist[[i]]<- letters[i]
}
names(notnamedlist) # get the name of each element in the list
notnamedlist[[2]]

str(notnamedlist[1]) # a list of "1"

notnamedlist[[1]]

str(mtcars) # structure function (not string function!!!)
as.character(2)

library(jsonlite)
tl
toJSON(tl) # create a json object from a list
toJSON(tl, auto_unbox = T) #change into a vector
toJSON(tl, auto_unbox = T, pretty = T) # Fformate the text 
write_json(tl, path = 'my_res.json',pretty = T,auto_unbox = T)

from_list <- fromJSON('my_res.json') # read from Json

getwd() # choose from "session" to change wd


# economist ---------------------------------------------------------------
# the difference is that we use list this time!!!

library(rvest)
library(data.table)
library(jsonlite)
my_url <- 'https://www.economist.com/finance-and-economics/'

t <- read_html(my_url)
write_html(t, 't.html')

boxes <- t %>% html_nodes('.teaser--section-collection') #from chrome extension or inspection
# space in "ds-layout-grid teaser teaser--section-collection" is separator!!!
# should it be teaser or teaser section collection? we'll see

x <- boxes[[1]] #use the first element as a trial
boxes_dfs <- lapply(boxes, function(x){ #within {} is the whole body of function
  tl <- list()
  tl[['title']] <- x %>% html_nodes('.headline-link') %>% html_text()
  tl[['link']] <- paste0('https://www.economist.com', x %>% html_nodes('.headline-link') %>% html_attr('href'))
  # I can use pipies within paste0? great!
  tl[['teaser']] <- x %>% html_nodes('.teaser__description') %>% html_text()
  # same way as to get link
  #tl[['myerror']] <- x %>% html_nodes('.teaser__descriptiondd') %>% html_text()
  return(data.frame(tl)) # it has only one row
})

df <- rbindlist(boxes_dfs, fill = T) # true fills na with blanks
# rbindlist can transform list of lists or dataframes


get_economist_data <- function(my_url) {
  print(my_url)
  t <- read_html(my_url)
  # write_html(t, 't.html')
  boxes <- t %>% html_nodes('.teaser')
  
  # x <- boxes[[1]]
  boxes_dfs <- lapply(boxes, function(x){
    tl <- list()
    tl[['title']] <- x %>% html_nodes('.headline-link') %>% html_text()
    tl[['link']] <- paste0('https://www.economist.com', x %>% html_nodes('.headline-link') %>% html_attr('href'))
    tl[['teaser']] <- x %>% html_nodes('.teaser__description') %>% html_text()
    #tl[['myerror']] <- x %>% html_nodes('.teaser__descriptiondd') %>% html_text()
    return(tl)
  })
  
  df <- rbindlist(boxes_dfs, fill = T)
  return(df)
} ## this functioin only gets on page of data; next we have a more advanced function

get_more_page  <- function(page_to_download = 5) {
  my_urls <- c('https://www.economist.com/finance-and-economics/', 
    paste0('https://www.economist.com/finance-and-economics/?page=', 2:page_to_download))
  
  list_of_dfs <- lapply(my_urls, get_economist_data)
  df <- rbindlist(list_of_dfs, fill=T)
  return(df)
}

df <- get_economist_data('https://www.economist.com/finance-and-economics/?page=2')
econ_data <- get_more_page(3)

# View(data.table(tl))


my_url <- 'https://en.wikipedia.org/wiki/Car'
t<- read_html(my_url)
list_of_table <- t %>% html_table(fill = T) # use true so as not to get error
df <- list_of_table[[1]]

df <- fromJSON('https://deathtimeline.com/api/deaths?season=1')
list_of_df <- fromJSON('https://deathtimeline.com/api/deaths?season=1', simplifyDataFrame = F)


companies <- fromJSON('https://www.forbes.com/forbesapi/org/powerful-brands/2020/position/true.json?limit=2000')


write_html(read_html('https://www.forbes.com/the-worlds-most-valuable-brands/'), 't.html')


# in-class exercise with tech world ---------------------------------------

library(rvest)
library(data.table)
my_url <- 'https://www.technewsworld.com/perl/search.pl?x=0&y=0&query=big+data'

get_one_page <- function(my_url) {
  
  t <- read_html(my_url)
  # write_html(t, 't.html')
  boxes <- t %>% html_nodes('.shadow')
  
  # x <- boxes[[1]]
  boxes_dfs <- lapply(boxes, function(x){
    tl <- list()
    tl[['title']] <- x %>% html_nodes('.searchtitle') %>% html_text()
    tl[['link']] <-  x %>% html_nodes('.searchtitle') %>% html_attr('href')
    tl[['teaser']] <- paste0(x %>% html_nodes('p') %>% html_text(), collapse = ' ')
    #tl[['myerror']] <- x %>% html_nodes('.teaser__descriptiondd') %>% html_text()
    return(tl)
  })
  
  df <- rbindlist(boxes_dfs, fill = T)
  
  return(df)
  #
}

df <- get_one_page(my_url)


# get search term and more pages ------------------------------------------

searchterm <- "big data"
get_techworld <- function(searchterm, pages_download){

  searchterm <- gsub(' ','+',searchterm, fixed = T)
  links_to_get <-
    paste0('https://www.technewsworld.com/perl/search.pl?x=0&y=0&query=',searchterm, '&init=', seq(0, (pages_download*20), by = 20 ))
  ret_df <- rbindlist(lapply(links_to_get, get_one_page))
  return(ret_df)
  }

df <- get_techworld(searchterm = 'hate', 2)
