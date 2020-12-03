library(rvest)
library(jsonlite)
library(data.table)

t<- read_html("https://www.imdb.com/title/tt0190332/")
write_html(t, "t.html")

df <- fromJSON(t %>% html_node(xpath = '//script[@type="application/ld+json"]') %>% html_text())
df$creator


# find_data_scientist_compensatoin ----------------------------------------

m <- read_html("https://www.payscale.com/research/US/Job=Data_Scientist/Salary")
write_html(m,"m.html")

df1 <- fromJSON(m %>% html_node(xpath = '//script[@type="application/json"]') %>% html_text())

toJSON(df1, auto_unbox = T) #  for viewing in JSON viewer

 df <- df1$props$pageProps$pageData$related #know different types(dataframe, vector, list)
 

# get funds from EU -------------------------------------------------------

 # download data from a website , send an email to misi, state your demand, choose json 
 # instead of html, Dec 14th Monday
 
 

