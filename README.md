# BookHarbour Planning Document

## 1. Overview

### 1.1. Vision Statement
The app aims to provide a virtual bookshelf where users
can efficiently manage their e-books, track reading progress, and personalize their reading
preferences. Its main three functions are to display books on a bookshelf, allow the user to readbooks they select, and offer more sorting capabilities such as by tag.

### 1.2. Target Audience
The Target Audience is readers who feel that their digital reading experience is lacking the customizability that reading physical books has. Therefore, it is aimed at all readers but mainly those of the 16-35 year old women demographic.

## 2. Features

### 2.1. Core Features


1. **Feature 1:** _Bookshelf Interface_

     - Display books on a virtual bookshelf with cover images
  
     - Have an intuitive UI for users to scroll through and visually locate books.
  
     - Have a button bar or area including some way for users to quickly access the sorting options

  
2. **Feature 2:** _Ability to read Epubs_

     - Integrate a built-in e-reader for users to read books from within the app
  

3. **Feature 3:** _Associate tags with Epubs and be able to customize how the user sorts their books_



### 2.2. Additional Features
Identify and describe any secondary features that enhance the user experience or provide additional functionality.

1. **Feature 4:** _Read time tracking_

     - Record reading start and end times
  
     - Track total reading duration for each book.

  
2. **Feature 5:** _Adding and storing reviews_

     - Allow users to leave reviews and star ratings for each book
  
     - Display their average ratings on the book modal pages

  
4. **Feature 6:** _Ability to edit and change what data is shown about each book (cover image, description, title, etc.)_
5. **Feature 7:** _Sort books by author, title, tags, etc._

     - Sort books by genre, author, rating, read status, etc.
  
     - Allow users to tag books for personalized organization
  
     - Implement search functionality for quick book retrieval
  
6. **Feature 8:** _Loading screens_
7. **Features 9:** _Remove duplicates of books_

## 3. User Stories

### 3.1. User Roles
Define different user roles and their responsibilities within the application.

1. **User Role 1:** _A casual user wanting to see more information, such as the synopsis and if they had read the book before, about their book of choice_
2. **User Role 2:** _A reader with a large quantity of books who wants to find specific books with certain attributes such as books with fantasy or the "enemies-to-lovers" trope_
3. **User Role 3:** _A reader who wants to read their ebook_

### 3.2. User Stories

- **User Story 1:** _As a casual user, I want to be able to see more information about the book I choose so I can choose and read a book of choice quicker than I would if I only saw the title_
- **User Story 2:** _As a reader, I want to be able to find my book and read it all in the same place so I don't have to open multiple apps to get the same information._
- **User Story 3:** _As a hardcore reader, I want to be able to sort and organize my books by trope, genre, or other attribute so I can find books quicker instead of wasting time digging through my books._

## 4. Data Model

### 4.1. Entities
Identify the key entities and their attributes that your application will manage.

1. **Entity 1:** _Ebooks_
	a. ***Attribute 1:*** _title_
	a. ***Attribute 2:*** _author_
	a. ***Attribute 3:*** _bookUID_
	a. ***Attribute 4:*** _coverImgPath_
	a. ***Attribute 5:*** _epubPath_
	a. ***Attribute 6:*** _id_
	a. ***Attribute 7:*** _opfFilePath_
	a. ***Attribute 8:*** _opfFileURL_
	a. ***Attribute 9:*** _synopsis_
	a. ***Attribute 10:*** _timeRead_
	a. ***Attribute 11:*** _tags_ <- one-to-many link to BookTags
	a. ***Attribute 12:*** _reviewLink_ <- one-to-many link to Reviews

2. **Entity 2:** _BookTags_
	a. ***Attribute 1:*** _id_
	a. ***Attribute 2:*** _name_
	a. ***Attribute 3:*** _bookTagsRelationship_ <- one-to-many link to Ebooks

3. **Entity 3:** _Reviews_
	a. ***Attribute 1:*** _reviewContent_
	a. ***Attribute 2:*** _reviewDateFinished_
	a. ***Attribute 3:*** _reviewDateStarted_
	a. ***Attribute 4:*** _reviewTitle_
	a. ***Attribute 5:*** _reviewRating_
	a. ***Attribute 6:*** _reviewToBook_ <- one-to-one link to Ebooks

