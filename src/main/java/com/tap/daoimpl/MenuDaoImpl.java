package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
            "INSERT INTO menu "
            + "(restaurantId, itemName, description, price, isAvailable, imagePath) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_MENU =
            "SELECT * FROM menu WHERE menuId = ?";

    private static final String UPDATE_MENU =
            "UPDATE menu SET restaurantId = ?, itemName = ?, description = ?, "
            + "price = ?, isAvailable = ?, imagePath = ? "
            + "WHERE menuId = ?";

    private static final String DELETE_MENU =
            "DELETE FROM menu WHERE menuId = ?";

    private static final String SELECT_ALL_MENUS =
            "SELECT * FROM menu";

    private static final String SELECT_MENUS_BY_RESTAURANT =
            "SELECT * FROM menu WHERE restaurantId = ?";

    @Override
    public void addMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_MENU)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImagePath());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Menu getMenu(int menuId) {

        Menu menu = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_MENU)) {

            ps.setInt(1, menuId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                    menu.setImagePath(rs.getString("imagePath"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menu;
    }

    @Override
    public void updateMenu(Menu menu) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_MENU)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImagePath());
            ps.setInt(7, menu.getMenuId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteMenu(int menuId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_MENU)) {

            ps.setInt(1, menuId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Menu> getAllMenus() {

        List<Menu> menuList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_MENUS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menuId"));
                menu.setRestaurantId(rs.getInt("restaurantId"));
                menu.setItemName(rs.getString("itemName"));
                menu.setDescription(rs.getString("description"));
                menu.setPrice(rs.getDouble("price"));
                menu.setAvailable(rs.getBoolean("isAvailable"));
                menu.setImagePath(rs.getString("imagePath"));

                menuList.add(menu);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {

        List<Menu> menuList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(SELECT_MENUS_BY_RESTAURANT)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(rs.getInt("menuId"));
                    menu.setRestaurantId(rs.getInt("restaurantId"));
                    menu.setItemName(rs.getString("itemName"));
                    menu.setDescription(rs.getString("description"));
                    menu.setPrice(rs.getDouble("price"));
                    menu.setAvailable(rs.getBoolean("isAvailable"));
                    menu.setImagePath(rs.getString("imagePath"));

                    menuList.add(menu);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return menuList;
    }
}