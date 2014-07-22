# Course Project of Developing Data Products course
# Shiny Application, server.R


library(shiny)
library(datasets)

# load mtcars dataset
data(mtcars)

# convert the am variable into factor variable
mtcars$am <- as.factor(mtcars$am)

# linear regression model with mpg as an outcome that includes authomatic or manual 
# transmission as a factor variable and weight as a confounder and an interaction term 
# b/n transmission and weight. 
fit <- lm(mpg ~ wt + am  + am*wt, data = mtcars) 
summary(fit)$coef

# define server logic required to 
# 1) plot mpg agaist transmission or weight
# 2) predict mpg based on user's input of transmission and weight
# 3) create supporting documentation

shinyServer(
        function(input, output) {
                
                # formulaText is a reactive expression to be used
                # by the output$caption and output$mpgPlot functions
                formulaText <- reactive({ paste("mpg ~ ", input$variable)})
                
                # Return the formulaText for printing as a caption
                output$caption <- renderText({paste("Explorotory plot of", formulaText())})
                
                # Use the formulaText to generate a plot mpg ~ requested variable
                output$mpgPlot <- renderPlot({
                        plot(as.formula(formulaText()), data = mtcars, 
                             xlab = input$variable, ylab = "mpg", 
                             pch = 19, col = "blue")
                })
                # predict mpg based on user's input of transmissiona and weight 
                am <- reactive(as.numeric(input$transmission))
                wt <- reactive(input$weight)
                prediction <- reactive(as.numeric(coef(fit)[1] + coef(fit)[2]*wt() + coef(fit)[3]*am() + coef(fit)[4]*wt()*am()))
                output$prediction <- renderPrint({prediction()})
                par(mfrow = c(1,1))
                # plot predicted mpg
                output$fitPlot <- renderPlot({
                plot(mtcars$wt, mtcars$mpg, pch=19, col=mtcars$am, xlab = "weight (lb/1000)", ylab = "mpg")
                abline(c(fit$coeff[1], fit$coeff[2]),col="black",lwd=3)
                abline(c(fit$coeff[1] + fit$coeff[3], fit$coeff[2] + fit$coeff[4]),col="red",lwd=3)
                lines(c(wt(), wt()), c(10, prediction()), col = "blue", lwd = 3, lty = "dashed")
                points(wt(), prediction(), col = "blue", pch = 25, bg = "blue", cex = 1.8)
                legend("topright", pch = 19, col = c("black","red"), legend = c("automatic transmission", "manual transmission"))
                })
                # documentation
                documentationText <- as.character("The Car's Explorer application is created to help car's users to investigate the question: Is an automatic or manual car transmission better for miles per gallon (mpg)?.
To address this question the Shiny application uses the mtcars datasets in R.
The application has two parts:
 - Part I: Explore car's mpg allows the user to explore mpg vs. transmission or weight.
     - User's input: transmission or weight (via select box at the left side bar)
     - App's output: plot of mpg vs. user's input (explore tab) 
 - Part II: Predict car's mpg allows the user to predict mpg for user's choice of transmission and weight.
     - User's input: transmission (via radio buttons) and weight (via numeric box)
     - App's output: Linear regression model prediction + plot with blue arrow dashed line (predict tab)  
The embedded linear regression model for predicting mpg includes automatic/manual transmission as a factor variable, weight as a confounder and the interaction between transmission and weight. ")

                output$documentation <- renderText({documentationText})
                
           
        }
)

