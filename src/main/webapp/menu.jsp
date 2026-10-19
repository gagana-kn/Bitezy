
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>

<%
    List<Menu> allMenu =
            (List<Menu>) request.getAttribute("allMenu");

    Restaurant restaurant =
            (Restaurant) request.getAttribute("restaurant");

    Cart cart = (Cart) session.getAttribute("cart");
    User user = (User) session.getAttribute("user");

    int restaurantId =
            restaurant != null ? restaurant.getRestaurantId() : 0;

    if (restaurantId == 0
            && request.getParameter("restaurantId") != null) {
        try {
            restaurantId = Integer.parseInt(
                    request.getParameter("restaurantId"));
        } catch (NumberFormatException ignored) {
            restaurantId = 0;
        }
    }

    int cartItemCount = 0;

    if (cart != null && cart.getItems() != null) {
        for (CartItem item : cart.getItems().values()) {
            cartItemCount += item.getQuantity();
        }
    }

    double cartTotal = cart != null ? cart.getTotal() : 0;

    String cartOpen = request.getParameter("cartOpen");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Bitezy | Restaurant Menu</title>

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --green: #174c36;
    --green-hover: #236447;
    --cream: #fffaf2;
    --dark: #222522;
    --muted: #858780;
    --orange: #f15a3b;
    --border: #eee8df;
    --white: #fff;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                 Roboto, Arial, sans-serif;
}

html {
    scroll-behavior: smooth;
    scroll-padding-top: 90px;
}

body {
    min-height: 100vh;
    background: #fff;
    color: var(--dark);
}

a {
    color: inherit;
    text-decoration: none;
}

button, input {
    font: inherit;
}

button {
    cursor: pointer;
}

/* NAVBAR */

.navbar {
    min-height: 74px;
    padding: 0 4%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 25px;
    background: #fff;
    border-bottom: 1px solid var(--border);
    position: sticky;
    top: 0;
    z-index: 20;
}

.logo-container {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-shrink: 0;
}

.logo-box {
    width: 43px;
    height: 43px;
    display: grid;
    place-items: center;
    background: var(--green);
    color: #fff;
    border-radius: 12px;
    font-weight: 800;
    font-size: 19px;
}

.logo-name {
    color: var(--green);
    font-size: 23px;
    font-weight: 800;
    letter-spacing: -.7px;
}

.nav-actions {
    display: flex;
    align-items: center;
    gap: 27px;
}

.nav-action {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    color: #353a35;
    font-size: 14px;
    font-weight: 500;
    transition: color .2s ease;
}

.nav-action:hover,
.nav-action:focus-visible,
.profile-toggle:hover,
.profile-toggle:focus-visible {
    color: var(--green);
}

.profile-dropdown {
    position: relative;
}

.profile-toggle {
    padding: 0;
    border: 0;
    background: transparent;
    cursor: pointer;
}

.profile-menu {
    display: none;
    position: absolute;
    top: calc(100% + 12px);
    right: 0;
    min-width: 155px;
    padding: 8px 0;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 10px;
    box-shadow: 0 8px 25px #0000001a;
    z-index: 30;
}

.profile-dropdown:hover .profile-menu,
.profile-dropdown:focus-within .profile-menu {
    display: block;
}

.profile-menu a {
    display: block;
    padding: 11px 15px;
    font-size: 13px;
}

.profile-menu a:hover {
    background: #f3f7f3;
    color: var(--green);
}

/* PAGE LAYOUT */

.page-container {
    max-width: 1120px;
    width: 86%;
    margin: 0 auto;
}

/* RESTAURANT DETAILS */

.restaurant-header {
    display: grid;
    grid-template-columns: 290px minmax(0, 1fr);
    gap: 30px;
    align-items: center;
    margin: 38px 0 35px;
    padding: 22px;
    background: #f3f7f3;
    border: 1px solid var(--border);
    border-radius: 16px;

    /* Restaurant card hover effect */
    transition: transform .24s ease, border-color .24s ease, box-shadow .24s ease;
    will-change: transform;
}

