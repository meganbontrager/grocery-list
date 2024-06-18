# Create list of produce for farmers market

library(tidyverse)

groceries = read_csv("master_list.csv") %>% 
  filter(section == "produce") %>% 
  filter(!ingredient %in% c("lemons", "onions", "garlic", "avocados", "bananas", 
                            "fresh coconut", "frozen fruit", "ginger", "grapefruit", 
                            "large green mango", "limes", "orange", "pine nuts",
                            "pomegranate seeds", "red onions", "silken tofu", "firm tofu", 
                            "soon tofu")) %>% 
  mutate(ingred_amt = paste0(ingredient, " (", amount, " ", units,")")) %>% 
  group_by(meal) %>% 
  mutate(produce_list = paste0(ingred_amt, collapse = ", ")) %>% 
  select(meal, produce_list) %>% 
  distinct()
  



