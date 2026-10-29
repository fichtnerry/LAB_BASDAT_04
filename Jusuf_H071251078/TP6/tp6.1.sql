SET search_path TO classicmodels, public;

-- Soal 1
SELECT
	productCode AS "Kode Produk",
	productName AS "Nama Produk",
	MSRP AS "MSRP",
	quantityInStock AS "Jumlah Stok",
	CASE
		WHEN msrp < 50 AND quantityInStock > 500 THEN 'Ekonomis - Stok Tinggi'
		WHEN msrp < 50 AND quantityInStock <= 500 THEN 'Ekonomis - Stok Rendah'
		WHEN msrp BETWEEN 50 AND 100 THEN 'Harga Menengah'
		WHEN msrp > 100 THEN 'Harga Premium'
	END AS "Kategori Produk"
FROM products
ORDER BY MSRP DESC;

-- Soal 2
SELECT
	productCode AS "Kode Produk",
	SUM (quantityOrdered) AS "Unit Terjual",
	COUNT (DISTINCT orderNumber) AS "Jumlah Unit"
FROM orderDetails
GROUP BY productCode
HAVING
	SUM (quantityOrdered) > (
		SELECT AVG (quantityOrdered)
		FROM orderDetails) AND
	COUNT(DISTINCT orderNumber) > 10
ORDER BY "Unit Terjual" DESC;

-- Soal 3
SELECT
	productCode AS "Kode Produk",
	productName AS "Nama Produk",
	quantityInStock AS "Jumlah Stok",
	msrp AS "MSRP"
FROM products
WHERE
	quantityInStock > (
		SELECT AVG (quantityInStock)
		FROM products) AND
	msrp > (
		SELECT AVG (msrp)
		FROM products)
ORDER BY "Jumlah Stok" DESC;

-- Soal 4
BEGIN;

UPDATE orders
SET status = 'Pengiriman'
WHERE orderNumber = 10100;

SAVEPOINT "Status Pengiriman";

UPDATE orders
SET status = 'Batal'
WHERE orderNumber = 10100;

ROLLBACK TO SAVEPOINT "Status Pengiriman";

COMMIT;

SELECT orderNumber, status FROM orders
WHERE orderNumber = '10100';

-- Soal 5
CREATE DATABASE db_perpustakaan;
