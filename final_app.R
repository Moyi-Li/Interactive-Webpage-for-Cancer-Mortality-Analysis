#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(tidyverse)
library(dplyr)
library(ggplot2)
library(usmap)
library(shiny)
library(shinyWidgets)
library(billboarder)

#################
# Data Cleaning

## perform in another file

#################
# Read data

# First table
cancer_result <- read_delim("cancer_result.csv")

# Second table
cancerI <- read_delim("Cancer Incidence by Sex.csv")

######################################################################################################
ui <- navbarPage("Analysis of Cancer Incidence and Mortality",
                 setBackgroundColor("ghostwhite"),
                 
                 tabPanel("General information",
                          imageOutput("home_img"),
                          h3("Project Overview & Purpose:"),
                          p("This project aims to provide a report that contains an overall summary and trends of the four specific cancers:", 
                            em('breast cancer, larynx cancer, liver cancer, and myeloma cancer.'), 
                            "It focuses on whether different states and sex relate to the increase/decrease in the cancer population in America, 
                     as well as how these two factors affect the cancer population. 
                     Through this project, we hope to help viewers better understand cancer trends through these years and their distribution of it. 
                     We also hope to grow awareness of what factors might affect the higher possibility of 
                     specific cancers and provide a resource for health officials to further enhance their research."),
                          h3("Audience:"),
                          p("Since cancer is the second leading cause of death in the United States, 
                     we anticipate that most of the general population will be interested in our dataset and could benefit from it. 
                     However, specifically, we focus primarily on the distribution and variation across gender, 
                     states, and various cancer sites.", em('Therefore, our target audience would mainly be medical institutions to 
                     better identify and even predict what kind of cancer patients in different regions are likely to get now or in the future')),
                          h3("Data set:"),
                          p("The dataset we’ll be working with is the cancer incidence from,", a(href="https://dataplanet-sagepub-com.offcampus.lib.washington.edu/dataset?view=AA0BXQAAgADnAQAAAAAAAAAA3_zMslwIJ8Ve1X%24GFkbpBG2ii7wZFl2tiSNB4wcDRmeLoNKyWPVjgsfC4awCfWnQgvxGyuLVrYsSWlUP3f8eTtrrcsfia4R0kyuMVsvfyGRddD%24DQpROZCYVu6YU1Uwq8Y5frZNlHUdkbgO_O5DiplarTBBL8kxBBxtdbl1Gv5XTbNensqqv43k8RxuipEmnq95UjUzbTO5vTcpNku_4ZGKvwlwLYgjJAq8QZpHoW4W5rNHziyrKZuI5gdEyBeNtFMkwRPrKKdP6",
                                                                                                 "the U.S. cancer statistics database."), 
                            "Under the CDC, Centers for Disease Control and Prevention, 
                          this health statistic information was compiled to guide policies to improve the health of people. 
                          The overall data provides counts and incidence rates of newly diagnosed cancer cases by cancer sites and U.S. regions.",
                            div('Although there are many breakdowns of the data, we selected only 
                              the population data for the four cancers mentioned above for the years 2009 to 2018 for analysis.')),
                          h3("What We Aim to Learn:"),
                          p(div(strong('- What are the trends of the four types of cancer according to gender over the years?')),
                            div(strong('- What type of cancer–among the four that we selected–is most prevalent among the population according to gender?')),
                            div(strong('- What is the regional distribution of cancer, 
                                  and is there a relationship between different regions and cancer prevalence?'))),
                          h3("Creators:"),
                          p(div('- Moyi Li'), div('- Ziyu Lin'), div('- Yoonsoo Cho'), div('- Chenyang Yuan'))
                          
                 ),
                 
                 tabPanel("Linear Plot",
                          sidebarLayout(
                            sidebarPanel(
                              sliderInput("time_range", label = "Choose the time range",
                                          min = min(cancerI$time),
                                          max = max(cancerI$time),
                                          value = c(2014, 2016)),
                              
                              selectInput("sex", label = "Select box",
                                          choices = list("Female" = "Female", "Male" = "Male"),
                                          selected = "Female"),
                              
                              radioButtons("plotchoice", label = "Different choice of plot", 
                                           choices = list("Trend_plot", "Scartter_plot"),
                                           selected = "Trend_plot"),
                              
                            ),
                            mainPanel(plotOutput("cancerIplot"),
                                      h3("Description"),
                                      textOutput("linedata"))
                          )),
                 
                 tabPanel('Pie chart',
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = "gender", label = "Select a Gender to display", 
                                          choices = list("Female" = "Female", "Male" = "Male"),
                                          selected = "Male"),
                              sliderInput("year", label = "Which year to check out?",
                                          min = min(cancer_result$Time),
                                          max = max(cancer_result$Time),
                                          value = 2013)
                            ),
                            mainPanel(
                              plotOutput(outputId = "pie_plot"),
                              h3("Description"),
                              textOutput("pietext"))
                          )),
                 
                 tabPanel('Choropleth Plot',
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = "rate", label = "Select infected population or death number to display", 
                                          choices = list("Incidence" = "Incidence", "Mortality" = "Mortality"),
                                          selected = "Incidence"),
                              sliderInput("time_table", label = "Choose the time",
                                          min = min(cancer$Time),
                                          max = max(cancer$Time),
                                          value = 2013, step = 1)
                            ),
                            mainPanel(
                              plotOutput(outputId = "choropleth"),
                              h3("Description"),
                              textOutput("chotext"))
                          )),
                 
                 tabPanel("Conclusion",
                          imageOutput("final_img"),
                          h3("Takeaways:"),
                          p(div('From our data, we concluded that the cancer population increased in every state from 2009 to 2018,
                          with population by region and gender correlating with cancer incidence and reported cases.'),
                            div('In terms of gender, we were able to see that the female population 
                          is more vulnerable to breast cancer than the male population. 
                          So when it comes to body protection and screening, women should pay more 
                          attention to their breasts. And men also have a relatively large percentage 
                          of liver cancers among the four cancers, which should also be taken seriously.'),
                            div('As for the region, we pondered when we found that California 
                          and Texas had relatively high numbers of people with cancer. 
                          Both states have in common one of the most populous and economically 
                          developed regions in the United States, which may also be a large part of the distribution difference.')),
                          h3("Implications:"),
                          p("The distribution from the chart above shows that a large number of people 
                            in all states of the United States have cancer and a large number of people die 
                            of cancer every year. Therefore, cancer will be a topic that should be taken 
                            seriously and discussed now and in the future. From the previous graphs and conclusions, 
                            we have concluded that women have a high prevalence of breast cancer; 
                            hence, the government of the United States–especially in California and Texas–needs 
                            to urge women to have regular checkups and medical examinations. 
                            The relatively high prevalence of liver cancer in men requires good lifestyle habits, 
                            less alcohol abuse, etc. Such data can give our audience a macroscopic concept of the 
                            population distribution of cancer, and in the future, it may be possible to explore 
                            in depth more factors that may lead to higher cancer incidence, as well as more 
                            types of cancer that show prevalence in the population according to gender, race, and age."),
                          h3("Data Quality:"),
                          p("Since our data comes from the CDC database, 
                            we believe it gives us unbiased results. The data strictly focus on and report how much 
                            of the U.S. population is affected by cancer. We did not see any issues in the data that 
                            could harm certain populations. However, a possible data issue is that we only selected 
                            data from the period 2009-2018, which could reach more accurate conclusions 
                            if we selected relatively more recent years."),
                          h3("Limitations:"),
                          p("While there were efforts to include all statistics on cancer incidences by the U.S. 
                            Cancer Statistics (USCS) database, it is an inevitable fact that it is 
                            impossible to include all cases mainly due to privacy issues and errors. 
                            Although the CDC database gives unbiased results, there could be many possibilities 
                            where the cancer incidence/cases aren’t properly–or mistakenly–reported. 
                            This type of coverage error could potentially lead to biased results."),
                          h3("Future Ideas:"),
                          p("Through this project, we aim to make healthcare professionals associated 
                          with cancer research aware of the changing trends in cancer and the 
                          distribution of the number of people with the disease over the years. 
                          As the number of cancer patients within the United States continues to increase, 
                          we would like to see medical treatments or policies to improve the incidence of cancer. 
                          It is also important in reminding residents in different areas to get regular checkups. 
                          In the future, more attention can be paid to the causative factors in areas with high cancer 
                          incidence to find associations and make changes.")
                 )
                 
)


server <- function(input, output) {
  
  # First Page: Introduction
  output$home_img <- renderImage({
    
    list(src = "medical.jpeg",
         width = "100%",
         height = 400)
    
  }, deleteFile = F)
  
  
  # Second Page: Linear Plot
  output$cancerIplot <- renderPlot({
    
    if (input$plotchoice == "Trend_plot"){
      cancerI %>%
        filter(sex %in% input$sex) %>%
        filter(time >= input$time_range[1],
               time <= input$time_range[2]) %>%
        group_by(position) %>%
        ggplot(aes(time, population, group = position, color = factor(position))) +
        labs(x = "Time", y = "Population of cancer", color = "Different body position") +
        geom_line() +
        geom_point() +
        ggtitle("Trend Plot of Cancer Population by Body Position over Time")
    }
    else {
      cancerI %>% 
        filter(sex %in% input$sex) %>%
        filter(time >= input$time_range[1],
               time <= input$time_range[2]) %>%
        group_by(position) %>%
        ggplot(aes(time, population, group = position, color = factor(position))) +
        labs(x = "Time", y = "Population of cancer", color = "Different body position") +
        geom_point() + 
        ggtitle("Scatter Plot of Cancer Population by Body Position over Time")
    }
  })
  
  output$linedata <- renderText({
    paste("For cancer cases reported in female and male populations, 
          the data clarifies which types of cancer have the most significant impact on people 
          and whether gender or region has a relationship with its prevalence. Breast cancer 
          had the highest incidence in the female population; as for the male population, 
          liver cancer had the highest incidence. Throat cancer was the least prevalent cancer, 
          with the lowest rates in both females and males. The average breast cancer population is 
          always around 20,000 in the range of one year. From 2009 to 2018, the trend of female breast 
          cancer increased. In contrast, the other three segments are relatively flat. For men, 
          liver and larynx cancers have been declining since 2013. The trend for breast 
          cancer is flat, and myeloma shows a relative increase.")
  })
  
  
  # Third Page: Pie chart
  output$pie_plot <- renderPlot({
    
    filtered <- cancer_result %>%
      filter(Time %in% input$year) %>%
      filter(Gender %in% input$gender) %>%
      group_by(Site) %>%
      summarize(sum_incidence = sum(Incidence, na.rm = TRUE), .groups = 'drop')
    
    ggplot(filtered, aes(x = "", y = sum_incidence, fill = Site)) +
      geom_bar(width = 1, stat = "identity") +
      coord_polar(theta = "y") +
      scale_fill_viridis_d() +
      theme_void() +
      ggtitle("Population Distribution by Site") +
      geom_text(aes(label = paste0(round(sum_incidence/sum(filtered$sum_incidence)*100), "%")), 
                position = position_stack(vjust = 0.5))
    
  })
  
  output$pietext <- renderText({
    paste("Based on the pie chart, we were able to find out that breast cancer is 
          most prevalent among the female population by an average of 92 percent. 
          As for the male population, we found out that liver cancer was most prevalent, 
          whereas–compared to the female population–breast cancer was rare. 
          The overall trend in the percentage of cancers affecting each gender 
          stayed consistent throughout time. ")
  })
  
  # Fourth Page: Choropleth map
  output$choropleth <- renderPlot({
    cancer_map <- cancer_result %>%
      filter(Time %in% input$time_table) %>%
      group_by(State) %>%
      summarize(total_incidence = sum(Incidence),
                total_mortality = sum(Death))
    
    state_map <- us_map(regions = "states") %>%
      left_join(cancer_map, by = c("full" = "State"))
    
    if (input$rate == "Incidence") {
      ggplot(state_map, aes(x, y, group = group)) + 
        geom_polygon(aes(fill = total_incidence)) + 
        coord_quickmap() +
        labs(x = "Longitude", y = "Latitude") +
        ggtitle("Total Incidence over US regions")
      
    } else {
      ggplot(state_map, aes(x, y, group = group)) + 
        geom_polygon(aes(fill = total_mortality)) + 
        coord_quickmap() +
        labs(x = "Longitude", y = "Latitude") +
        ggtitle("Total Mortality over US regions")
    }
  })
  
  output$chotext <- renderText({
    paste("From the Choropleth chart, we can see the regional distribution (by US states). 
    With this graph, we found a direct relationship between the total morbidity 
    in each US state and the total mortality in each US state. Also, California and 
    Texas have higher morbidity and mortality rates than other regions. Most northern 
    areas also have relatively lower numbers of people with the disease.")
  })
  
  # Final Page: Conclusion
  output$final_img <- renderImage({
    
    list(src = "choro_plot.png",
         width = "50%",
         height = 400)
    
  }, deleteFile = F)
  
  
}


# Run the application 
shinyApp(ui = ui, server = server)
