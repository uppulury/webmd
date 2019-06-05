library(shiny)
library(ggplot2)
library(dplyr)
library(ggmap)

Webmd_sub <- read.csv("Webmd_sub.csv",sep='\t')
Supplement_unique = unique(Webmd_sub$Supplement)
Gender_unique = unique(Webmd_sub$Gender)

UA = unique(Webmd_sub$Age)
#Find All Rows that match with UA[10] and UA[c(12:43)]
UAindex = UA[c(10,12:43)]
Deleterows = c()
for (i in 1:length(UAindex)) {
  index = which(Webmd_sub$Age==UAindex[i])
  Deleterows = c(Deleterows,index)
}
#Delete Rows
Webmd_sub_new = Webmd_sub[-c(Deleterows),]
Age_unique = unique(Webmd_sub_new$Age)
Supplement_selected = unique(Webmd_sub_new$Supplement[order(-Webmd_sub_new$NReviews)])[1:25]

var = c(1,5,9)
#k:1(EaseOfUse),k:2(Satisfaction),k:3(Effectiveness)
k = 1
Webmd_sub_new$Response = Webmd_sub_new[1:nrow(Webmd_sub_new),var[k]]

ui <- fluidPage(
  titlePanel("WebMD"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("GenderInput", "Gender",
                   choices = Gender_unique),
      radioButtons("SupplementInput", "Supplement",
                   choices = Supplement_selected),
      radioButtons("AgeInput", "Age",
                   choices = Age_unique)
      ),
    mainPanel(
      plotOutput("Figure1"), br(), br(),
      plotOutput("Figure2"), br(), br(),
      plotOutput("Figure3"), br(), br(),
      plotOutput("Figure4"), br(), br(),
      plotOutput("Figure5"), br(), br(),
      plotOutput("Figure6"), br(), br(),
      plotOutput("Figure7"), br(), br(),
      plotOutput("Figure8"), br(), br(),
      plotOutput("Figure9")
     
    )
  )
)