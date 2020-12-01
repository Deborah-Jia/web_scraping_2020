library(data.table)
library(rvest)
my_url <- c('https://www.ultimatespecs.com/car-specs/Lexus/M7008/IS-(XE30)',
            'https://www.ultimatespecs.com/car-specs/Jeep/M3522/Grand-Cherokee-(WK2)',
            'https://www.ultimatespecs.com/car-specs/Volvo/M9815/XC40')

my_link <- 'https://www.ultimatespecs.com/car-specs/Volvo/M9815/XC40'

t <- read_html(my_link)
data_list <- list()

tkey <- gsub(':', '',trimws(t %>%  html_nodes('.tabletd') %>% html_text()), fixed = TRUE)

tvalues <- trimws(t %>%  html_nodes('.tabletd_right') %>% html_text())

if(length(tkey) == length(tvalues)) {
  for (key_id in 1: length(tvalues)) {
    data_list[[tkey[key_id]]] <- tvalues[key_id]
  }
}

process_one_car <- function(my_link){
  
}


# nasdaq ------------------------------------------------------------------
library(jsonlite)
df <- fromJSON('https://www.nasdaq.com/api/v1/screener?page=3&pageSize=20', flatten=T)
# automatically flatten nested data frames into a single non-nested data frame
# only deal with data frames, not lists

tdf <- df$data    

tdf$articles <- NULL

tdf$priceChartSevenDay <-
unlist(
lapply(tdf$priceChartSevenDay, function(x){
  if(nrow(x)==0){
    return(0)
  }else{
    first_value <- head(x$price, 1)
    last_value <- tail(x$price, 1)
    price_change <- (((last_value/first_value)-1)*100)
    return(price_change)
  }
  
}))

# sky scanner flight ------------------------------------------------------

library(jsonlite)
library(data.table)
library(lubridate)
from<-"2021-01-01"
to<-"2021-03-01"
print(from)
myurl <- paste0("https://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/HU/HUF/en-US/BUD-sky/Anywhere/",from,"/",to,"?apiKey=ha828488142052428051835227839847")

t <- fromJSON(myurl)
