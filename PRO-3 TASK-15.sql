SELECT 

    -- Total Sales
    SUM(o.quantity * o.selling_price) AS total_sales,

    -- Total Profit
    SUM(
        (o.selling_price - p.cost_price)
        * o.quantity
    ) AS total_profit,

    -- Total Discounts
    SUM(IFNULL(d.discount_amount,0)) AS total_discounts,

    -- Total Returns Loss
    SUM(
        CASE 
            WHEN r.return_flag = 'Y'
            THEN (o.quantity * o.selling_price)
            ELSE 0
        END
    ) AS total_returns_loss,

    -- Total Logistics Cost
    SUM(
        IFNULL(l.shipping_cost,0)
        + IFNULL(l.reverse_cost,0)
    ) AS total_logistics_cost,

    -- Total Payment Fees
    SUM(
        (o.quantity * o.selling_price)
        * (pf.fee_percentage / 100)
    ) AS total_payment_fees

FROM orders_v2 o

JOIN products_v2 p
ON o.product_id = p.product_id

LEFT JOIN discount_v2 d
ON o.order_id = d.order_id

LEFT JOIN returns_v2 r
ON o.order_id = r.order_id

LEFT JOIN logistics_cost_v2 l
ON o.order_id = l.order_id

LEFT JOIN payment_fees_v2 pf
ON o.payment_method = pf.payment_method;