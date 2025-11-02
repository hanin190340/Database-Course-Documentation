USE library_db;
CREATE TABLE Publishers (
	Publisher_ID INT IDENTITY(1,1) PRIMARY KEY,
	Branches_Name Varchar(100)NOT NULL,
	country  Varchar (255),
	contact_Email Varchar (100)NOT NULL,
	Established_Year int
);

CREATE TABLE Branches(
Branches_ID INT IDENTITY(1,1) PRIMARY KEY,
Name Varchar(100)NOT NULL,
Address Varchar (255),
Phone Varchar (20)NOT NULL,
Manger_Name Varchar(100)NOT NULL,
Opening_Date date ) ; 

		CREATE TABLE Books (
		Books_ID INT IDENTITY(1,1) PRIMARY KEY,
		ISBN  Varchar(20),
		Title  Varchar (255)NOT NULL,
		Edition Varchar (50),
		Publication_year int,
		Total_Copies int NOT NULL CHECK (Total_Copies >= 0),
		Availble_Copies int NOT NULL CHECK (Availble_Copies >= 0) ,
			CONSTRAINT chk_copies CHECK (Availble_Copies <= Total_Copies),
		Shelf_Location varchar(50),
		Book_Condition VARCHAR(20) NOT NULL DEFAULT 'Good'
					   CHECK (Book_Condition IN ('New', 'Good', 'Fair', 'Damaged')),
		Publisher_ID INT,
		FOREIGN KEY (Publisher_ID) REFERENCES Publishers(Publisher_ID)
				ON DELETE CASCADE
				ON UPDATE CASCADE,
		) ; 

	CREATE TABLE Members (
	Members_ID INT IDENTITY(1,1) PRIMARY KEY,
	Name Varchar(100)NOT NULL,
	Email  Varchar (55),
	Phone Varchar (20)NOT NULL,
	Address Varchar (255),
	Membership_Type  Varchar (20),
	Join_Date   date  ,
	Expiry_Date  date ,
	Status VARCHAR(20) NOT NULL DEFAULT 'Active'
		   CHECK (Status IN ('Active', 'Expired', 'Suspended'))
	);

	CREATE TABLE Borrow (
		Borrow_ID INT IDENTITY(1,1) PRIMARY KEY,
		Status VARCHAR(20) NOT NULL DEFAULT 'Borrowed'
		CHECK (Status IN ('Borrowed', 'Returned', 'Overdue')),
	   Borrow_Date   date  ,
	Due_Date  date ,
		Return_Date DATE,
		Branch_ID  int,
		Member_ID   int ,
		Book_ID   int,
		FOREIGN KEY (Branch_ID) REFERENCES Branches(Branches_ID)
				ON DELETE CASCADE
			ON UPDATE CASCADE,
		FOREIGN KEY (Member_ID) REFERENCES Members(Members_ID)        
		ON DELETE CASCADE
			ON UPDATE CASCADE,
		FOREIGN KEY (Book_ID) REFERENCES Books(Books_ID)
				ON DELETE CASCADE
			ON UPDATE CASCADE,
	);

CREATE TABLE Fines (
    Fines_ID INT IDENTITY(1,1) PRIMARY KEY,
    Borrow_ID INT,
    Address VARCHAR(255),
	Status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (Status IN ('Pending','Paid','Waived')), 
    Fine_Amount DECIMAL(10,2),
    Paid_Amount DECIMAL(10,2),
    Payment_Date DATE,
    FOREIGN KEY (Borrow_ID) REFERENCES Borrow(Borrow_ID)
	        ON DELETE CASCADE
        ON UPDATE CASCADE,
);
CREATE TABLE Reservation (
    Reservation_ID INT IDENTITY(1,1) PRIMARY KEY,
    Member_ID INT,
    Book_ID INT,
   Status VARCHAR(20) NOT NULL
    DEFAULT 'Active'
    CHECK (Status IN ('Active', 'Fulfilled', 'Expired')),
    Expiry_Date DATE,
    FOREIGN KEY (Member_ID) REFERENCES Members(Members_ID)
	        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Books(Books_ID)
	        ON DELETE CASCADE
        ON UPDATE CASCADE,
);
-- Table: Authors
CREATE TABLE Authors (
    Author_ID INT  IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100)NOT NULL,
    Biography TEXT,
    Birth_Year INT,
    Nationality VARCHAR(50)
);

