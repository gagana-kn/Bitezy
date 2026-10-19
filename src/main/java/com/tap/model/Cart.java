package com.tap.model;

import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private int restaurantId;
    private Map<Integer, CartItem> items;

    public Cart() {
        this.restaurantId = 0;
        this.items = new LinkedHashMap<>();
    }

    public boolean addItem(Menu menu) {

        if (items.isEmpty()) {
            restaurantId = menu.getRestaurantId();
        } 
        else if (restaurantId != menu.getRestaurantId()) {
            return false;
        }

        int menuId = menu.getMenuId();

        if (items.containsKey(menuId)) {

            CartItem existing = items.get(menuId);

            existing.setQuantity(
                    existing.getQuantity() + 1
            );

        } else {

            items.put(
                    menuId,
                    new CartItem(menu, 1)
            );
        }

        return true;
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public void setItems(Map<Integer, CartItem> items) {
        this.items = items;
    }

    public void updateQuantity(int menuId, int quantity) {

        if (items.containsKey(menuId)) {

            if (quantity <= 0) {
                removeItem(menuId);
            } else {
                items.get(menuId).setQuantity(quantity);
            }
        }
    }

    public void removeItem(int menuId) {
        items.remove(menuId);

        if (items.isEmpty()) {
            restaurantId = 0;
        }
    }

    public double getTotal() {

        double total = 0;

        for (CartItem item : items.values()) {
            total += item.getSubtotal();
        }

        return total;
    }

    public void clear() {
        items.clear();
        restaurantId = 0;
    }

    @Override
    public String toString() {
        return "Cart [restaurantId=" + restaurantId + ", items=" + items + "]";
    }
}