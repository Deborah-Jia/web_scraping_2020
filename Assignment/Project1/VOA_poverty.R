library(rvest)
library(data.table)

get_one_voa  <- function(my_url) {
  
  m <- read_html(my_url)

  write_html(m, 'm.html')
  
  boxes <- 
    m %>%
    html_nodes('.vertical-list__item--bordered')
  
  list_of_df <- 
    lapply(boxes, function(x){
      
      titles <- 
        x %>% 
        html_nodes('.teaser__title--dated') %>% 
        html_text()
      
      times <- 
        x %>% 
        html_nodes('.teaser__date') %>% 
        html_text()
      if (length( times) ==0) {
        times <- ''
      }
      
      
      my_link <- 
        paste0('https://www.voanews.com', x %>% 
        html_nodes('.teaser__title-link--dated') %>% 
        html_attr('href'))
      
      text_summary <- 
        x %>% 
        html_nodes('.teaser__text--dated') %>% 
        html_text()
      
      
      categories <- 
        x %>% html_nodes('.eyebrow a') %>% 
        html_text()
      if (length(categories) ==0) {
        categories <- ''
      }
      
      # it will be a one row data.frame
      return(data.frame('categories' = categories, 'title'=titles,  'times'=times, 'links'=  my_link, 'summary'= text_summary))
    })
  
  page_df <- rbindlist(list_of_df)
  return(page_df)
  
}


df1 <- get_one_voa('https://www.voanews.com/search?search_api_fulltext=poverty&type=1&sort_by=publication_time&changed=All&sort_order=DESC&page=0')

write.csv(df1, "voa_pageone.csv")
saveRDS(df1, "voa_pageone.rds")


# the 2nd function --------------------------------------------------------

searchterm <- "love peace"
get_more_voa <- function(searchterm, pages_download){
  
  searchterm <- gsub(' ','+',searchterm, fixed = T)
  links_to_get <-
    paste0('https://www.voanews.com/search?search_api_fulltext=',searchterm, '&type=1&sort_by=publication_time&changed=All&sort_order=DESC&page=', seq(0, pages_download))
  ret_df <- rbindlist(lapply(links_to_get, get_one_voa))
  return(ret_df)
}

df2 <- get_more_voa(searchterm = 'China', 3)

write.csv(df2, "voa_page_more.csv")
saveRDS(df2, "voa_voa_page_more.rds")
