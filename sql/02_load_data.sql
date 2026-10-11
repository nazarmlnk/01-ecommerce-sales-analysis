\copy categories (product_category_name, product_category_name_english) FROM 'data/processed/categories.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy geolocation (zip_code_prefix, lat, lng, city, state) FROM 'data/processed/geolocation.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy sellers (seller_id, seller_zip_code_prefix, seller_city, seller_state) FROM 'data/processed/sellers.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy customers (customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) FROM 'data/processed/customers.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy products (product_id, product_category_name, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm, category) FROM 'data/processed/products.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy orders (order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date, is_delivered, purchase_month, delivery_days, is_late, in_analysis_period) FROM 'data/processed/orders.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value) FROM 'data/processed/order_items.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy payments (order_id, payment_sequential, payment_type, payment_installments, payment_value) FROM 'data/processed/payments.csv' WITH (FORMAT csv, HEADER true, NULL '')

\copy reviews (order_id, review_score, review_creation_date, review_answer_timestamp) FROM 'data/processed/reviews.csv' WITH (FORMAT csv, HEADER true, NULL '')


SELECT 'categories' AS table_name, COUNT(*) FROM categories
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews;