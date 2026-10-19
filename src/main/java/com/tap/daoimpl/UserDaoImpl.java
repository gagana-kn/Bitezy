package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserDao;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDaoImpl implements UserDao {

    private static final String INSERT_USER =
            "INSERT INTO user (username, password, email, phone, address, role) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_USER =
            "SELECT * FROM user WHERE userId = ?";
    
    private static final String SELECT_USERBY_EMAIL =
            "SELECT * FROM user WHERE email = ?";

    private static final String UPDATE_USER =
            "UPDATE user SET username = ?, password = ?, email = ?, "
            + "phone = ?, address = ?, role = ? WHERE userId = ?";

    private static final String DELETE_USER =
            "DELETE FROM user WHERE userId = ?";

    private static final String SELECT_ALL_USERS =
            "SELECT * FROM user";
    
    private static final String UPDATE_PROFILE =
            "UPDATE user SET username = ?, email = ?, phone = ?, address = ? "
            + "WHERE userId = ?";


    @Override
    public void addUser(User user) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_USER)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public User getUser(int userId) {

        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_USER)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    user = new User();

                    user.setUserId(rs.getInt("userId"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }
    
    @Override
    public User getUserByEmail(String userEmail) {

        User user = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_USERBY_EMAIL)) {

            ps.setString(1, userEmail);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    user = new User();

                    user.setUserId(rs.getInt("userId"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }



    @Override
    public void updateUser(User user) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_USER)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getUserId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    @Override
    public void deleteUser(int userId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_USER)) {

            ps.setInt(1, userId);

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    
    @Override
    public boolean updateProfile(User user) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_PROFILE)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getUserId());

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    @Override
    public List<User> getAllUsers() {

        List<User> userList = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(rs.getInt("userId"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));

                userList.add(user);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return userList;
    }
}