package com.tap.controller;

import java.io.IOException;
import java.sql.Date;

import com.tap.dao.OrderDao;
import com.tap.dao.OrderItemDao;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;

    @Override
    public void init() {
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?redirect=checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");

        request.setAttribute("cart", cart);

        RequestDispatcher rd =
                request.getRequestDispatcher("/checkout.jsp");

        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login?redirect=checkout");
            return;
        }

        User user = (User) session.getAttribute("user");
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        String address = request.getParameter("address");
        String paymentMode = request.getParameter("paymentMode");

        if (address == null || address.trim().isEmpty()
                || paymentMode == null
                || !(paymentMode.equals("COD")
                || paymentMode.equals("UPI")
                || paymentMode.equals("Card"))) {

            request.setAttribute("cart", cart);
            request.setAttribute("error",
                    "Please enter a delivery address and select a valid payment method.");

            RequestDispatcher rd =
                    request.getRequestDispatcher("/checkout.jsp");

            rd.forward(request, response);
            return;
        }

        try {
            Order order = new Order();

            order.setUserId(user.getUserId());
            order.setRestaurantId(cart.getRestaurantId());
            order.setOrderDate(new Date(System.currentTimeMillis()));
            order.setTotalAmount(cart.getTotal());
            order.setStatus("Placed");
            order.setPaymentMode(paymentMode);

            int orderId = orderDao.addOrder(order);

            if (orderId <= 0) {
                request.setAttribute("cart", cart);
                request.setAttribute("error",
                        "Unable to place your order. Please try again.");

                RequestDispatcher rd =
                        request.getRequestDispatcher("/checkout.jsp");

                rd.forward(request, response);
                return;
            }

            for (CartItem cartItem : cart.getItems().values()) {
                OrderItem orderItem = new OrderItem();

                orderItem.setOrderId(orderId);
                orderItem.setMenuId(cartItem.getMenu().getMenuId());
                orderItem.setTotalAmount(cartItem.getSubtotal());

                orderItemDao.addOrderItem(orderItem);
            }

            user.setAddress(address.trim());
            session.setAttribute("user", user);
            session.setAttribute("checkoutAddress", address.trim());
            session.setAttribute("lastOrderId", orderId);

            cart.clear();

            response.sendRedirect("order-success.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("cart", cart);
            request.setAttribute("error",
                    "Something went wrong while placing your order. Please try again.");

            RequestDispatcher rd =
                    request.getRequestDispatcher("/checkout.jsp");

            rd.forward(request, response);
        }
    }
}