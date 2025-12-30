-- Q6. Join the necessary tables to find the total quantity of each pizza category ordered.

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

-- Q7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS no_of_orders
FROM
    orders
GROUP BY hour;

-- Q8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS no_of_pizzas
FROM
    pizza_types
GROUP BY category;

-- Q9. Group the orders by date and calculate the average number of pizzas ordered per day.

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

-- Q10. Determine the top 3 most ordered pizza types based on revenue.

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
