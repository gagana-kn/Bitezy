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

@WebServlet("/edit-profile")
public class EditProfileController extends HttpServlet {

    private User getLoggedInUser(HttpServletRequest request,
                                 HttpSession session,
                                 UserDaoImpl userDao) {

        User sessionUser = (User) session.getAttribute("user");

        if (sessionUser == null) {
            return null;
        }

        User user;

        if (sessionUser.getUserId() > 0) {
            user = userDao.getUser(sessionUser.getUserId());
        } else {
            // Fallback for a session created before the ID was loaded.
            user = userDao.getUserByEmail(sessionUser.getEmail());
        }

        if (user != null) {
            session.setAttribute("user", user);
        }

        return user;
    }

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

        UserDaoImpl userDao = new UserDaoImpl();
        User user = getLoggedInUser(request, session, userDao);

        if (user == null) {
            session.invalidate();
            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        request.setAttribute("profileUser", user);

        request.getRequestDispatcher("/edit-profile.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
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

        UserDaoImpl userDao = new UserDaoImpl();
        User user = getLoggedInUser(request, session, userDao);

        if (user == null) {
            session.invalidate();
            response.sendRedirect(
                request.getContextPath() + "/login"
            );
            return;
        }

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        username = username == null ? "" : username.trim();
        email = email == null ? "" : email.trim();
        phone = phone == null ? "" : phone.trim();
        address = address == null ? "" : address.trim();

        String error = null;

        if (username.isEmpty() || email.isEmpty()
                || phone.isEmpty() || address.isEmpty()) {

            error = "Please complete all profile fields.";

        } else if (!email.matches(
                "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {

            error = "Please enter a valid email address.";

        } else {
            User existingUser = userDao.getUserByEmail(email);

            if (existingUser != null &&
                existingUser.getUserId() != user.getUserId()) {

                error = "This email address is already in use.";
            }
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("profileUser", user);

            request.getRequestDispatcher("/edit-profile.jsp")
                   .forward(request, response);
            return;
        }

        user.setUsername(username);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        if (!userDao.updateProfile(user)) {
            request.setAttribute(
                "error",
                "Unable to save your changes. Please try again."
            );

            request.setAttribute("profileUser", user);

            request.getRequestDispatcher("/edit-profile.jsp")
                   .forward(request, response);
            return;
        }

        // Refresh the current session with the updated profile.
        session.setAttribute("user", user);

        response.sendRedirect(
            request.getContextPath() + "/profile?updated=1"
        );
    }
}