-- 1. Top 3 Most Frequently Issued Books
SELECT issued_book_name, COUNT(*) AS times_issued
FROM issuestatus
GROUP BY issued_book_name
ORDER BY times_issued DESC
LIMIT 3;

-- 2. Customers Who Borrowed But Never Returned
SELECT c.customer_name, i.issued_book_name
FROM issuestatus i
LEFT JOIN returnstatus r ON i.isbn_book = r.isbn_book2 AND i.issued_cust = r.return_cust
JOIN customer c ON i.issued_cust = c.customer_id
WHERE r.return_id IS NULL;

-- 3. Average Salary by Position and Branch
SELECT position, branch_no, ROUND(AVG(salary), 2) AS avg_salary
FROM employee
GROUP BY position, branch_no
ORDER BY avg_salary DESC;

-- 4. Branch with Maximum Customers Registered
SELECT b.branch_no, COUNT(c.customer_id) AS total_customers
FROM branch b
JOIN employee e ON b.branch_no = e.branch_no
JOIN issuestatus i ON e.branch_no = b.branch_no
JOIN customer c ON i.issued_cust = c.customer_id
GROUP BY b.branch_no
ORDER BY total_customers DESC
LIMIT 1;

-- 5. Find Customers Who Borrowed More Than 1 Category
SELECT i.issued_cust, c.customer_name, COUNT(DISTINCT b.category) AS categories_borrowed
FROM issuestatus i
JOIN books b ON i.isbn_book = b.isbn
JOIN customer c ON i.issued_cust = c.customer_id
GROUP BY i.issued_cust, c.customer_name
HAVING COUNT(DISTINCT b.category) > 1;

-- 6. Most Popular Category Based on Issues
SELECT b.category, COUNT(*) AS issues_count
FROM issuestatus i
JOIN books b ON i.isbn_book = b.isbn
GROUP BY b.category
ORDER BY issues_count DESC
LIMIT 1;

-- 7. Rank Books by Times Issued (Window Function)
SELECT issued_book_name, COUNT(*) AS total_issues,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS popularity_rank
FROM issuestatus
GROUP BY issued_book_name;

-- 8. Customer Borrowing Streak (Max Books Issued Consecutively)
SELECT issued_cust, COUNT(*) AS borrow_count,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_by_activity
FROM issuestatus
GROUP BY issued_cust;