.restaurant-header:hover {
    transform: translateY(-5px);
    border-color: #d6e1d7;
    box-shadow: 0 12px 28px rgba(23, 76, 54, .13);
}

.restaurant-image-wrap {
    width: 100%;
    height: 205px;
    overflow: hidden;
    background: #eee8df;
    border-radius: 12px;
}

.restaurant-image {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.restaurant-info {
    min-width: 0;
}

.restaurant-label {
    display: inline-block;
    margin-bottom: 8px;
    color: var(--green);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.restaurant-name {
    margin-bottom: 7px;
    color: var(--dark);
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(27px, 3vw, 36px);
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.restaurant-cuisine {
    margin-bottom: 17px;
    color: var(--muted);
    font-size: 14px;
}

.restaurant-meta {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 18px;
    margin-bottom: 15px;
}

.restaurant-rating {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 6px 9px;
    color: #fff;
    background: #176c3b;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 700;
}

.restaurant-rating i {
    font-size: 11px;
}

.restaurant-delivery {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    color: #565c56;
    font-size: 13px;
}

.restaurant-address {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.7;
    overflow-wrap: anywhere;
}

.restaurant-address i {
    margin-top: 4px;
    color: var(--green);
}

.restaurant-unavailable {
    margin: 35px 0;
    padding: 22px;
    background: var(--cream);
    border: 1px solid var(--border);
    border-radius: 12px;
    color: var(--dark);
    line-height: 1.8;
}

.restaurant-unavailable a {
    color: var(--green);
    font-weight: 700;
    text-decoration: underline;
}

/* MENU HEADING */

.page-heading {
    margin: 35px 0 25px;
}

.page-heading h1 {
    margin-bottom: 8px;
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(28px, 3vw, 36px);
    line-height: 1.25;
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.7;
}

.section-heading {
    margin-bottom: 18px;
}

.section-heading h2 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 25px;
    line-height: 1.3;
}

/* HORIZONTAL MENU ITEMS */

.menu-grid {
    display: flex;
    flex-direction: column;
    gap: 15px;
    margin-bottom: 50px;
}

.menu-card {
    display: grid;
    grid-template-columns: 150px minmax(0, 1fr);
    gap: 20px;
    align-items: center;
    min-width: 0;
    padding: 17px;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 14px;
}

.image-wrap {
    width: 150px;
    height: 130px;
    overflow: hidden;
    background: #f3eee6;
    border-radius: 11px;
}

.dish-image {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform .3s ease;
}

.menu-card:hover .dish-image {
    transform: scale(1.04);
}

.menu-details {
    display: grid;
    grid-template-columns: minmax(0, 1fr) auto;
    align-items: center;
    gap: 10px 20px;
    min-width: 0;
}

.dish-information {
    min-width: 0;
}

.dish-name {
    margin-bottom: 7px;
    color: var(--dark);
    font-size: 17px;
    font-weight: 700;
    line-height: 1.4;
    overflow-wrap: anywhere;
}

.dish-description {
    margin-bottom: 12px;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.65;
    overflow-wrap: anywhere;
}

.dish-price {
    color: var(--green);
    font-size: 16px;
    font-weight: 800;
    white-space: nowrap;
}

.dish-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 10px;
}

.add-form {
    margin: 0;
}

.add-button {
    min-width: 92px;
    padding: 10px 20px;
    color: var(--green);
    background: #fff;
    border: 1px solid var(--green);
    border-radius: 8px;
    font-size: 13px;
    font-weight: 800;
    transition: color .2s, background .2s;
}

.add-button:hover {
    color: #fff;
    background: var(--green);
}

.quantity-control {
    display: flex;
    align-items: center;
    gap: 13px;
    padding: 5px;
    background: #f3f7f3;
    border: 1px solid #dce7de;
    border-radius: 9px;
}

.quantity-control form {
    margin: 0;
}

.quantity-button {
    display: grid;
    place-items: center;
    width: 30px;
    height: 30px;
    color: #fff;
    background: var(--green);
    border: 0;
    border-radius: 6px;
    font-size: 20px;
    line-height: 1;
}

.quantity-button:hover {
    background: var(--green-hover);
}

.quantity-number {
    min-width: 15px;
    color: var(--dark);
    font-size: 14px;
    font-weight: 800;
    text-align: center;
}

.empty-menu {
    margin-bottom: 50px;
    padding: 55px 20px;
    background: var(--cream);
    border: 1px solid var(--border);
    border-radius: 14px;
    text-align: center;
}

.empty-menu > i {
    margin-bottom: 15px;
    color: var(--green);
    font-size: 32px;
}

.empty-menu h2 {
    margin-bottom: 8px;
    font-family: Georgia, "Times New Roman", serif;
    font-size: 23px;
}

.empty-menu p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.7;
}

