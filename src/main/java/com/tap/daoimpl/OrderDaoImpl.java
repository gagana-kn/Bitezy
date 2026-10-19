package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER =
            "INSERT INTO orders "
            + "(userId, restaurantId, orderDate, totalAmount, status, paymentMode) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_ORDER =
            "SELECT * FROM orders WHERE orderId = ?";

    private static final String UPDATE_ORDER =
            "UPDATE orders SET userId = ?, restaurantId = ?, orderDate = ?, "
            + "totalAmount = ?, status = ?, paymentMode = ? "
            + "WHERE orderId = ?";

    private static final String DELETE_ORDER =
            "DELETE FROM orders WHERE orderId = ?";

    private static final String SELECT_ALL_ORDERS =
            "SELECT * FROM orders";

    private static final String SELECT_ORDERS_BY_USER =
            "SELECT * FROM orders WHERE userId = ? ORDER BY orderId DESC";

    @Override
    public int addOrder(Order order) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(
                     INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setDate(3, order.getOrderDate());
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getStatus());
            ps.setString(6, order.getPaymentMode());

            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {

                    if (generatedKeys.next()) {

                        int orderId = generatedKeys.getInt(1);

                        order.setOrderId(orderId);

                        return orderId;
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public Order getOrder(int orderId) {

        Order order = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ORDER)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setOrderDate(rs.getDate("orderDate"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    @Override
    public void updateOrder(Order order) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_ORDER)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setDate(3, order.getOrderDate());
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getStatus());
            ps.setString(6, order.getPaymentMode());
            ps.setInt(7, order.getOrderId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_ORDER)) {

            ps.setInt(1, orderId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Order> getAllOrders() {

        List<Order> orderList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Order order = new Order();

                order.setOrderId(rs.getInt("orderId"));
                order.setUserId(rs.getInt("userId"));
                order.setRestaurantId(rs.getInt("restaurantId"));
                order.setOrderDate(rs.getDate("orderDate"));
                order.setTotalAmount(rs.getDouble("totalAmount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMode(rs.getString("paymentMode"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {

        List<Order> orderList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(SELECT_ORDERS_BY_USER)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Order order = new Order();

                    order.setOrderId(rs.getInt("orderId"));
                    order.setUserId(rs.getInt("userId"));
                    order.setRestaurantId(rs.getInt("restaurantId"));
                    order.setOrderDate(rs.getDate("orderDate"));
                    order.setTotalAmount(rs.getDouble("totalAmount"));
                    order.setStatus(rs.getString("status"));
                    order.setPaymentMode(rs.getString("paymentMode"));

                    orderList.add(order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }
}