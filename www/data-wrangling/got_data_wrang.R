# Set-up ------------------------------------------------------------------

### GoT
got_nodes <- read_csv(
  here::here("www", "data", "got", "got_nodes.csv"),
  col_types = cols(name = col_character(),
                   house = col_character())) %>%
  rename(source = name) %>% 
  select(-color)

got_edges <- read_csv(
  here::here("www", "data", "got", "got_edges.csv"),
  col_types = cols(source = col_character(),
                   target = col_character(),
                   Weight = col_double()))

# Remove last names
got_nodes$source <- gsub("_"," ", got_nodes$source)
got_edges$source <- gsub("_"," ", got_edges$source)
got_edges$target <- gsub("_"," ", got_edges$target)

# Capitalize names
got_nodes$source <- tools::toTitleCase(got_nodes$source)
got_edges$source <- tools::toTitleCase(got_edges$source)
got_edges$target <- tools::toTitleCase(got_edges$target)
got_nodes$house  <- tools::toTitleCase(got_nodes$house)

# died/ alive
died <- c("Craster", "Jeor", "Martyn", "Rickard", "Ros", 
          "Kraznys mo Nakloz", "Greizhen", "Prendahl", 
          "Mero", "Joyeuse", "Talisa", 'Robb', "Catelyn")
got_nodes$died <- ifelse(got_nodes$source %in% died, "yes", "no")