/* CART SUMMARY — ORIGINAL COMPACT STYLE */

.cart-summary-bar {
    position: fixed;
    right: 25px;
    bottom: 20px;
    z-index: 50;
    width: min(390px, calc(100% - 30px));
}

.cart-summary-bar > summary {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 17px 20px;
    color: #fff;
    background: var(--green);
    border-radius: 12px;
    box-shadow: 0 7px 25px #00000025;
    cursor: pointer;
    list-style: none;
}

.cart-summary-bar > summary::-webkit-details-marker {
    display: none;
}

.cart-summary-bar > summary::marker {
    content: "";
}

.cart-summary-title {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 14px;
    font-weight: 700;
}

.cart-summary-total {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    font-size: 14px;
    font-weight: 800;
    white-space: nowrap;
}

.cart-panel {
    max-height: 55vh;
    margin-bottom: 10px;
    overflow-y: auto;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 12px;
    box-shadow: 0 7px 25px #00000018;
}

.cart-panel-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 16px;
    border-bottom: 1px solid var(--border);
}

.cart-panel-heading h2 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 19px;
}

.cart-close-link {
    color: var(--green);
    font-size: 12px;
    font-weight: 700;
    text-decoration: underline;
}

.cart-line {
    display: grid;
    grid-template-columns: minmax(0, 1fr) auto;
    gap: 12px;
    align-items: center;
    padding: 14px 16px;
    border-bottom: 1px solid #f0eee9;
}

.cart-line-name {
    margin-bottom: 4px;
    font-size: 13px;
    font-weight: 700;
    overflow-wrap: anywhere;
}

.cart-line-price {
    color: var(--muted);
    font-size: 12px;
}

.cart-line-controls {
    display: flex;
    align-items: center;
    gap: 7px;
}

.cart-line-controls form {
    margin: 0;
}

.cart-line-controls button {
    width: 27px;
    height: 27px;
    color: #fff;
    background: var(--green);
    border: 0;
    border-radius: 5px;
    font-size: 17px;
}

.cart-line-controls span {
    min-width: 15px;
    font-size: 13px;
    font-weight: 700;
    text-align: center;
}

.cart-panel-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 14px 16px;
}

.cart-panel-footer form {
    margin: 0;
}

.cart-clear-button {
    padding: 9px 11px;
    color: #a33c2a;
    background: #fff;
    border: 1px solid #efd5cf;
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
}

.cart-view-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 10px 15px;
    color: #fff;
    background: var(--green);
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
}

.cart-view-button:hover {
    background: var(--green-hover);
}

/* FOOTER */

footer {
    background: #103e2e;
    color: #fff;
    padding: 42px 7% 20px;
}

.footer-container {
    max-width: 1120px;
    margin: auto;
    display: grid;
    grid-template-columns: 1.5fr 1fr 1fr 1fr;
    gap: 35px;
}

.footer-logo {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 14px;
}

.footer-logo .logo-box {
    background: #fff;
    color: var(--green);
}

.footer-logo .logo-name {
    color: #fff;
    font-size: 21px;
}

