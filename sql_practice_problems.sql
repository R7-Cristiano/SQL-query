-- -------------------------------
-- 📘 테이블 생성 (MariaDB 기준)
-- -------------------------------

-- 고객 등급 테이블
CREATE TABLE grades (
    grade_id INT PRIMARY KEY,
    grade_name VARCHAR(20) NOT NULL,
    discount_rate DECIMAL(5,2)
);

-- 고객 테이블
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    gender CHAR(1),
    age INT,
    grade_id INT,
    FOREIGN KEY (grade_id) REFERENCES grades(grade_id)
);

-- 상품 테이블
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(20),
    price DECIMAL(10,2)
);

-- 주문 테이블
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 주문 상세 테이블
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- -------------------------------
-- 📥 더미 데이터 INSERT
-- -------------------------------

-- 등급
INSERT INTO grades VALUES
(1, 'Bronze', 0.00),
(2, 'Silver', 5.00),
(3, 'Gold', 10.00),
(4, 'Platinum', 15.00),
(5, 'Diamond', 20.00);

-- 고객
INSERT INTO customers VALUES
(1, 'Alice', 'F', 29, 3),
(2, 'Bob', 'M', 34, 2),
(3, 'Charlie', 'M', 25, 1),
(4, 'Diana', 'F', 40, 3),
(5, 'Eve', 'F', 22, 2),
(6, 'Frank', 'M', 31, 5);  -- Diamond 고객

-- 상품
INSERT INTO products VALUES
(101, 'Shampoo', 'Beauty', 12.50),
(102, 'Toothpaste', 'Health', 5.75),
(103, 'Notebook', 'Stationery', 3.20),
(104, 'Pen', 'Stationery', 1.10),
(105, 'Face Cream', 'Beauty', 25.00);

-- 주문
INSERT INTO orders VALUES
(1001, 1, '2024-12-01', 50.75),
(1002, 2, '2024-12-02', 17.20),
(1003, 1, '2025-01-15', 30.00),
(1004, 3, '2025-02-10', 6.40),
(1005, 4, '2025-02-15', 25.00),
(1006, 5, '2025-03-01', 37.25);

-- 주문 상세
INSERT INTO order_items VALUES
(1, 1001, 101, 2),
(2, 1001, 105, 1),
(3, 1002, 102, 3),
(4, 1003, 101, 1),
(5, 1003, 103, 5),
(6, 1004, 104, 4),
(7, 1005, 105, 1),
(8, 1006, 101, 1),
(9, 1006, 102, 2);

-- 고객 정보 전체 조회
SELECT * FROM customers;

-- 등급 정보 전체 조회
SELECT * FROM grades;

-- 상품 정보 전체 조회
SELECT * FROM products;

-- 주문 정보 전체 조회
SELECT * FROM orders;

-- 주문 상세 정보 전체 조회
SELECT * FROM order_items;

-- [문제 4] ‘gold’ 등급의 고객들이 구매한 상품 이름과 수량을 출력
SELECT p.name, oi.quantity
FROM customers c
JOIN grades g ON c.grade_id = g.grade_id
JOIN orders o ON o.customer_id  = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE g.grade_name = 'gold';

-- [문제 3] 상품별로 총 판매 수량 조회
SELECT p.name, SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_quantity DESC;

-- [문제 6] 상품 카테고리별 평균 판매단가 출력
SELECT category, AVG(price) AS avg_price
FROM products
GROUP BY category
ORDER BY avg_price DESC;

-- [문제 7] 한번도 주문하지 않은 고객의 이름과 등급을 조회 (LEFT JOIN + IS NULL)
SELECT c.name, g.grade_name
FROM customers c
JOIN grades g ON c.grade_id = g.grade_id
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- [문제 7] 한번도 주문하지 않은 고객 (NOT EXISTS 사용)
SELECT c.name, g.grade_name
FROM customers c
JOIN grades g ON g.grade_id = c.grade_id
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);

-- [문제 8] 고객별로 구매한 총 수량을 구하고, 5개 이상 구매한 고객만 조회
SELECT c.name, SUM(oi.quantity) AS total_quantity
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
HAVING total_quantity >= 5
ORDER BY total_quantity DESC;

-- [문제 9] 할인율을 반영한 최종 지불단가 계산
SELECT c.name, p.name AS product_name, oi.quantity, p.price, g.discount_rate,
       ROUND(p.price * oi.quantity * (1 - g.discount_rate / 100), 2) AS final_payment
FROM customers c
JOIN grades g ON g.grade_id = c.grade_id
JOIN orders o ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
ORDER BY c.name, p.name;

-- [문제 10] 상품별 매출 계산 후 top1 조회
SELECT p.name, SUM(p.price * oi.quantity) AS total_sales
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
GROUP BY p.product_id
ORDER BY total_sales DESC
LIMIT 1;

-- [문제 10] 매출 상위 동률 포함
SELECT p.name, SUM(p.price * oi.quantity) AS total_sales
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
GROUP BY p.product_id
HAVING total_sales = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(p2.price * oi2.quantity) AS total
        FROM products p2
        JOIN order_items oi2 ON oi2.product_id = p2.product_id
        JOIN orders o2 ON o2.order_id = oi2.order_id
        GROUP BY p2.product_id
    ) AS sub
);