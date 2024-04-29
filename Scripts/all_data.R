# Load here package for directory management
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
library(here)

# Load data using 'here()' function
all_data <- read.csv(here("DATA", "cancer_data.csv"))

# Print the first few rows of data
print(head(data))

# Install and load the tidyverse and dplyr packages
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
library(tidyverse)

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
library(dplyr)


View(data)


# Remove certain columns from dataset as these are not needed
new.data <- all_data%>%
  select(-upper, -lower, - age, - sex, -location, -metric)


#rename columns and remove rows that are not needed
updated.data <- new.data %>%
  rename(Cancer_Type = cause, Year = year, Death_Rate = val)

updated.data <- subset(updated.data, 
                       Cancer_Type != "Other neoplasms" &
                         Cancer_Type != "Hodgkin lymphoma" &
                         Cancer_Type != "Mesothelioma" &
                         Cancer_Type != "Testicular cancer" &
                         Cancer_Type != "Malignant skin melanoma" &
                         Cancer_Type != "Other pharynx cancer" &
                         Cancer_Type != "Larynx cancer" &
                         Cancer_Type != "Multiple myeloma" &
                         Cancer_Type != "Nasopharynx cancer" &
                         Cancer_Type != "Thyroid cancer" &
                         Cancer_Type != "Non-melanoma skin cancer" &
                         Cancer_Type != "Uterine cancer" &
                         Cancer_Type != "Kidney cancer" &
                         Cancer_Type != "Gallbladder and biliary tract cancer"&
                         Cancer_Type != "Lip and oral cavity cancer"&
                         Cancer_Type != "Ovarian cancer"&
                         Cancer_Type != "Bladder cancer"&
                         Cancer_Type != "Non-Hodgkin lymphoma"&
                         Cancer_Type != "Brain and central nervous system cancer")
                        
                   
                       
                
view(updated.data)

#factor the variable "Cancer Type" in order to create defined levels 
updated.data$Cancer_Type <- factor(updated.data$Cancer_Type)

#install and load packages needed for creating interactive line graph
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

if (!requireNamespace("plotly", quietly = TRUE)) {
  install.packages("plotly")
}

if (!requireNamespace("ggtext", quietly = TRUE)) {
  install.packages("ggtext")
}

library(ggplot2)
library(plotly)
library(ggtext)

#plot a standard line graph
#add appropriate title and labels
p <- ggplot(updated.data, aes(x = Year, y = Death_Rate, color = Cancer_Type)) + 
  geom_line() + labs(
    x = "Year", 
    y = "Death Rate (Per 100,000)", 
    color = "Cancer Type",
    title ="Changing Death Rates of Different Types of Cancer: 1990-2019\n<span style='font-size: 12; font-style: italic'>Institute for Health Metrics and Evaluation</span>") + 
  scale_y_continuous(breaks = seq(0, 25, by = 5), labels = seq(0, 25, by = 5)) +
  theme_minimal() 

#Change the aesthetics (font, font size, position) of the title, legend and labels
p <- p +
  theme(
    text = element_text(family = "helvetica"),
    legend.text = element_text(size = 9),
    legend.title = element_text(face = "bold", size = 15),
    plot.title = element_text(size = 13, face = "bold",  hjust = 0.5, vjust = 1),
    axis.title.x = element_text(face = "bold", size = 12), 
    axis.title.y = element_text(face = "bold", size = 12)
  )


#change the colour of the plot lines  
colours <- c("red","brown", "cornflowerblue","chartreuse2", "orange", "black","darkred","lightblue",
             "darkblue", "darkgreen","hotpink", "purple")

p <- p + scale_color_manual(values = colours) 

# Make the line graph interactive and specify the width using the plotly package
ip <- ggplotly(p, width = 1000, height = 700, tooltip =  c("Year", "Death_Rate", "Cancer_Type"),
               labels = c("Year", "Death Rate", "Cancer Type"))

# Change levels of Cancer_Type Variable
updated.data$Cancer_Type <- factor(updated.data$Cancer_Type, levels = unique(updated.data$Cancer_Type))

print(ip)

# Save interactive plot as an html
htmlwidgets::saveWidget(ip, file = "figs/Cancer_Deaths.html")

