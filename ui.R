###############################
### Lasso Penalty Example - ui.R ###
###############################

library(shiny) 

shinyUI(pageWithSidebar( 
  
  headerPanel("Modeling Baseball Salary with Different Lasso Penalties"),
  
  sidebarPanel(
    sliderInput(inputId = "frac",
                label = "Fraction of Full Solution",
                min = 0,
                max = 1,
                value = 1,
                step = 0.05),
    br(),
     p("This simple app demonstrates the benefit of adding a lasso penalty to a predictive
      model (if you are unfamiliar with penalized models, I suggest reading 'Elements of Statistical 
      Learning', which can be found free online)."),
    p("I used the Hitters dataset avaible in the R package 
      'ISLR' and built a linear model to predict player salary. I added 6 random noise 
      variables to the model to demonstrate the benefits of a lasso penalty."),
    p("Without the lasso penalty (Fraction of Full Solution=1), the model includes these noise
      variables in the model, eventhough we know they have no predictive ability.  This causes the model to
      overfit the data, and become less accurate. By adding a lasso penalty we can reduce overfitting, by 
      penalizing a model for the inclusion of unnecesary predictors."),
    p("An in-depth explanation of how the lasso penalty accomplishes this is outside the scope of this app, 
      but is well-documented in the ESL book I refered to earlier.  In short though, when minimizing the sum of squared
     error, a factor of the sum of the absolute value of the coefficients is added to the equation, meaning that in addition, to minimizing
     the SSE, the best model will also minimize the coefficients of the predictors."),
    p("The slider allows you to choose how penalized the model is. A fraction of 0.5, for example,
      means that the sum of the absolute value of the penalized coefficients will be 50% of the sum of the absolute
      value of the unpenalized coefficients.  Therefore setting the slider to 0, forces all coefficients to 0, and
      a fraction of 1, removes the penalty entirely.  The best model had a fraction of 0.15. Compare how small
      and sparse the coefficients in this penalized model are to the full model.  Also note, that the penalized model 
      did what we hoped and forced the random noise coefficients to 0.")
    
    
  ),
  mainPanel(
    h3("Reduce Model Error By Penalizing Overfitting"),
      plotOutput("fractionPlot"),
    plotOutput("barchart")
    )))