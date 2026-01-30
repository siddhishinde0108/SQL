-- Create Database

CREATE DATABASE OnlineBookstore

-- Create Tables

DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);


DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);


DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
-- import data using(table data import wizard)

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM orders;

-- SQL Queries

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books 
WHERE Genre='Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books 
WHERE Published_year>1950;

-- 3) List all customers from the Canada:
SELECT * FROM Customers 
WHERE country='Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders 
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS Total_Stock
From Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books 
ORDER BY Price DESC 
LIMIT 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders 
WHERE quantity>1;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders 
WHERE total_amount>20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books 
ORDER BY stock 
LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) As Revenue 
FROM Orders;

-- 12) Retrieve the total number of books sold for each genre:
SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o, Books b
WHERE b.Book_ID=o.Book_ID
GROUP BY b.Genre;

-- 13) Find the average price of books in the "Fantasy" genre:
SELECT AVG(price) AS Average_Price
FROM Books
WHERE Genre = 'Fantasy';

-- 14) List customers who have placed at least 2 orders:
SELECT c.customer_id,c.name,COUNT(o.order_id) AS TotalOrders
FROM Customers c,Orders o
WHERE c.Customer_ID=o.Customer_ID
GROUP BY c.Customer_ID,c.name
HAVING COUNT(o.Order_ID)>=2;

-- 15) Find the most frequently ordered book:
SELECT b.Book_ID,b.Title,SUM(o.Quantity) AS TotalOrdered
FROM Books b, Orders o
WHERE b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title
ORDER BY TotalOrdered DESC
LIMIT 1;   

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT Book_ID,Title,Price
FROM books
WHERE genre ='Fantasy'
ORDER BY price DESC LIMIT 3;

-- 17) Retrieve the total quantity of books sold by each author:
SELECT b.author, SUM(o.quantity) AS Total_Books_Sold
FROM  orders o,Books b
WHERE o.book_id=b.book_id
GROUP BY b.Author;

-- 18) Find books that have never been ordered:
SELECT Book_ID,Title
FROM Books
WHERE Book_ID NOT IN (
    SELECT Book_ID
    FROM Orders);

-- 19) Find the customer who spent the most on orders:
SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_Spent
FROM customers c, orders o
WHERE c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_Spent DESC
LIMIT 1;


-- 20) calculate remaining stock after fulfilling all orders:
SELECT b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
FROM books b
LEFT JOIN orders o ON b.book_id=o.book_id
GROUP BY b.book_id ORDER BY b.book_id;

-- 20)
SELECT b.Title, (b.Stock - SUM(o.Quantity)) AS RemainingStock
FROM Books b, Orders o
WHERE b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Stock;

-- 21)Show customer names, book titles, and quantity ordered:
SELECT c.Name, b.Title, o.Quantity
FROM Customers c, Orders o, Books b
WHERE c.Customer_ID = o.Customer_ID
  AND o.Book_ID = b.Book_ID;

-- 22)Orders with book price greater than 45:
SELECT c.Name, b.Title, b.Price
FROM Customers c, Orders o, Books b
WHERE c.Customer_ID = o.Customer_ID
  AND o.Book_ID = b.Book_ID
  AND b.Price >=45;















