# Load here package for directory management
if (!requireNamespace("here", quietly = TRUE)) {
  install.packages("here")
}
library(here)

# Load data using 'here()' function
male_data <- read.csv(here("DATA", "male_data.csv"))

# Print the first few rows of data
print(head(male_data))

# Install and load the tidyverse and dplyr packages
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
library(tidyverse)

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
library(dplyr)


View(male_data)


# Remove certain columns from dataset as these are not needed
new_male_data <- male_data%>%
  select(-measure_id, -measure_name, -location_id, -location_name, -sex_id, -sex_name
         , -age_id, -age_name, -cause_id, -metric_id, -metric_name, -upper, -lower)

#rename columns and remove rows that are not needed
new_male_data <- new_male_data %>%
  rename(Cancer_Type = cause_name, Year = year, Death_Rate = val)


new_male_data <- subset(new_male_data, 
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
                                Cancer_Type != "Brain and central nervous system cancer"&
                                Cancer_Type != "Pancreatic cancer"&
                                Cancer_Type != "Cervical cancer"&
                                Cancer_Type != "Leukemia"&
                                Cancer_Type != "Prostate cancer"&
                                Cancer_Type != "Other malignant neoplasms"&
                                Cancer_Type != "Liver cancer"&
                                Cancer_Type != "Esophageal cancer"&
                                Cancer_Type != "Breast cancer")

View(new_male_data)

#factor the variable "Cancer Type" in order to create defined levels 
new_male_data$Cancer_Type <- factor(new_male_data$Cancer_Type)

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

# Change levels of Cancer_Type Variable
new_male_data$Cancer_Type <- factor(new_male_data$Cancer_Type, levels = unique(new_male_data$Cancer_Type))

#plot a standard line graph
#add appropriate title and labels
p <- ggplot(new_male_data, aes(x = Year, y = Death_Rate, color = Cancer_Type)) + 
  geom_line() + labs(
    x = "Year", 
    y = "Death Rate (Per 100,000)", 
    color = "Cancer Type",
    title ="Changing Death Rates of Different Types of Cancer in Males: 1990-2019\n<span style='font-size: 12; font-style: italic'>Institute for Health Metrics and Evaluation</span>") + 
  scale_y_continuous(breaks = seq(0, 35, by = 5), labels = seq(0, 35, by = 5)) +
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


# Define custom colors for each cancer type in order to match the colours of visualisation 1
custom_colours <- c("Colon and rectum cancer" = "darkgreen", "Stomach cancer" = "hotpink", "Tracheal, bronchus, and lung cancer" = "purple")


p <- p + scale_color_manual(values = custom_colours) 

# Make the line graph interactive and specify the width using the plotly package
ip <- ggplotly(p, width = 1000, height = 700, tooltip =  c("Year", "Death_Rate", "Cancer_Type"),
               labels = c("Year", "Death Rate", "Cancer Type"))

print(ip)

# Save interactive plot as an html
htmlwidgets::saveWidget(ip, file = "../figs/Male_Cancer_Deaths.html")