
-- Creando la base de datos
CREATE DATABASE BDSALES
GO

use BDSALES
GO
-- Creando las tablas

/* Creando la tabla Customer */
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL
)

/* Creando la tabla Category */
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName VARCHAR(200) NOT NULL
)

/* Creando la tabla Product con el foreign key de category */
CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
)

/* Creando la tabla Orders(Order es una palabra reservada) con el foreign key de customer */
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    OrderDate DATE NOT NULL
)

/* Creando la tabla OrderDetail con el foreign key de product y oderId, generando un primary key compuesto por estos dos */
CREATE TABLE OrderDetail (
    OrderID INT NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    ProductID INT NOT NULL,
    CONSTRAINT fk_product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID) -- Clave primaria compuesta
)
-- Insertando Datos a las tablas

/*Insertando datos en la tabla Customer*/
INSERT INTO Customer (FirstName, LastName, Email)
VALUES ('John', 'Doe', 'johndoe@example.com'),
       ('Jane', 'Smith', 'janesmith@example.com');

/*Insertando datos en la tabla Category*/
INSERT INTO Category (CategoryName)
VALUES ('Electronics'),
       ('Clothing');

/*Insertando datos en la tabla Product*/
INSERT INTO Product (ProductName, Price, CategoryID)
VALUES ('Smartphone', 599.99, 1),
       ('T-Shirt', 19.99, 2);

/* Insertando datos en la tabla Orders*/
INSERT INTO Orders (CustomerID, OrderDate)
VALUES (1, '2023-11-22'),
       (2, '2023-11-23');

/* Insertando datos en la tabla OrderDetail*/
INSERT INTO OrderDetail (OrderID, ProductID, Quantity)
VALUES (1, 1, 2),
       (2, 2, 5);


-- Generando 2 QUERYS
/* Utilizamos el join para combinar datos de orders y  customer, luego filtramos los pedidos con el customerID
Query para obtener pedidos por IdCustomer*/
SELECT o.OrderID, c.FirstName, c.LastName, o.OrderDate
FROM Orders o
INNER JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID = @CustomerID;

/*Utilizamos join para combinar diferente tablas, asimismo multiplicamos para obtener el totalvendido luego filtramos con el where
 el rango de fechas del que queremos*/

SELECT c.CategoryName, SUM(od.Quantity * p.Price) AS TotalVendido
FROM OrderDetail od
INNER JOIN Orders o ON od.OrderID = o.OrderID
INNER JOIN Product p ON od.ProductID = p.ProductID
INNER JOIN Category c ON p.CategoryID = c.CategoryID
WHERE o.OrderDate BETWEEN @FechaInicio AND @FechaFin
GROUP BY c.CategoryName;

-- Generando 2 STORE PROCEDURES
/*Este store procedure  añade un nuevo producto, recibe tres parametros; el nombre ,precio y la categoria */
USE BDSALES
GO

CREATE PROCEDURE sp_AgregarProducto (
    @NombreProducto VARCHAR(100),
    @Precio DECIMAL(10,2),
    @CategoriaID INT
)
AS
BEGIN
    INSERT INTO Product(ProductName, Price, CategoryID)
    VALUES ('Phone X', 500, 1);
END;

/*Este store procedure actualiza el cliente, recibe cuatro parametros; el nombre ,apellido ,email y 
el IDcustomer para actualizar dicho customer*/

USE BDSALES
GO


CREATE PROCEDURE sp_ActualizarCliente (
    @CustomerID INT,
    @Nombre VARCHAR(100),
    @Apellido VARCHAR(100),
    @Email VARCHAR(255)
)
AS
BEGIN
    UPDATE Customer
    SET FirstName = @Nombre,
        LastName = @Apellido,
        Email = @Email
    WHERE CustomerID = @CustomerID;
END;