.footer-brand p {
    max-width: 250px;
    color: #d7e2da;
    font-size: 13px;
    line-height: 1.8;
}

.footer-column h3 {
    margin-bottom: 16px;
    font-size: 14px;
}

.footer-column a {
    display: block;
    margin-bottom: 11px;
    color: #d7e2da;
    font-size: 13px;
    transition: color .2s;
}

.footer-column a:hover {
    color: #f2c78b;
}

.copyright {
    max-width: 1120px;
    margin: 30px auto 0;
    padding-top: 18px;
    border-top: 1px solid #ffffff2a;
    color: #c8d7cd;
    text-align: center;
    font-size: 12px;
}

/* RESPONSIVE */

@media (max-width: 900px) {
    .navbar {
        padding: 0 4%;
    }

    .nav-actions {
        gap: 15px;
    }

    .page-container {
        width: 92%;
    }

    .restaurant-header {
        grid-template-columns: 230px minmax(0, 1fr);
        gap: 22px;
    }

    .image-wrap {
        width: 125px;
        height: 115px;
    }

    .menu-card {
        grid-template-columns: 125px minmax(0, 1fr);
        gap: 15px;
    }

    .menu-details {
        gap: 10px 14px;
    }

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 560px) {
    .navbar {
        flex-wrap: wrap;
        padding: 12px 4%;
        gap: 12px;
    }

    .logo-name {
        font-size: 20px;
    }

    .nav-actions {
        gap: 12px;
        flex-wrap: wrap;
    }

    .nav-action {
        font-size: 12px;
    }

    .restaurant-header {
        grid-template-columns: 1fr;
        gap: 18px;
        margin-top: 22px;
        padding: 15px;
    }

    .restaurant-image-wrap {
        height: 200px;
    }

    .page-heading {
        margin-top: 28px;
    }

    .menu-grid {
        gap: 12px;
    }

    .menu-card {
        grid-template-columns: 95px minmax(0, 1fr);
        gap: 12px;
        padding: 12px;
        align-items: start;
    }

    .image-wrap {
        width: 95px;
        height: 100px;
    }

    .menu-details {
        grid-template-columns: minmax(0, 1fr);
        gap: 10px;
    }

    .dish-name {
        font-size: 15px;
        margin-bottom: 5px;
    }

    .dish-description {
        margin-bottom: 8px;
        font-size: 12px;
    }

    .dish-bottom {
        display: flex;
        align-items: center;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 10px;
    }

    .dish-actions {
        justify-content: flex-start;
    }

    .add-button {
        min-width: 75px;
        padding: 8px 14px;
    }

    .quantity-control {
        gap: 9px;
    }

    .quantity-button {
        width: 27px;
        height: 27px;
    }

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 27px 20px;
    }

    .cart-summary-bar {
        right: 15px;
        bottom: 12px;
        width: calc(100% - 30px);
    }

    .cart-panel {
        max-height: 45vh;
    }
}

@media (max-width: 480px) {
    .cart-summary-bar {
        right: 12px;
        bottom: 12px;
        width: calc(100% - 24px);
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        scroll-behavior: auto !important;
        transition: none !important;
    }
}
</style>
</head>

<body>

<!-- NAVBAR -->

<header class="navbar">
    <a href="<%= contextPath %>/restaurant" class="logo-container">
        <span class="logo-box">B</span>
        <span class="logo-name">Bitezy</span>
    </a>

    <nav class="nav-actions">
        <a href="<%= contextPath %>/restaurant" class="nav-action">
            <i class="fa-solid fa-house"></i>
            Home
        </a>

        <a href="<%= contextPath %>/restaurant#restaurants" class="nav-action">
            Restaurants
        </a>

        <a href="<%= contextPath %>/cart" class="nav-action">
            <i class="fa-solid fa-cart-shopping"></i>
            Cart<% if (cartItemCount > 0) { %> (<%= cartItemCount %>)<% } %>
        </a>

        <a href="<%= contextPath %>/orders" class="nav-action">
            <i class="fa-solid fa-box"></i>
            Orders
        </a>

        <% if (user == null) { %>
    <a href="<%= contextPath %>/login" class="nav-action">
        <i class="fa-regular fa-user"></i>
        Login
    </a>
<% } else { %>
    <div class="profile-dropdown">
        <button type="button" class="nav-action profile-toggle">
            <i class="fa-regular fa-user"></i>
            Profile
        </button>

        <div class="profile-menu">
            <a href="<%= contextPath %>/edit-profile">Edit Profile</a>
            <a href="<%= contextPath %>/logout">Logout</a>
        </div>
    </div>
<% } %>
    </nav>
