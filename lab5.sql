/* Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.*/

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

USE sakila;

CREATE VIEW rental_info as
SELECT rental.customer_id, concat(first_name, ' ', last_name) as name, email, count(rental.customer_id) as rental_count FROM sakila.rental
JOIN sakila.customer ON sakila.rental.customer_ID = sakila.customer.customer_ID
GROUP BY customer_ID;

-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.


CREATE TEMPORARY TABLE temp_table as
SELECT rental_info.customer_id, name, SUM(amount) AS money_spent FROM sakila.payment
INNER JOIN sakila.rental_info on payment.customer_id = rental_info.customer_id
GROUP BY customer_id;

SELECT * FROM temp_table;

-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH cte as (
    SELECT temp_table.customer_id, money_spent, rental_count, rental_info.name, email FROM temp_table
	JOIN rental_info on temp_table.customer_id = rental_info.customer_id
    )
SELECT * FROM cte;


-- Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.*/

WITH cte as (
    SELECT temp_table.customer_id, money_spent, rental_count, rental_info.name, email, (money_spent/rental_count) as average_payment_per_rental FROM temp_table
	JOIN rental_info on temp_table.customer_id = rental_info.customer_id
    )
SELECT * FROM cte;

