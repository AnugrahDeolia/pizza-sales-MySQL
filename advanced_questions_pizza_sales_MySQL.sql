-- Q11. Calculate the percentage contribution of each pizza type to total revenue.

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

-- Q12. Analyze the cumulative revenue generated over time.

select order_date, round(sum(revenue)
over (order by order_date),2) as cum_revenue
from
(select orders.order_date, round(sum(order_details.quantity * pizzas.price),2) as revenue
from orders
join order_details on orders.order_id = order_details.order_id
join pizzas on pizzas.pizza_id = order_details.pizza_id 
group by orders.order_date) as sales;

-- Q13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue
from
(select category, name, revenue, 
rank() over (partition by category order by revenue desc) as rn
from
(select	 pizza_types.category, pizza_types.name, sum(order_details.quantity * pizzas.price)
as revenue from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name)
as a)
as b where rn<=3;
