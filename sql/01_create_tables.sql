-- ============================================================
-- Схема таблиць для проєкту Olist E-Commerce Sales Analysis
-- База даних: olist_ecommerce
-- Джерело даних: data/processed/ (очищені CSV після 01_data_cleaning.ipynb)
-- ============================================================

-- Видаляємо таблиці, якщо запускаємо скрипт повторно
-- (порядок важливий через зовнішні ключі)
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS sellers;
DROP TABLE IF EXISTS geolocation;
DROP TABLE IF EXISTS categories;

-- ------------------------------------------------------------
-- Довідники (без залежностей від інших таблиць)
-- ------------------------------------------------------------

CREATE TABLE categories (
    product_category_name          VARCHAR(100) PRIMARY KEY,
    product_category_name_english  VARCHAR(100)
);

CREATE TABLE geolocation (
    zip_code_prefix  INT PRIMARY KEY,
    lat              NUMERIC(10, 6),
    lng              NUMERIC(10, 6),
    city             VARCHAR(100),
    state            CHAR(2)
);

CREATE TABLE sellers (
    seller_id               VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix  INT,
    seller_city             VARCHAR(100),
    seller_state            CHAR(2)
);

CREATE TABLE customers (
    customer_id               VARCHAR(50) PRIMARY KEY,
    customer_unique_id        VARCHAR(50) NOT NULL,
    customer_zip_code_prefix  INT,
    customer_city             VARCHAR(100),
    customer_state            CHAR(2)
);

CREATE TABLE products (
    product_id                   VARCHAR(50) PRIMARY KEY,
    product_category_name        VARCHAR(100),
    category                     VARCHAR(100),   -- уже з перекладом і unknown замість NULL
    product_name_length          NUMERIC,
    product_description_length   NUMERIC,
    product_photos_qty           NUMERIC,
    product_weight_g             NUMERIC,
    product_length_cm            NUMERIC,
    product_height_cm            NUMERIC,
    product_width_cm             NUMERIC
);

-- ------------------------------------------------------------
-- Таблиці з зовнішніми ключами
-- ------------------------------------------------------------

CREATE TABLE orders (
    order_id                        VARCHAR(50) PRIMARY KEY,
    customer_id                     VARCHAR(50) NOT NULL REFERENCES customers(customer_id),
    order_status                    VARCHAR(20),
    order_purchase_timestamp        TIMESTAMP,
    order_approved_at               TIMESTAMP,
    order_delivered_carrier_date    TIMESTAMP,
    order_delivered_customer_date   TIMESTAMP,
    order_estimated_delivery_date   TIMESTAMP,
    is_delivered                    BOOLEAN,
    purchase_month                  DATE,
    delivery_days                   NUMERIC,
    is_late                         BOOLEAN,
    in_analysis_period              BOOLEAN
);

CREATE TABLE order_items (
    order_id              VARCHAR(50) NOT NULL REFERENCES orders(order_id),
    order_item_id         INT NOT NULL,
    product_id            VARCHAR(50) REFERENCES products(product_id),
    seller_id              VARCHAR(50) REFERENCES sellers(seller_id),
    shipping_limit_date   TIMESTAMP,
    price                 NUMERIC(10, 2),
    freight_value         NUMERIC(10, 2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE payments (
    order_id               VARCHAR(50) NOT NULL REFERENCES orders(order_id),
    payment_sequential     INT NOT NULL,
    payment_type           VARCHAR(20),
    payment_installments   INT,
    payment_value          NUMERIC(10, 2),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE reviews (
    order_id                   VARCHAR(50) PRIMARY KEY REFERENCES orders(order_id),
    review_score                INT,
    review_creation_date        TIMESTAMP,
    review_answer_timestamp     TIMESTAMP
);

-- ------------------------------------------------------------
-- Індекси для прискорення частих запитів (дати, категорії, регіони)
-- ------------------------------------------------------------

CREATE INDEX idx_orders_purchase_month ON orders(purchase_month);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_customers_state ON customers(customer_state);
CREATE INDEX idx_products_category ON products(category);
