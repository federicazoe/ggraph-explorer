
# Read data ---------------------------------------------------------------

hp_characters <- read_csv(here::here("www", "data", "hp", "characters.csv"),
                          col_types = cols(id = col_double(),
                                           name = col_character(),
                                           bio = col_character(),
                                           house = col_character()))
hp_relations <- read_csv(
  here::here("www", "data", "hp", "relations.csv"),
  col_types = cols(source = col_double(),
                   target = col_double(),
                   type = col_character())) %>% 
  rename(relationship = type) %>% 
  mutate(relationship = case_when(relationship == "+" ~ "positive",
                                  relationship == "-" ~ "negative"))

# Which characters are human/other creatures? -----------------------------

hp_characters$name[hp_characters$id %in% c(0:58)] # Human characters
hp_characters$name[!(hp_characters$id %in% c(0:58))] # Other creatures
hp_characters <- hp_characters %>% 
  mutate(species = case_when(id %in% c(0:58) ~ "human",
                             TRUE ~ "other creature")) # TRUE is all other cases

# What are the families of the characters? --------------------------------

hp_characters <- hp_characters %>%
  mutate(name = case_when(
    name == "Bartemius \"Barty\" Crouch Sr." ~ "Bartemius Sr. Crouch",
    name == "Bartemius \"Barty\" Crouch Jr." ~ "Bartemius Jr. Crouch",
    name == "Alastor \"Mad-Eye\" Moody" ~ "Alastor Moody",
    TRUE ~ name))

family_names <- str_extract(hp_characters$name, regex("[A-z]+$"))

# Non-human creatures don't have a family name
hp_characters <- hp_characters %>% 
  mutate(family = family_names,
         family = case_when(species == "human" ~ family)) # This gives NA to family 
# for "other creature"

# What is the relevance of the character in the story? --------------------

protagonist <- c("Harry Potter")
co_protagonists <- c("Hermione Granger", "Ron Weasley")
main_characters <- c("Albus Dumbledore",
                     "Lord Voldemort",
                     "Draco Malfoy",
                     "Sirius Black",
                     "Neville Longbottom",
                     "Rubeus Hagrid",
                     "Bellatrix Lestrange",
                     "Luna Lovegood",
                     "Remus Lupin",
                     "Lucius Malfoy",
                     "Minerva McGonagall",
                     "Peter Pettigrew",
                     "Severus Snape",
                     "George Weasley",
                     "Fred Weasley",
                     "Ginny Weasley")
secondary_characters <- c("Arthur Weasley",
                          "Molly Weasley",
                          "Dobby",
                          "Dolores Janes Umbridge",
                          "James Potter",
                          "Lily Potter",
                          "Dudley Dursley",
                          "Petunia Dursley",
                          "Vernon Dursley",
                          "Regulus Arcturus Black",
                          "Alastor Moody",
                          "Lavender Brown",
                          "Cho Chang",
                          "Vincent Crabbe Sr.",
                          "Vincent Crabbe",
                          "Bartemius Sr. Crouch",
                          "Bartemius Jr. Crouch",
                          "Fleur Delacour",
                          "Cedric Diggory",
                          "Alberforth Dumbledore",
                          "Argus Filch",
                          "Seamus Finnigan",
                          "Nicolas Flamel",
                          "Cornelius Fudge",
                          "Goyle Sr.",
                          "Gregory Goyle",
                          "Igor Karkaroff",
                          "Viktor Krum",
                          "Alice Longbottom",
                          "Frank Longbottom",
                          "Xenophilius Lovegood",
                          "Narcissa Malfoy",
                          "Olympe Maxime",
                          "Quirinus Quirrell",
                          "Tom Riddle Sr.",
                          "Mary Riddle",
                          "Rita Skeeter",
                          "Nymphadora Tonks",
                          "Bill Weasley",
                          "Charlie Weasley",
                          "Fluffy",
                          "Hedwig",
                          "Moaning Myrtle",
                          "Aragog",
                          "Grawp")

hp_characters <- hp_characters %>% 
  mutate(relevance = case_when(name %in% protagonist ~ "protagonist",
                               name %in% co_protagonists ~ "co-protagonist",
                               name %in% main_characters ~ "main character",
                               name %in% secondary_characters ~ "secondary character"))

# Clean environment of objects no longer needed
remove(protagonist, co_protagonists, main_characters, 
       secondary_characters, family_names)

# Create DT ---------------------------------------------------------------

# Re-order variables
hp_characters <- hp_characters %>% 
  relocate(id, name, relevance, house, species, family, bio) 

# Characters, subset
hp_main_characters <- hp_characters %>% 
  filter(relevance != "secondary character")

# Relations, full data
find_label_id <- function(d){
  i <- which(hp_characters$id == d)[1]
  hp_characters$name[i]
}

source_label = map_chr(hp_relations$source, find_label_id)
target_label = map_chr(hp_relations$target, find_label_id)

hp_relations_with_labels <- hp_relations %>% 
  mutate(source = source_label,
         target = target_label)

# Relations, subset

hp_main_characters_relations <- hp_relations %>% 
  filter(source %in% hp_main_characters$id &
           target %in% hp_main_characters$id)

find_label_id <- function(d){
  i <- which(hp_main_characters$id == d)[1]
  hp_main_characters$name[i]
}

source_label = map_chr(hp_main_characters_relations$source, find_label_id)
target_label = map_chr(hp_main_characters_relations$target, find_label_id)

hp_main_characters_relations_with_labels <- hp_main_characters_relations %>% 
  mutate(source = source_label,
         target = target_label) 

# Create networks ------------------------------------------------------------

hp_net <- graph_from_data_frame(d = hp_relations, 
                                vertices = hp_characters,
                                directed = FALSE)

# Remove duplicate edges
hp_net <- simplify(hp_net, remove.multiple = TRUE, edge.attr.comb = "min")

# Only main characters
hp_main_characters_net <- induced_subgraph(
  hp_net, 
  v = which(hp_characters$relevance %in% c("protagonist", 
                                           "co-protagonist", 
                                           "main character")))
