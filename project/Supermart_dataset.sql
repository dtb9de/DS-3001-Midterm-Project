CREATE DATABASE `supermart` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `supermart`;
 

CREATE TABLE IF NOT EXISTS `supermart`.`dim_customer` (
  `order_key` int  NOT NULL AUTO_INCREMENT,
  `customer` VARCHAR(25) NULL DEFAULT NULL,
  `category` VARCHAR(50) NULL DEFAULT NULL,
  `sub_category` VARCHAR(50) NULL DEFAULT NULL,
  `city` VARCHAR(50) NULL DEFAULT NULL,
  `order_date` VARCHAR(25) NULL DEFAULT NULL,
  `region` VARCHAR(25) NULL DEFAULT NULL,
  `sales` INT(25) NULL DEFAULT NULL,
  `discount` DECIMAL(20, 3) NULL DEFAULT '0.000',
  `profit` DECIMAL(20, 3)  NULL DEFAULT '0.000',
  `state` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`order_key`),
  INDEX `customer` (`customer` ASC),
  INDEX `category` (`category` ASC),
  INDEX `sub_category` (`sub_category` ASC),
  INDEX `state` (`state` ASC),
  INDEX `order_date` (`order_date` ASC),
  INDEX `region` (`region` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

INSERT INTO `supermart`.`dim_customer`
	(`order_key`,
	`customer`,
	`category`,
	`sub_category`,
	`city`,
	`order_date`,
	`region`,
	`sales`,
    `discount`,
	`profit`,
	`state`)
	SELECT  `customer`.`order_key`,
		`customer`.`customer_name`,
		`customer`.`category`,
		`customer`.`sub_category`,
		`customer`.`city`,
		`customer`.`order_date`,
		`customer`.`region`,
		`customer`.`sales`,
        `customer`.`discount`,
		`customer`.`profit`,
		`customer`.`state`
	FROM `supermart`.`customer`;
    
INSERT INTO `supermart`.`dim_customer`
	(`order_date`)
	SELECT 
		`customer`.`order_date`
	FROM `supermart`.`customer`;

#Testing to see if it works
SELECT order_date from dim_customer;

CREATE TABLE `dim_products` (
  `product_key` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `brand` varchar(50) DEFAULT NULL,
  `price` int(25) default NULL ,
  `discounted_price` int default null,
  `category`  varchar(50) DEFAULT NULL,
  `sub_category`  varchar(50) DEFAULT NULL,
  `quantity` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_key`),
  INDEX `product_key` (`product_key` ASC),
  INDEX `name` (`name` ASC),
  INDEX `brand` (`brand` ASC),
  INDEX `price` (`price` ASC),
  INDEX `discounted_price` (`discounted_price` ASC),
  INDEX `category` (`category` ASC),
  INDEX `sub_category` (`sub_category` ASC),
  INDEX `quantity` (`quantity` ASC))
 ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4;

INSERT INTO `supermart`.`dim_products`
	(`product_key`,
	`name`,
	`brand`,
	`price`,
	`discounted_price`,
	`category`,
	`sub_category`,
	`quantity`)
	SELECT  `products`.`product_key`,
		`products`.`name`,
		`products`.`brand`,
		`products`.`price`,
		`products`.`discounted_price`,
		`products`.`category`,
		`products`.`sub_category`,
		`products`.`quantity`
	FROM `supermart`.`products`;


CREATE TABLE IF NOT EXISTS `fact_orders`(
	`fact_order_key` int NOT NULL AUTO_INCREMENT,
    `order_key` int DEFAULT NULL,
    `product_key` int DEFAULT NULL,
    `customer` VARCHAR(25) NULL DEFAULT NULL,
    `sales` INT(25) NULL DEFAULT NULL,
    `profit` DECIMAL(20, 3)  NULL DEFAULT '0.000',
	`name` varchar(100) DEFAULT NULL,
    `price` int(25) default NULL ,
    `quantity` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`fact_order_key`),
    INDEX `fact_order_key` (`fact_order_key` ASC),
    INDEX `order_key` (`order_key` ASC),
	INDEX `product_key` (`product_key` ASC),
	INDEX `customer` (`customer` ASC),
	INDEX `sales` (`sales` ASC),
	INDEX `profit` (`profit` ASC),
	INDEX `name` (`name` ASC),
	INDEX `price` (`price` ASC),
	INDEX `quantity` (`quantity` ASC))
	ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET = utf8mb4;


INSERT INTO `supermart`.`fact_orders`
(`order_key`,
`product_key`,
`customer`,
`sales`,
`profit`,
`name`,
`price`,
`quantity`)
SELECT c.order_key,
	p.product_key,
    c.customer_name,
    c.sales,
    c.profit,
    p.name,
    p.price,
    p.quantity
FROM supermart.customer as c
JOIN supermart.products AS p
ON p.product_key = c.order_key;

#Testing to see if it works
SELECT profit from fact_orders;

# SELECT STATEMENTS
SELECT dim_customer.city, 
	dim_products.name , 
    dim_products.price,
    fact_orders.profit
    FROM dim_products, dim_customer, fact_orders
    WHERE dim_products.price > (SELECT AVG(dim_products.price) FROM supermart.dim_products);

SELECT brand
	, COUNT(*) AS product_count
FROM supermart.products
WHERE price < 500.00
GROUP BY brand;