USE monomart;
    
-- /*******************************************************
-- *
-- * Table: Orders
-- *
-- *******************************************************/
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	order_guid VARCHAR(36) DEFAULT '' NOT NULL,
	order_ip VARCHAR(39) NOT NULL,
	order_date DATETIME NOT NULL,
	order_status INT DEFAULT 0 NOT NULL,
	customer_name VARCHAR(255) DEFAULT '' NOT NULL,
	customer_email VARCHAR(255) DEFAULT '' NOT NULL,
	phone_number VARCHAR(10) DEFAULT '' NOT NULL,
	ship_to_name VARCHAR(255) DEFAULT '' NOT NULL,
	ship_to_address1 VARCHAR(255) DEFAULT '' NOT NULL,
	ship_to_address2 VARCHAR(255) DEFAULT '' NOT NULL,
	ship_to_city VARCHAR(255) DEFAULT '' NOT NULL,
	ship_to_country VARCHAR(255) DEFAULT '' NOT NULL,
	ship_to_state VARCHAR(2) DEFAULT '' NOT NULL,
	ship_to_zip VARCHAR(5) DEFAULT '' NOT NULL
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- /*******************************************************
-- *
-- * Table: Items
-- *
-- *******************************************************/

DROP TABLE IF EXISTS items;

