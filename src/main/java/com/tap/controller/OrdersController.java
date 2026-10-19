
package com.tap.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.dao.MenuDao;
import com.tap.dao.OrderDao;
import com.tap.dao.OrderItemDao;
import com.tap.dao.RestaurantDao;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;

import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private MenuDao menuDao;
    private RestaurantDao restaurantDao;

    @Override
    public void init() {
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
        menuDao = new MenuDaoImpl();
        restaurantDao = new RestaurantDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        List<Order> orders =
                orderDao.getOrdersByUser(user.getUserId());

        Map<Integer, List<OrderItem>> orderItemsMap =
                new HashMap<>();

        Map<Integer, Menu> menuMap =
                new HashMap<>();

        Map<Integer, String> restaurantNameMap =
                new HashMap<>();

        Map<Integer, String> restaurantImageMap =
                new HashMap<>();

        for (Order order : orders) {

            int orderId = order.getOrderId();
            int restaurantId = order.getRestaurantId();

            // Fetch items for this order
            List<OrderItem> items =
                    orderItemDao.getOrderItemsByOrder(orderId);

            orderItemsMap.put(orderId, items);

            // Fetch menu item details
            for (OrderItem item : items) {

                int menuId = item.getMenuId();

                if (!menuMap.containsKey(menuId)) {

                    Menu menu = menuDao.getMenu(menuId);

                    if (menu != null) {
                        menuMap.put(menuId, menu);
                    }
                }
            }

            // Fetch the actual restaurant details once per restaurant
            if (!restaurantNameMap.containsKey(restaurantId)) {

                Restaurant restaurant =
                        restaurantDao.getRestaurant(restaurantId);

                if (restaurant != null) {

                    restaurantNameMap.put(
                            restaurantId,
                            restaurant.getName()
                    );

                    restaurantImageMap.put(
                            restaurantId,
                            restaurant.getImagePath()
                    );
                }
            }
        }

        request.setAttribute("orders", orders);
        request.setAttribute("orderItemsMap", orderItemsMap);
        request.setAttribute("menuMap", menuMap);

        request.setAttribute("restaurantNameMap", restaurantNameMap);
        request.setAttribute("restaurantImageMap", restaurantImageMap);

        request.getRequestDispatcher("/orders.jsp")
               .forward(request, response);
    }
}
