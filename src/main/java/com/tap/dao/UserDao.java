package com.tap.dao;

import java.util.List;
import com.tap.model.User;

public interface UserDao {

    void addUser(User user);

    User getUser(int userId);
    
    User getUserByEmail(String userEmail);

    void updateUser(User user);

    void deleteUser(int userId);
    
    boolean updateProfile(User user);

    List<User> getAllUsers();

}