-- ------------------------------------------------------------------
-- 0). First, How Many Rows are in the Products Table?
-- ------------------------------------------------------------------
SELECT COUNT(*) AS Num_Products FROM northwind.products;
-- The amount of rows is 45

-- ------------------------------------------------------------------
-- 1). Product Name and Unit/Quantity
-- ------------------------------------------------------------------
SELECT product_name, quantity_per_unit
FROM northwind.products;

-- ------------------------------------------------------------------
-- 2). Product ID and Name of Current Products
-- ------------------------------------------------------------------
SELECT id AS product_id, product_name
FROM northwind.products
WHERE discontinued <> 1;

-- ------------------------------------------------------------------
-- 3). Product ID and Name of Discontinued Products
-- ------------------------------------------------------------------
SELECT id AS product_id, product_name
FROM northwind.products
WHERE discontinued <> 0;

-- ------------------------------------------------------------------
-- 4). Name & List Price of Most & Least Expensive Products
-- ------------------------------------------------------------------
SELECT product_name, list_price 
FROM northwind.products
-- Least Expensive
WHERE list_price = (SELECT MIN(list_price) FROM northwind.products)

-- Most Expensive
OR list_price = (SELECT MAX(list_price) FROM northwind.products);


-- ------------------------------------------------------------------
-- 5). Product ID, Name & List Price Costing Less Than $20
-- ------------------------------------------------------------------
SELECT id
	, product_name
    , list_price
FROM northwind.products
WHERE list_price < 20;

-- ------------------------------------------------------------------
-- 6). Product ID, Name & List Price Costing Between $15 and $20
-- ------------------------------------------------------------------
SELECT id
	, product_name
    , list_price
FROM northwind.products
WHERE list_price BETWEEN 15 AND 20;

-- ------------------------------------------------------------------
-- 7). Product Name & List Price Costing Above Average List Price
-- ------------------------------------------------------------------
SELECT product_name
	, list_price
FROM northwind.products
WHERE list_price > (SELECT AVG(list_price) FROM northwind.products);

-- ------------------------------------------------------------------
-- 8). Product Name & List Price of 10 Most Expensive Products 
-- ------------------------------------------------------------------
SELECT product_name
	, list_price
FROM northwind.products 
ORDER BY list_price DESC
LIMIT 10;

-- ------------------------------------------------------------------ 
-- 9). Count of Current and Discontinued Products 
-- ------------------------------------------------------------------
-- Double-Checking distinct values in discontinued column
SELECT COUNT(DISTINCT discontinued) as prodtype
FROM northwind.products;

-- There doesn't seem to be any discontinued products
SELECT discontinued, COUNT(*) as freq 
FROM northwind.products
GROUP BY discontinued;

-- ------------------------------------------------------------------
-- 10). Product Name, Units on Order and Units in Stock
--      Where Quantity In-Stock is Less Than the Quantity On-Order. 
-- ------------------------------------------------------------------
WITH stocking AS (
	-- Get products in inventory and products on order
	SELECT prod.id AS product_id, product_name
		, orderDeets.quantity AS OnOrder
		, invent.quantity AS InStock
	FROM northwind.products AS prod

	LEFT OUTER JOIN northwind.order_details AS orderDeets
	ON prod.id = orderDeets.product_id
	LEFT OUTER JOIN northwind.inventory_transactions AS invent
	ON orderDeets.product_id  = invent.product_id
)
-- Select by unitsStocked is less than unitsOrdered using HAVING
SELECT product_name
	, SUM(OnOrder) AS unitsOrdered
    , SUM(InStock) AS unitsStocked
FROM stocking
GROUP BY product_name
HAVING unitsStocked < unitsOrdered;

-- It appears that more Beer and Ravioli units need to be bought in order to keep up with demand.

-- ------------------------------------------------------------------
-- EXTRA CREDIT -----------------------------------------------------
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
-- 11). Products with Supplier Company & Address Info
-- ------------------------------------------------------------------
WITH supplierDetails AS (
SELECT supplier_ids, product_name
	, supplier.company AS company
    , CONCAT(supplier.address, ' ', supplier.city, ' ', supplier.state_province, ' ', supplier.zip_postal_code, ' ') AS address
    FROM northwind.products AS prod
    
    JOIN northwind.suppliers AS supplier
    ON supplier_ids = supplier.id
)

SELECT supplier_ids
	, company
	, address
    , product_name
FROM supplierDetails
ORDER BY supplier_ids;

-- ------------------------------------------------------------------
-- 12). Number of Products per Category With Less Than 5 Units
-- ------------------------------------------------------------------
-- ------------------------------------------------------------------
-- 13). Number of Products per Category Priced Less Than $20.00
-- ------------------------------------------------------------------