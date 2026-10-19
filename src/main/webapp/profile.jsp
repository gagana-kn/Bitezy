<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.User"%>

<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("\"", "&quot;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("'", "&#39;");
    }
%>

<%
    String contextPath = request.getContextPath();
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(contextPath + "/login");
        return;
    }

    String username = user.getUsername() == null
            ? "" : user.getUsername().trim();

    String email = user.getEmail() == null
            ? "" : user.getEmail().trim();

    String phone = user.getPhone() == null
            ? "" : user.getPhone().trim();

    String address = user.getAddress() == null
            ? "" : user.getAddress().trim();

    String initial = username.isEmpty()
            ? "U" : username.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Profile | Bitezy</title>

<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
    --green: #174c36;
    --green-hover: #236447;
    --dark: #222522;
    --muted: #858780;
    --border: #eee8df;
    --light-green: #f3f7f3;
    --footer-green: #103e2e;
    --coral: #f15a3b;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                 Roboto, Arial, sans-serif;
}

body {
    color: var(--dark);
    background: #fff;
}

a {
    color: inherit;
    text-decoration: none;
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
.nav-action:focus-visible {
    color: var(--green);
}

.profile-dropdown {
    position: relative;
}

.profile-toggle {
    border: 0;
    background: transparent;
    cursor: pointer;
    font-size: 14px;
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
    background: var(--light-green);
    color: var(--green);
}

/* PROFILE CONTENT */

.page-container {
    width: 86%;
    max-width: 1000px;
    margin: 0 auto;
}

.profile-page {
    padding-top: 45px;
    padding-bottom: 70px;
    min-height: 530px;
}

.breadcrumb {
    display: flex;
    align-items: center;
    gap: 9px;
    margin-bottom: 25px;
    font-size: 12px;
    color: var(--muted);
}

.breadcrumb a:hover {
    color: var(--green);
}

.breadcrumb i {
    font-size: 9px;
}

.page-heading {
    margin-bottom: 25px;
}

.page-heading h1 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(29px, 4vw, 37px);
    font-weight: 600;
    letter-spacing: -.5px;
    margin-bottom: 9px;
}

.page-heading h1 span {
    font-family: Georgia, "Times New Roman", serif;
    color: var(--green);
}

.page-heading p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.7;
}

/* MAIN PROFILE CARD */

.profile-card {
    border: 1px solid var(--border);
    border-radius: 14px;
    background: #fff;
    box-shadow: 0 5px 20px #00000005;
    overflow: hidden;
}

.profile-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 22px;
    padding: 27px 30px;
}

.profile-identity {
    display: flex;
    align-items: center;
    gap: 17px;
    min-width: 0;
}

.avatar {
    width: 68px;
    height: 68px;
    flex-shrink: 0;
    display: grid;
    place-items: center;
    border-radius: 50%;
    background: var(--light-green);
    border: 1px solid #dce8dd;
    color: var(--green);
    font-family: Georgia, "Times New Roman", serif;
    font-size: 29px;
    font-weight: 700;
}

.profile-identity h2 {
    font-size: 20px;
    font-weight: 700;
    line-height: 1.4;
    overflow-wrap: anywhere;
    margin-bottom: 6px;
}

.account-label {
    color: var(--muted);
    font-size: 12px;
}

.profile-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    flex-shrink: 0;
}

.btn {
    min-height: 41px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 11px 16px;
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
    transition: background .2s, color .2s, border-color .2s;
}

.edit-btn {
    background: var(--green);
    color: #fff;
    border: 1px solid var(--green);
}

.edit-btn:hover {
    background: var(--green-hover);
    border-color: var(--green-hover);
}

.logout-btn {
    color: var(--coral);
    background: #fff;
    border: 1px solid #f0d7d1;
}

.logout-btn:hover {
    color: #fff;
    background: var(--coral);
    border-color: var(--coral);
}

.card-divider {
    height: 1px;
    background: var(--border);
}

/* PERSONAL DETAILS */

.details-section {
    padding: 26px 30px 12px;
}

.details-heading {
    font-size: 16px;
    font-weight: 700;
    margin-bottom: 5px;
}

.details-description {
    font-size: 12px;
    line-height: 1.6;
    color: var(--muted);
    margin-bottom: 14px;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    column-gap: 38px;
}

.detail-item {
    padding: 20px 0;
    border-bottom: 1px solid var(--border);
    min-width: 0;
}

