
# Read data ---------------------------------------------------------------
lotr_characters <- read_csv(here::here("www", "data", "lotr", "characters.csv"),
                            col_types = cols(id = col_double(),
                                             name = col_character(),
                                             race = col_character(),
                                             fellowship = col_logical()))
lotr_relations <- read_csv(here::here("www", "data", "lotr", "edges.csv"),
                           col_types = cols(source = col_double(),
                                            target = col_double(),
                                            weight = col_double()))

lotr_fellowship_characters <- lotr_characters %>% 
  filter(fellowship)

lotr_fellowship_relations <- lotr_relations %>% 
  filter(source %in% lotr_fellowship_characters$id &
           target %in% lotr_fellowship_characters$id)

# Create networks ---------------------------------------------------------

# all characters
lotr_net <- graph_from_data_frame(d = lotr_relations, 
                                vertices = lotr_characters,
                                directed = FALSE)

# only fellowship members
lotr_fellowship_net <- induced_subgraph(lotr_net, 
                                        v = which(lotr_characters$fellowship))

