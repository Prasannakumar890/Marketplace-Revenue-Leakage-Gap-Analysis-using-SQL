-- task -1

SELECT 
    SUM(quantity * selling_price) AS total_sales_revenue
FROM orders_v2;

-- tsak -2

SELECT 
    p.category,

    SUM(o.quantity * o.selling_price) AS total_sales,

    SUM(o.quantity * p.cost_price) AS total_cost,

    SUM(
        (o.selling_price - p.cost_price) * o.quantity
    ) AS total_profit

FROM orders_v2 o
JOIN products_v2 p
ON o.product_id = p.product_id

GROUP BY p.category
ORDER BY total_profit DESC;

-- task-3

SELECT 
    p.product_id,
    p.category,
    p.sub_category,
    p.brand,

    SUM(o.quantity * o.selling_price) AS total_sales,

    SUM(o.quantity * p.cost_price) AS total_cost,

    SUM(
        (o.selling_price - p.cost_price) * o.quantity
    ) AS total_profit

FROM orders_v2 o
JOIN products_v2 p
ON o.product_id = p.product_id

GROUP BY 
    p.product_id,
    p.category,
    p.sub_category,
    p.brand

HAVING total_profit < 0

ORDER BY total_profit ASC;

-- task -4

SELECT 
    COUNT(DISTINCT order_id) AS discounted_orders,
    
    SUM(discount_amount) AS total_discount_amount

FROM discount_v2;

--  task -5

SELECT 
    payment_method,

    COUNT(order_id) AS total_orders,

    SUM(quantity * selling_price) AS total_sales_value

FROM orders_v2

GROUP BY payment_method

ORDER BY total_sales_value DESC;

-- task -6

SELECT 
    CASE 
        WHEN d.order_id IS NOT NULL THEN 'Discounted Orders'
        ELSE 'Non-Discounted Orders'
    END AS order_type,

    COUNT(DISTINCT o.order_id) AS total_orders,

    AVG(
        (o.selling_price - p.cost_price) * o.quantity
    ) AS avg_profit_per_order

FROM orders_v2 o

JOIN products_v2 p
ON o.product_id = p.product_id

LEFT JOIN discount_v2 d
ON o.order_id = d.order_id

GROUP BY order_type;

-- task -7

SELECT 
    SUM(o.quantity * o.selling_price) AS revenue_lost,

    SUM(
        (o.selling_price - p.cost_price) * o.quantity
    ) AS profit_lost

FROM returns_v2 r

JOIN orders_v2 o
ON r.order_id = o.order_id

JOIN products_v2 p
ON o.product_id = p.product_id

WHERE r.return_flag = 'Y';

-- task -8 

SELECT 
    r.return_reason,

    COUNT(r.return_id) AS total_returns,

    SUM(o.quantity * o.selling_price) AS revenue_lost,

    SUM(
        (o.selling_price - p.cost_price) * o.quantity
    ) AS profit_lost

FROM returns_v2 r

JOIN orders_v2 o
ON r.order_id = o.order_id

JOIN products_v2 p
ON o.product_id = p.product_id

WHERE r.return_flag = 'Y'

GROUP BY r.return_reason

ORDER BY profit_lost DESC;

-- tsak -9

SELECT 
    o.order_id,

    (o.quantity * o.selling_price) AS order_value,

    (l.shipping_cost + l.reverse_cost) AS total_logistics_cost,

    (
        (l.shipping_cost + l.reverse_cost)
        / (o.quantity * o.selling_price)
    ) * 100 AS logistics_cost_percentage

FROM orders_v2 o

JOIN logistics_cost_v2 l
ON o.order_id = l.order_id

WHERE (
        (l.shipping_cost + l.reverse_cost)
        / (o.quantity * o.selling_price)
      ) > 0.20

ORDER BY logistics_cost_percentage DESC;

-- task -10

SELECT 
    o.payment_method,

    SUM(o.quantity * o.selling_price) AS total_sales,

    SUM(o.quantity * p.cost_price) AS total_cost,

    SUM(
        (
            o.quantity * o.selling_price
        ) * (pf.fee_percentage / 100)
    ) AS total_payment_fee,

    SUM(
        (
            (o.selling_price - p.cost_price)
            * o.quantity
        )
        -
        (
            (o.quantity * o.selling_price)
            * (pf.fee_percentage / 100)
        )
    ) AS net_profit_after_fee

FROM orders_v2 o

JOIN products_v2 p
ON o.product_id = p.product_id

JOIN payment_fees_v2 pf
ON o.payment_method = pf.payment_method

