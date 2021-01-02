
# Code to run only once 
source(here::here("www", "data-wrangling", "got_data_wrang.R"))
source(here::here("www", "plotting-utils", "got_plotting_utils.R"))
source(here::here("www", "data-wrangling", "hp_data_wrang.R"))
source(here::here("www", "plotting-utils", "hp_plotting_utils.R"))
source(here::here("www", "data-wrangling", "lotr_data_wrang.R"))
source(here::here("www", "plotting-utils", "lotr_plotting_utils.R"))

function(input, output) {
  
  ### GOT
  
  # creating the plot
  output$got_plot <- renderPlot({
    # select house(s)
    nodes <- input$got_node_house
    
    # filter dataset by selected house(s)
    fam_names <- got_nodes %>%
      filter(house %in% nodes) 
    
    if(input$got_node_died){
      fam_names <- fam_names %>% 
        filter(died == "yes") %>% 
        select(source) %>%
        pull()
    } else {
      fam_names <- fam_names %>% 
        select(source) %>%
        pull()
    }
      
    new_edges <- got_edges %>%
      filter(source %in% fam_names & target %in% fam_names)
    
    fam_names2 <- unique(c(new_edges$source, new_edges$target))
    
    new_nodes <- got_nodes %>%
      filter(source %in% fam_names2)
    
    # create graph object
    got_data <- graph_from_data_frame(d = new_edges,
                                      vertices = new_nodes,
                                      directed = FALSE)
    
    # layout attributes
    set.seed(9)
    p <- ggraph(got_data, layout = input$got_layout) +
      theme_graph()
    
    # edge attributes
    if(input$got_edge_style == "arc"){
      if(input$got_edge_alpha){
        p <-  p +
          geom_edge_arc(aes(alpha = Weight)) 
      } else{
        p <- p + 
          geom_edge_arc()
      }
    } else if(input$got_edge_style == "bend"){
      if(input$got_edge_alpha){
        p <-  p +
          geom_edge_bend(aes(alpha = Weight)) 
      } else{
        p <- p + 
          geom_edge_bend()
      }
    } else if(input$got_edge_style == "fan"){
      if(input$got_edge_alpha){
        p <-  p +
          geom_edge_fan(aes(alpha = Weight)) 
      } else{
        p <- p + 
          geom_edge_fan()
      }
    } else if(input$got_edge_style == "hive"){
      if(input$got_edge_alpha){
        p <-  p +
          geom_edge_hive(aes(alpha = Weight)) 
      } else{
        p <- p + 
          geom_edge_hive()
      }
    } else {
      if(input$got_edge_alpha){
        p <-  p +
          geom_edge_link(aes(alpha = Weight)) 
      } else{
        p <- p + 
          geom_edge_link()
      }
    }
    
    # node attributes
    if(input$got_node_col){
      p +
        geom_node_point(aes(color = house), 
                        size = input$got_node_size) +
        geom_node_label(aes(label = name), 
                        size = input$got_text_size,
                        color = "black", repel = input$got_node_repel) +
        scale_color_manual(values = got_color_palette) 
    } else {
      p +
        geom_node_point(size = input$got_node_size) +
        geom_node_label(aes(label = name), 
                        size = input$got_text_size,
                        color = "black", repel = input$got_node_repel)
    }
    
  })

  
  output$got_nodes_table <- renderDT(
    got_nodes, options = list(lengthChange = FALSE)
  )
  
  output$got_edges_table <- renderDT(
    got_edges, options = list(lengthChange = FALSE)
  )
  
  output$got_code <- renderText({
    ## to do: add subset code by house
    got_network_code <- paste("got_net <- graph_from_data_frame(d = got_edges,\n", 
                               "\t vertices = got_nodes,\n",
                               "\t directed = FALSE)\n", sep = "")
    got_layout_code <- paste("got_layout <- create_layout(net, layout = \"",
                              input$got_layout, "\")\n", sep = "")
    got_plot_code <- paste("got_plot <- ggraph(got_net) +\n",
                           "\t theme_graph() +\n", sep = "")
    
    # edge attributes
    
    if(input$got_edge_style == "arc"){
      if(input$got_edge_alpha){
        got_plot_code <- paste(got_plot_code, "\t geom_edge_arc(aes(alpha = Weight)) +\n", sep = "")
      } else{
        got_plot_code <- paste(got_plot_code, "\t geom_edge_arc() +\n", sep = "")
      }
    } else if(input$got_edge_style == "bend"){
      if(input$got_edge_alpha){
        got_plot_code <- paste(got_plot_code, "\t geom_edge_bend(aes(alpha = Weight)) +\n", sep = "")
      } else{
        got_plot_code <- paste(got_plot_code, "\t geom_edge_bend() +\n", sep = "")
      }
    } else if(input$got_edge_style == "fan"){
      if(input$got_edge_alpha){
        got_plot_code <- paste(got_plot_code, "\t geom_edge_fan(aes(alpha = Weight)) +\n", sep = "")
      } else{
        got_plot_code <- paste(got_plot_code, "\t geom_edge_fan() +\n", sep = "")
      }
    } else if(input$got_edge_style == "hive"){
      if(input$got_edge_alpha){
        got_plot_code <- paste(got_plot_code, "\t geom_edge_hive(aes(alpha = Weight)) +\n", 
                               sep = "")
      } else{
        got_plot_code <- paste(got_plot_code, "\t geom_edge_hive() +\n", sep = "")
      }
    } else if(input$got_edge_style == "link"){
      if(input$got_edge_alpha){
        got_plot_code <- paste(got_plot_code, "\t geom_edge_link(aes(alpha = Weight)) +\n", sep = "")
      } else{
        got_plot_code <- paste(got_plot_code, "\t geom_edge_link() +\n", sep = "")
      }
    }
    
    
    # node attributes
    if(input$got_node_col){
      got_plot_code <- paste(got_plot_code, 
                             "\t geom_node_point(aes(color = house),
                              size = ", 
                             input$got_node_size, ") +\n", 
                             sep = "") 
    } else {
      got_plot_code <- paste(got_plot_code, 
                             "\t geom_node_point(size = ",
                             input$got_node_size, ") +\n", sep = "")
    }
    
    got_plot_code <- paste(got_plot_code,
                           "\t geom_node_label(aes(label = name), 
                             size = ", input$got_text_size, ",",
                             "color = \"black\", 
                             repel = ", input$got_node_repel, "))",
                           sep = "")
    
    paste("# create network \n", got_network_code,
          "\n# create layout \n", got_layout_code,
          "\n# create plot \n", got_plot_code,
          sep = "")
  })
  
  # Harry Potter plot
  output$hp_plot <- renderPlot({ 
    hp_dynamic_plot(use_subset = input$hp_node_main_characters,
                    layout = input$hp_layout,
                    edge_color = input$hp_edge_color,
                    edge_style = input$hp_edge_style,
                    edge_linetype = input$hp_edge_linetype,
                    edge_width = input$hp_edge_width,
                    edge_alpha = input$hp_edge_alpha,
                    node_size = input$hp_node_size,
                    node_shape = input$hp_node_shape,
                    node_color = input$hp_node_color,
                    node_alpha = input$hp_node_alpha,
                    show_labels = input$hp_node_text,
                    repel = input$hp_node_repel,
                    label_size = input$hp_text_size)
  })
  
  # HP data tables
  output$hp_characters_table <- renderDT(
    {
      if(input$hp_node_main_characters == TRUE) {
        hp_main_characters
      } else {
        hp_characters
      }
    }, options = list(lengthChange = FALSE)
  )
  
  output$hp_relations_table <- renderDT(
    {
      if(input$hp_node_main_characters == TRUE) {
        hp_main_characters_relations_with_labels
      } else {
        hp_relations_with_labels
      }
    }, options = list(lengthChange = FALSE)
  )
  
  # HP code
  output$hp_code <- renderText({
    hp_network_code <- paste("net <- graph_from_data_frame(d = hp_relations,\n", 
                               "\t vertices = hp_characters,\n",
                               "\t directed = FALSE)\n", sep = "")
    if (input$hp_node_main_characters) {
      hp_network_code <- paste(hp_network_code, "net <- induced_subgraph(net,\n",
                                 "\t v = which(hp_characters$relevance != 'secondary_character')\n", 
                                 sep = "")
    }
    hp_layout_code <- paste("hp_layout <- create_layout(net, layout = \"",
                              input$hp_layout, "\")\n", sep = "")
    hp_plot_code <- paste("hp_g <- ggraph(hp_layout) +\n",
                            "\t theme_graph() +\n", sep = "")
    if (input$hp_edge_color) {
      hp_edge_aes <- paste("aes(color = relationship")
      if(input$hp_edge_linetype){
        hp_edge_aes <- paste0(hp_edge_aes,
                               ", linetype = relationship),\n \t\t\t")
      }else{
        hp_edge_aes <- paste0(hp_edge_aes, "),\n \t\t\t")
      }
    } else if (input$hp_edge_linetype){
      hp_edge_aes <- "aes(linetype = relationship),\n \t\t\t color = black,"
    } else {
      hp_edge_aes <- "color = 'black',"
    }
    hp_edge_aes <- paste0(hp_edge_aes,
                          " width = ", input$hp_edge_width,
                          ", alpha = ", input$hp_edge_alpha,
                          ") +\n")

    hp_node_aes <- paste0("aes(color = ", input$hp_node_color)
    if (input$hp_node_shape){
      hp_node_aes <- paste0(hp_node_aes, ", shape = house), \n")
    } else{
      hp_node_aes <- paste0(hp_node_aes, "), \n")
    }
    hp_node_aes <- paste0(hp_node_aes, "\t\t\t size = ", input$hp_node_size,
                          ", alpha = ", input$hp_node_alpha, ")")
    
    if (input$hp_node_text){
      hp_node_text <- paste(" + \n\t geom_node_text(aes(label = name), \n \t\t\t size = ",
                            input$hp_text_size,
                            ", repel = ",
                            input$hp_node_repel,
                            ")",
                            sep = "")
    } else{
      hp_node_text <- ""
    }
    hp_plot_code <- paste(hp_plot_code,
                          "\t geom_edge_",
                          input$hp_edge_style,
                          "(",
                          hp_edge_aes,
                          "\t geom_node_point(",
                          hp_node_aes,
                          hp_node_text,
                          sep = "")
    
    if (input$hp_node_color == "house"){
      hp_plot_code <- paste0(hp_plot_code,
                            " +\n",
                            "\t scale_color_manual(values = c(",
                            "'gryffindor' = 'firebrick2', \n",
                            "\t \t \t \t \t 'hufflepuff' = 'gold1', \n ",
                            "\t \t \t \t \t 'slytherin' = 'springgreen4', \n",
                            "\t \t \t \t \t 'none' = 'gray50'))")
    }
    
    if (input$hp_edge_color){
      hp_plot_code <- paste0(hp_plot_code,
                            " +\n",
                            "\t scale_edge_color_manual(values = c(",
                            "'positive' = 'seagreen4', \n",
                            "\t \t \t \t \t \040  \040 'negative' = 'red3'))")   
    }
    
    paste("# create network \n", hp_network_code,
          "\n# create layout \n", hp_layout_code,
          "\n# create plot \n", hp_plot_code,
          sep = "")
  })
  
  ### LoTR
  
  # lotr dataset info
  lotr_url <- a("networkdata package", 
                href="https://rdrr.io/github/schochastics/networkdata/man/movie_439.html")
  moviegalaxies_url <- a("Moviegalaxies", 
                href="https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/T4HBA3")
  output$lotr_data_source <- renderUI({
    tagList("Data source:", lotr_url)
  })
  
  output$lotr_info <- renderText("From here")
  
  # lotr plot
  output$lotr_plot <- renderPlot({
    lotr_dynamic_plot(fellowship = input$lotr_node_fellowship,
                      layout = input$lotr_layout,
                      edge_color = input$lotr_edge_color,
                      edge_style = input$lotr_edge_style,
                      edge_strong = input$lotr_edges_strong,
                      node_color = input$lotr_color,
                      node_size = input$lotr_node_size,
                      node_text = input$lotr_node_text,
                      text_size = input$lotr_text_size,
                      repel = input$lotr_node_repel)
  })
  
  # lotr data tables
  output$lotr_characters_table <- renderDT(
    {
      if(input$lotr_node_fellowship) {
        lotr_fellowship_characters
      } else {
        lotr_characters
      }
    }, options = list(lengthChange = FALSE)
  )
  
  output$lotr_relations_table <- renderDT(
    {
      if(input$lotr_node_fellowship) {
        lotr_fellowship_relations
      } else {
        lotr_relations
      }
    }, options = list(lengthChange = FALSE)
  )
  
  # lotr code showcase
  output$lotr_code <- renderText({
    lotr_network_code <- paste("net <- graph_from_data_frame(d = lotr_relations,\n", 
                               "\t vertices = lotr_characters,\n",
                               "\t directed = FALSE)\n", sep = "")
    if (input$lotr_node_fellowship) {
      lotr_network_code <- paste(lotr_network_code, "net <- induced_subgraph(net,\n",
                                 "\t v = which(lotr_characters$fellowship)\n",
                                 sep = "")
    }
    lotr_layout_code <- paste("lotr_layout <- create_layout(net, layout = \"",
                              input$lotr_layout, "\")\n", sep = "")
    lotr_plot_code <- paste("lotr_g <- ggraph(lotr_layout) +\n",
                            "\t theme_graph() +\n", sep = "")
    if (input$lotr_edge_color) {
      lotr_edge_aes <- paste("aes(color = (weight >= ", input$lotr_edges_strong,
                             ")), \n", sep = "")
      lotr_edge_col_scale <- paste("\t scale_edge_color_manual(name = \"strong link\"\n",
                                   "\t\t values = setNames(c(\"red\", \"gray75\"),\n",
                                   "\t\t c(TRUE, FALSE))) +\n",
                                   sep = "")
    } else {
      lotr_edge_aes <- "color = \"gray70\", \n"
      lotr_edge_col_scale <- ""
    }
    if (input$lotr_color == "none") {
      lotr_node_aes <- "color = \"gray50\", "
    } else {
      lotr_node_aes <- paste("aes(color = ",
                             input$lotr_color,
                             "), ", sep = "")
    }
    if (input$lotr_node_text) {
      lotr_lotr_text <- paste(
        " + \n\t geom_node_text(aes(label = name), \n \t \t size = ",
        input$lotr_text_size,
        ", \n\t\t color = \"black\", \n\t\t fontface = \"bold\", \n\t\t repel = ",
        input$lotr_node_repel,
        ")",
        sep = "")
    } else {
      lotr_lotr_text <- ""
    }
    lotr_plot_code <- paste(lotr_plot_code,
                            "\t geom_edge_",
                            input$lotr_edge_style,
                            "(",
                            lotr_edge_aes,
                            "\t\t width = 0.8, alpha = 0.9) +\n",
                            lotr_edge_col_scale,
                            "\t geom_node_point(",
                            lotr_node_aes,
                            "size = ",
                            input$lotr_node_size,
                            ")",
                            lotr_lotr_text,
                            sep = "")
    paste("# create network \n", lotr_network_code,
          "\n# create layout \n", lotr_layout_code,
          "\n# create plot \n", lotr_plot_code,
          sep = "")
  })
  
}