CREATE TABLE items (
	id BIGINT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	order_id INT NOT NULL,
	product_id INT NOT NULL,
	price DECIMAL(12,2) NOT NULL,
	quantity INT NOT NULL,
	INDEX AK_items_order (order_id),
	INDEX AK_items_product (product_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;


-- /*******************************************************
-- *
-- * Table: Brands
-- *
-- *******************************************************/

DROP TABLE IF EXISTS brands;

CREATE TABLE brands (
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	name VARCHAR(255) DEFAULT '' NOT NULL
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
-- /*******************************************************
-- *
-- * Table: Products
-- *
-- *******************************************************/

DROP TABLE IF EXISTS products;

CREATE TABLE products (
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	fid VARCHAR(36) NOT NULL,
	brand_id INT NOT NULL,
	name VARCHAR(255) NOT NULL,
	size VARCHAR(255) NOT NULL,
	upc VARCHAR(12) NOT NULL,
	ean13 VARCHAR(13) NOT NULL,
	category VARCHAR(255) NOT NULL,
	price DECIMAL(12,2) NOT NULL,
	ingredients VARCHAR(1024) NOT NULL,
	servingsize VARCHAR(255) NOT NULL,
	servings VARCHAR(255) NOT NULL,
	image VARCHAR(255) NOT NULL,
	INDEX AK_product_brand (brand_id)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- /*******************************************************
-- *
-- * Proc: MM_GetProducts
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_GetProducts;

DELIMITER //
CREATE PROCEDURE MM_GetProducts (IN brandId INT)
BEGIN
	IF brandId = 0 THEN
		SELECT products.id, brands.name AS 'brand', products.name, products.size, products.upc, products.price, products.ingredients, products.servings, products.servingsize, products.image FROM products JOIN brands ON products.brand_id = brands.id;
	ELSE
		SELECT products.id, brands.name AS 'brand', products.name, products.size, products.upc, products.price, products.ingredients, products.servings, products.servingsize, products.image FROM products JOIN brands ON products.brand_id = brands.id WHERE brand_id=brandId;
	END IF;

END //
DELIMITER ;

-- /*******************************************************
-- *
-- * Proc: MM_GetCart
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_GetCart;

DELIMITER //
CREATE PROCEDURE MM_GetCart(IN orderId INT)
BEGIN
	SELECT items.id, items.order_id, items.product_id, brands.name AS 'brand', products.name, products.size, products.upc, products.price, products.servings, products.servingsize, products.ingredients, products.image, items.quantity FROM items JOIN orders ON orders.id = items.order_id JOIN products ON items.product_id = products.id JOIN brands on products.brand_id = brands.id WHERE order_id=orderId AND orders.order_status = 0;
END //
DELIMITER ;


-- /*******************************************************
-- *
-- * Proc: MM_GetOrder
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_GetOrder;

DELIMITER //
CREATE PROCEDURE MM_GetOrder(IN id INT)
BEGIN
	SELECT * FROM orders WHERE id = @id;
END //
DELIMITER ;


-- /*******************************************************
-- *
-- * Proc: MM_GetBrand
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_GetBrand;

DELIMITER //
CREATE PROCEDURE MM_GetBrand(IN id INT)
BEGIN
	IF id = 0 THEN
		SELECT * from brands;
	ELSE
		SELECT * from brands WHERE brands.id=id;
	END IF;
END //
DELIMITER ;


-- /*******************************************************
-- *
-- * Proc: MM_NewCart
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_NewCart;

DELIMITER //
CREATE PROCEDURE MM_NewCart(IN orderIp VARCHAR(39))
BEGIN
	INSERT INTO orders (order_date, order_ip) VALUES (NOW(), orderIp);
	SELECT LAST_INSERT_ID() AS id;
END //
DELIMITER ;


-- /*******************************************************
-- *
-- * Proc: MM_UpdateCart
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_UpdateCart;

DELIMITER //
CREATE PROCEDURE MM_UpdateCart(IN orderId INT, IN productId INT, IN price DECIMAL(12,2), IN quantity INT)
BEGIN

	DECLARE q INT;
	SET q = 0;
	SELECT q = quantity FROM items WHERE order_id = orderId AND product_id = productId;
	DELETE FROM items WHERE order_id = orderId AND product_id = productId;
	IF quantity + q > 0 THEN
		INSERT INTO items (order_id, product_id, price, quantity) VALUES (orderId, productId, price, quantity + q);
	END IF;
END //
DELIMITER ;




-- /*******************************************************
-- *
-- * Proc: MM_DelCart
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_DelCart;

DELIMITER //
CREATE PROCEDURE MM_DelCart(IN orderId INT)
BEGIN
	DELETE FROM items WHERE order_id = @orderId;
	DELETE FROM orders WHERE id = @orderId;
END //
DELIMITER ;


-- /*******************************************************
-- *
-- * Proc: MM_ShipTo
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_ShipTo;

DELIMITER //
CREATE PROCEDURE MM_ShipTo(
	IN order_id INT,
	IN confirmation VARCHAR(36),
	IN customer_name VARCHAR(255),
	IN customer_email VARCHAR(255),
	IN phone_number VARCHAR(10),
	IN ship_to_name VARCHAR(255),
	IN ship_to_address1 VARCHAR(255),
	IN ship_to_address2 VARCHAR(255),
	IN ship_to_city VARCHAR(255),
	IN ship_to_country VARCHAR(255),
	IN ship_to_state VARCHAR(2),
	IN ship_to_zip VARCHAR(5))
BEGIN
	UPDATE orders
		SET order_status = 1,
			order_date = NOW(),	
			order_guid = confirmation,
			customer_name = customer_name,
			customer_email = customer_email,
			phone_number = phone_number,
			ship_to_name = ship_to_name,
			ship_to_address1 = ship_to_address1,
			ship_to_address2 = ship_to_address2,
			ship_to_city = ship_to_city,
			ship_to_country = ship_to_country,
			ship_to_state = ship_to_state,
			ship_to_zip = ship_to_zip
		WHERE id = order_id;

END //
DELIMITER ;

-- /*******************************************************
-- *
-- * Proc: MM_Submit
-- *
-- *******************************************************/

DROP PROCEDURE IF EXISTS MM_Submit;

DELIMITER //
CREATE PROCEDURE MM_Submit(IN order_id INT)
BEGIN
	UPDATE orders
		SET order_status = 1
		WHERE id = @order_id;

END //
DELIMITER ;

-- /*******************************************************
-- *
-- * Data: Products
-- *
-- *******************************************************/
INSERT INTO brands (name)
VALUES (
'Alvita'
),(
'Traditional Medicinals'
),(
'Yogi Tea'
);


INSERT INTO products (fid, brand_id, name, size, upc, ean13, 
category, price, ingredients, servingsize, servings, image) 
VALUES (
'0440e1e9-bb7f-436b-bb85-d9ee48afa4d9',
1,
'Senna Leaf',
'30 tea bags',
'726016005258',
'0726016005258',
'Tea & Coffee',
2.91,
'Senna Leaf',
'1 capsule',
'90',
'ais-283_1.jpg'
),
(
'62cfca6b-fa5b-402e-b30e-5f46a04d13de',
3,
'Detox Tea',
'16 tea bags',
'076950450080',
'0076950450080',
'Tea & Coffee',
4.38,
'Indian Sarsaparilla Root,Organic Cinnamon Bark,Organic Ginger Root,Licorice Root,Burdock Root,Organic Dandelion Root,Organic Cardamom Seed,Organic Clove Bud,Organic Black Pepper,Juniper Berry Extract,Long Pepper Berry,Chinese Amur Cork Tree Bark,Japanese Honeysuckle Flower,Forsythia Fruit,Gardenia Flower,Skullcap Root,Black Cohosh Root,Chinese Goldenthread Root,Rhubarb Root,Wax Gourd,Asian Psyllium Seed',
'1 tea bag',
'16',
'824_YogiTeaDetox_L.jpg'
),
(
'2de8d690-2f3b-4505-a59d-25533fc3afd8',
2,
'Peppermint Herb Tea',
'0.6 oz; 17 g',
'032917000163',
'0032917000163',
'Tea & Coffee',
3.72,
'Peppermint',
'1 cup brewed tea',
'16',
'f-032917000163.jpg'
),
(
'c230b3f5-9739-4cde-bd34-218910196762',
3,
'Green Tea Kombucha',
'16 tea bags',
'076950450219',
'0076950450219',
'Tea & Coffee',
4.22,
'Natural Passion Fruit Flavor,Natural Plum Flavor',
'1 tea bag (makes 8 fl oz)',
'16',
'f-076950450219.jpg'
),
(
'20c53fbd-8fc8-43ea-afd9-e79bee7d0137',
3,
'Bedtime Tea',
'16 tea bags',
'076950450011',
'0076950450011',
'Tea & Coffee',
4.2,
'Natural Orange, Flavor',
'1 tea bag (makes 8 fl oz)',
'16',
'821_YogiTeaBedtime_L.jpg'
),
(
'de120df4-3e2e-4b2c-b7d0-b0fd558aedab',
1,
'Red Clover Tea',
'30 tea bags',
'726016005029',
'0726016005029',
'Tea & Coffee',
3.5,
'Red Clover (Aerial Part)',
'1 bag',
'30',
'f-726016005029.jpg'
),
(
'7704fd7d-f785-4e29-9497-f1118526ea17',
3,
'Peach Detox Tea',
'16 tea bags',
'076950450233',
'0076950450233',
'Tea & Coffee',
4.51,
'Organic Cinnamon Bark,Organic Ginger Root,Organic Cardamom Seed,Organic Licorice Root,Organic Clove Bud,Organic Orange Peel,Bilberry Leaf,Organic Parsley Leaf,Fo-ti Root,Cornsilk Stem,Organic Dandelion Root,Organic Black Pepper,Long Pepper Berry,Other Natural Peach Flavor,Natural Cinnamon Oil,Natural Cardamom Oil,Natural Ginger Oil',
'1 tea bag',
'16',
'828_YogiTeaPeachDetox_L.jpg'
),
(
'd5580d77-3d74-449e-bb08-ec0f83c3fc58',
2,
'Herbal Tea Organic Throat Coat',
'1.13 oz; 32 g',
'032917000132',
'0032917000132',
'Tea & Coffee',
3.73,
'Organic Wild Cherry Bark [Bhp],Organic Bitter Fennel Fruit [Pheur],Organic Cinnamon Bark [Jp],Organic Sweet Orange Peel',
'1 cup',
'16',
'f-032917000132.jpg'
),
(
'4988187d-7f53-4490-93cf-6318f781de54',
3,
'Cold Season Tea',
'1.12 oz',
'076950450097',
'0076950450097',
'Tea & Coffee',
3,
'Organic Ginger Root,Organic Licorice Root,Organic Eucalyptus Leaf,Organic Orange Peel,Organic Valerian Root,Organic Lemongrass,Organic Peppermint Leaf,Organic Basil Leaf,Organic Cardamom Seed,Organic Oregano Leaf,Organic Black Pepper,Organic Clove Bud,Organic Parsley Leaf,Organic Yarrow Flower,Organic Cinnamon Bark,Other Organic Orange Flower',
'1 tea bag',
'16',
'f-076950450097.jpg'
),
(
'65fad80d-f699-4d95-9221-bae1a4bde80b',
3,
'Organic Ginger Tea',
'16 tea bags',
'076950450110',
'0076950450110',
'Tea & Coffee',
3.76,
'Organic Ginger Root,Organic Lemongrass,Organic Licorice Root,Organic Peppermint Leaf,Organic Black Pepper',
'1 tea bag',
'16',
'826_YogiTeaGinger_L.jpg'
),
(
'bd4ed099-85b1-4f2f-9ae3-7968b09f7eed',
2,
'Herbal Tea Organic Smooth Move',
'16 tea bags',
'032917000095',
'0032917000095',
'Tea & Coffee',
4.68,
'Organic Licorice Root [Pheur],Organic Bitter Fennel Fruit [Pheur],Organic Sweet Orange Peel,Organic Cinnamon Bark,Organic Coriander Fruit [Pheur],Organic Ginger Rhizome [Pheur]',
'1 cup',
'16',
'f-032917000095.jpg'
),
(
'02f5e26a-88af-4b4a-93d3-3d494e0a55be',
1,
'Hawthorn Berries Tea Bags',
'24 tea bags',
'726016004497',
'0726016004497',
'Tea & Coffee',
3.75,
'Hawthorn Berries',
'1 bag',
'24',
'ais-300b_1.jpg'
),
(
'9142d42b-b8b1-4a73-9d9f-696bcfa13e64',
3,
'Egyptian Licorice Tea',
'16 tea bags',
'076950415164',
'0076950415164',
'Tea & Coffee',
3.92,
'Organic Licorice Root,Organic Cinnamon Bark,Organic Orange Peel,Organic Ginger Root,Organic Cardamom Seed,Organic Black Pepper,Organic Clove Bud,Other Natural Tangerine Flavor,Natural Cinnamon Oil',
'1 tea bag',
'16',
'831_YogiTeaEgyptian_L.jpg'
),
(
'76a121a1-cce6-45d9-b8ea-c63517806b6a',
3,
'Echinacea Immune Support Tea',
'16 tea bags',
'076950450103',
'0076950450103',
'Tea & Coffee',
4.08,
'Organic Peppermint Leaf,Organic Lemongrass,Organic Licorice Root,Organic Cinnamon Bark,Organic Spearmint Leaf,Organic Fennel Seed,Organic Cardamom Seed,Organic Rose Hip,Organic Ginger Root,Organic Burdock Root,Stevia Leaf,Organic Mullein Leaf,Organic Clove Bud,Astragalus Root Extract,Organic Black Pepper,Other Organic Lemon Flavor,Natural Cinnamon Oil,Natural Cardamom Oil,Natural Ginger Oil',
'1 tea bag (makes 8 fl oz)',
'16',
'f-076950450103.jpg'
),
(
'186cbd80-7660-4873-b737-57305cf340b7',
3,
'Green Tea Super Anti-Oxidant',
'16 tea bags',
'076950450363',
'0076950450363',
'Tea & Coffee',
3.95,
'Organic Lemongrass,Organic Green Tea Leaf,Organic Licorice Root,Jasmine Green Tea Leaf,Organic Alfalfa Leaf,Organic Burdock Root,Organic Dandelion Root,Irish Moss Powder',
'1 tea bag (makes 8 fl oz)',
'16',
'819_YogiTeaGreen_L.jpg'
),
(
'09022229-9774-4a09-beec-f912191be160',
3,
'Lemon Ginger Tea',
'16 tea bags',
'076950450172',
'0076950450172',
'Tea & Coffee',
4.35,
'Organic Ginger Root,Organic Lemongrass,Lemon Peel,Organic Licorice Root,Organic Black Pepper,Organic Peppermint Leaf,Other Natural Lemon Flavor,Natural Licorice Flavor,Citric Acid',
'1 tea bag',
'16',
'3312_2790_large.jpg'
),
(
'23b652a8-a31b-4fe9-9b28-50e6ea2eda1b',
1,
'Tea Bags Fennel Seed Caffeine Free',
'24 tea bags',
'726016004251',
'0726016004251',
'Tea & Coffee',
4.4,
'Fennel Seed',
'1 bag',
'24',
'f-726016004251.jpg'
),
(
'3c8da2ea-7383-4fde-a489-31970a05bc7a',
1,
'Tea Bags',
'24 tea bags',
'726016004701',
'0726016004701',
'Tea & Coffee',
3.36,
'Milk Thistle',
'1 bag',
'24',
'f-726016004701.jpg'
),
(
'96afe338-872f-47ed-83bc-6a458cfe63f9',
3,
'Green Tea Pure Green Decaf',
'16 tea bags',
'076950450417',
'0076950450417',
'Tea & Coffee',
3.72,
'Organic Decaffeinated Green Tea Leaf',
'1 tea bag (makes 8 fl oz)',
'16',
'f-076950450417.jpg'
),
(
'0a6e0629-f4de-4492-afa6-ba1bad151d79',
3,
'Green Tea Energy 16 Tea Bags',
'16 tea bags',
'076950450271',
'0076950450271',
'Tea & Coffee',
3.53,
'Panax Ginseng,Panax Quinquefolium,Eleutherococcus Senticosus,Proprietary Blend Of Herbs: Organic Green Tea Leaf,Organic Lemongrass,Organic Spearmint Leaf,Kombucha',
'1 tea bag (makes 8 fl oz)',
'16',
'f-076950450271.jpg'
);

