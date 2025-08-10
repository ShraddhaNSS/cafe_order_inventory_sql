-- 1. Create the database
CREATE DATABASE CafeDB_Advanced;
USE CafeDB_Advanced;

-- 2. Create MenuItems table
CREATE TABLE MenuItems (
    ItemID INT PRIMARY KEY AUTO_INCREMENT,
    DrinkName VARCHAR(30) NOT NULL,
    Size VARCHAR(10) NOT NULL,
    Price DECIMAL(5,2) NOT NULL,
    Stock INT NOT NULL
);

-- 3. Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(50) NOT NULL,
    ItemID INT NOT NULL,
    OrderTime DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ItemID) REFERENCES MenuItems(ItemID)
);

-- 4. Insert sample menu items
INSERT INTO MenuItems (DrinkName, Size, Price, Stock) VALUES
('Latte', 'Small', 3.50, 15),
('Latte', 'Large', 4.00, 10),
('Cappuccino', 'Small', 3.25, 12),
('Cappuccino', 'Large', 4.75, 8),
('Espresso', 'Single', 2.50, 20),
('Espresso', 'Double', 3.00, 18),
('Mocha', 'Medium', 4.25, 7),
('Flat White', 'Medium', 3.80, 9);

-- 5. Insert sample orders
INSERT INTO Orders (CustomerName, ItemID) VALUES
('Alice Johnson', 1),
('Bob Smith', 4),
('Carla Davis', 5),
('Daniel Green', 7),
('Ella Brown', 2),
('Frank Wilson', 3),
('Grace Miller', 8),
('Hank Taylor', 1),
('Ivy Parker', 4),
('Jack White', 6);

-- 6. JOIN query: show customer orders with drink details
SELECT O.OrderID, O.CustomerName, M.DrinkName, M.Size, M.Price, O.OrderTime
FROM Orders O
JOIN MenuItems M ON O.ItemID = M.ItemID;

-- 7. GROUP BY: total sales per drink type
SELECT M.DrinkName, SUM(M.Price) AS TotalSales, COUNT(*) AS OrdersCount
FROM Orders O
JOIN MenuItems M ON O.ItemID = M.ItemID
GROUP BY M.DrinkName
ORDER BY TotalSales DESC;

-- 8. Create a view: top selling drinks
CREATE VIEW TopSellingDrinks AS
SELECT M.DrinkName, COUNT(*) AS OrdersCount
FROM Orders O
JOIN MenuItems M ON O.ItemID = M.ItemID
GROUP BY M.DrinkName
ORDER BY OrdersCount DESC;

-- 9. Trigger: update stock after new order
DELIMITER //
CREATE TRIGGER ReduceStockAfterOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    UPDATE MenuItems
    SET Stock = Stock - 1
    WHERE ItemID = NEW.ItemID;
END;
//
DELIMITER ;

-- 10. Test the trigger by placing a new order
INSERT INTO Orders (CustomerName, ItemID) VALUES ('Test Customer', 1);
SELECT * FROM MenuItems;
