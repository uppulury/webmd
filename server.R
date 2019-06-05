library(ggplot2)

Webmd_sub <- read.csv("Webmd_sub.csv",sep='\t')
Supplement_unique = unique(Webmd_sub$Supplement)

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

var = c(1,5,9)
#k:1(EaseOfUse),k:2(Satisfaction),k:3(Effectiveness)
k = 3
Webmd_sub_new$Response = Webmd_sub_new[1:nrow(Webmd_sub_new),var[k]]
Rvar = colnames(Webmd_sub_new)[var[k]]
  
server <- function(input,output) {
  
  output$Figure1 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput)
    
    fig1 = ggplot(data=filtered,aes(EaseOfUse))+geom_histogram()+ggtitle(paste0("EaseOfUse","\n",input$SupplementInput))
    fig1
  #  figinset = ggplot(data=filtered,aes(EaseOfUse))+geom_histogram()
  #  fig1+annotation_custom(ggplotGrob(figinset),xmin=1,xmax=3,ymin=20,ymax=40)
  })
  
  output$Figure2 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput,
             Gender==input$GenderInput)
    ggplot(data=filtered,aes(EaseOfUse))+geom_histogram()+ggtitle(paste0("EaseOfUse","\n",input$SupplementInput,"\n",input$GenderInput))
  })
  
  output$Figure3 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput,
             Gender==input$GenderInput,
             Age==input$AgeInput)
    ggplot(data=filtered,aes(EaseOfUse))+geom_histogram()+ggtitle(paste0("EaseOfUse","\n",input$SupplementInput,"\n",input$GenderInput,"\n",input$AgeInput))
  })
  
  output$Figure4 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput)
    ggplot(data=filtered,aes(Effectiveness))+geom_histogram()+ggtitle(paste0("Effectiveness","\n",input$SupplementInput))
  })

  output$Figure5 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput,
             Gender==input$GenderInput)
    ggplot(data=filtered,aes(Effectiveness))+geom_histogram()+ggtitle(paste0("Effectiveness","\n",input$SupplementInput,"\n",input$GenderInput))
  })
  
  output$Figure6 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput,
             Gender==input$GenderInput,
             Age==input$AgeInput)
    ggplot(data=filtered,aes(Effectiveness))+geom_histogram()+ggtitle(paste0("Effectiveness","\n",input$SupplementInput,"\n",input$GenderInput,"\n",input$AgeInput))
  })
  
  output$Figure7 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput)
    ggplot(data=filtered,aes(Satisfaction))+geom_histogram()+ggtitle(paste0("Satisfaction","\n",input$SupplementInput))
  })
   
  output$Figure8 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput,
             Gender==input$GenderInput)
    ggplot(data=filtered,aes(Satisfaction))+geom_histogram()+ggtitle(paste0("Satisfaction","\n",input$SupplementInput,"\n",input$GenderInput))
  })
  
  output$Figure9 <- renderPlot({
    filtered <-
      Webmd_sub_new %>%
      filter(Supplement==input$SupplementInput,
             Gender==input$GenderInput,
             Age==input$AgeInput)
    ggplot(data=filtered,aes(Satisfaction))+geom_histogram()+ggtitle(paste0("Satisfaction","\n",input$SupplementInput,"\n",input$GenderInput,"\n",input$AgeInput))
  })
}
  
  