-- Table: Categories
CREATE TABLE Categories (
    Category_ID INT  IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50)NOT NULL,
    Description TEXT
);
CREATE TABLE BookAuthors (
    Author_ID INT NOT NULL,
    Book_ID INT,
    PRIMARY KEY (Author_ID, Book_ID),
    FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Books(Books_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Table: BookCategories (Many-to-Many between Books and Categories)
CREATE TABLE BookCategories (
    Category_ID INT,
    Book_ID INT,
    PRIMARY KEY (Category_ID, Book_ID),
    FOREIGN KEY (Category_ID) REFERENCES Categories(Category_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (Book_ID) REFERENCES Books(Books_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
ALTER TABLE Reservations
ADD ReservationDate DATE NOT NULL
    DEFAULT GETDATE();
CREATE INDEX idx_books_publisher ON Books(Publisher_ID);
CREATE INDEX idx_borrowing_member ON Borrow(Member_ID);
CREATE INDEX idx_borrowing_book ON Borrow(Book_ID);
CREATE INDEX idx_borrowing_branch ON Borrow(Branch_ID);
CREATE INDEX idx_fines_borrow ON Fines(Borrow_ID);
CREATE INDEX idx_bookauthors_book ON BookAuthors(Book_ID);
CREATE INDEX idx_bookauthors_author ON BookAuthors(Author_ID);
CREATE INDEX idx_reservations_member ON Reservations(Member_ID);
CREATE INDEX idx_reservations_book ON Reservations(Book_ID);
CREATE INDEX idx_bookcategories_book ON BookCategories(Book_ID);
CREATE INDEX idx_bookcategories_category ON BookCategories(Category_ID);
--Search fields:
CREATE INDEX idx_books_title ON Books(Title);
CREATE INDEX idx_members_name ON Members(Name);
--Date fields
CREATE INDEX idx_borrow_date ON Borrow(Borrow_Date);
CREATE INDEX idx_borrow_due ON Borrow(Due_Date);
CREATE INDEX idx_borrow_return ON Borrow(Return_Date);
CREATE INDEX idx_reservation_date ON Reservation(ReservationDate);
CREATE INDEX idx_reservation_expiry ON Reservations(Expiry_Date);
CREATE INDEX idx_member_join ON Members(Join_Date);
CREATE INDEX idx_member_expiry ON Members(Expiry_Date);
CREATE INDEX idx_fines_payment ON Fines(Payment_Date);
ALTER TABLE Members
ADD last_login DATETIME NULL;
ALTER TABLE Books
ADD rating INT NULL
    CHECK (rating BETWEEN 1 AND 5);
	INSERT INTO Branches (Name, Address, Phone, Manger_Name, Opening_Date) VALUES
('Central Library', '123 Main St', '555-1001', 'Alice Green', '2020-01-01'),
('East Branch', '456 East Rd', '555-1002', 'Bob Smith', '2019-03-15'),
('West Branch', '789 West Ave', '555-1003', 'Carol Lee', '2021-06-20'),
('North Branch', '321 North St', '555-1004', 'David Brown', '2020-09-10'),
('South Branch', '654 South Rd', '555-1005', 'Eva White', '2018-11-05');

SELECT * FROM Branches;
INSERT INTO Members (Name, Email, Phone, Address, Membership_Type, Join_Date, Expiry_Date, Status) VALUES
('Alice Johnson','alice@example.com','555-2001','12 Oak St','Standard','2025-01-15','2026-01-14','Active'),
('Bob Smith','bob@example.com','555-2002','34 Pine St','Premium','2025-02-10','2026-02-09','Active'),
('Carol Lee','carol@example.com','555-2003','56 Maple St','Standard','2024-05-20','2025-05-19','Expired'),
('David Brown','david@example.com','555-2004','78 Elm St','Premium','2025-03-05','2026-03-04','Active'),
('Eva Green','eva@example.com','555-2005','90 Cedar St','Standard','2025-04-12','2026-04-11','Active'),
('Frank White','frank@example.com','555-2006','21 Birch St','Premium','2023-12-01','2024-11-30','Expired'),
('Grace Kim','grace@example.com','555-2007','43 Walnut St','Standard','2025-05-07','2026-05-06','Active'),
('Henry Adams','henry@example.com','555-2008','65 Cherry St','Premium','2025-06-11','2026-06-10','Active'),
('Isla Scott','isla@example.com','555-2009','87 Spruce St','Standard','2025-07-09','2026-07-08','Active'),
('Jack Turner','jack@example.com','555-2010','109 Aspen St','Premium','2024-08-21','2025-08-20','Expired'),
('Kelly Wilson','kelly@example.com','555-2011','12 Oak St','Standard','2025-01-30','2026-01-29','Active'),
('Liam Harris','liam@example.com','555-2012','34 Pine St','Premium','2025-02-25','2026-02-24','Active'),
('Mia Young','mia@example.com','555-2013','56 Maple St','Standard','2024-11-12','2025-11-11','Expired'),
('Noah Martin','noah@example.com','555-2014','78 Elm St','Premium','2025-03-18','2026-03-17','Active'),
('Olivia Clark','olivia@example.com','555-2015','90 Cedar St','Standard','2025-04-05','2026-04-04','Active'),
('Paul Lewis','paul@example.com','555-2016','21 Birch St','Premium','2023-10-22','2024-10-21','Expired'),
('Quinn Hall','quinn@example.com','555-2017','43 Walnut St','Standard','2025-05-15','2026-05-14','Active'),
('Ruby Allen','ruby@example.com','555-2018','65 Cherry St','Premium','2025-06-08','2026-06-07','Active'),
('Sam Walker','sam@example.com','555-2019','87 Spruce St','Standard','2025-07-01','2026-06-30','Active'),
('Tina Baker','tina@example.com','555-2020','109 Aspen St','Premium','2024-09-30','2025-09-29','Expired');
SELECT * FROM Members;
INSERT INTO Authors (Name, Biography, Birth_Year, Nationality) VALUES
('J.K. Rowling','British author, creator of Harry Potter',1965,'UK'),
('George R.R. Martin','American novelist and short story writer',1948,'USA'),
('Agatha Christie','English writer known for mystery novels',1890,'UK'),
('Stephen King','American author of horror and supernatural fiction',1947,'USA'),
('Isaac Asimov','Russian-born American science fiction author',1920,'USA'),
('Jane Austen','English novelist known for romantic fiction',1775,'UK'),
('Mark Twain','American writer and humorist',1835,'USA'),
('Ernest Hemingway','American novelist and short story writer',1899,'USA'),
('Leo Tolstoy','Russian writer famous for War and Peace',1828,'Russian'),
('F. Scott Fitzgerald','American novelist of the Jazz Age',1896,'USA');
SELECT * FROM Authors;
INSERT INTO Publishers (Branches_Name, Country, Contact_Email, Established_Year) VALUES
('Penguin Random House','USA','contact@penguinrandom.com',1927),
('HarperCollins','USA','contact@harpercollins.com',1989),
('Simon & Schuster','USA','contact@simonandschuster.com',1924),
('Hachette Book Group','France','contact@hachette.com',1826),
('Macmillan Publishers','UK','contact@macmillan.com',1843);
SELECT * FROM Publishers;
INSERT INTO Categories (Name, Description) VALUES
('Fiction','Fictional works of prose'),
('Non-Fiction','Informative or factual works'),
('Mystery','Mystery and detective novels'),
('Science Fiction','Sci-Fi books with futuristic elements'),
('Fantasy','Books with magical or fantastical themes'),
('Romance','Romantic novels'),
('Biography','Biographies of famous people'),
('Historical','Historical novels');
SELECT * FROM Categories;
INSERT INTO Books (ISBN, Title, Edition, Publication_Year, Total_Copies, Availble_Copies, Shelf_Location, Book_Condition, Publisher_ID, rating) VALUES
('9780747532699','Harry Potter and the Sorcerer''s Stone','1st',1997,10,5,'A1','Good',1,5),
('9780553103540','A Game of Thrones','1st',1996,8,2,'B1','Good',2,5),
('9780007119318','Murder on the Orient Express','1st',1934,6,1,'C1','Good',3,4),
('9780307743657','The Shining','1st',1977,5,0,'D1','Good',4,5),
('9780553293357','Foundation','1st',1951,7,3,'E1','Good',5,4),
('9780141439518','Pride and Prejudice','1st',1813,9,4,'A2','Good',1,5),
('9780486280615','Adventures of Huckleberry Finn','1st',1884,6,6,'B2','Good',2,4),
('9780684801223','The Old Man and the Sea','1st',1952,4,2,'C2','Good',3,3),
('9781853260629','War and Peace','1st',1869,5,1,'D2','Good',4,5),
('9780743273565','The Great Gatsby','1st',1925,7,5,'E2','Good',5,4),
('9780747538493','Harry Potter and the Chamber of Secrets','2nd',1998,8,3,'A3','Good',1,5),
('9780553108033','A Clash of Kings','2nd',1998,6,4,'B3','Good',2,5),
('9780007136834','And Then There Were None','1st',1939,5,0,'C3','Good',3,5),
('9780307743658','It','1st',1986,4,2,'D3','Good',4,4),
('9780553294385','I, Robot','1st',1950,6,3,'E3','Good',5,4),
('9780141439587','Emma','1st',1815,7,6,'A4','Good',1,4),
('9780486400778','The Adventures of Tom Sawyer','1st',1876,5,5,'B4','Good',2,3),
('9780684801224','For Whom the Bell Tolls','1st',1940,4,2,'C4','Good',3,4),
('9781853260628','Anna Karenina','1st',1878,6,1,'D4','Good',4,5),
('9780684801225','Tender Is the Night','1st',1934,3,3,'E4','Good',5,3),
('9780747542155','Harry Potter and the Prisoner of Azkaban','3rd',1999,9,5,'A5','Good',1,5),
('9780553106633','A Storm of Swords','3rd',2000,7,4,'B5','Good',2,5),
('9780007119332','Death on the Nile','1st',1937,5,2,'C5','Good',3,4),
('9780307743660','Carrie','1st',1974,6,3,'D5','Good',4,3),
('9780553293371','The Caves of Steel','1st',1953,7,5,'E5','Good',5,4),
('9780141439600','Sense and Sensibility','1st',1811,5,5,'A6','Good',1,4),
('9780486400785','Life on the Mississippi','1st',1883,4,2,'B6','Good',2,3),
('9780684801226','The Sun Also Rises','1st',1926,6,3,'C6','Good',3,4),
('9781853260627','Resurrection','1st',1899,5,1,'D6','Good',4,3),
('9780684801227','The Beautiful and Damned','1st',2024,3,2,'E6','Good',5,3);
SELECT * FROM Books;
INSERT INTO BookAuthors (Author_ID, Book_ID) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,9),
(10,10),
(1,11),
(2,12),
(3,13),
(4,14),
(5,15),
(1,5);  
SELECT * FROM BookAuthors;

INSERT INTO BookCategories (Category_ID, Book_ID) VALUES
(5,1),(5,2),(3,3),(3,4),(4,5),(6,6),(1,7),(1,8),(8,9),(1,10),
(5,11),(5,12),(3,13),(3,14),(4,15),(6,16),(1,17),(1,18),(8,19),(1,20),
(5,21),(5,22),(3,23),(3,24),(4,25),(6,26),(1,27),(1,28),(8,29),(1,30);
SELECT * FROM BookCategories;
INSERT INTO Borrow 
(Member_ID, Book_ID, Borrow_Date, Due_Date, Return_Date, Branch_ID, Status, Fines_ID)
VALUES
(1,1,'2025-10-01','2025-10-15',NULL,1,'Borrowed',1),
(2,2,'2025-09-15','2025-09-29','2025-09-28',2,'Returned',2),
(3,3,'2025-09-01','2025-09-15',NULL,3,'Overdue',3),
(4,4,'2025-10-10','2025-10-24',NULL,4,'Borrowed',4),
(5,5,'2025-09-05','2025-09-19','2025-09-18',5,'Returned',5),
(6,6,'2025-09-20','2025-10-04',NULL,1,'Overdue',6),
(7,7,'2025-10-08','2025-10-22',NULL,2,'Borrowed',7),
(8,8,'2025-08-25','2025-09-08','2025-09-07',3,'Returned',8),
(9,9,'2025-09-10','2025-09-24',NULL,4,'Overdue',9),
(10,10,'2025-10-05','2025-10-19',NULL,5,'Borrowed',10),
(11,11,'2025-09-12','2025-09-26','2025-09-25',1,'Returned',11),
(12,12,'2025-10-01','2025-10-15',NULL,2,'Borrowed',12),
(13,13,'2025-09-02','2025-09-16',NULL,3,'Overdue',13),
(14,14,'2025-10-03','2025-10-17',NULL,4,'Borrowed',14),
(15,15,'2025-09-18','2025-10-02','2025-10-01',5,'Returned',15),
(16,16,'2025-09-20','2025-10-04',NULL,1,'Overdue',16),
(17,17,'2025-10-06','2025-10-20',NULL,2,'Borrowed',17),
(18,18,'2025-09-22','2025-10-06','2025-10-05',3,'Returned',18),
(19,19,'2025-09-25','2025-10-09',NULL,4,'Overdue',19),
(20,20,'2025-10-07','2025-10-21',NULL,5,'Borrowed',20),
(1,21,'2025-09-28','2025-10-12',NULL,1,'Borrowed',21),
(2,22,'2025-09-30','2025-10-14',NULL,2,'Borrowed',22),
(3,23,'2025-09-05','2025-09-19','2025-09-18',3,'Returned',23),
(4,24,'2025-09-12','2025-09-26',NULL,4,'Overdue',24),
(5,25,'2025-10-08','2025-10-22',NULL,5,'Borrowed',25);

SELECT * FROM Borrow ;
INSERT INTO Fines (Borrow_ID, Status, Fine_Amount, Paid_Amount, Payment_Date) VALUES
(3,'Pending',10.00,0.00,NULL),
(2,'Paid',15.00,15.00,'2025-10-10');

INSERT INTO Reservations(Member_ID, Book_ID, Expiry_Date, Status, ReservationDate) VALUES
(1,2,'2025-11-01','Active','2025-10-20'),
(2,5,'2025-11-05','Active','2025-10-21'),
(3,7,'2025-11-10','Active','2025-10-22'),
(4,1,'2025-11-12','Active','2025-10-23'),
(5,3,'2025-11-15','Active','2025-10-24');
SELECT * FROM Reservations ;
UPDATE Members
SET Membership_Type = 'Premium'
WHERE Membership_Type = 'Standard';

-- Update Borrow status and Return_Date
UPDATE Borrow
SET Status = 'Returned',
    Return_Date = GETDATE()
WHERE  Status = 'Borrowed';

-- Update available copies in Books
UPDATE Books
SET Availble_Copies = Availble_Copies + 1
WHERE Books_ID = 1;

UPDATE Fines
SET Status = 'Paid',
    Paid_Amount = Fine_Amount,
    Payment_Date = GETDATE()
WHERE Borrow_ID = 3
AND Status = 'Pending';


DELETE FROM Reservations
WHERE Expiry_Date < GETDATE();
UPDATE Reservations
SET Expiry_Date = '2025-01-01'
WHERE Reservation_ID = 1;

SELECT DISTINCT Member_ID, Status
FROM Borrow
WHERE Status = 'Borrowed';

UPDATE Borrow
SET Status = 'Borrowed', Return_Date = NULL
WHERE Borrow_ID = 1;  -- or any existing ID

SELECT Member_ID
FROM Borrow
WHERE Borrow_ID = 1;

SELECT Borrow_ID, Member_ID, Book_ID, Status
FROM Borrow;

SELECT Books_ID, Title, Publication_Year, Publisher_ID
FROM Books
WHERE Publication_Year > 2020;

SELECT Members_ID, Name, Email, Expiry_Date
FROM Members
WHERE Expiry_Date BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE());

SELECT Borrow_ID, Member_ID, Book_ID, Borrow_Date, Due_Date
FROM Borrow
WHERE Return_Date IS NULL
  AND Due_Date < GETDATE();

SELECT b.Books_ID, b.Title
FROM Books b
LEFT JOIN Borrow br ON b.Books_ID = br.Book_ID
WHERE br.Book_ID IS NULL;

SELECT m.Members_ID, m.Name, f.Fine_Amount, f.Status
FROM Members m
JOIN Borrow br ON m.Members_ID = br.Member_ID
JOIN Fines f ON br.Borrow_ID = f.Borrow_ID
WHERE f.Status = 'Pending'
  AND f.Fine_Amount > 10.00;

  SELECT b.Books_ID, b.Title, c.Name AS Category
FROM Books b
JOIN BookCategories bc ON b.Books_ID = bc.Book_ID
JOIN Categories c ON bc.Category_ID = c.Category_ID
WHERE c.Name = 'Fiction';

SELECT Books_ID, Title, Availble_Copies, Total_Copies
FROM Books
WHERE Availble_Copies < 2;

SELECT Author_ID, Name, Nationality
FROM Authors
WHERE Nationality IN ('USA', 'UK');

SELECT b.Books_ID, b.Title, p.Branches_Name AS Publisher_Name
FROM Books b
JOIN Publishers p ON b.Publisher_ID = p.Publisher_ID
WHERE p.Branches_Name = 'Penguin Random House';

SELECT Borrow_ID, Member_ID, Book_ID, Borrow_Date, Due_Date
FROM Borrow
WHERE Borrow_Date BETWEEN 
      DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
  AND DATEADD(DAY, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1));

  SELECT b.Borrow_ID,m.Name AS Member_Name,bk.Title AS Book_Title,b.Status,b.Borrow_Date,b.Due_Date
FROM Borrow b
INNER JOIN Members m ON b.Member_ID = m.Members_ID
INNER JOIN Books bk ON b.Book_ID = bk.Books_ID;

SELECT b.Borrow_ID,m.Name AS Member_Name,bk.Title AS Book_Title,br.Name AS Branch_Name,b.Borrow_Date,b.Due_Date
FROM Borrow b
INNER JOIN Members m ON b.Member_ID = m.Members_ID
INNER JOIN Books bk ON b.Book_ID = bk.Books_ID
INNER JOIN Branches br ON b.Branch_ID = br.Branches_ID
WHERE b.Status = 'Borrowed';

SELECT  b.Borrow_ID,m.Name AS Member_Name,bk.Title AS Book_Title,br.Name AS Branch_Name,b.Borrow_Date, b.Due_Date
FROM Borrow b
INNER JOIN Members m ON b.Member_ID = m.Members_ID
INNER JOIN Books bk ON b.Book_ID = bk.Books_ID
INNER JOIN Branches br ON b.Branch_ID = br.Branches_ID
WHERE b.Status = 'Borrowed';

SELECT bk.Books_ID,bk.Title,b.Status AS Borrow_Status
FROM Books bk
LEFT JOIN Borrow b ON bk.Books_ID = b.Book_ID
  AND b.Status = 'Borrowed';

  SELECT m.Members_ID,m.Name AS Member_Name,b.Borrow_ID,b.Status AS Borrow_Status
FROM Members m
LEFT JOIN Borrow b ON m.Members_ID = b.Member_ID
  AND b.Status = 'Borrowed';

SELECT  c.Name AS Category_Name,COUNT(bc.Book_ID) AS Book_Count
FROM Categories c
FULL OUTER JOIN BookCategories bc ON c.Category_ID = bc.Category_ID
GROUP BY c.Name;
-- 1.1 Total number of borrowings per member
SELECT Member_ID, COUNT(*) AS Total_Borrowings
FROM Borrow
GROUP BY Member_ID;

-- 1.2 Number of books per category
SELECT bc.Category_ID, c.Name AS Category_Name, COUNT(bc.Book_ID) AS Book_Count
FROM BookCategories bc
JOIN Categories c ON bc.Category_ID = c.Category_ID
GROUP BY bc.Category_ID, c.Name;

-- 1.3 Count of overdue books per branch
SELECT br.Branches_ID, br.Name AS Branch_Name, COUNT(*) AS Overdue_Count
FROM Borrow b
JOIN Branches br ON b.Branch_ID = br.Branches_ID
WHERE b.Status = 'Overdue'
GROUP BY br.Branches_ID, br.Name;
-- 2.1 Total fines collected per month
SELECT YEAR(Payment_Date) AS Year, MONTH(Payment_Date) AS Month, SUM(Paid_Amount) AS Total_Fines_Collected
FROM Fines
WHERE Status = 'Paid'
GROUP BY YEAR(Payment_Date), MONTH(Payment_Date)
ORDER BY Year, Month;

SELECT m.Members_ID,m.Name,SUM(f.Fine_Amount - f.Paid_Amount) AS Total_Pending_Fines
FROM Fines f
JOIN Borrow b ON f.Borrow_ID = b.Borrow_ID
JOIN Members m ON b.Member_ID = m.Members_ID
WHERE f.Fine_Amount > f.Paid_Amount
GROUP BY m.Members_ID, m.Name;



-- 2.3 Sum of available copies per publisher
SELECT p.Publisher_ID, p.Branches_Name AS Publisher_Name, SUM(b.Availble_Copies) AS Total_Available
FROM Books b
JOIN Publishers p ON b.Publisher_ID = p.Publisher_ID
GROUP BY p.Publisher_ID, p.Branches_Name;


 -- 3.1 Average number of days books are borrowed
SELECT AVG(DATEDIFF(DAY, Borrow_Date, Return_Date)) AS Avg_Borrow_Days
FROM Borrow
WHERE Return_Date IS NOT NULL;

SELECT m.Members_ID,m.Name,AVG(f.Fine_Amount) AS Avg_Fine
FROM Fines f
JOIN Borrow b ON f.Borrow_ID = b.Borrow_ID
JOIN Members m ON b.Member_ID = m.Members_ID
GROUP BY m.Members_ID, m.Name;

-- 3.3 Average books borrowed per branch
SELECT Branch_ID, AVG(Borrow_Count) AS Avg_Borrowed
FROM (
    SELECT Branch_ID, COUNT(*) AS Borrow_Count
    FROM Borrow
    GROUP BY Branch_ID
) AS SubQuery
GROUP BY Branch_ID;


-- 4.1 Oldest and newest publications
SELECT 
    MIN(Publication_Year) AS Oldest_Publication,
    MAX(Publication_Year) AS Newest_Publication
FROM Books;

-- 4.2 Member with maximum and minimum borrowings
SELECT TOP 1 Member_ID, COUNT(*) AS TotalBorrowed
FROM Borrow
GROUP BY Member_ID
ORDER BY COUNT(*) DESC;  -- Max borrowings

SELECT TOP 1 Member_ID, COUNT(*) AS TotalBorrowed
FROM Borrow
GROUP BY Member_ID
ORDER BY COUNT(*) ASC;   -- Min borrowings

-- 4.3 Highest fine amount ever charged
SELECT MAX(Fine_Amount) AS Highest_Fine
FROM Fines;
 -- 5.1 Categories with more than 5 books
SELECT c.Category_ID, c.Name, COUNT(bc.Book_ID) AS TotalBooks
FROM Categories c
LEFT JOIN BookCategories bc ON c.Category_ID = bc.Category_ID
GROUP BY c.Category_ID, c.Name
HAVING COUNT(bc.Book_ID) > 5;

-- 5.2 Members who borrowed more than 3 books last month
SELECT Member_ID, COUNT(*) AS BorrowCount
FROM Borrow
WHERE Borrow_Date BETWEEN 
      DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
  AND DATEADD(DAY, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
GROUP BY Member_ID
HAVING COUNT(*) > 3;

-- 5.3 Authors with more than 2 books in the library
SELECT a.Author_ID, a.Name, COUNT(ba.Book_ID) AS BookCount
FROM Authors a
JOIN BookAuthors ba ON a.Author_ID = ba.Author_ID
GROUP BY a.Author_ID, a.Name
HAVING COUNT(ba.Book_ID) > 2;

-- 5.4 Branches with total pending fines > $100
SELECT b.Branch_ID, SUM(f.Fine_Amount) AS TotalPending
FROM Fines f
JOIN Borrow b ON f.Borrow_ID = b.Borrow_ID
WHERE f.Status = 'Pending'
GROUP BY b.Branch_ID
HAVING SUM(f.Fine_Amount) > 100;

-- 6.1 Total borrowings per branch per month
SELECT Branch_ID, YEAR(Borrow_Date) AS Year, MONTH(Borrow_Date) AS Month, COUNT(*) AS TotalBorrowings
FROM Borrow
GROUP BY Branch_ID, YEAR(Borrow_Date), MONTH(Borrow_Date)
ORDER BY Branch_ID, Year, Month;

-- 6.2 Fine collection per member per year
SELECT  m.Members_ID,m.Name,YEAR(f.Payment_Date) AS Year,SUM(f.Paid_Amount) AS TotalPaid
FROM Fines f
JOIN Borrow b ON f.Borrow_ID = b.Borrow_ID
JOIN Members m ON b.Member_ID = m.Members_ID
WHERE f.Status = 'Paid'
GROUP BY m.Members_ID, m.Name, YEAR(f.Payment_Date)
ORDER BY m.Members_ID, Year;









 











