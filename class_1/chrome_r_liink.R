getOption("browser")

library(withr)
library('googlesheets')

#install.packages('googlesheets')

with_options(
  #  list(browser = "/usr/bin/open -a '/Applications/Safari.app'"),
  list(browser = "/usr/bin/open -a '/Applications/Google Chrome.app'"),
  gs_auth()
)