### 4.2. Relationships
Define the relationships between different entities.

1. **Relationship 1:** _Ebooks -> BookTags : oneToMany = tags_
3. **Relationship 3:** _Ebooks -> Review : oneToOne = reviewLink_
2. **Relationship 2:** _BookTags -> Ebooks : oneToMany = bookTagsRelationship_
3. **Relationship 3:** _Review -> Ebooks : oneToOne = reviewToBook_

## 5. Technology Stack

### 5.1. Frontend
Specify the technologies and frameworks you plan to use for the user interface.

- **UI Framework:** _SwiftUI, Webkit, UIKit_
- **State Management:** _[Library]_
- **Other Frontend Tools:** _[Tools]_

### 5.2. Backend
Specify the technologies and frameworks for server-side development.

- **Backend Framework:** _SSZipArchive, SwiftSoup, SWXMLHash_
- **Database:** Core Data
- **API Documentation:** _[Tool]_

### 5.3. Deployment and Infrastructure
Outline your deployment strategy and the infrastructure required.

- **Hosting Service:** _[Service]_
- **Scalability Plan:** _[Description]_
- **Monitoring Tools:** _[Tools]_

## 6. User Interface (UI) Design

### 6.1. Wireframes
Create wireframes or mockups for key screens in your application.

1. **Screen 1:** _[Description]_
2. **Screen 2:** _[Description]_
3. **Screen 3:** _[Description]_

### 6.2. User Flow
Define the flow of actions users will take within the application.

- **User Flow 1:** _[Adding books to the library]_
- **User Flow 2:** _[Adding tags and reviews]_
- **User Flow 3:** _[Sorting books in library]_
- **User Flow 3:** _[Reading the book]_
- **User Flow 3:** _[Editing book attributes]_
- **User Flow 3:** _[Resetting the books you have loaded]_
- **User Flow 3:** _[Description]_
- **User Flow 3:** _[Description]_



## 7. Development Roadmap

### 7.1. Milestones
Break down the development process into key milestones.

1. **Milestone 1:** Create Custom Epub Parsing Functionality
2. **Milestone 2:** Create Bookshelf, EPUB Selection Display, and Reading Ability
3. **Milestone 3:** Create User Customization Features (Tags, Reviews, etc.)

#### 7.1.1. Additional Future Features
These features are features that I'd like to get to if I have time after finishing the above milestones.

1. Custom bookshelf builder: the ability for a user to organize all of their books on a physical bookshelf if they'd like to. Could have additional props, such as fake plants or pictures, should time allow.

2. More tools for reading (a table of contents, highlighting/bookmarking and ability to view all of these in one book in one place, page count at the bottom of the page, ability to turn pages, customizing the look of the page and fonts used, etc.)

3. Integration with GoodReads

### 7.2. Release Plan
Specify the planned release dates for each version or major feature.

- **Version 1.0 Release Date:** _[Date]_
- **Feature X Release Date:** _[Date]_
- **Feature Y Release Date:** _[Date]_

## 8. Testing Strategy

### 8.1. Test Types
Identify the types of testing you will conduct.

- **Unit Testing**
- **Integration Testing**

### 8.2. Testing Tools
Specify the tools and frameworks you will use for testing.

- **Unit Testing Framework:** _[Framework]_
- **End-to-End Testing Tool:** _[Tool]_
- **Code Quality Analysis:** _[Tool]_

## 9. Security Considerations

### 9.2. Data Security
There will be no sensitive data asked for by the application. The only data collected by this application are the ebook metadata and the storage location of the files. This data will be stored and will remain persistent to ensure user fluidity and ease-of-access.

- **Encryption Standards:** _[Standards]_
- **Data Backup and Recovery Plan:** _[Plan]_

## 10. Project Management

### 10.1. Team Structure
Define the roles and responsibilities of team members.

1. **Product Owner:** _Summer Gasaway_
2. **Development Team:** _Summer Gasaway_
3. **Testing Team:** _Summer Gasaway_

### 10.2. Communication Plan
Specify communication channels and frequency.

- **Issue Tracking:** _GitHubIssues_

## 12. Legal and Compliance

