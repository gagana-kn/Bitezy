
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.tap.model.Order"%>
<%@ page import="com.tap.model.OrderItem"%>
<%@ page import="com.tap.model.Menu"%>
<%@ page import="com.tap.model.User"%>

<%
User user = (User) session.getAttribute("user");

if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

List<Order> orders =
        (List<Order>) request.getAttribute("orders");

Map<Integer, List<OrderItem>> orderItemsMap =
        (Map<Integer, List<OrderItem>>) request.getAttribute("orderItemsMap");

Map<Integer, Menu> menuMap =
        (Map<Integer, Menu>) request.getAttribute("menuMap");

Map<Integer, String> restaurantNameMap =
        (Map<Integer, String>) request.getAttribute("restaurantNameMap");

Map<Integer, String> restaurantImageMap =
        (Map<Integer, String>) request.getAttribute("restaurantImageMap");

String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Orders | Bitezy</title>

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
    color: var(--dark);
    background: #fff;
}

a {
    color: inherit;
    text-decoration: none;
}

button, input {
    font: inherit;
}

/* NAVBAR - SAME AS RESTAURANT.JSP */

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
    background: white;
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

/* ORDERS PAGE */

.page-container {
    max-width: 1120px;
    width: 86%;
    min-height: 70vh;
    margin: 42px auto 65px;
}

.page-heading {
    margin-bottom: 28px;
}

.section-heading {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 30px;
    line-height: 1.3;
    margin-bottom: 9px;
    color: var(--green);
}

.section-caption {
    font-size: 14px;
    color: var(--muted);
    line-height: 1.6;
}

/* ORDER CARD */

.order-card {
    background: #fff;
    border: 1px solid #e4e7e2;
    border-radius: 13px;
    overflow: hidden;
    margin-bottom: 24px;
    box-shadow: 0 4px 14px rgba(0, 0, 0, .035);
}

.restaurant-section {
    display: flex;
    align-items: center;
    gap: 20px;
    padding: 22px;
}

.restaurant-image {
    width: 180px;
    height: 150px;
    object-fit: cover;
    object-position: center;
    border-radius: 10px;
    background: #f0f0f0;
    flex-shrink: 0;
}

.restaurant-info {
    flex: 1;
    min-width: 0;
}

.restaurant-info h2 {
    color: var(--green);
    font-size: 21px;
    margin-bottom: 10px;
}

.order-date {
    color: #777;
    font-size: 13px;
    margin-bottom: 13px;
}

.item-heading {
    color: #888;
    font-size: 13px;
    margin-bottom: 6px;
}

.item-names {
    color: #333;
    font-size: 14px;
    line-height: 1.8;
    overflow-wrap: anywhere;
}

/* BOTTOM SECTION */

.order-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    padding: 19px 22px;
    border-top: 1px solid #ededed;
    background: #fcfcfb;
}

.total-label {
    color: #777;
    font-size: 13px;
    margin-bottom: 5px;
}

.total-amount {
    color: var(--green);
    font-size: 22px;
    font-weight: bold;
}

/* ORDER MORE BUTTON */

.order-more {
    display: inline-block;
    padding: 13px 24px;
    background: var(--green);
    color: #fff;
    text-decoration: none;
    text-align: center;
    border-radius: 8px;
    font-size: 13px;
    font-weight: bold;
    white-space: nowrap;
    transition: background .2s ease;
}

.order-more:hover {
    background: var(--green-hover);
}

/* EMPTY ORDERS */

.empty-orders {
    background: #fff;
    border: 1px solid #e4e7e2;
    border-radius: 12px;
    text-align: center;
    padding: 65px 20px;
}

.empty-orders h2 {
    color: var(--green);
    font-size: 23px;
    margin-bottom: 12px;
}

.empty-orders p {
    color: #777;
    font-size: 14px;
    margin-bottom: 24px;
}

.browse-link {
    display: inline-block;
    padding: 12px 23px;
    color: #fff;
    background: var(--green);
    border-radius: 8px;
    text-decoration: none;
    font-size: 14px;
    font-weight: bold;
}

.browse-link:hover {
    background: var(--green-hover);
}

/* FOOTER - SAME AS RESTAURANT.JSP */

footer {
    background: #103e2e;
    color: white;
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
    background: white;
    color: var(--green);
}

