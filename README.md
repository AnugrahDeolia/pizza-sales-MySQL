# 🍕 Pizza Sales Analysis using MySQL

## 📌 Project Overview
This project involves an in-depth SQL-based analysis of pizza sales data using MySQL, aimed at answering practical business questions faced by a food retail business. The dataset represents real transactional data, including customer orders, pizza types, categories, sizes, prices, and order timestamps.

The analysis is structured into Basic, Intermediate, and Advanced SQL queries, allowing a progressive demonstration of SQL proficiency — from fundamental aggregations to complex analytical queries using joins, subqueries, and window functions. Each question is designed to uncover insights related to sales performance, revenue contribution, customer ordering behavior, and product demand trends.

By working with multiple interconnected tables, this project emphasizes relational database concepts, data integrity, and query optimization techniques. The ultimate objective is not just to retrieve data, but to translate raw transactional records into meaningful business insights that could support decision-making in areas such as inventory planning, pricing strategy, and sales optimization.

This project also serves as a strong demonstration of data analysis, structured problem-solving, and SQL query design, making it suitable for roles involving data analysis, backend systems, or business intelligence.
---

## 📂 Dataset Description
The dataset consists of multiple related tables that store information about:
- Orders placed by customers
- Pizza types and categories
- Pizza sizes and prices
- Quantity of pizzas ordered

### Tables Used:
- `orders`
- `order_details`
- `pizzas`
- `pizza_types`

---

## 🟢 Basic Level Analysis

### 1. Retrieve the total number of orders placed
```sql
SELECT count(order_id) from orders;
```
### 2. Calculate the total revenue generated from pizza sales
```sql
SELECT 
    ROUND(SUM(pizzas.price * order_details.quantity),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
```
### 3. Identify the highest-priced pizza
```sql
SELECT 
    pizza_types.name, pizzas.price
FROM
    pizzas
        JOIN
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
```
### 4. Identify the most common pizza size ordered
```sql
SELECT 
    pizzas.size, COUNT(order_details.quantity) AS order_count
FROM
    pizzas
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC
LIMIT 1;
```
### 5. List the top 5 most ordered pizza types along with their quantities
```sql
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS total_quantity_ordered
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY total_quantity_ordered DESC
LIMIT 5;
```
## 🟡 Intermediate Level Analysis 

### 6. Total quantity of each pizza category ordered
```sql
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;
```
### 7. Distribution of orders by hour of the day
```sql
SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS no_of_orders
FROM
    orders
GROUP BY hour;
```
### 8. Category-wise distribution of pizzas
```sql
SELECT 
    category, COUNT(name) AS no_of_pizzas
FROM
    pizza_types
GROUP BY category;
```
### 9. Average number of pizzas ordered per day
```sql
SELECT 
    AVG(quantity_ordered) AS avg_quantity_ordered_per_day
FROM
    (SELECT 
        orders.order_date,
            SUM(order_details.quantity) AS quantity_ordered
    FROM
        orders
    JOIN order_details ON order_details.order_id = orders.order_id
    GROUP BY orders.order_date) AS order_quantity;
```
### 10. Top 3 most ordered pizza types based on revenue
```sql
SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;
```
## 🔴 Advanced Level Analysis

### 11. Percentage contribution of each pizza type to total revenue
```sql
SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(pizzas.price * order_details.quantity),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS total_revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;
```
### 12. Cumulative revenue generated over time
```sql
select order_date, round(sum(revenue)
over (order by order_date),2) as cum_revenue
from
(select orders.order_date, round(sum(order_details.quantity * pizzas.price),2) as revenue
from orders
join order_details on orders.order_id = order_details.order_id
join pizzas on pizzas.pizza_id = order_details.pizza_id 
group by orders.order_date) as sales;
```
### 13. Top 3 pizza types based on revenue for each category
```sql
select category, name, revenue
from
(select category, name, revenue, 
rank() over (partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name, sum(order_details.quantity * pizzas.price)
as revenue from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name)
as a)
as b where rn<=3;
```
---
## 📊 Key Insights

- Large-sized pizzas contribute significantly to total revenue.
- Certain pizza categories consistently outperform others.
- Peak order volume occurs during specific hours of the day.
- A small number of pizza types generate a major share of total revenue.

## 🛠 Tools & Skills Used

- MySQL
- Joins & Subqueries
- Aggregate Functions
- Window Functions
- Business-Oriented Data Analysis

## 🚀 How to Run the Project

- Import the dataset into MySQL.
- Create the required tables.
- Execute the queries section-wise (Basic → Intermediate → Advanced).
- Analyze the results for business insights.

---
## 📌 Conclusion

Through this project, meaningful insights were derived from raw pizza sales data using structured SQL analysis. By answering business-driven questions at multiple complexity levels, the project demonstrates how MySQL can be effectively used to analyze transactional datasets and extract actionable intelligence.

The analysis highlights key trends such as revenue distribution across pizza types and categories, peak ordering periods, and top-performing products that significantly contribute to overall sales. Advanced queries, including cumulative revenue analysis and category-wise ranking, showcase the ability to perform deeper analytical operations commonly required in real-world business environments.

Overall, this project reinforces the importance of well-designed relational databases, efficient SQL querying, and clear analytical thinking. It reflects the practical application of SQL in solving business problems and provides a solid foundation for further extensions such as dashboard visualization, performance optimization, or integration with analytics tools.

---
