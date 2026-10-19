package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

        MenuDaoImpl menuDao = new MenuDaoImpl();
        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        List<Menu> menuList = menuDao.getMenusByRestaurant(restaurantId);
        Restaurant restaurant = restaurantDao.getRestaurant(restaurantId);

        req.setAttribute("allMenu", menuList);
        req.setAttribute("restaurant", restaurant);

        RequestDispatcher rd = req.getRequestDispatcher("menu.jsp");
        rd.forward(req, resp);
    }
}