</header>

<!-- MAIN CONTENT -->

<main class="page-container">

    <% if (restaurant != null) { %>
        <section class="restaurant-header" aria-label="Restaurant details">

            <div class="restaurant-image-wrap">
                <% if (restaurant.getImagePath() != null
                        && !restaurant.getImagePath().trim().isEmpty()) { %>
                    <img class="restaurant-image"
                         src="<%= restaurant.getImagePath() %>"
                         alt="<%= restaurant.getName() %>">
                <% } %>
            </div>

            <div class="restaurant-info">
                <span class="restaurant-label">Restaurant</span>

                <h1 class="restaurant-name">
                    <%= restaurant.getName() %>
                </h1>

                <p class="restaurant-cuisine">
                    <%= restaurant.getCuisineType() != null
                            && !restaurant.getCuisineType().trim().isEmpty()
                            ? restaurant.getCuisineType()
                            : "Cuisine information unavailable" %>
                </p>

                <div class="restaurant-meta">
                    <span class="restaurant-rating">
                        <i class="fa-solid fa-star"></i>
                        <%= String.format("%.1f", restaurant.getRating()) %>
                    </span>

                    <span class="restaurant-delivery">
                        <i class="fa-regular fa-clock"></i>
                        <%= restaurant.getDeliveryTime() != null
                                && !restaurant.getDeliveryTime().trim().isEmpty()
                                ? restaurant.getDeliveryTime()
                                : "Delivery time unavailable" %>
                    </span>
                </div>

                <div class="restaurant-address">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>
                        <%= restaurant.getAddress() != null
                                && !restaurant.getAddress().trim().isEmpty()
                                ? restaurant.getAddress()
                                : "Address unavailable" %>
                    </span>
                </div>
            </div>
        </section>
    <% } else { %>
        <div class="restaurant-unavailable">
            Restaurant details could not be loaded.
            Please return to the
            <a href="<%= contextPath %>/restaurant">restaurants page</a>.
        </div>
    <% } %>

    <section class="page-heading">
        <h1>Explore the menu</h1>
        <p>Find your favourites and add something delicious to your order.</p>
    </section>

    <section aria-labelledby="menu-heading">
        <div class="section-heading">
            <h2 id="menu-heading">Our Menu</h2>
        </div>

        <% if (allMenu != null && !allMenu.isEmpty()) { %>

            <div class="menu-grid">

                <% for (Menu menu : allMenu) {

                    CartItem cartItem = null;

                    if (cart != null && cart.getItems() != null) {
                        cartItem = cart.getItems().get(menu.getMenuId());
                    }

                    int quantity = cartItem != null
                            ? cartItem.getQuantity()
                            : 0;
                %>

                    <article class="menu-card">

                        <div class="image-wrap">
                            <% if (menu.getImagePath() != null
                                    && !menu.getImagePath().trim().isEmpty()) { %>
                                <img class="dish-image"
                                     src="<%= menu.getImagePath() %>"
                                     alt="<%= menu.getItemName() %>"
                                     loading="lazy">
                            <% } %>
                        </div>

                        <div class="menu-details">

                            <div class="dish-information">
                                <h3 class="dish-name">
                                    <%= menu.getItemName() %>
                                </h3>

                                <p class="dish-description"><%=
                                    menu.getDescription() != null
                                    && !menu.getDescription().trim().isEmpty()
                                    ? menu.getDescription()
                                    : "Freshly prepared and ready to enjoy."
                                %></p>

                                <span class="dish-price">
                                    &#8377;<%= String.format("%.2f", menu.getPrice()) %>
                                </span>
                            </div>

                            <div class="dish-actions">

                                <% if (quantity > 0) { %>

                                    <div class="quantity-control">

                                        <form action="<%= contextPath %>/cart"
                                              method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="menuId"
                                                   value="<%= menu.getMenuId() %>">
                                            <input type="hidden" name="quantity"
                                                   value="<%= quantity - 1 %>">
                                            <input type="hidden" name="source" value="menu">
                                            <input type="hidden" name="restaurantId"
                                                   value="<%= menu.getRestaurantId() %>">
                                            <input type="hidden" name="cartOpen" value="true">

                                            <button type="submit"
                                                    class="quantity-button"
                                                    aria-label="Decrease quantity">
                                                &minus;
                                            </button>
                                        </form>

                                        <span class="quantity-number"><%= quantity %></span>

                                        <form action="<%= contextPath %>/cart"
                                              method="post">
                                            <input type="hidden" name="action" value="update">
                                            <input type="hidden" name="menuId"
                                                   value="<%= menu.getMenuId() %>">
                                            <input type="hidden" name="quantity"
                                                   value="<%= quantity + 1 %>">
                                            <input type="hidden" name="source" value="menu">
                                            <input type="hidden" name="restaurantId"
                                                   value="<%= menu.getRestaurantId() %>">
                                            <input type="hidden" name="cartOpen" value="true">

                                            <button type="submit"
                                                    class="quantity-button"
                                                    aria-label="Increase quantity">
                                                +
                                            </button>
                                        </form>

                                    </div>

                                <% } else { %>

                                    <form action="<%= contextPath %>/cart"
                                          method="post"
                                          class="add-form">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="menuId"
                                               value="<%= menu.getMenuId() %>">
                                        <input type="hidden" name="source" value="menu">
                                        <input type="hidden" name="restaurantId"
                                               value="<%= menu.getRestaurantId() %>">

                                        <button type="submit" class="add-button">
                                            ADD
                                        </button>
                                    </form>

                                <% } %>

                            </div>
                        </div>
                    </article>

                <% } %>

            </div>

        <% } else { %>

            <div class="empty-menu">
                <i class="fa-solid fa-utensils"></i>
                <h2>Menu coming soon</h2>
                <p>There are no menu items available to display right now.</p>
            </div>

        <% } %>
    </section>

