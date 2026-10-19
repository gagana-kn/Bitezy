package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher rd = request.getRequestDispatcher("/signup.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String password = request.getParameter("password");

        UserDaoImpl userDao = new UserDaoImpl();

        User existingUser = userDao.getUserByEmail(email);

        if (existingUser != null) {
            request.setAttribute("error", "An account with this email already exists.");

            RequestDispatcher rd = request.getRequestDispatcher("/signup.jsp");
            rd.forward(request, response);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt(12));

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);
        user.setPassword(hashedPassword);
        user.setRole("customer");

        userDao.addUser(user);

     // Reload the registered user to obtain the generated userId.
     User savedUser = userDao.getUserByEmail(email);

     if (savedUser == null) {
         request.setAttribute(
             "error",
             "Account creation failed. Please try again."
         );

         RequestDispatcher rd =
                 request.getRequestDispatcher("/signup.jsp");

         rd.forward(request, response);
         return;
     }

     HttpSession session = request.getSession();
     session.setAttribute("user", savedUser);

     response.sendRedirect(
         request.getContextPath() + "/restaurant"
     );
    }
}