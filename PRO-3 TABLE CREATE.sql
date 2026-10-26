CREATE DATABASE Market_place;
USE Market_place;

CREATE TABLE products_v2 (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    brand VARCHAR(50),
    supplier_id INT,
    cost_price DECIMAL(10,2),
    mrp DECIMAL(10,2),
    weight_kg DECIMAL(6,2),
    launch_date DATE
);

SELECT * FROM products_v2;

SELECT COUNT(*) AS total_products
FROM products_v2;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE payment_fees_v2 (
    payment_method VARCHAR(20) PRIMARY KEY,
    fee_percentage DECIMAL(5,2),
    settlement_days INT
);

SELECT * FROM payment_fees_v2;

CREATE TABLE orders_v2 (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    product_id INT,
    quantity INT,
    selling_price DECIMAL(10,2),
    order_status VARCHAR(20),
    payment_method VARCHAR(20),
    order_channel VARCHAR(20),
    warehouse_id INT,
    
    FOREIGN KEY (product_id) 
    REFERENCES products_v2(product_id),

    FOREIGN KEY (payment_method) 
    REFERENCES payment_fees_v2(payment_method)
);

CREATE TABLE logistics_cost_v2 (
    logistics_id INT PRIMARY KEY,
    order_id INT,
    shipping_cost DECIMAL(10,2),
    reverse_cost DECIMAL(10,2),
    delivery_days INT,
    delivery_status VARCHAR(20),

    FOREIGN KEY (order_id) 
    REFERENCES orders_v2(order_id)
);

CREATE TABLE returns_v2 (
    return_id INT PRIMARY KEY,
    order_id INT,
    return_flag VARCHAR(1),
    return_reason VARCHAR(50),
    return_initiated_date DATE,
    refund_mode VARCHAR(20),
    refund_status VARCHAR(20),
    customer_fault_flag VARCHAR(1),

    FOREIGN KEY (order_id) 
    REFERENCES orders_v2(order_id)
);

CREATE TABLE discount_v2 (
    discount_id INT PRIMARY KEY,
    order_id INT,
    discount_amount DECIMAL(10,2),
    discount_type VARCHAR(20),
    coupon_code VARCHAR(20),
    is_stackable VARCHAR(20),

    FOREIGN KEY (order_id) 
    REFERENCES orders_v2(order_id)
);