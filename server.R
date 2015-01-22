library(shiny)
library(plyr)
# setwd("/Users//polong//Dropbox/DataSci Projects//book-rating-recommender-system/ShinyApp/")

data <- readRDS("data.rds")
books <- readRDS("books.rds")
results <- readRDS("results_top50.rds")
booklist <- readRDS("booklist.rds")

source("recommender-shiny.R")

shinyServer(
    function(input, output) {
        output$oUserInput <- renderText({
            if(input$submitButton == 0){
                return()
            }
            if(is.numeric(input$sentenceInputVar)){
                stop("Please use a non-numeric input.")
            }
            title <- simpleCap(tolower(input$sentenceInputVar)) #Capitalize first letter of each word
            search_result <- books[suppressWarnings(grep(title, books$Book.Title)),][1,]
            paste0("'",search_result$Book.Title, "' by ",
                          search_result$Book.Author, " (",
                          search_result$Year.Of.Publication, ")") #takes the first result
        })
        
        output$oRecommendationsFor <- renderText({
            if(input$submitButton == 0){
                return()
            }
            paste("Recommendations for:")
        })
        
        output$oResults <- renderTable({
            if(input$submitButton == 0){
                return()
            }
            if(is.numeric(input$sentenceInputVar)){
                stop("Please use a non-numeric input.")
            }
            #results <- isolate(cat(find_similar_books(input$sentenceInputVar)))
            isolate(result <- find_similar_books(input$sentenceInputVar))
            isolate(result)
        })
        
        output$oSimExplanation <- renderText({
            if(input$submitButton == 0){
                return()
            }
            isolate(paste("'sim' represents the similarity to your book and is between -1.0 and 1.0. A high sim means that if you enjoyed your book, you'll enjoy this one too. A negative sim means you should probably avoid it!"))
        })
    }
)
