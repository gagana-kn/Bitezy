package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        UserDaoImpl userDao = new UserDaoImpl();

        // Load the latest saved user details.
        User user = userDao.getUser(sessionUser.getUserId());

        if (user == null) {
            session.invalidate();

            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        session.setAttribute("user", user);
        request.setAttribute("profileUser", user);

        request.getRequestDispatcher("/profile.jsp")
               .forward(request, response);
    }
}