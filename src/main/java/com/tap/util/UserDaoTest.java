package com.tap.util;

import java.util.List;

import com.tap.dao.UserDao;
import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

public class UserDaoTest {

    public static void main(String[] args) {

        UserDao userDao = new UserDaoImpl();

        // Create User
        User user = new User(
                0,
                "testuser",
                "test123",
                "testuser@gmail.com",
                "9876543210",
                "Bangalore",
                "USER"
        );

        // Add User
        userDao.addUser(user);

        System.out.println("User added successfully.");

        // Get All Users
        List<User> users = userDao.getAllUsers();

        System.out.println("\nAll Users:");

        for (User u : users) {
            System.out.println(u);
        }
    }
}