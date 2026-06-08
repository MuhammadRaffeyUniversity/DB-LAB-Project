-- ============================================================
--  E-Commerce Store — 10 Real-World Features
--  University of Lahore | Database Systems Lab
-- ============================================================


-- ============================================================
--  FEATURE 01 — Add a New Product to the Store  [INSERT]
--  Store admin lists a new product with name, description,
--  stock quantity, and price.
-- ============================================================

INSERT INTO PRODUCT (name, description, quantity, price)
VALUES (
    'Embroidered Lawn Suit',
    'Premium 3-piece lawn suit with embroidered dupatta',
    50,
    4500.00
);


-- ============================================================
--  FEATURE 02 — Register a New Customer  [INSERT]
--  A new user signs up by providing name, address,
--  email, and phone number.
-- ============================================================

INSERT INTO CUSTOMER (name, address, email, phone)
VALUES (
    'Ayesha Tariq',
    'House 12, Block B, Gulshan-e-Iqbal, Karachi',
    'ayesha.tariq@gmail.com',
    '0312-4567890'
);


-- ============================================================
--  FEATURE 03 — Place an Order with Multiple Items  [INSERT]
--  A customer checks out a cart with multiple products.
--  An order record is created, then each product is added
--  as an order item.
-- ============================================================

-- Step 1: Create the order
INSERT INTO "ORDER" (customer_id, status)
VALUES (1, 'pending');
-- Suppose the returned order id = 1

-- Step 2: Add items to the order
INSERT INTO ORDER_ITEM (order_id, product_id, quantity, unit_price)
VALUES
    (1, 1, 2, 4500.00),   -- 2x Embroidered Lawn Suit
    (1, 3, 1, 1800.00);   -- 1x another product


-- ============================================================
--  FEATURE 04 — Record a Payment for an Order  [INSERT]
--  After placing an order, the customer pays via JazzCash,
--  EasyPaisa, card, or COD. Details stored against the order.
-- ============================================================

INSERT INTO PAYMENT (method, card_details, order_id)
VALUES (
    'JazzCash',
    '0312-4567890',
    1
);


-- ============================================================
--  FEATURE 05 — View All Orders for a Customer  [SELECT]
--  Customer views their order history with date, status,
--  total items, and total order value.
-- ============================================================

SELECT
    o.id          AS order_id,
    o.order_date,
    o.status,
    COUNT(oi.id)  AS total_items,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM "ORDER" o
JOIN ORDER_ITEM oi ON oi.order_id = o.id
WHERE o.customer_id = 1
GROUP BY o.id, o.order_date, o.status
ORDER BY o.order_date DESC;


-- ============================================================
--  FEATURE 06 — Search Products by Name  [SELECT]
--  Customer types a keyword in the search bar. ILIKE performs
--  a case-insensitive match, results sorted by price.
-- ============================================================

SELECT id, name, description, quantity, price
FROM PRODUCT
WHERE name ILIKE '%lawn%'
ORDER BY price ASC;


-- ============================================================
--  FEATURE 07 — Update Product Stock After a Sale  [UPDATE]
--  When an order is confirmed, stock is decremented.
--  Guard clause prevents stock from going negative.
-- ============================================================

UPDATE PRODUCT
SET quantity = quantity - 2
WHERE id = 1
  AND quantity >= 2;  -- guard: prevents negative stock


-- ============================================================
--  FEATURE 08 — Update Order Status & Assign Courier  [UPDATE]
--  When an order is dispatched, it is marked 'shipped'
--  and linked to a courier tracking record.
-- ============================================================

-- Step 1: Insert courier record
INSERT INTO COURIER (tracking_id, current_state)
VALUES ('TCS-20240601-001', 'picked_up')
ON CONFLICT (tracking_id) DO NOTHING;

-- Step 2: Link courier to order and update status
UPDATE "ORDER"
SET status               = 'shipped',
    courier_tracking_id  = 'TCS-20240601-001'
WHERE id = 1;


-- ============================================================
--  FEATURE 09 — View Full Order Details (All Tables)  [SELECT]
--  Admin views the complete breakdown of an order: items,
--  prices, customer info, payment method, and delivery status.
-- ============================================================

SELECT
    o.id                          AS order_id,
    o.order_date,
    o.status,
    c.name                        AS customer_name,
    c.phone,
    p.name                        AS product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total,
    py.method                     AS payment_method,
    cr.current_state              AS courier_status
FROM "ORDER" o
JOIN CUSTOMER    c  ON c.id            = o.customer_id
JOIN ORDER_ITEM  oi ON oi.order_id     = o.id
JOIN PRODUCT     p  ON p.id            = oi.product_id
JOIN PAYMENT     py ON py.order_id     = o.id
LEFT JOIN COURIER cr ON cr.tracking_id = o.courier_tracking_id
WHERE o.id = 1;


-- ============================================================
--  FEATURE 10 — Remove a Product from the Store  [DELETE]
--  Admin deletes a product only if it has never been ordered,
--  protecting historical order data from breaking.
-- ============================================================

DELETE FROM PRODUCT
WHERE id = 5
  AND id NOT IN (
      SELECT DISTINCT product_id FROM ORDER_ITEM
  );