</main>

<!-- CART SUMMARY -->

<% if (cartItemCount > 0 && cart != null && cart.getItems() != null) { %>

    <details class="cart-summary-bar"
             <%= "true".equals(cartOpen) ? "open" : "" %>>

        <summary>
            <span class="cart-summary-title">
                <i class="fa-solid fa-receipt"></i>
                Your Order (<%= cartItemCount %>)
            </span>

            <span class="cart-summary-total">
                &#8377;<%= String.format("%.2f", cartTotal) %>
                <i class="fa-solid fa-chevron-up"></i>
            </span>
        </summary>

        <div class="cart-panel">

            <div class="cart-panel-heading">
                <h2>Your Order</h2>
                <span class="cart-close-link">Tap the order bar to collapse</span>
            </div>

            <% for (CartItem item : cart.getItems().values()) {
                Menu cartMenu = item.getMenu();
            %>

                <div class="cart-line">

                    <div>
                        <p class="cart-line-name">
                            <%= cartMenu.getItemName() %>
                        </p>

                        <p class="cart-line-price">
                            &#8377;<%= String.format("%.2f",
                                cartMenu.getPrice() * item.getQuantity()) %>
                        </p>
                    </div>

                    <div class="cart-line-controls">

                        <form action="<%= contextPath %>/cart" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="menuId"
                                   value="<%= cartMenu.getMenuId() %>">
                            <input type="hidden" name="quantity"
                                   value="<%= item.getQuantity() - 1 %>">
                            <input type="hidden" name="source" value="menu">
                            <input type="hidden" name="restaurantId"
                                   value="<%= restaurantId %>">
                            <input type="hidden" name="cartOpen" value="true">

                            <button type="submit" aria-label="Decrease quantity">
                                &minus;
                            </button>
                        </form>

                        <span><%= item.getQuantity() %></span>

                        <form action="<%= contextPath %>/cart" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="menuId"
                                   value="<%= cartMenu.getMenuId() %>">
                            <input type="hidden" name="quantity"
                                   value="<%= item.getQuantity() + 1 %>">
                            <input type="hidden" name="source" value="menu">
                            <input type="hidden" name="restaurantId"
                                   value="<%= restaurantId %>">
                            <input type="hidden" name="cartOpen" value="true">

                            <button type="submit" aria-label="Increase quantity">
                                +
                            </button>
                        </form>

                    </div>
                </div>

            <% } %>

            <div class="cart-panel-footer">

                <form action="<%= contextPath %>/cart" method="post">
                    <input type="hidden" name="action" value="clear">
                    <input type="hidden" name="source" value="menu">
                    <input type="hidden" name="restaurantId"
                           value="<%= restaurantId %>">

                    <button type="submit" class="cart-clear-button">
                        Clear Cart
                    </button>
                </form>

                <a href="<%= contextPath %>/cart" class="cart-view-button">
                    View Cart
                </a>

            </div>
        </div>
    </details>

