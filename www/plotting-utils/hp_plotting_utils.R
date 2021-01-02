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

hp_layouts <- sapply(layouts, 
                     generate_layout, 
                     net = hp_net, 
                     simplify = FALSE)

# Layout for main characters 
hp_main_characters_layouts <- sapply(layouts, 
                                     generate_layout, 
                                     net = hp_main_characters_net, 
                                     simplify = FALSE)

# Palettes ----------------------------------------------------------------

house_color_palette <- c("gryffindor" = "firebrick2",
                         "hufflepuff" = "gold1",
                         "ravenclaw" = "blue3",
                         "slytherin" = "springgreen4",
                         "none" = "gray50")
relationship_color_palette <- c( "positive" = "seagreen4",
                                 "negative" = "red3")

relationship_linetype_palette <- c( "positive" = "solid",
                                    "negative" = "dashed")


# Edges plotting --------------------------------------------------------------

hp_geom_edge_dynamic <- function(style = "fan",
                                 var_color = TRUE,
                                 var_linetype = FALSE,
                                 color = "black",
                                 width = 0.5,
                                 alpha = 0.3){
  
  hp_geom_edge <- list(
    fan = ggraph::geom_edge_fan(color = color, width = width, alpha = alpha),
    link = ggraph::geom_edge_link(color = color, width = width, alpha = alpha), 
    arc = ggraph::geom_edge_arc(color = color, width = width, alpha = alpha), 
    hive = ggraph::geom_edge_hive(color = color, width = width, alpha = alpha)
  )
  
  if (var_color == TRUE & var_linetype == TRUE){
    
    hp_geom_edge <- list(
      fan = ggraph::geom_edge_fan(aes(color = relationship, 
                                      linetype = relationship), 
                                  width = width, alpha = alpha),
      link = ggraph::geom_edge_link(aes(color = relationship, 
                                        linetype = relationship), 
                                    width = width, alpha = alpha),
      arc = ggraph::geom_edge_arc(aes(color = relationship, 
                                      linetype = relationship), 
                                  width = width, alpha = alpha),
      hive = ggraph::geom_edge_hive(aes(color = relationship, 
                                        linetype = relationship), 
                                    width = width, alpha = alpha)
    )
  } else if (var_color == TRUE & var_linetype == FALSE){
    
    hp_geom_edge <- list(
      fan = ggraph::geom_edge_fan(aes(color = relationship), 
                                  width = width, alpha = alpha),
      link = ggraph::geom_edge_link(aes(color = relationship), 
                                    width = width, alpha = alpha),
      arc = ggraph::geom_edge_arc(aes(color = relationship), 
                                  width = width, alpha = alpha),
      hive = ggraph::geom_edge_hive(aes(color = relationship), 
                                    width = width, alpha = alpha)
    )
  } else if (var_color == FALSE & var_linetype == TRUE){
    
    hp_geom_edge <- list(
      fan = ggraph::geom_edge_fan(aes(linetype = relationship), 
                                  width = width, alpha = alpha),
      link = ggraph::geom_edge_link(aes(linetype = relationship), 
                                    width = width, alpha = alpha),
      arc = ggraph::geom_edge_arc(aes(linetype = relationship), 
                                  width = width, alpha = alpha),
      hive = ggraph::geom_edge_hive(aes(linetype = relationship), 
                                    width = width, alpha = alpha)
    )
  }
  
  hp_geom_edge[[style]]
  
}

# Node plotting --------------------------------------------------------------

hp_geom_node_dynamic <- function(node_color, node_shape, size = 3, alpha = 1){
  
  if (as.character(node_color) == "family" & node_shape == FALSE){
    geom_node_point(aes(color = family), size = size, alpha = alpha) 
  } else if(as.character(node_color) == "family" & node_shape == TRUE){
    geom_node_point(aes(color = family, shape = house), 
                    size = size, alpha = alpha) 
  } else if(as.character(node_color) == "house" & node_shape == TRUE){
    geom_node_point(aes(color = house, shape = house), 
                    size = size, alpha = alpha)
  } else{
    geom_node_point(aes(color = house), size = size, alpha = alpha) 
  }
  
}  


# Plotting function -------------------------------------------------------

hp_dynamic_plot <- function(use_subset,
                            layout,
                            edge_color,
                            show_labels,
                            repel,
                            label_size,
                            node_size,
                            node_color,
                            node_shape,
                            node_alpha,
                            edge_style,
                            edge_linetype,
                            edge_width,
                            edge_alpha){
  
  if (use_subset == TRUE){
    layouts_list <- hp_main_characters_layouts
  }else{
    layouts_list <- hp_layouts
  }
  
  # Add edges
  hp_g <- ggraph(layouts_list[[layout]]) +
    hp_geom_edge_dynamic(style = edge_style,
                         var_color = edge_color,
                         var_linetype = edge_linetype,
                         width = edge_width,
                         alpha = edge_alpha) +
    scale_edge_color_manual(values = relationship_color_palette) +
    scale_edge_linetype_manual(values = relationship_linetype_palette)
  
  # Add nodes
  
  hp_g <- hp_g +
    hp_geom_node_dynamic(node_color = node_color, 
                         node_shape = node_shape,
                         size = node_size,
                         alpha = node_alpha)
  
  if (as.character(node_color) == "house"){
    hp_g <- hp_g + scale_color_manual(values = house_color_palette)
  }
  
  
  if (show_labels == TRUE){
    hp_g <- hp_g +
      geom_node_text(aes(label = name), color = "black",
                     repel = repel, size = label_size,
                     fontface = "bold")
  }
  
  hp_g +
    theme_graph() +
    theme(plot.margin = unit(c(2, 2, 2, 2), "cm"))
  
}

# ggraph(hp_main_characters_layout) +
#   geom_edge_fan(aes(color = relationship, linetype = relationship), 
#                 width = 0.5, alpha = 0.3) +
#   geom_node_point(aes(color = house, shape = house), size = 3) +
#   geom_node_text(aes(label = name), size = 3, color = "black", 
#                  repel = TRUE, fontface = "bold") +
#   scale_color_manual(values = house_color_palette) +
#   scale_edge_color_manual(values = relationship_color_palette) +
#   scale_edge_linetype_manual(values = relationship_linetype_palette) +
#   theme_graph() 

