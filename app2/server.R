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

df = data.frame(UReason_ordered,nrev_ordered)
  
server <- function(input,output) {
  output$Table1 <- DT::renderDataTable({
    filtered <-
      Webmd_sub_new %>%
      filter(Reason==input$ReasonInput)
    DT::datatable(filtered)
  })
  output$Table2 <- DT::renderDataTable({
    filtered <-
      Webmd_sub_new %>%
      filter(Reason==input$ReasonInput)
    filtered_unique_suppl = unique(filtered$Supplement)
    filtered_unique_suppl_reviews = c()
    for (i in 1:length(filtered_unique_suppl)) {
      rev_ind = length(which(filtered$Supplement==filtered_unique_suppl[i]))
      filtered_unique_suppl_reviews = append(filtered_unique_suppl_reviews,rev_ind)
    }
    Suppl_top = filtered_unique_suppl[order(filtered_unique_suppl_reviews,decreasing = TRUE)]
    Suppl_Rev_top = filtered_unique_suppl_reviews[order(filtered_unique_suppl_reviews,decreasing = TRUE)]
    TopSuppl = data.frame(Suppl_top,Suppl_Rev_top)
    
    DT::datatable(TopSuppl)
  })
}
  
  