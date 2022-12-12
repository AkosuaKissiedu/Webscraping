library(rvest)
library(dplyr)
library(xml2)
library(tidyverse)
library(polite)
library(xlsx)

setwd("C:/Users/afari/Desktop/Data Driven management/Business Intelligence")


#New York
##################################################################################################################################################################


get_info = function(property_agent_links_NY) {
  session <- bow(property_agent_links_NY, user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36")
  
  property_manager_name_NY = scrape(session) %>% html_nodes(".gDqTKI")%>% html_text()%>% paste(collapse = ",")
  
  property_manager_companyname_NY = scrape(session) %>% html_nodes(".ctcd-title .hWdvTH")%>% html_text()%>% paste(collapse = ",")
  
  property_manager_sales_NY = scrape(session) %>% html_nodes(".jMsmDX")%>% html_text()%>% paste(collapse = ",")
  
  property_manager_address_NY = scrape(session) %>% html_nodes(".dmgWTu:nth-child(1) .dfSxsE")%>% html_text() %>% paste(collapse = ",")
  
  property_manager_website_NY = scrape(session) %>% html_nodes(".dfSxsE .hKdCXh")%>%
    html_attr("href") %>%  paste(collapse = ",")
  
  property_manager_cell_NY = scrape(session) %>% html_nodes(".dmgWTu:nth-child(2) .dfSxsE")%>% html_text() %>% paste(collapse = ",")
  
  property_manager_brokerphone_NY = scrape(session) %>% html_nodes(".dmgWTu:nth-child(3) .dfSxsE")%>% html_text() %>% paste(collapse = ",")
  
  
  property_manager_specialities_NY = scrape(session) %>% html_nodes(".dXLBGn")%>% html_text() %>% paste(collapse = ",")
  
  length(property_manager_address_NY) <- length( property_manager_name_NY)
  length(property_manager_companyname_NY) <- length( property_manager_name_NY)
  length(property_manager_sales_NY) <- length( property_manager_name_NY)
  length(property_manager_brokerphone_NY) <- length( property_manager_name_NY)
  length(property_manager_website_NY) <- length( property_manager_name_NY)
  length(property_manager_cell_NY) <- length( property_manager_name_NY)
  length(property_manager_specialities_NY) <- length( property_manager_name_NY)
  
  manager_details_NY <- data.frame(property_manager_name_NY, property_manager_companyname_NY, property_manager_sales_NY, property_manager_address_NY,  property_manager_website_NY, property_manager_cell_NY, property_manager_brokerphone_NY, property_manager_specialities_NY)
  return(manager_details_NY)
  
} 


property_manager_profile_NY = data.frame()

for(page_result in 1:25){
  
  linka = paste0("https://www.zillow.com/professionals/real-estate-agent-reviews/new-york-ny/?page=",page_result)
  
  session <- bow(linka, user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36" )
  
  property_agent_links_NY = scrape(session) %>% html_nodes(".dRCSGX .jMHzWg")%>%
    html_attr("href") %>% paste("https://www.zillow.com",., sep = "")
  
  
  property_managers_NY = sapply(property_agent_links_NY, FUN = get_info)
  property_managers_details_NY = as.data.frame(t(property_managers_NY))
  
  
  property_manager_profile_NY = rbind( property_manager_profile_NY, data.frame(property_managers_details_NY))
  
  
  
  print(paste("Page:", page_result))
  
  
  
}


typeof(property_manager_profile_NY$property_manager_address_NY)
typeof(property_manager_profile_NY$property_manager_website_NY)
typeof(property_manager_profile_NY$property_manager_cell_NY)
typeof(property_manager_profile_NY$property_manager_name_NY)
typeof(property_manager_profile_NY$property_manager_specialities_NY)

property_manager_profiles_NY = as.data.frame(property_manager_profile_NY) 


write.table( property_manager_profiles_NY, "property_manager_profile_NY")
write.xlsx(
  property_manager_profiles_NY,
  "NY.xlsx",
  sheetName = "Sheet1",
  col.names = TRUE,
  row.names = TRUE,
  append = FALSE,
  showNA = TRUE,
  password = NULL
)



#################################################################################################################################################################