.footer-logo .logo-name {
    color: white;
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

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 650px) {
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

    .page-container {
        width: 92%;
        margin-top: 28px;
    }

    .section-heading {
        font-size: 25px;
    }

    .restaurant-section {
        align-items: flex-start;
        padding: 16px;
        gap: 13px;
    }

    .restaurant-image {
        width: 110px;
        height: 100px;
    }

    .restaurant-info h2 {
        font-size: 17px;
    }

    .order-date {
        line-height: 1.5;
    }

    .item-names {
        font-size: 13px;
    }

    .order-bottom {
        padding: 16px;
        gap: 12px;
    }

    .total-amount {
        font-size: 20px;
    }

    .order-more {
        padding: 12px 14px;
        font-size: 12px;
    }

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 27px 20px;
    }
}

@media (max-width: 380px) {
    .restaurant-section {
        flex-direction: column;
    }

    .restaurant-image {
        width: 100%;
        height: 180px;
    }

    .order-bottom {
        align-items: flex-start;
        flex-direction: column;
    }

    .order-more {
        width: 100%;
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

<!-- NAVBAR - SAME AS RESTAURANT.JSP -->

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
            Cart
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

                <button type="button"
                        class="nav-action profile-toggle"
                        aria-label="Open profile menu">

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

<!-- MAIN CONTENT -->

<main class="page-container">

    <div class="page-heading">

        <h1 class="section-heading">My Orders</h1>

        <p class="section-caption">
            Your previous orders, all in one place.
        </p>

    </div>

    <% if (orders == null || orders.isEmpty()) { %>

        <div class="empty-orders">

            <h2>No orders yet</h2>

            <p>
                Discover delicious food and place your first order.
            </p>

            <a href="<%= contextPath %>/restaurant"
               class="browse-link">
                Explore Restaurants
            </a>

        </div>

    <% } else { %>

        <% for (Order order : orders) {

            int restaurantId = order.getRestaurantId();

            List<OrderItem> items =
                    orderItemsMap != null
                    ? orderItemsMap.get(order.getOrderId())
                    : null;

            String restaurantName =
                    restaurantNameMap != null
                    ? restaurantNameMap.get(restaurantId)
                    : null;

            String restaurantImage =
                    restaurantImageMap != null
                    ? restaurantImageMap.get(restaurantId)
                    : null;

            if (restaurantName == null || restaurantName.trim().isEmpty()) {
                restaurantName = "Restaurant";
            }

            String imageSrc = null;

            if (restaurantImage != null
                    && !restaurantImage.trim().isEmpty()) {

                if (restaurantImage.startsWith("http://")
                        || restaurantImage.startsWith("https://")) {

                    imageSrc = restaurantImage;

                } else {

                    String imagePath = restaurantImage.replace('\\', '/');

                    while (imagePath.startsWith("/")) {
                        imagePath = imagePath.substring(1);
                    }

                    imageSrc = contextPath + "/" + imagePath;
                }
            }

            StringBuilder names = new StringBuilder();

            if (items != null) {

                for (OrderItem item : items) {

                    Menu menu = menuMap != null
                            ? menuMap.get(item.getMenuId())
                            : null;

                    String itemName = menu != null
                            ? menu.getItemName()
                            : "Menu item";

                    if (names.length() > 0) {
                        names.append(", ");
                    }

                    names.append(itemName);
                }
            }
        %>

            <section class="order-card">

                <div class="restaurant-section">

                    <% if (imageSrc != null) { %>

                        <img class="restaurant-image"
                             src="<%= imageSrc %>"
                             alt="<%= restaurantName %>"
                             onerror="this.style.display='none';">

                    <% } %>

                    <div class="restaurant-info">

                        <h2><%= restaurantName %></h2>

                        <div class="order-date">
                            Order placed:
                            <%= order.getOrderDate() %>
                        </div>

                        <div class="item-heading">
                            Items ordered
                        </div>

                        <div class="item-names">
                            <%= names.length() > 0
                                    ? names.toString()
                                    : "Item details unavailable" %>
                        </div>

                    </div>

                </div>

                <div class="order-bottom">

                    <div>

                        <div class="total-label">
                            Total amount
                        </div>

                        <div class="total-amount">
                            ₹<%= String.format("%.2f", order.getTotalAmount()) %>
                        </div>

                    </div>

                    <a href="<%= contextPath %>/menu?restaurantId=<%= order.getRestaurantId() %>"
                       class="order-more">
                        ORDER MORE
                    </a>

                </div>

            </section>

        <% } %>

    <% } %>

</main>

<!-- FOOTER - SAME AS RESTAURANT.JSP -->

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
