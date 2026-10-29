SET search_path TO classicmodels;

-- Soal 1
SELECT
	c.contactFirstName AS nama_depan_kontak,
	c.customerName AS nama_pelanggan,
	o.city AS kantor_cabang,
	CONCAT (e.firstName, ' ', e.lastName) AS sales_rep_name
FROM customers AS c
INNER JOIN employees AS e
	ON c.salesRepEmployeeNumber = e.employeeNumber
INNER JOIN offices AS o
	ON e.officeCode = o.officeCode
WHERE
	c.contactFirstName ILIKE 'A%' AND
	o.city != 'NYC'
ORDER BY nama_pelanggan ASC;

-- Soal 2
SELECT
	c.customerName AS nama_pelanggan,
	SUM (p.amount) AS total_payment,
	MAX (p.amount) AS max_single_payment
FROM customers AS c
INNER JOIN payments AS p
	ON c.customerNumber = p.customerNumber
GROUP BY c.customerName
HAVING SUM (p.amount) > 50000
ORDER BY total_payment DESC;

-- Soal 3
SELECT
	c.customerName AS nama_pelanggan,
	COUNT (DISTINCT o.orderNumber) AS total_order,
	ROUND (AVG (od.quantityOrdered), 2) AS avg_quantity_per_order
FROM customers AS c
INNER JOIN orders AS o
	ON c.customerNumber = o.customerNumber
INNER JOIN orderDetails AS od
	ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
HAVING
	COUNT (DISTINCT o.orderNumber) > 3 AND
	AVG (od.quantityOrdered) > 35
ORDER BY total_order DESC, avg_quantity_per_order DESC;

-- Soal 4
SELECT
	p.productLine AS lini_produk,
	SUM (od.quantityOrdered) AS total_terjual,
	ROUND (AVG (od.priceEach), 2) rata_rata_harga,
	ROUND (AVG ((p.msrp - od.priceEach) / p.msrp * 100), 2) AS avg_discount_percentage
FROM products AS p
INNER JOIN orderDetails AS od
	ON p.productCode = od.productCode
GROUP BY p.productLine
HAVING
	SUM (od.quantityOrdered) > 3000 AND
	AVG (od.priceEach) > 80
ORDER BY total_terjual DESC;

-- Soal 5
SELECT
	c.customerName AS nama_pelanggan,
	SUM (od.quantityOrdered * od.priceEach) AS total_transaksi,
	COUNT (DISTINCT o.orderNumber) AS total_shipped_orders,
	ROUND (SUM (od.quantityOrdered * od.priceEach) / COUNT (DISTINCT o.orderNumber), 2) AS avg_transaction_per_order
FROM customers AS c
INNER JOIN orders AS o
	ON c.customerNumber = o.customerNumber
INNER JOIN orderDetails AS od
	ON o.orderNumber = od.orderNumber
WHERE o.status = 'Shipped'
GROUP BY c.customerName
HAVING
	COUNT (DISTINCT EXTRACT (YEAR FROM o.orderDate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;


-- Soal 6
SELECT
	c.customerName AS nama_pelanggan,
	c.city AS customer_city,
	ofc.city AS office_city,
	SUM (od.quantityOrdered) AS total_unit_terjual,
	ROUND (SUM (od.quantityOrdered * od.priceEach) / COUNT (DISTINCT ord.orderNumber), 2) AS avg_nilai_per_order
FROM customers AS c
INNER JOIN employees AS e
	ON c.salesRepEmployeeNumber = e.employeeNumber
INNER JOIN offices AS ofc
	ON e.officeCode = ofc.officeCode
INNER JOIN orders AS ord
	ON c.customerNumber = ord.customerNumber
INNER JOIN orderDetails AS od
	ON ord.orderNumber = od.orderNumber
WHERE ofc.territory = 'EMEA'
GROUP BY c.customerName, c.city, ofc.city
HAVING
	COUNT (DISTINCT EXTRACT (YEAR FROM ord.orderDate)) > 2 AND
	SUM (od.quantityOrdered) > 1000 AND
	SUM (od.quantityOrdered * od.priceEach) / COUNT (DISTINCT ord.orderNumber) > 10000
ORDER BY avg_nilai_per_order DESC