GROUP BY o.payment_method

ORDER BY net_profit_after_fee DESC;

-- task -11

SELECT 
    o.order_id,

    (o.quantity * o.selling_price) AS order_value,

    IFNULL(d.discount_amount, 0) AS discount_loss,

    CASE 
        WHEN r.return_flag = 'Y'
        THEN (o.quantity * o.selling_price)
        ELSE 0
    END AS return_loss,

    IFNULL(l.shipping_cost, 0)
    + IFNULL(l.reverse_cost, 0)
    AS logistics_loss,

    (
        (o.quantity * o.selling_price)
        * (pf.fee_percentage / 100)
    ) AS payment_fee_loss,

    (
        IFNULL(d.discount_amount, 0)
        +
        CASE 
            WHEN r.return_flag = 'Y'
            THEN (o.quantity * o.selling_price)
            ELSE 0
        END
        +
        IFNULL(l.shipping_cost, 0)
        + IFNULL(l.reverse_cost, 0)
        +
        (
            (o.quantity * o.selling_price)
            * (pf.fee_percentage / 100)
        )
    ) AS total_leakage

FROM orders_v2 o

LEFT JOIN discount_v2 d
ON o.order_id = d.order_id

LEFT JOIN returns_v2 r
ON o.order_id = r.order_id

LEFT JOIN logistics_cost_v2 l
ON o.order_id = l.order_id

LEFT JOIN payment_fees_v2 pf
ON o.payment_method = pf.payment_method;

-- TASK -12
SELECT 
    p.product_id,
    p.category,
    p.sub_category,
    p.brand,

    SUM(o.quantity * o.selling_price) AS total_sales,

    SUM(o.quantity * p.cost_price) AS total_cost,

    SUM(
        (o.selling_price - p.cost_price)
        * o.quantity
    ) AS net_profit,

    RANK() OVER (
        ORDER BY 
        SUM(
            (o.selling_price - p.cost_price)
            * o.quantity
        ) DESC
    ) AS profit_rank

FROM orders_v2 o

JOIN products_v2 p
ON o.product_id = p.product_id

GROUP BY 
    p.product_id,
    p.category,
    p.sub_category,
    p.brand;
    
    -- task -13
    
    SELECT 
    p.category,

    COUNT(o.order_id) AS total_orders,

    AVG(
        (
            (o.selling_price - p.cost_price)
            / o.selling_price
        ) * 100
    ) AS avg_profit_margin_percentage,

    STDDEV(
        (
            (o.selling_price - p.cost_price)
            / o.selling_price
        ) * 100
    ) AS margin_variation

FROM orders_v2 o

JOIN products_v2 p
ON o.product_id = p.product_id

WHERE o.selling_price > 0

GROUP BY p.category

ORDER BY margin_variation DESC;

-- task -14

SELECT 
    o.customer_id,

    COUNT(o.order_id) AS total_orders,

    SUM(
        CASE 
            WHEN r.return_flag = 'Y' THEN 1
            ELSE 0
        END
    ) AS returned_orders,

    ROUND(
        (
            SUM(
                CASE 
                    WHEN r.return_flag = 'Y' THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(o.order_id),
        2
    ) AS return_rate_percentage

FROM orders_v2 o

LEFT JOIN returns_v2 r
ON o.order_id = r.order_id

GROUP BY o.customer_id;

-- Find Customers Above Marketplace Average

SELECT *
FROM (
    SELECT 
        o.customer_id,

        COUNT(o.order_id) AS total_orders,

        SUM(
            CASE 
                WHEN r.return_flag = 'Y' THEN 1
                ELSE 0
            END
        ) AS returned_orders,

        ROUND(
            (
                SUM(
                    CASE 
                        WHEN r.return_flag = 'Y' THEN 1
                        ELSE 0
                    END
                ) * 100.0
            ) / COUNT(o.order_id),
            2
        ) AS return_rate_percentage

    FROM orders_v2 o

    LEFT JOIN returns_v2 r
    ON o.order_id = r.order_id

    GROUP BY o.customer_id
) customer_returns

WHERE return_rate_percentage >
(
    SELECT 
        ROUND(
            (
                SUM(
                    CASE 
                        WHEN r.return_flag = 'Y' THEN 1
                        ELSE 0
                    END
                ) * 100.0
            ) / COUNT(o.order_id),
            2
        )
    FROM orders_v2 o

    LEFT JOIN returns_v2 r
    ON o.order_id = r.order_id
)

ORDER BY return_rate_percentage DESC;