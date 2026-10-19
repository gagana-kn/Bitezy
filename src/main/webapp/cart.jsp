
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.User" %>
<%
    Cart cart = (Cart) request.getAttribute("cart");
    if (cart == null) {
        cart = (Cart) session.getAttribute("cart");
    }

    User user = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();

    int cartItemCount = 0;
    int restaurantId = 0;
    double cartTotal = 0;

    if (cart != null && cart.getItems() != null
            && !cart.getItems().isEmpty()) {
        for (CartItem item : cart.getItems().values()) {
            cartItemCount += item.getQuantity();
        }

        cartTotal = cart.getTotal();

        CartItem firstItem = cart.getItems().values().iterator().next();
        if (firstItem != null && firstItem.getMenu() != null) {
            restaurantId = firstItem.getMenu().getRestaurantId();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bitezy | Your Cart</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --green: #174c36;
    --green-hover: #236447;
    --dark: #222522;
    --muted: #858780;
    --border: #eee8df;
    --soft-green: #f3f7f3;
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
    max-width: 100%;
    overflow-x: clip;
}

body {
    min-height: 100vh;
    width: 100%;
    max-width: 100%;
    display: flex;
    flex-direction: column;
    color: var(--dark);
    background: #fff;
    overflow-x: clip;
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
    transition: color .2s;
    white-space: nowrap;
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
    background: var(--soft-green);
    color: var(--green);
}

/* CART PAGE */

.cart-section {
    flex: 1;
    width: 100%;
    min-width: 0;
    background: #fff;
    padding: 42px 4% 65px;
}

.cart-container {
    max-width: 1120px;
    width: 100%;
    min-width: 0;
    margin: 0 auto;
}

.cart-heading-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 18px;
    flex-wrap: wrap;
    margin-bottom: 24px;
}

.cart-heading {
    min-width: 0;
}

