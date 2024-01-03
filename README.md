# grocery-list

List of recipes and their ingredients in `master_list.csv`. This assumes you already have some pantry items, listed in `pantry_assumptions.csv`. 

The shiny app is written in `app.R` and hosted at <https://meganbontrager.shinyapps.io/grocery-list/>. See <https://docs.posit.co/shinyapps.io> for full deployment instructions. Once you're configured, you can simply update the master list, open R, load `library(rsconnect)` and run `shiny::runApp()` to test and `deployApp()` to update the website. 
