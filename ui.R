source(here::here("www", "general-utils", "load_packages.R"))
source(here::here("www", "general-utils", "dashboard_message.R"))

dashboardPage(
  dashboardHeader(title = "ggraph explorer"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Game of Thrones", tabName = "got", icon = icon("dragon")),
      menuItem("Harry Potter", tabName = "hp", icon = icon("bolt")),
      menuItem("Lord of the Rings", tabName = "lotr", icon = icon("ring"))
    )),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    tabItems(
      tabItem(tabName = "dashboard",
              make_dashboard_message_pre_data(),
              bsCollapse(
                bsCollapsePanel(style = "info",
                                title = "Game of Thrones",
                                p("This dataset is based on the third season of the HBO series",
                                  a(href = 'https://www.hbo.com/game-of-thrones', "Game of Thrones"), 
                                  ". The data contains an edge-list (interactions between characters) 
                                  and a node list (contains each character mentioned) and added \"House\" 
                                  and \"Died\" variables to each observation.",
                                  "Visit ",
                                  a(href = 'https://bigdata.duke.edu/projects/social-network-analysis-basics-case-studies-game-thrones-and-national-hockey-league',
                                    "this website"),
                                  " for more information.")
                ),
                bsCollapsePanel(style = "info",
                                title = "Harry Potter",
                                p("This dataset is based on the series of books by",
                                  a(href = 'https://www.jkrowling.com/writing/', "J. K. Rowling"),
                                  ". A link in this dataset represents a positive or negative 
                                  relationship between two characters.")
                ),
                bsCollapsePanel(style = "info",
                                title = "Lord of the Rings",
                                p("This dataset is based on the movie on the ",
                                  a(href = 'https://lotr.fandom.com/wiki/The_Lord_of_the_Rings', 
                                    "epic high-fantasy novel"),
                                  " by J. R. R. Tolkien. If two characters are linked in this dataset,
                                  they shared at least one scene together in the Fellowship of the 
                                  Ring movie. Each link is  weighted by the number of scenes that two 
                                  characters shared, e.g. if a link has weight 5, those two characters 
                                  were in 5 scenes together.")
                )
              ),
              make_dashboard_message_post_data()
      ),
      tabItem(tabName = "got",
              sidebarPanel(
                h3("Plotting Options"),
                "Click on Layout, Nodes, or Edges below to see what options are available.",
                h3(""),
                bsCollapse(
                  bsCollapsePanel(style = "info",
                                  value = "Layout",
                                  h4("Layout", align = "center"),
                                  checkboxGroupInput("got_node_house", "Select House(s):",
                                                     choices = c("Baratheon",
                                                                 "Bolton",
                                                                 "Greyjoy",
                                                                 "Lannister",
                                                                 "Stark",
                                                                 "Targaryen",
                                                                 "Tyrell",
                                                                 "Other"),
                                                     selected = "Stark"
                                                     #actionLink("selectall","Select All")
                                  ),
                                  selectInput(inputId = "got_layout",
                                              label = "Layout style:",
                                              c("fr",
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
                                                "circle"),
                                              selected = "fr"),
                                  checkboxInput("got_node_died", "Character Died",
                                                FALSE)
                  ),
                  bsCollapsePanel(style = "info",
                                  value = "Nodes",
                                  h4("Nodes",  align = "center"),
                                  checkboxInput("got_node_col", "Color Node by House",
                                                FALSE),
                                  h5(strong("Labels:")),
                                  sliderInput("got_node_size", "Node size:",
                                              1, 10, 3),
                                  sliderInput("got_text_size", "Text size:",
                                              1, 10, 3),
                                  checkboxInput("got_node_repel",
                                                "Repel",
                                                value = TRUE)
                  ),
                  bsCollapsePanel(style = "info",
                                  value = "Edges",
                                  h4("Edges", align = "center"),
                                  checkboxInput("got_edge_alpha",
                                                "Weight edges by relationship strength",
                                                FALSE),
                                  selectInput("got_edge_style",
                                              "Edge style:",
                                              c("arc",
                                                "bend",
                                                "fan",
                                                "hive",
                                                "link"),
                                              selected = "bend")
                  )
                )
              ),
              mainPanel(
                tabsetPanel(type = "tabs",
                            tabPanel("Plot",
                                     plotOutput("got_plot")),
                            tabPanel("Nodes",
                                     h3("Characters"),
                                     DTOutput('got_nodes_table')),
                            tabPanel("Edges",
                                     h3("Relations"),
                                     DTOutput('got_edges_table')),
                            tabPanel("Code",
                                     fluidRow(style = "padding-right: 10px;",
                                              h4("Modify the options in the Plotting Options
                                                   panel and see how to create the ggraph
                                                   with the options you selected."),
                                              textOutput("got_code", container = pre)))
                            )
                )
      ),
      tabItem(tabName = "hp",
              fluidRow(
                sidebarPanel(
                  h3("Plotting Options"),
                  "Click on Layout, Nodes, or Edges below to see what options are available.",
                  h3(""),
                  bsCollapse(
                    bsCollapsePanel(style = "info",
                                    value = "Layout",
                                    h4("Layout", align = "center"),
                                    h5(strong("Subset:")),
                                    checkboxInput("hp_node_main_characters",
                                                  "Only main characters",
                                                  value = TRUE),
                                    selectInput(inputId = "hp_layout",
                                                label = "Layout style:",
                                                c("fr",
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
                                                  "circle"),
                                                selected = "lgl")
                    ),
                    bsCollapsePanel(style = "info",
                                    value = "Nodes",
                                    h4("Nodes",  align = "center"),
                                    selectInput("hp_node_color",
                                                "Color by:",
                                                c("house", "family"),
                                                selected = "house"),
                                    h5(strong("Shape by:")),
                                    checkboxInput("hp_node_shape",
                                                  "house ",
                                                  value = FALSE),
                                    sliderInput("hp_node_size", "Size:",
                                                1, 10, value = 3),
                                    sliderInput("hp_node_alpha",
                                                "Opacity:",
                                                min = 0,
                                                max = 1,
                                                step = 0.1,
                                                value = 1),
                                    h5(strong("Labels:")),
                                    checkboxInput("hp_node_text",
                                                  "Show",
                                                  value = TRUE),
                                    checkboxInput("hp_node_repel",
                                                  "Repel",
                                                  value = TRUE),
                                    sliderInput("hp_text_size", "Text size:",
                                                min = 1,
                                                max = 8,
                                                value = 3)
                    ),
                    bsCollapsePanel(style = "info",
                                    value = "Edges",
                                    h4("Edges", align = "center"),
                                    selectInput("hp_edge_style",
                                                "Style:",
                                                c("fan",
                                                  "link",
                                                  "arc",
                                                  "hive"),
                                                selected = "fan"),
                                    h5(strong("Color by:")),
                                    checkboxInput("hp_edge_color",
                                                  "relationship",
                                                  value = TRUE),
                                    h5(strong("Linetype by:")),
                                    checkboxInput("hp_edge_linetype",
                                                  "relationship",
                                                  value = FALSE),
                                    sliderInput("hp_edge_width", "Width:",
                                                min = 0,
                                                max = 3,
                                                step = 0.1,
                                                value = 0.5),
                                    sliderInput("hp_edge_alpha", "Opacity:",
                                                min = 0,
                                                max =1,
                                                step = 0.1,
                                                value = 0.2)
                    )
                  )
                ),
                mainPanel(
                  tabsetPanel(type = "tabs",
                              tabPanel("Plot",
                                       h3("Harry Potter Network"),
                                       plotOutput("hp_plot", height = "500px")),
                              tabPanel("Nodes",
                                       h3("Characters"),
                                       DTOutput('hp_characters_table')),
                              tabPanel("Edges",
                                       h3("Relations"),
                                       DTOutput('hp_relations_table')),
                              tabPanel("Code",
                                       fluidRow(style = "padding-right: 10px;",
                                                h4("Modify the options in the Plotting Options
                                                   panel and see how to create the ggraph
                                                   with the options you selected."),
                                                textOutput("hp_code", container = pre)))
                              )
                  )
              )
      ),
      tabItem(tabName = "lotr",
              fluidRow(
                sidebarPanel(
                  h3("Plotting Options"),
                  "Click on Layout, Nodes, or Edges below to see what options are available.",
                  h3(""),
                  bsCollapse(
                    bsCollapsePanel(style = "info",
                                    value = "Layout",
                                    h4("Layout", align = "center"),
                                    h5(strong("Subset:")),
                                    checkboxInput("lotr_node_fellowship",
                                                  "Only Fellowship",
                                                  FALSE),
                                    selectInput(inputId = "lotr_layout",
                                                label = "Layout style:",
                                                c("fr",
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
                                                  "circle"),
                                                selected = "lgl")
                    ),
                    bsCollapsePanel(style = "info",
                                    value = "Nodes",
                                    h4("Nodes",  align = "center"),
                                    checkboxInput("lotr_node_text",
                                                  "Show names",
                                                  TRUE),
                                    checkboxInput("lotr_node_repel",
                                                  "Repel names",
                                                  TRUE),
                                    sliderInput("lotr_text_size", "Text size:",
                                                1, 8, 3),
                                    sliderInput("lotr_node_size", "Node size:",
                                                1, 20, 8),
                                    selectInput("lotr_color",
                                                "Color nodes by:",
                                                c("race", "fellowship", "none"))
                    ),
                    bsCollapsePanel(style = "info",
                                    value = "Edges",
                                    h4("Edges", align = "center"),
                                    selectInput("lotr_edge_style",
                                                "Edge style:",
                                                c("fan",
                                                  "link",
                                                  "arc",
                                                  "hive"),
                                                selected = "fan"),
                                    sliderInput("lotr_edges_strong",
                                                "Strong link weight requirement:",
                                                1, 11, 5),
                                    checkboxInput("lotr_edge_color",
                                                  "Show strong links",
                                                  FALSE)
                    )
                  )
                ),
                mainPanel(
                  tabsetPanel(type = "tabs",
                              tabPanel("Plot",
                                       h3("Lord of the Rings Network"),
                                       plotOutput("lotr_plot", height = "500px")),
                              tabPanel("Nodes",
                                       h3("Characters"),
                                       DTOutput('lotr_characters_table')),
                              tabPanel("Edges",
                                       h3("Relations"),
                                       DTOutput('lotr_relations_table')),
                              tabPanel("Code",
                                       fluidRow(style = "padding-right: 10px;",
                                                h4("Modify the options in the Plotting Options
                                                   panel and see how to create the ggraph
                                                   with the options you selected."),
                                                textOutput("lotr_code", container = pre)))
                              )
                  )
            )
      )
    )#tabItems
  )#dashboardBody
)#dashboardPage
