package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO orderItem "
            + "(orderId, menuId, totalAmount) "
            + "VALUES (?, ?, ?)";

    private static final String SELECT_ORDER_ITEM =
            "SELECT * FROM orderItem WHERE orderItemId = ?";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE orderItem SET orderId = ?, menuId = ?, totalAmount = ? "
            + "WHERE orderItemId = ?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM orderItem WHERE orderItemId = ?";

    private static final String SELECT_ALL_ORDER_ITEMS =
            "SELECT * FROM orderItem";

    private static final String SELECT_ORDER_ITEMS_BY_ORDER =
            "SELECT * FROM orderItem WHERE orderId = ?";

    @Override
    public void addOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(INSERT_ORDER_ITEM)) {

            ps.setInt(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getMenuId());
            ps.setDouble(3, orderItem.getTotalAmount());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {

        OrderItem orderItem = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(SELECT_ORDER_ITEM)) {

            ps.setInt(1, orderItemId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    orderItem = new OrderItem();

                    orderItem.setOrderItemId(rs.getInt("orderItemId"));
                    orderItem.setOrderId(rs.getInt("orderId"));
                    orderItem.setMenuId(rs.getInt("menuId"));
                    orderItem.setTotalAmount(rs.getDouble("totalAmount"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItem;
    }

    @Override
    public void updateOrderItem(OrderItem orderItem) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(UPDATE_ORDER_ITEM)) {

            ps.setInt(1, orderItem.getOrderId());
            ps.setInt(2, orderItem.getMenuId());
            ps.setDouble(3, orderItem.getTotalAmount());
            ps.setInt(4, orderItem.getOrderItemId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteOrderItem(int orderItemId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(DELETE_ORDER_ITEM)) {

            ps.setInt(1, orderItemId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItemList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(SELECT_ALL_ORDER_ITEMS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                OrderItem orderItem = new OrderItem();

                orderItem.setOrderItemId(rs.getInt("orderItemId"));
                orderItem.setOrderId(rs.getInt("orderId"));
                orderItem.setMenuId(rs.getInt("menuId"));
                orderItem.setTotalAmount(rs.getDouble("totalAmount"));

                orderItemList.add(orderItem);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItemList;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrder(int orderId) {

        List<OrderItem> orderItemList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(SELECT_ORDER_ITEMS_BY_ORDER)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    OrderItem orderItem = new OrderItem();

                    orderItem.setOrderItemId(rs.getInt("orderItemId"));
                    orderItem.setOrderId(rs.getInt("orderId"));
                    orderItem.setMenuId(rs.getInt("menuId"));
                    orderItem.setTotalAmount(rs.getDouble("totalAmount"));

                    orderItemList.add(orderItem);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderItemList;
    }
}