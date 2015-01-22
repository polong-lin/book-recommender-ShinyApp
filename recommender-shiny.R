#setwd("/Users//polong//Dropbox/DataSci Projects//book-rating-recommender-system")

data <- readRDS("data.rds")
books <- readRDS("books.rds")
results <- readRDS("results_top100.rds")
booklist <- readRDS("booklist.rds")


## Goal: Recommend a new book ####
# We will recommend a new book based on the ratings from common reviewers. (aka Collaborative Filtering)

# Create a function that capitalizes the first word of each word in a sentence
simpleCap <- function(x) {
    s <- strsplit(x, " ")[[1]]
    paste(toupper(substring(s,1,1)), substring(s,2),
          sep = "", collapse=" ")
}

# Create a function that returns the Book Title given an ISBN

book_isbn_to_title <- function(isbn) {
    if(class(isbn) == "numeric") {
        stop("ISBN must be in quotations")
    }
    books[books$ISBN == isbn,]$Book.Title
}

#book_isbn_to_title(0971880107)
# book_isbn_to_title("0971880107")


book_title_to_isbn <- function(title) {
    title <- simpleCap(tolower(title)) #Capitalize first letter of each word
    # If book not found:
    len <- length(books[suppressWarnings(grep(title, books$Book.Title)),]$ISBN)
    if(len == 0){
        stop("Book title not found")
    } else if(len > 1){
        #cat("More than one title found. <Need to fix>")
        books[suppressWarnings(grep(title, books$Book.Title)),][1,]$ISBN #takes the first result
    }
    books[suppressWarnings(grep(title, books$Book.Title)),]$ISBN
}

# Debug:
# book_title_to_isbn("Decision in Normandy") #should return ISBN
# book_title_to_isbn("Decision in Normand") #incomplete title
# book_title_to_isbn("Decision in Normandya") #spelling mistake
# book_title_to_isbn("Classical Mythology") #should return two books, select choice

# Create a function that returns a vector of ratings of a book from a vector of common users
get_reviews <- function(isbn, common_users) {
    #subset data by specified ISBN
    #subset data further by looking up user
    data.subset_isbn <- subset(data, ISBN == isbn)
    as.numeric(data.subset_isbn[data.subset_isbn$User.ID %in% common_users,]$Book.Rating)
}

# a <- subset(data, ISBN == "0971880107")
# a[a$User.ID %in% c("276925", "277427"),]$Book.Rating
# str(c("277378"))
# str(common_reviewer_by_isbn("0971880107", "0316666343"))

# Create a function that returns a dataframe of ratings from the same reviewers given two ISBNs

common_reviewer_by_isbn <- function(isbn1, isbn2) {
    reviews1 <- subset(data, ISBN == isbn1)
    reviews2 <- subset(data, ISBN == isbn2)
    
    reviewers_sameset <- intersect(reviews1[,'User.ID'],
                                   reviews2[,'User.ID'])
    if(length(reviewers_sameset) == 0){
        NA
    } else {
        reviewers_sameset
    }
}

#common_reviewer_by_isbn("0971880107", "0316666343")


# Create a function that calculates the similarity in ratings between two ISBNs

calc_similarity <- function (isbn1, isbn2) {
    common_users <- common_reviewer_by_isbn(isbn1, isbn2)
        if(suppressWarnings(is.na(common_users))){
            return (NA)
        }
    isbn1.reviews <- get_reviews(isbn1, common_users)
    isbn2.reviews <- get_reviews(isbn2, common_users)
    #print(data.frame(isbn1_ratings = isbn1.reviews, isbn2_ratings = isbn2.reviews))
    cor(isbn1.reviews, isbn2.reviews)
}
# isbn1 <- "0971880107"
# isbn2 <- "0316666343"
# 
# book_isbn_to_title("0971880107")
# book_isbn_to_title("0316666343")

# calc_similarity(isbn1, isbn2)


find_similar_books <- function(mybook, style = NULL, n = 5){
    if(suppressWarnings(is.na(as.numeric(mybook)) == TRUE)){  #If mybook is a book title:
        myisbn <- book_title_to_isbn(title = mybook)
    }
    
    similar <- subset(results, isbn1 == myisbn)
    similar <- merge(books, similar, by.x = "ISBN", by.y = "isbn2")
    similar <- similar[order(-similar$sim),]
    n <- min(n, nrow(similar))
    similar <- similar[1:n, c(1:5, 7)]
    similar
}


