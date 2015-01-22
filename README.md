# book-recommender-ShinyApp

Input a bookname, and it will generate a sorted list of other books that other reviewers rated as well


## Have you ever wanted to find a new book but didn't know which one to get?

## Use this app and find out new books to read!

### How the app works:

You input the name of a book (MyBook)that you have previously enjoyed, and the app will return a list of books (Book A, B, C) that others have read as well. A "sim" score is produced which is a simple correlation score (between -1 and 1) between the ratings of common reviewers for {MyBook and Book A}, {MyBook and Book B}, {MyBook and Book C}. The app sorts the books (A, B, C) by "sim" in decreasing order. A high "sim" (e.g., 0.5 to 1.0) indicates that those who read both books rated them very similarly. A negative "sim" indicates that those who read both books rated them in opposite ways (e.g., high ratings for MyBook but low ratings for Book X). A "sim" close to zero indicates that a strong relationship between the ratings of both books were unobserved.

### Data Source:
#### The data was taken from:

-http://www2.informatik.uni-freiburg.de/~cziegler/BX/

-Improving Recommendation Lists Through Topic Diversification,
Cai-Nicolas Ziegler, Sean M. McNee, Joseph A. Konstan, Georg Lausen; Proceedings of the 14th International World Wide Web Conference (WWW '05), May 10-14, 2005, Chiba, Japan. To appear.

- Collected by Cai-Nicolas Ziegler in a 4-week crawl (August / September 2004) from the Book-Crossing community with kind permission from Ron Hornbaker, CTO of Humankind Systems. Contains 278,858 users (anonymized but with demographic information) providing 1,149,780 ratings (explicit / implicit) about 271,379 books.
- data was mined by Cai-Nicolas Ziegler, DBIS Freiburg

#### Recommender System Tutorial
A tutorial on building recommender systems that this app was based upon, can be found at:
blog.yhathq.com/posts/recommender-system-in-r.html
