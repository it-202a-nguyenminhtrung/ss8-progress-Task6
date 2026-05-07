-- Truy vấn 6 (Column Subquery): Lấy danh sách thông tin các khách hàng chưa từng đặt bất kỳ đơn hàng nào (Sử dụng toán tử NOT IN kết hợp truy vấn lồng).
SELECT * FROM customers 
WHERE customer_id NOT IN (SELECT customer_id FROM orders WHERE customer_id IS NOT NULL); -- Sử dụng truy vấn lồng để lọc 

SELECT * FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL; -- Liên kết 2 bảng bằng left join rồi lọc 