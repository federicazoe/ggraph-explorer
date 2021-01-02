# Set-up ------------------------------------------------------------------

layouts <- c("fr",
             "dh",
             "gem",
             "star",
             "lgl",
             "randomly",
             "mds",
             "grid",
             "kk",
             "graphopt",
             "drl",
             "circle")

generate_layout <- function(layout, net) {
  create_layout(net, layout = layout)
}

# Create layouts with all characters --------------------------------------
lotr_layouts <- sapply(layouts, 
                       generate_layout, 
                       net = lotr_net, 
                       simplify = FALSE)

# Create layouts with only Fellowship members -----------------------------
lotr_fellowship_layouts <- sapply(layouts, 
                                  generate_layout, 
                                  net = lotr_fellowship_net, 
                                  simplify = FALSE)


# Create plots ------------------------------------------------------------

lotr_dynamic_plot <- function(fellowship,
                              layout,
                              edge_color,
                              edge_style,
                              edge_strong,
                              node_color,
                              node_size,
                              node_text,
                              text_size,
                              repel) {
  
  # check if nodes should be subsetted
  if(fellowship) {
    lotr_g <- ggraph(lotr_fellowship_layouts[[layout]])
  } else {
    lotr_g <- ggraph(lotr_layouts[[layout]])
  }
  
  # set edge style
  if (edge_color) {
    if (edge_style == "fan") {
      lotr_g <- lotr_g + 
        geom_edge_fan(aes(color = (weight >= edge_strong)), 
                      width = 0.8, alpha = 0.9)
      
    } else if (edge_style == "link") {
      lotr_g <- lotr_g + 
        geom_edge_link(aes(color = (weight >= edge_strong)), 
                       width = 0.8, alpha = 0.9)
      
    } else if (edge_style == "arc") {
      lotr_g <- lotr_g + 
        geom_edge_arc(aes(color = (weight >= edge_strong)), 
                      width = 0.8, alpha = 0.9)
    } else {
      lotr_g <- lotr_g + 
        geom_edge_hive(aes(color = (weight >= edge_strong)), 
                       width = 0.8, alpha = 0.9)
    }
    lotr_g <- lotr_g  +
      scale_edge_color_manual(name = "strong link", 
                              values = setNames(c("gray75", "red"), 
                                                c(FALSE, TRUE)))
  } else {
    if (edge_style == "fan") {
      lotr_g <- lotr_g + 
        geom_edge_fan(color = "gray70", width = 0.8, alpha = 0.9)
      
    } else if (edge_style == "link") {
      lotr_g <- lotr_g + 
        geom_edge_link(color = "gray70", width = 0.8, alpha = 0.9)
      
    } else if (edge_style == "arc") {
      lotr_g <- lotr_g + 
        geom_edge_arc(color = "gray70", width = 0.8, alpha = 0.9)
    } else {
      lotr_g <- lotr_g + 
        geom_edge_hive(color = "gray70", width = 0.8, alpha = 0.9)
    }
  }
  # set node color and size
  if (node_color == "race") {
    lotr_g <- lotr_g +
      geom_node_point(aes(color = race), size = node_size)
  } else if (node_color == "fellowship") {
    lotr_g <- lotr_g +
      geom_node_point(aes(color = fellowship), size = node_size)
  } else {
    lotr_g <- lotr_g +
      geom_node_point(color = "gray50", size = node_size)
  }
  # set node text and size
  if (node_text == TRUE){
    lotr_g <- lotr_g +  
      geom_node_text(aes(label = name), size = text_size, 
                     color = "black", repel = repel, fontface = "bold") 
  }
  
  lotr_g + theme_graph()
}

