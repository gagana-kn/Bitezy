
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User"%>

<%
    User user = (User) session.getAttribute("user");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Order Successful | Bitezy</title>

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
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

a {
    color: inherit;
    text-decoration: none;
}

button {
    font: inherit;
}

/* NAVBAR — same as restaurant.jsp */

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

/* ORDER SUCCESS CONTENT */

.success-section {
    flex: 1;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 65px 20px 75px;
    background: #fff;
}

.success-content {
    width: 100%;
    max-width: 600px;
    margin: auto;
    text-align: center;
}

.success-icon {
    width: 84px;
    height: 84px;
    margin: 0 auto 25px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: #e8f2eb;
    color: var(--green);
    font-size: 39px;
}

.success-content h1 {
    font-family: Georgia, "Times New Roman", serif;
    color: var(--green);
    font-size: clamp(29px, 4vw, 39px);
    line-height: 1.25;
    margin-bottom: 16px;
}

.success-content .success-lead {
    color: #444a44;
    font-size: 16px;
    line-height: 1.8;
    margin-bottom: 7px;
}

.success-content .success-description {
    max-width: 440px;
    margin: 0 auto;
    color: var(--muted);
    font-size: 14px;
    line-height: 1.9;
}

.success-actions {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-wrap: wrap;
    gap: 13px;
    margin-top: 30px;
}

.success-btn {
    min-height: 45px;
    padding: 0 22px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    border: 1px solid var(--green);
    border-radius: 8px;
    font-size: 13px;
    font-weight: 700;
    transition: background .2s ease, color .2s ease;
}

.success-btn-primary {
    background: var(--green);
    color: white;
}

.success-btn-primary:hover {
    background: var(--green-hover);
    border-color: var(--green-hover);
}

.success-btn-secondary {
    background: white;
    color: var(--green);
}

.success-btn-secondary:hover {
    background: #f3f7f3;
}

/* FOOTER — same as restaurant.jsp */

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

    .success-section {
        padding: 50px 20px 60px;
    }

    .success-icon {
        width: 74px;
        height: 74px;
        font-size: 34px;
    }

    .success-actions {
        flex-direction: column;
    }

    .success-btn {
        width: 100%;
        max-width: 280px;
    }

    .footer-container {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 27px 20px;
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

<!-- ORDER SUCCESS -->

<main class="success-section">
    <section class="success-content">

        <div class="success-icon">
            <i class="fa-solid fa-check"></i>
        </div>

        <h1>Order Placed Successfully!</h1>

        <p class="success-lead">
            Thank you for choosing Bitezy!
        </p>

        <p class="success-description">
            Your delicious food is being prepared with care.
            We hope you enjoy every bite.
        </p>

        <div class="success-actions">
            <a href="<%= contextPath %>/orders"
               class="success-btn success-btn-primary">
                <i class="fa-solid fa-box"></i>
                View My Orders
            </a>

            <a href="<%= contextPath %>/restaurant"
               class="success-btn success-btn-secondary">
                Continue Shopping
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>

    </section>
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
