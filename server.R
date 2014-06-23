####################################
#### Lasso Penalty Example - server.R ###
####################################

#Packages
library(shiny)
library(ggplot2)
library(ISLR)
library(caret)
library(lattice)
library(elasticnet)
library(lars)

# Load complete cases of the data
hitterSal <-  Hitters[complete.cases(Hitters),19]
hitterStats <- Hitters[complete.cases(Hitters),-19] 



# Scale numeric variables
integer <- sapply(hitterStats, is.integer)
scaledvars <- apply(hitterStats[,integer],2,function(x){
        (x-mean(x))/(2*sd(x))})
hitterStats  <- data.frame(scaledvars,hitterStats[,!integer])

#Add 6 noise variables
set.seed(5652)
hitterStats <- data.frame(hitterStats,
                          Fake1=rnorm(263,0,0.5),
                          Fake2=rnorm(263,0,0.5),
                          Fake3=rnorm(263,0,0.5),
                          Fake4=rnorm(263,0,0.5),
                          Fake5=rnorm(263,0,0.5),
                          Fake6=rnorm(263,0,0.5))

hitterStats1  <- model.matrix(hitterSal~.-1,data=hitterStats)

# Train Model
trcontrol <- trainControl(method="cv",number=10)
lassoGrid <- expand.grid(fraction=seq(.1,1,by=0.01))
lassoTrained <- train(x=hitterStats1,
                      y=hitterSal,
                     method="lasso",
                     tuneGrid=lassoGrid,
                     trControl=trcontrol)

lassoTrained
penGraph <- ggplot(lassoTrained)

# Server is defined within these parentheses
shinyServer(function(input, output) {
        #Code for first graph
  output$fractionPlot <- renderPlot({theGraph <- penGraph+
                                           geom_vline(xintercept=input$frac)
        
        print(theGraph+ggtitle("Model Accuracy vs Fraction of Full Model Used")+
                       ylab("Cross-validated RMSE (1000s of Dollars)")+
                       theme(axis.title.x = element_text(size=13),
                             axis.title.y= element_text(size=13)))})
        #Code for second graph
        output$barchart <- renderPlot({bar <- ggplot(data=data.frame(
                                                prediction=predict(lassoTrained$finalModel,
                                                                   s=input$frac,mode="fraction",
                                                                   type = "coefficients")$coefficients,
                                                names=names(predict(lassoTrained$finalModel,
                                                                    s=input$frac,mode="fraction",
                                                                    type = "coefficients")$coefficients)),
                                                     aes(x=names,y=abs(prediction)))+
                                               geom_bar(stat="identity")
        print(bar+ylab("Coefficient Absolute Value") +scale_y_continuous(limits=c(0,1000))+
                                                      xlab("")+
                                                      theme(axis.text.x = element_text(angle = 45,
                                                                                       hjust = 1,
                                                                                       face="bold",
                                                                                       size=13),
                                                           axis.title.y= element_text(size=13))+
                                                     ggtitle("Magnitude of Each Coefficient"))})
})