### 12.1. Licensing
Choose and specify the license under which your application will be released.

- **License Type:** _[License]_
- **Open Source Dependencies:** _[List]_

### 12.2. Compliance
Ensure compliance with legal requirements and industry standards.

- **Data Protection Compliance:** _[Details]_
- **Accessibility Standards:** _[Details]_

## 13. Documentation

### 13.1. Internal Documentation
Plan for documenting code, APIs, and infrastructure for internal use.

- **Code Comments:** _[Standards]_
- **API Documentation Standards:** _[Standards]_

### 13.2. External Documentation
Outline plans for user documentation and help resources.

- **User Guides:** _[Format]_

## 14. Conclusion

### 14.1.

 Summary
Summarize the key points from each section.

### 14.2. Next Steps
Define the immediate next steps in the development process



## Progress Log

----CURRENT TASK-----

LAST UPDATED: 23/02/2024

- implement more of Jules' bookshelf idea

----TODO----

HIGH PRIORITY:
- loading pop up for when the books are loading in
- save position that reader was last at in the book


MEDIUM PRIORITY:
- how to group books of the same series
- some books are not loading in (they might be throwing errors but are not being tracked)


LOW PRIORITY:
- go through and remove duplicates (have it look back through the books and do this?)
- make it all look pretty
- rating system (first by numbers then by clicking stars like good reads)
- shrink the pop up a little bit
- have it blur the background when a title is clicked
- stretch the book cover holding to be the size of the normal book covers 
- tap the back button to actually go back
- be able to have a drop down with all of the tags that the user can auto select to prevent overwriting
- have it search through the list of tags to see if they're writing anything that is already there
- a way to delete tags
- redesign reading menu in reader to make more sense


----DONE----
- ability to read book
- adding tags to books
- create buttons at the top to sort the books
- ability to sort books
- real-time updating the bookshelf
- get the metadata from the epubs and have them display
- make all of the books the correct size
- make the books be able to be side by side
- modal pop ups (currently in its own view)
- work on getting the covers clickable so that a sheet pops up
- have the epubs display all in one section
- have the description text auto wrap
- convert grids to lazy grids to be more efficient
- marking and storing reviews
- create a button bar for the top to control the sorting and such
- remove duplicates 
- for some reason, after you scroll for a bit, the books stop becoming buttons
- edited data isn't overwriting previous data
- be able to display the reading info as the correct xhtml instead of the html string it is right now that way we can link things correctly and display things like images <-- works sometimes but not for all books; I think there's a different way that some of the images and stylesheets are being referenced
- more efficient way of storing data (only initially store coverimage and file url then when modal clicked, gather the data then)
- add a search bar
- add the ability to delete some books from the view
- tracking reading time (add a timer to the ReaderController and or ReadingView)
- create the view for sorting the books by tag
	- eventually reorganize DefaultView so that the actual view, excluding the toolbar is the thing that is changed and have the fetched results happen on DisplayBooks and feeds into the DisplayBooks view
- implement the ability to change the font size
- marking and sorting by tags (pausing until I figure out how I want to display this)
- the html is showing up a plain text and i need it to show up with all of its styling and images (going to have to use webview and then work in the editing for that)(maybe have the edited be the plain text that is a state and then when the save button is pressed, it refreshes the webview?)
- have the description show how it was supposed to in html



----FEATURES I'D LIKE----
- move original bookbinder parsing from kanna to swiftsoup
- change layout of library to just see the spine
- make a customizable bookshelf where you can have a list of your books and design your bookshelf, drag and drop
- delete books from the book shelf when you click on them
- book reading stats (total books read, books you need to read, total time read this year, etc.)
- tap the image to look at the book cover bigger
- reorganize to MVC schema for efficiency and cleanliness
- make more customizations to the style of the actual books and reading experience (maybe find a way to use the original stylesheet??)


----KNOWN BUGS----
- be able to edit the synopsis (i can't at the moment)
	- maybe i put it back to the plain text and then update the binding based on that?)
- some books don't have covers even though the covers exist
	-Realm of Ash is no longer displaying its cover

----NOTES----

The manifest stores all of the data such as where the different pictures, covers, and toc are

Data I want from reviews: content, title?, date read, total read time, rating


