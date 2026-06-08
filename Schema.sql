-- ============================================================
--  E-Commerce Store — PostgreSQL Schema
--  University of Lahore | Database Systems Lab
-- ============================================================

CREATE TABLE CUSTOMER (
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    address     TEXT,
    email       VARCHAR(150)    UNIQUE NOT NULL,
    phone       VARCHAR(20)
);

-- -------------------------------------------------------

CREATE TABLE COURIER (
    tracking_id   VARCHAR(50)   PRIMARY KEY,
    current_state VARCHAR(50)   NOT NULL
);

-- -------------------------------------------------------

CREATE TABLE PRODUCT (
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(200)    NOT NULL,
    description TEXT,
    quantity    INT             NOT NULL DEFAULT 0,
    price       DECIMAL(10,2)   NOT NULL,
    images      BYTEA
);

-- -------------------------------------------------------

CREATE TABLE "ORDER" (
    id                  SERIAL          PRIMARY KEY,
    order_date          DATE            NOT NULL DEFAULT CURRENT_DATE,
    status              VARCHAR(30)     NOT NULL DEFAULT 'pending',
    customer_id         INT             NOT NULL REFERENCES CUSTOMER(id),
    courier_tracking_id VARCHAR(50)     REFERENCES COURIER(tracking_id)
);

-- -------------------------------------------------------

CREATE TABLE ORDER_ITEM (
    id          SERIAL          PRIMARY KEY,
    order_id    INT             NOT NULL REFERENCES "ORDER"(id),
    product_id  INT             NOT NULL REFERENCES PRODUCT(id),
    quantity    INT             NOT NULL,
    unit_price  DECIMAL(10,2)   NOT NULL
);

-- -------------------------------------------------------

CREATE TABLE PAYMENT (
    id           SERIAL          PRIMARY KEY,
    method       VARCHAR(50)     NOT NULL,
    card_details VARCHAR(200),
    order_id     INT             NOT NULL REFERENCES "ORDER"(id)
);
