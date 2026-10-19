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

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");

        UserDaoImpl userDao = new UserDaoImpl();

        User user = userDao.getUserByEmail(email);

        boolean passwordMatches = false;

        if (user != null && user.getPassword() != null) {
            try {
                passwordMatches = BCrypt.checkpw(password, user.getPassword());
            } catch (IllegalArgumentException e) {
                passwordMatches = false;
            }
        }

        if (user != null && passwordMatches) {

            HttpSession session = request.getSession();

            session.setAttribute("user", user);

            if ("checkout".equals(redirect)) {
                response.sendRedirect("checkout");
            } else {
                response.sendRedirect("restaurant");
            }

        } else {

            request.setAttribute("error", "Invalid email or password");

            RequestDispatcher rd =
                    request.getRequestDispatcher("/login.jsp");

            rd.forward(request, response);
        }
    }
}