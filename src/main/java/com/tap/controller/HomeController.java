
package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private RestaurantDao restaurantDao;

    @Override
    public void init() throws ServletException {
        restaurantDao = new RestaurantDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<Restaurant> restaurants = restaurantDao.getAllRestaurants();

        request.setAttribute("restaurants", restaurants);

        request.getRequestDispatcher("/home.jsp")
               .forward(request, response);
    }
}
