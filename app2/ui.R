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

#Number of Pathology Conditions
UReason = unique(Webmd_sub_new$Reason)
#Define Number_of_reviews for each Condition
nrev = c()
#Calculate Number_of_reviews for each Condition
for (i in 1:length(UReason)) {
  nrev = append(nrev,length(which(Webmd_sub_new$Reason==UReason[i])))
}
 
UReason_ordered = UReason[order(nrev,decreasing = TRUE)]
nrev_ordered = nrev[order(nrev,decreasing = TRUE)]
  
  
ui <- fluidPage(
  titlePanel("WebMD"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("ReasonInput", "Reason",
                   choices = UReason_ordered[1:50])
      ),
    mainPanel(
      tabsetPanel(
        tabPanel(DT::dataTableOutput("Table1")),
        tabPanel(DT::dataTableOutput("Table2"))
      )
      
    )
  )
)