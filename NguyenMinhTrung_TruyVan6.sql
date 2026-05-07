CREATE DATABASE sales_management_db;
-- drop database sales_management_db;
USE sales_management_db;
--  Mã khách hàng, Họ và tên, Email, Giới tính, Ngày sinh.

CREATE TABLE customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    fullname VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    dob DATE NOT NULL
);

create table categories(
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

create table products(
	product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL(18,2) NOT NULL CHECK(price > 0),
    stock INT CHECK(stock >=0 ),
    category_id INT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
    
);

create table orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	status ENUM ('COMPLETED', 'CANCEL') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

create table order_detail(
	detail_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    order_id INT,
    quantity INT NOT NULL CHECK (quantity >= 0),
    unit_price DECIMAL(18,2) CHECK( unit_price >= 0),
    status ENUM ('COMPLETED', 'CANCEL') NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
	FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


-- Phần II - Nhập dữ liệu ban đầu
-- 2.1. Dữ liệu Khách hàng (5 khách hàng)
INSERT INTO customers (fullname, email, gender, dob) VALUES
('Nguyễn Văn An',    'an.nguyen@gmail.com',    'Male', '2002-03-15'),
('Trần Thị Bích',    'bich.tran@yahoo.com',    'Female', '2001-07-22'),
('Lê Hoàng Cường',   'cuong.le@outlook.com',   'Male', '1985-11-08'),
('Phạm Ngọc Dung',   'dung.pham@gmail.com',    'Female', '2004-01-30'),
('Hoàng Văn Em',     'em.hoang@gmail.com',     'Male', '1990-05-18');
-- 2.2. Dữ liệu Danh mục (5 danh mục)
INSERT INTO categories (category_name) VALUES
('Điện tử'),
('Thời trang'),
('Thực phẩm'),
('Nội thất'),
('Sách & Văn phòng');
-- 2.3. Dữ liệu Sản phẩm (5 sản phẩm)
INSERT INTO products (product_name, price, stock, category_id) VALUES
-- Mỗi danh mục có 1 sản phẩm, riêng 'Điện tử' có 2 sản phẩm (để test HAVING >= 2)
('iPhone 15 Pro Max',       29990000.00,  10, 1),   -- Điện tử (SP1)
('MacBook Air M3',          25990000.00,   5, 1),   -- Điện tử (SP2)
('Áo sơ mi trắng',            450000.00,  50, 2),   -- Thời trang
('Bánh quy dinh dưỡng',        85000.00, 100, 3),   -- Thực phẩm
('Bàn làm việc gỗ tự nhiên', 3200000.00,   8, 4);   -- Nội thất
-- Lưu ý: Danh mục 'Sách & Văn phòng' chỉ có 1 sp → sẽ bị HAVING lọc bỏ
-- 2.4. Dữ liệu Đơn hàng (5 đơn hàng)
INSERT INTO orders (customer_id, created_at, status) VALUES
(1, '2026-01-10 08:30:00', 'COMPLETED'),   -- Đơn 1: An mua iPhone + Áo sơ mi

(1, '2026-03-20 10:15:00', 'COMPLETED'),     -- Đơn 3: An mua Bánh quy
(3, '2026-04-05 16:45:00', 'COMPLETED'),    -- Đơn 4: Cường mua Bàn làm việc
(5, '2026-04-25 09:00:00', 'CANCEL');     -- Đơn 5: Em mua Áo sơ mi (KHÔNG có order_detail - bị hủy)
-- 2.5. Dữ liệu Chi tiết đơn hàng (5 chi tiết)
INSERT INTO Order_Detail (order_id, product_id, quantity, unit_price, status) VALUES
(1, 1, 1, 29990000.00 , 'COMPLETED'),  -- Đơn 1: 1 chiếc iPhone 15 Pro Max
(1, 3, 1,   450000.00 , 'COMPLETED'),  -- Đơn 1: 1 áo sơ mi trắng
(2, 2, 1, 25990000.00 , 'COMPLETED'),  -- Đơn 2: 1 chiếc MacBook Air M3
(3, 4, 1,    85000.00, 'COMPLETED'),  -- Đơn 3: 1 gói bánh quy
(4, 5, 1,  3200000.00, 'CANCEL');  -- Đơn 4: 1 bàn làm việc
-- Lưu ý: Đơn 5 KHÔNG có chi tiết → order_id=5 không xuất hiện ở đây

-- Phần III - Cập nhật dữ liệu
UPDATE products 
SET price = 10000000
WHERE product_id = 5;
-- select * from products;
UPDATE customers
SET email = 'nguyenvana@gmail.com'
WHERE customer_id = 5;
-- select * from customers;

-- Phần IV - Xóa dữ liệu
DELETE FROM order_detail
WHERE status LIKE '%CANCEL%'
LIMIT 1;
-- select * from order_detail;
/*Lấy danh sách khách hàng gồm họ tên, email và sử dụng câu lệnh CASE để hiển thị giới tính dưới dạng văn bản ('Nam' hoặc 'Nữ').
 Sử dụng AS để đặt lại tên cột.
*/
SELECT 
fullname,
 email,
 CASE 
	WHEN gender = 'MALE' THEN 'NAM'
    WHEN gender = 'FEMALE' THEN 'NỮ'
    WHEN gender = 'ORTHER' THEN 'KHÁC'
	ELSE 'KHÔNG BIẾT'
END AS 'Gioi tinh'
FROM customers;
-- Lấy thông tin 3 khách hàng trẻ tuổi nhất: Sử dụng hàm YEAR() và NOW() để tính tuổi, kết hợp mệnh đề ORDER BY và LIMIT.
SELECT *, YEAR(NOW()) - YEAR(dob) as 'age' FROM customers
ORDER BY dob DESC
LIMIT 3;
-- Hiển thị danh sách tất cả các đơn hàng kèm theo tên khách hàng tương ứng (Sử dụng INNER JOIN).
SELECT o.order_id, o.customer_id, c.fullname , o.created_at, o.status
FROM orders o 
INNER JOIN customers c ON o.customer_id = c.customer_id;

-- CASE 4
-- Đếm số lượng sản phẩm theo từng danh mục. Sử dụng GROUP BY và HAVING để chỉ hiển thị các danh mục có từ 2 sản phẩm trở lên.
SELECT category_name, COUNT(product_id) AS total
FROM products p
join categories c
on p.category_id = c.category_id
GROUP BY category_name
HAVING COUNT(product_id) >=2;

-- 5. (Scalar Subquery) Lấy danh sách các sản phẩm có giá lớn hơn giá trị trung bình (AVG) của tất cả các sản phẩm trong cửa hàng.
SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

-- Truy vấn 6 (Column Subquery): Lấy danh sách thông tin các khách hàng chưa từng đặt bất kỳ đơn hàng nào (Sử dụng toán tử NOT IN kết hợp truy vấn lồng).
SELECT * FROM customers 
WHERE customer_id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL); -- Sử dụng truy vấn lồng để lọc 

-- Truy vấn 7: (Subquery với hàm tổng hợp) Tìm các phòng ban/danh mục có tổng doanh thu lớn hơn 120% doanh thu trung bình của toàn bộ cửa hàng
SELECT 
    c.category_id,
    c.category_name,
    SUM(od.quantity * od.unit_price) AS total_revenue
FROM categories c
INNER JOIN products p 
    ON c.category_id = p.category_id
INNER JOIN order_detail od 
    ON p.product_id = od.product_id
WHERE od.status = 'COMPLETED'
GROUP BY c.category_id, c.category_name
HAVING SUM(od.quantity * od.unit_price) > (
    
    SELECT AVG(category_revenue) * 1.2
    FROM (
        SELECT 
            SUM(od.quantity * od.unit_price) AS category_revenue
        FROM categories c
        INNER JOIN products p 
            ON c.category_id = p.category_id
        INNER JOIN order_detail od 
            ON p.product_id = od.product_id
        WHERE od.status = 'COMPLETED'
        GROUP BY c.category_id
    ) AS revenue_table
);

-- Truy vấn 8 (Correlated Subquery) Lấy danh sách các sản phẩm có giá đắt nhất trong từng danh mục (Truy vấn con tham chiếu đến outer query).
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    c.category_name
FROM products p
INNER JOIN categories c 
    ON p.category_id = c.category_id
WHERE p.price = (
    SELECT MAX(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);