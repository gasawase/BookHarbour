# BookHarbour Planning Document

## 1. Overview

### 1.1. Vision Statement
Provide a concise statement outlining the overall vision and purpose of your application.

### 1.2. Target Audience
Define the primary users and their needs. Consider demographics, technical expertise, and any specific user requirements.

## 2. Features

### 2.1. Core Features
List and describe the essential features of your application.


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

1. **User Role 1:** _[Description]_
2. **User Role 2:** _[Description]_
3. **User Role 3:** _[Description]_

### 3.2. User Stories
Create user stories for each feature, specifying the actions users can perform and the value they derive.

- **User Story 1:** _[As a <user role>, I want to <perform an action> so that <benefit>._
- **User Story 2:** _[As a <user role>, I want to <perform an action> so that <benefit>._
- **User Story 3:** _[As a <user role>, I want to <perform an action> so that <benefit>._

## 4. Data Model

### 4.1. Entities
Identify the key entities and their attributes that your application will manage.

1. **Entity 1:** _Ebooks_
2. **Entity 2:** _BookTags_
3. **Entity 3:** _Reviews_

### 4.2. Relationships
Define the relationships between different entities.

1. **Relationship 1:** _Ebooks -> BookTags : oneToMany = tags_
2. **Relationship 2:** _BookTags -> Ebooks : oneToMany = bookTagsRelationship_
3. **Relationship 3:** _[Description]_

## 5. Technology Stack

### 5.1. Frontend
Specify the technologies and frameworks you plan to use for the user interface.

- **UI Framework:** _SwiftUI, Webkit_
- **State Management:** _[Library]_
- **Other Frontend Tools:** _[Tools]_

### 5.2. Backend
Specify the technologies and frameworks for server-side development.

- **Backend Framework:** _[Framework]_
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

- **User Flow 1:** _[Description]_
- **User Flow 2:** _[Description]_
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
2. 

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

----CURRENT TAST-----

LAST UPDATED: 30/1/2024

- marking and storing reviews



----TODO----

- more efficient way of storing data (only initially store coverimage and file url then when modal clicked, gather the data then)
- go through and remove duplicates
- tracking reading time
- be able to display the reading info as the correct xhtml instead of the html string it is right now
	that way we can link things correctly and display things like images
	- I think I'm going to have to parse it like it's an xml document.
- be able to have a drop down with all of the tags that the user can auto select to prevent overwriting
	- also to have it search through the list to see if they're writing anything that is already there
- have the description show how it was supposed to in html
- make it all look pretty
- have it blur the background when a title is clicked
- shrink the pop up a little bit
- remove duplicates 
- create a button bar for the top to control the sorting and such
- handling descriptions and the formatting (automatically in HTML)
- marking and sorting by tags (pausing until I figure out how I want to display this)
- rating system (first by numbers then by clicking stars like good reads)


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

----FEATURES I'D LIKE----
- move original bookbinder parsing from kanna to swiftsoup
- change layout of library to just see the spine
- make a customizable bookshelf where you can have a list of your books and design your bookshelf, drag and drop

----KNOWN BUGS----

----NOTES----

The manifest stores all of the data such as where the different pictures, covers, and toc are

Data I want from reviews: content, title?, date read, total read time, rating
