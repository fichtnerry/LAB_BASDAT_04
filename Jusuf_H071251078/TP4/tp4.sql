SET search_path TO classicmodels;

-- Soal 1
SELECT
	customerNumber AS "Nomor Pelanggan",
	SUM (amount) AS "Total Setoran",
	COUNT (checkNumber) AS "Jumlah Transaksi",
	MAX (amount) AS "Setoran Terbesar"
FROM payments
GROUP BY customerNumber
HAVING
	COUNT (checkNumber) > 4 AND
	AVG (amount) > 20000;

-- Soal 2
SELECT
	customerNumber AS "Nomor Pelanggan",
	SUM (amount) AS "Total Setoran"
FROM payments
GROUP BY customerNumber
HAVING SUM (amount) > 80000
ORDER BY "Total Setoran" DESC;

-- Soal  3
SELECT
	productLine AS "Kategori Produk",
	COUNT (productCode) AS "Jumlah Produk",
	ROUND (AVG (MSRP), 2) AS "Rata-rata Harga Jual",
	STRING_AGG (productName, ', ' ORDER BY productName ASC) AS "Daftar Produk"
FROM products
GROUP BY productLine
HAVING COUNT (productCode) > 10;

-- Soal 4
SELECT
	employeeNumber AS "Nomor Staf",
	jobTitle AS "Jabatan"
FROM employees
WHERE employeeNumber IN (SELECT DISTINCT reportsTo FROM employees)
EXCEPT
SELECT
	employeeNumber AS "Nomor Staf",
	jobTitle AS "Jabatan"
FROM employees
WHERE jobTitle ILIKE '%VP%' OR jobTitle ILIKE '%President%';

-- Soal 5
SELECT
	productCode AS "Kode Produk",
	SUM (quantityOrdered) AS "Total Unit Terjual",
	ROUND (AVG (priceEach), 2) AS "Rata-rata Harga Jual"
FROM orderDetails
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM (quantityOrdered) > 50
ORDER BY "Total Unit Terjual" DESC;

-- Soal 6
SELECT
	productCode AS "Kode Produk",
	SUM (quantityOrdered) AS "Total Unit Dipesan",
	SUM (quantityOrdered * priceEach) AS "Pendapatan Kotor",
	ROUND (AVG (priceEach), 2) AS "Rata-rata Harga Jual",
	MAX (priceEach) - MIN (priceEach) AS "Rentang Harga"
FROM orderDetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM (quantityOrdered * priceEach) > 50000
ORDER BY "Pendapatan Kotor";

-- Soal 7
SELECT customerNumber FROM customers
WHERE creditLimit > 80000
INTERSECT
SELECT customerNumber FROM orders
WHERE status IN ('Cancelled', 'On Hold')
EXCEPT
SELECT customerNumber FROM payments
GROUP BY customerNumber
HAVING SUM (amount) > 100000;