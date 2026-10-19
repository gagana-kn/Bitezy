package com.tap.util;

import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Restaurant;

public class RestaurantDaoTest {

    public static void main(String[] args) {

        RestaurantDao restaurantDao = new RestaurantDaoImpl();

        // Create Restaurant
        Restaurant restaurant = new Restaurant(
                0,
                "Food Paradise",
                "Indian",
                "30-40 mins",
                "Bangalore",
                1,
                4.5,
                true,
                "foodparadise.jpg"
        );

        // Add Restaurant
        restaurantDao.addRestaurant(restaurant);

        System.out.println("Restaurant added successfully.");

        // Get All Restaurants
        List<Restaurant> restaurants = restaurantDao.getAllRestaurants();

        System.out.println("\nAll Restaurants:");

        for (Restaurant r : restaurants) {
            System.out.println(r);
        }
    }
}