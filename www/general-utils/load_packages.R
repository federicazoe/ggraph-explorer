
# Check if packages used in the app are installed
# If not, install them
packages_to_load <- c("tidyverse",
                      "ggraph",
                      "igraph",
                      "shiny",
                      "shinydashboard",
                      "DT",
                      "shinyBS")
installed_packages <- installed.packages()[, "Package"]
new_packages <- packages_to_load[!(packages_to_load %in% installed_packages)]

if (length(new_packages) > 0) {
  install <- menu(c("yes", "no"),
                  title = paste0("To compile the app we need to install the
                                 following packages: ",
                                 paste(new_packages, collapse = ", "),
                                 "\nDo you want to install them?
                                 (Enter yes/no)"))
  if (install == 1) {
    install.packages(new_packages)
  } else{
    warning("The app cannot be compiled because there are packages that are
            required but not installed.")
    stopApp()
  }
}

# Load packages used in the app
library(tidyverse)
library(ggraph)
library(igraph)
library(shiny)
library(shinydashboard)
library(DT)
library(shinyBS)
