SET SQL_SAFE_UPDATES = 0;

DELETE FROM discount_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE product_id IN (
        SELECT product_id
        FROM products_v2
        WHERE cost_price <= 0
           OR cost_price > mrp
    )
);

DELETE FROM returns_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE product_id IN (
        SELECT product_id
        FROM products_v2
        WHERE cost_price <= 0
           OR cost_price > mrp
    )
);

DELETE FROM logistics_cost_v2
WHERE order_id IN (
    SELECT order_id
    FROM orders_v2
    WHERE product_id IN (
        SELECT product_id
        FROM products_v2
        WHERE cost_price <= 0
           OR cost_price > mrp
    )
);

DELETE FROM orders_v2
WHERE product_id IN (
    SELECT product_id
    FROM products_v2
    WHERE cost_price <= 0
       OR cost_price > mrp
);

DELETE FROM products_v2
WHERE cost_price <= 0
   OR cost_price > mrp;