.cart-eyebrow {
    margin-bottom: 8px;
    color: var(--green);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.cart-heading h1 {
    color: var(--dark);
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(29px, 3vw, 37px);
    line-height: 1.2;
}

.cart-heading p:last-child {
    margin-top: 8px;
    color: var(--muted);
    font-size: 14px;
    line-height: 1.6;
}

/* ADD MORE ITEMS */

.add-more-items {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 11px 17px;
    flex-shrink: 0;
    border: 1px solid var(--green);
    border-radius: 8px;
    background: #fff;
    color: var(--green);
    font-size: 13px;
    font-weight: 700;
    transition: background-color .2s, color .2s;
}

.add-more-items:hover {
    background: var(--green);
    color: #fff;
}

.cart-layout {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 310px;
    align-items: start;
    gap: 22px;
    min-width: 0;
    width: 100%;
}

.cart-items-panel,
.order-summary,
.empty-cart {
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 15px;
    box-shadow: 0 4px 18px rgba(38, 42, 35, .035);
}

.cart-items-panel {
    min-width: 0;
    max-width: 100%;
    overflow: hidden;
}

.cart-table-heading,
.cart-item {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 116px 100px 34px;
    align-items: center;
    gap: 12px;
    min-width: 0;
}

.cart-table-heading {
    padding: 16px 20px;
    background: #fff;
    border-bottom: 1px solid var(--border);
    color: #747970;
    font-size: 11px;
    font-weight: 750;
    letter-spacing: .25px;
    text-transform: uppercase;
}

.cart-table-heading span:not(:first-child) {
    text-align: center;
}

/* CSS-ONLY SELECTED ROW */

.cart-card-choice {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}

.cart-item {
    position: relative;
    min-height: 120px;
    padding: 17px 20px;
    background: #fff;
    border-bottom: 1px solid var(--border);
    transition: none;
}

.cart-item:last-child {
    border-bottom: 0;
}

.cart-card-choice:checked + .cart-item {
    border-color: #d6e1d7;
}

.cart-card-choice:focus-visible + .cart-item {
    outline: 2px solid var(--green);
    outline-offset: -3px;
}

.cart-item-select-overlay {
    position: absolute;
    inset: 0;
    z-index: 1;
    border-radius: 5px;
    cursor: pointer;
}

.item-left,
.item-subtotal {
    position: relative;
    z-index: 0;
    pointer-events: none;
}

.item-quantity,
.remove-form {
    position: relative;
    z-index: 2;
}

.item-left {
    min-width: 0;
    overflow: hidden;
    display: flex;
    align-items: center;
    gap: 14px;
}

.item-image {
    width: 78px;
    height: 76px;
    flex-shrink: 0;
    display: block;
    object-fit: cover;
    background: #f1eee8;
    border-radius: 11px;
}

.item-details {
    min-width: 0;
}

.item-name {
    margin-bottom: 6px;
    color: var(--dark);
    font-size: 15px;
    font-weight: 700;
    line-height: 1.4;
    overflow-wrap: anywhere;
}

.item-price {
    color: var(--muted);
    font-size: 12px;
}

/* QUANTITY BUTTONS — MATCH MENU.JSP */

.item-quantity {
    justify-self: center;
    display: flex;
    align-items: center;
    gap: 9px;
    padding: 5px;
    background: #f3f7f3;
    border: 1px solid #dce7de;
    border-radius: 9px;
}

.item-quantity form,
.remove-form,
.clear-cart-form {
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
    transition: background .2s;
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

/* RECTANGULAR DELETE BUTTON */

.remove-form {
    display: flex;
    justify-content: center;
}

.remove-button {
    width: 34px;
    height: 34px;
    display: grid;
    place-items: center;
    border: 1px solid #e7e3dc;
    border-radius: 7px;
    background: #f3f7f3;
    color: #858780;
    font-size: 13px;
    transition: color .2s, background .2s, border-color .2s;
}

.remove-button:hover {
    color: #b33c32;
    background: #f3f7f3;
    border-color: #efc9c2;
}

/* ORDER SUMMARY */

.order-summary {
    padding: 24px;
    position: sticky;
    top: 96px;
    /* No hover lift, no green top border */
}

.summary-title {
    margin-bottom: 19px;
    font-family: Georgia, "Times New Roman", serif;
    font-size: 22px;
    line-height: 1.3;
    color: var(--green);
}

.summary-note {
    margin: -9px 0 18px;
    color: var(--muted);
    font-size: 12px;
    line-height: 1.5;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 14px;
    color: #646960;
    font-size: 13px;
}

.summary-row span:last-child {
    color: var(--dark);
    font-weight: 650;
    text-align: right;
    white-space: nowrap;
}

.summary-divider {
    height: 1px;
    margin: 18px 0;
    background: var(--border);
}

.summary-total {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
    padding: 14px 0;
    background: transparent;
    border: 0;
    color: var(--dark);
    font-size: 15px;
    font-weight: 800;
}

.summary-total span:last-child {
    font-size: 20px;
    white-space: nowrap;
}

.checkout-button {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    width: 100%;
    min-height: 46px;
    padding: 12px 16px;
    background: var(--green);
    border: 1px solid var(--green);
    border-radius: 9px;
    color: #fff;
    font-size: 13px;
    font-weight: 750;
    text-align: center;
    transition: background .2s;
}

.checkout-button:hover {
    background: var(--green-hover);
}

/* CONTINUE SHOPPING — OUTLINE, NOT GREEN FILLED */

.continue-shopping {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    width: 100%;
    min-height: 44px;
    margin-top: 11px;
    padding: 10px 14px;
    border: 1px solid #dce2db;
    border-radius: 9px;
    background: #f3f7f3;
    color: #454b45;
    font-size: 12px;
    font-weight: 700;
    text-align: center;
    transition: background .2s, border-color .2s;
}

.continue-shopping:hover {
    background: #f3f7f3;
    border-color: #bfcfc1;
}

.clear-cart-form {
    margin-top: 15px;
    text-align: center;
}

.clear-cart-button {
    padding: 5px 8px;
    border: 0;
    background: transparent;
    color: #8a6d67;
    font-size: 12px;
    text-decoration: underline;
    text-underline-offset: 3px;
}

.clear-cart-button:hover {
    color: #b33c32;
}

/* EMPTY CART */

.empty-cart {
    padding: 65px 22px;
    text-align: center;
    transition: transform .2s ease, box-shadow .2s ease;
}

.empty-cart:hover {
    transform: translateY(-3px);
    box-shadow: 0 9px 22px rgba(23, 76, 54, .12);
}

.empty-cart-icon {
    width: 68px;
    height: 68px;
    display: grid;
    place-items: center;
    margin: 0 auto 18px;
    background: var(--soft-green);
    border-radius: 50%;
    color: var(--green);
    font-size: 25px;
}

.empty-cart h2 {
    margin-bottom: 9px;
    font-family: Georgia, "Times New Roman", serif;
    font-size: 25px;
}

.empty-cart p {
    margin-bottom: 22px;
    color: var(--muted);
    font-size: 14px;
    line-height: 1.7;
}

.browse-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    min-height: 43px;
    padding: 0 20px;
    background: var(--green);
    color: #fff;
    border-radius: 8px;
    font-size: 13px;
    font-weight: 700;
    transition: background .2s;
}

.browse-button:hover {
    background: var(--green-hover);
}

/* FOOTER */

footer {
    margin-top: auto;
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

@media (max-width: 950px) {
    .nav-actions {
        gap: 15px;
    }

    .cart-layout {
        grid-template-columns: minmax(0, 1fr) 280px;
        gap: 16px;
    }

    .cart-table-heading,
    .cart-item {
        grid-template-columns: minmax(0, 1fr) 100px 82px 34px;
        gap: 8px;
        padding-left: 14px;
        padding-right: 14px;
    }

    .item-left {
        gap: 10px;
    }

    .item-image {
        width: 66px;
        height: 66px;
    }

    .order-summary {
        padding: 18px;
    }

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 850px) {
    .cart-layout {
        grid-template-columns: minmax(0, 1fr);
    }

    .order-summary {
        position: static;
    }
}

@media (max-width: 720px) {
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

    .cart-section {
        padding: 30px 4% 45px;
    }

    .cart-layout {
        grid-template-columns: minmax(0, 1fr);
    }

    .order-summary {
        position: static;
    }

    .cart-table-heading,
    .cart-item {
        grid-template-columns: minmax(0, 1fr) 96px 76px 34px;
    }

    .cart-table-heading {
        font-size: 10px;
    }

    .cart-item {
        min-height: 105px;
        padding-top: 13px;
        padding-bottom: 13px;
    }

    .item-name {
        font-size: 13px;
    }

    .item-price {
        font-size: 11px;
    }

    .item-image {
        width: 58px;
        height: 60px;
    }

    .quantity-button {
        width: 27px;
        height: 27px;
    }

    .item-quantity {
        gap: 9px;
    }

    .quantity-number {
        min-width: 13px;
    }

    .item-subtotal {
        font-size: 12px;
    }

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 27px 20px;
    }
}

@media (max-width: 480px) {
    .cart-heading-row {
        align-items: flex-start;
    }

    .add-more-items {
        padding: 10px 12px;
        font-size: 12px;
    }

    .cart-table-heading {
        grid-template-columns: minmax(0, 1fr) 75px 58px 30px;
        gap: 5px;
        padding: 13px 8px;
        font-size: 9px;
    }

    .cart-item {
        grid-template-columns: minmax(0, 1fr) 75px 58px 30px;
        gap: 5px;
        padding: 12px 8px;
    }

    .item-left {
        gap: 7px;
    }

    .item-image {
        width: 45px;
        height: 48px;
        border-radius: 8px;
    }

    .item-name {
        font-size: 11px;
    }

    .item-price {
        font-size: 10px;
    }

    .item-quantity {
        gap: 4px;
        padding: 3px;
    }

    .quantity-button {
        width: 22px;
        height: 25px;
        font-size: 17px;
    }

    .quantity-number {
        min-width: 12px;
        font-size: 12px;
    }

    .item-subtotal {
        font-size: 10px;
    }

    .remove-button {
        width: 28px;
        height: 30px;
    }

    .footer-container {
        grid-template-columns: 1fr;
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
            <i class="fa-solid fa-house"></i> Home
        </a>

        <a href="<%= contextPath %>/restaurant#restaurants"
           class="nav-action">Restaurants</a>

        <a href="<%= contextPath %>/cart" class="nav-action">
            <i class="fa-solid fa-cart-shopping"></i>
            Cart
            <% if (cartItemCount > 0) { %>
                (<%= cartItemCount %>)
            <% } %>
        </a>

        <a href="<%= contextPath %>/orders" class="nav-action">
            <i class="fa-solid fa-box"></i> Orders
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
            <%= user.getUsername() %>
            <i class="fa-solid fa-chevron-down"></i>
        </button>

        <div class="profile-menu">
            <a href="<%= contextPath %>/profile">My Profile</a>
            <a href="<%= contextPath %>/logout">Logout</a>
        </div>

    </div>

<% } %>
    </nav>
</header>

<!-- MAIN CART -->

<main class="cart-section">
<div class="cart-container">

    <div class="cart-heading-row">
        <div class="cart-heading">
            <p class="cart-eyebrow">Fresh picks, made for you</p>
            <h1>Your Cart</h1>
            <p>Review your items and get ready for something delicious.</p>
        </div>

        <% if (restaurantId > 0) { %>
            <a href="<%= contextPath %>/menu?restaurantId=<%= restaurantId %>"
               class="add-more-items">
                <i class="fa-solid fa-plus"></i>
                Add More Items
            </a>
        <% } %>
    </div>

    <% if (cart != null && cart.getItems() != null
            && !cart.getItems().isEmpty()) { %>

    <div class="cart-layout">

        <section class="cart-items-panel" aria-label="Cart items">

            <div class="cart-table-heading">
                <span>Product</span>
                <span>Quantity</span>
                <span>Total</span>
                <span></span>
            </div>

            <% for (Map.Entry<Integer, CartItem> entry
                    : cart.getItems().entrySet()) {
                CartItem cartItem = entry.getValue();
                int menuId = cartItem.getMenu().getMenuId();
                String rowId = "cart-row-" + menuId;
            %>

            <input type="radio"
                   class="cart-card-choice"
                   name="selectedCartItem"
                   id="<%= rowId %>"
                   aria-label="Select <%= cartItem.getMenu().getItemName() %>">

            <article class="cart-item">

                <label class="cart-item-select-overlay"
                       for="<%= rowId %>"
                       aria-label="Select this cart item"></label>

                <div class="item-left">
                    <img src="<%= cartItem.getMenu().getImagePath() %>"
                         class="item-image"
                         alt="<%= cartItem.getMenu().getItemName() %>">

                    <div class="item-details">
                        <div class="item-name">
                            <%= cartItem.getMenu().getItemName() %>
                        </div>
                        <div class="item-price">
                            ₹<%= String.format("%.2f",
                                cartItem.getMenu().getPrice()) %> each
                        </div>
                    </div>
                </div>

                <!-- QUANTITY CONTROL MATCHING MENU.JSP -->

                <div class="item-quantity" aria-label="Change quantity">

                    <form action="<%= contextPath %>/cart" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="menuId" value="<%= menuId %>">
                        <input type="hidden" name="quantity"
                               value="<%= cartItem.getQuantity() - 1 %>">
                        <input type="hidden" name="source" value="cart">

                        <button type="submit" class="quantity-button"
                                aria-label="Decrease quantity">−</button>
                    </form>

                    <span class="quantity-number">
                        <%= cartItem.getQuantity() %>
                    </span>

                    <form action="<%= contextPath %>/cart" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="menuId" value="<%= menuId %>">
                        <input type="hidden" name="quantity"
                               value="<%= cartItem.getQuantity() + 1 %>">
                        <input type="hidden" name="source" value="cart">

                        <button type="submit" class="quantity-button"
                                aria-label="Increase quantity">+</button>
                    </form>

                </div>

                <div class="item-subtotal">
                    ₹<%= String.format("%.2f", cartItem.getSubtotal()) %>
                </div>

                <!-- RECTANGULAR DELETE BUTTON -->

                <form action="<%= contextPath %>/cart"
                      method="post"
                      class="remove-form">

                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="menuId" value="<%= menuId %>">
                    <input type="hidden" name="quantity" value="0">
                    <input type="hidden" name="source" value="cart">

                    <button type="submit" class="remove-button"
                            aria-label="Remove item">
                        <i class="fa-regular fa-trash-can"></i>
                    </button>
                </form>

            </article>

            <% } %>
        </section>

        <!-- ORDER SUMMARY -->

        <aside class="order-summary" aria-label="Order summary">

            <h2 class="summary-title">Order Summary</h2>
            <p class="summary-note">
                A little deliciousness is just a step away.
            </p>

            <div class="summary-row">
                <span>Items</span>
                <span><%= cartItemCount %></span>
            </div>

            <div class="summary-row">
                <span>Subtotal</span>
                <span>₹<%= String.format("%.2f", cartTotal) %></span>
            </div>

            <div class="summary-divider"></div>

            <div class="summary-total">
                <span>Total</span>
                <span>₹<%= String.format("%.2f", cartTotal) %></span>
            </div>

            <a href="<%= contextPath %>/checkout" class="checkout-button">
                Proceed to Checkout
                <i class="fa-solid fa-arrow-right"></i>
            </a>

            <a href="<%= contextPath %>/restaurant"
               class="continue-shopping">
                <i class="fa-solid fa-arrow-left"></i>
                Continue Shopping
            </a>

            <form action="<%= contextPath %>/cart"
                  method="post"
                  class="clear-cart-form">
                <input type="hidden" name="action" value="clear">
                <input type="hidden" name="source" value="cart">
                <button type="submit" class="clear-cart-button">
                    Clear cart
                </button>
            </form>

        </aside>
    </div>

    <% } else { %>

    <section class="empty-cart">
        <div class="empty-cart-icon">
            <i class="fa-solid fa-cart-shopping"></i>
        </div>

        <h2>Your cart is waiting for something tasty</h2>

        <p>
            You haven't added any dishes yet.
            Explore the menu and find a new favourite.
        </p>

        <a href="<%= contextPath %>/restaurant" class="browse-button">
            Browse Restaurants
            <i class="fa-solid fa-arrow-right"></i>
        </a>
    </section>

    <% } %>

</div>
</main>

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
        © 2026 Bitezy. All rights reserved.
    </div>
</footer>

</body>
</html>