.detail-label {
    display: flex;
    align-items: center;
    gap: 9px;
    color: var(--muted);
    font-size: 11px;
    font-weight: 650;
    text-transform: uppercase;
    letter-spacing: .5px;
    margin-bottom: 9px;
}

.detail-label i {
    color: var(--green);
    font-size: 13px;
}

.detail-value {
    color: var(--dark);
    font-size: 14px;
    line-height: 1.7;
    overflow-wrap: anywhere;
}

.detail-value.empty {
    color: #999b95;
    font-style: italic;
}

/* FOOTER */

footer {
    background: var(--footer-green);
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

    .profile-top {
        align-items: flex-start;
        flex-direction: column;
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

    .profile-page {
        padding-top: 30px;
        padding-bottom: 45px;
    }

    .profile-top {
        padding: 23px 19px;
    }

    .profile-identity {
        gap: 13px;
    }

    .avatar {
        width: 58px;
        height: 58px;
        font-size: 25px;
    }

    .profile-identity h2 {
        font-size: 18px;
    }

    .profile-actions {
        width: 100%;
    }

    .profile-actions .btn {
        flex: 1;
    }

    .details-section {
        padding: 23px 19px 8px;
    }

    .details-grid {
        grid-template-columns: 1fr;
    }

    .detail-item {
        padding: 17px 0;
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

        <div class="profile-dropdown">
            <button type="button" class="nav-action profile-toggle">
                <i class="fa-regular fa-user"></i>
                <%= escapeHtml(username) %>
                <i class="fa-solid fa-chevron-down"></i>
            </button>

            <div class="profile-menu">
                <a href="<%= contextPath %>/profile">My Profile</a>
                <a href="<%= contextPath %>/logout">Logout</a>
            </div>
        </div>
    </nav>
</header>

<!-- PROFILE PAGE -->

<main class="page-container profile-page">

    <div class="breadcrumb">
        <a href="<%= contextPath %>/restaurant">Home</a>
        <i class="fa-solid fa-chevron-right"></i>
        <span>My Profile</span>
    </div>

    <div class="page-heading">
        <h1>My <span>Profile</span></h1>
        <p>View and manage your personal information.</p>
    </div>

    <section class="profile-card">

        <!-- USER SUMMARY AND ACTION BUTTONS -->

        <div class="profile-top">

            <div class="profile-identity">
                <div class="avatar"><%= escapeHtml(initial) %></div>

                <div>
                    <h2><%= username.isEmpty()
                            ? "Customer" : escapeHtml(username) %></h2>
                    <p class="account-label">Bitezy Customer</p>
                </div>
            </div>

            <div class="profile-actions">
                <a href="<%= contextPath %>/edit-profile"
                   class="btn edit-btn">
                    <i class="fa-solid fa-pen-to-square"></i>
                    Edit Profile
                </a>

                <a href="<%= contextPath %>/logout"
                   class="btn logout-btn">
                    <i class="fa-solid fa-right-from-bracket"></i>
                    Logout
                </a>
            </div>

        </div>

        <div class="card-divider"></div>

        <!-- PERSONAL INFORMATION -->

        <div class="details-section">

            <h3 class="details-heading">Personal Information</h3>

            <p class="details-description">
                Your account details and contact information.
            </p>

            <div class="details-grid">

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fa-regular fa-user"></i>
                        Full Name
                    </div>

                    <div class="detail-value <%= username.isEmpty() ? "empty" : "" %>">
                        <%= username.isEmpty()
                                ? "Not provided" : escapeHtml(username) %>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fa-regular fa-envelope"></i>
                        Email Address
                    </div>

                    <div class="detail-value <%= email.isEmpty() ? "empty" : "" %>">
                        <%= email.isEmpty()
                                ? "Not provided" : escapeHtml(email) %>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fa-solid fa-phone"></i>
                        Phone Number
                    </div>

                    <div class="detail-value <%= phone.isEmpty() ? "empty" : "" %>">
                        <%= phone.isEmpty()
                                ? "Not provided" : escapeHtml(phone) %>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">
                        <i class="fa-solid fa-location-dot"></i>
                        Delivery Address
                    </div>

                    <div class="detail-value <%= address.isEmpty() ? "empty" : "" %>">
                        <%= address.isEmpty()
                                ? "Not provided" : escapeHtml(address) %>
                    </div>
                </div>

            </div>
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