<% } %>

<!-- FOOTER -->

<footer>
    <div class="footer-container">

        <div class="footer-brand">
            <a href="<%= contextPath %>/restaurant" class="footer-logo">
                <span class="logo-box">B</span>
                <span class="logo-name">Bitezy</span>
            </a>

            <p>
                Delicious food from your favourite restaurants,
                delivered fresh to your doorstep.
            </p>
        </div>

        <div class="footer-column">
            <h3>Company</h3>
            <a href="#">About Us</a>
            <a href="#">Careers</a>
            <a href="#">Contact</a>
        </div>

        <div class="footer-column">
            <h3>Support</h3>
            <a href="#">Help Center</a>
            <a href="#">FAQs</a>
            <a href="#">Delivery Support</a>
        </div>

        <div class="footer-column">
            <h3>Legal</h3>
            <a href="#">Privacy Policy</a>
            <a href="#">Terms &amp; Conditions</a>
        </div>

    </div>

    <div class="copyright">
        &copy; 2026 Bitezy. All rights reserved.
    </div>
</footer>

<script>
    if ("scrollRestoration" in history) {
        history.scrollRestoration = "manual";
    }
</script>

<script>
(function () {
    const params = new URLSearchParams(window.location.search);
    const savedPosition = params.get("scrollY");

    document.querySelectorAll('form[action$="/cart"]').forEach(function (form) {
        form.addEventListener("submit", function () {
            let scrollInput = form.querySelector('input[name="scrollY"]');

            if (!scrollInput) {
                scrollInput = document.createElement("input");
                scrollInput.type = "hidden";
                scrollInput.name = "scrollY";
                form.appendChild(scrollInput);
            }

            scrollInput.value = String(window.scrollY);

            const cartSummary = document.querySelector(".cart-summary-bar");

            if (cartSummary && cartSummary.open
                    && !form.querySelector('input[name="cartOpen"]')) {
                const cartOpenInput = document.createElement("input");
                cartOpenInput.type = "hidden";
                cartOpenInput.name = "cartOpen";
                cartOpenInput.value = "true";
                form.appendChild(cartOpenInput);
            }
        });
    });

    if (savedPosition !== null && /^\d+$/.test(savedPosition)) {
        const position = Number(savedPosition);

        document.documentElement.style.scrollBehavior = "auto";

        window.scrollTo({
            top: position,
            left: 0,
            behavior: "auto"
        });
    }
})();
</script>







</body>
</html>
