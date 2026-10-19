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

    Object errorObject = request.getAttribute("error");
    String error = errorObject == null ? "" : errorObject.toString();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Edit Profile | Bitezy</title>

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

button, input, textarea {
    font: inherit;
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

/* EDIT PROFILE CONTENT */

.page-container {
    width: 86%;
    max-width: 850px;
    margin: 0 auto;
}

.edit-page {
    min-height: 530px;
    padding-top: 45px;
    padding-bottom: 70px;
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

/* FORM CARD */

.form-card {
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 14px;
    box-shadow: 0 5px 20px #00000005;
    padding: 30px;
}

.form-header {
    padding-bottom: 21px;
    margin-bottom: 25px;
    border-bottom: 1px solid var(--border);
}

.form-header h2 {
    font-size: 17px;
    font-weight: 750;
    margin-bottom: 7px;
}

.form-header p {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.7;
}

.error-message {
    display: flex;
    align-items: flex-start;
    gap: 10px;
    margin-bottom: 22px;
    padding: 13px 14px;
    color: #a52b20;
    background: #fff2ef;
    border: 1px solid #f2d2cb;
    border-radius: 8px;
    font-size: 13px;
    line-height: 1.6;
    overflow-wrap: anywhere;
}

.error-message i {
    margin-top: 2px;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 23px 20px;
}

.form-group {
    min-width: 0;
}

.form-group.full-width {
    grid-column: 1 / -1;
}

.form-group label {
    display: block;
    margin-bottom: 9px;
    color: #353a35;
    font-size: 12px;
    font-weight: 700;
}

.form-group input,
.form-group textarea {
    display: block;
    width: 100%;
    padding: 13px 14px;
    color: var(--dark);
    background: #fff;
    border: 1px solid #e6e1d8;
    border-radius: 8px;
    outline: none;
    font-size: 13px;
    transition: border-color .2s, box-shadow .2s;
}

.form-group input {
    min-height: 46px;
}

.form-group textarea {
    min-height: 115px;
    resize: vertical;
    line-height: 1.7;
}

.form-group input:focus,
.form-group textarea:focus {
    border-color: var(--green);
    box-shadow: 0 0 0 3px #174c3610;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
    color: #a2a39e;
}

.form-note {
    margin-top: 8px;
    color: var(--muted);
    font-size: 11px;
    line-height: 1.6;
}

.form-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    padding-top: 24px;
    margin-top: 28px;
    border-top: 1px solid var(--border);
}

.btn {
    min-height: 43px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 11px 18px;
    border: 1px solid var(--green);
    border-radius: 7px;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: background .2s, color .2s, border-color .2s;
}

.save-btn {
    background: var(--green);
    color: #fff;
}

.save-btn:hover {
    background: var(--green-hover);
    border-color: var(--green-hover);
}

.cancel-btn {
    background: #fff;
    color: var(--green);
}

.cancel-btn:hover {
    background: var(--light-green);
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

    .edit-page {
        padding-top: 30px;
        padding-bottom: 45px;
    }

    .form-card {
        padding: 22px 18px;
    }

    .form-grid {
        grid-template-columns: 1fr;
        gap: 21px;
    }

    .form-group.full-width {
        grid-column: auto;
    }

    .form-actions {
        flex-direction: column;
    }

    .form-actions .btn {
        width: 100%;
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

<!-- EDIT PROFILE FORM -->

<main class="page-container edit-page">

    <div class="breadcrumb">
        <a href="<%= contextPath %>/restaurant">Home</a>
        <i class="fa-solid fa-chevron-right"></i>
        <a href="<%= contextPath %>/profile">My Profile</a>
        <i class="fa-solid fa-chevron-right"></i>
        <span>Edit Profile</span>
    </div>

    <div class="page-heading">
        <h1>Edit <span>Profile</span></h1>
        <p>Update your personal information below.</p>
    </div>

    <section class="form-card">

        <div class="form-header">
            <h2>Personal Information</h2>
            <p>Your current details are filled in automatically.</p>
        </div>

        <% if (!error.isEmpty()) { %>
            <div class="error-message">
                <i class="fa-solid fa-circle-exclamation"></i>
                <span><%= escapeHtml(error) %></span>
            </div>
        <% } %>

        <form action="<%= contextPath %>/edit-profile" method="post">

            <div class="form-grid">

                <div class="form-group">
                    <label for="username">Full Name</label>
                    <input
                        type="text"
                        id="username"
                        name="username"
                        value="<%= escapeHtml(username) %>"
                        maxlength="100"
                        autocomplete="name"
                        placeholder="Enter your full name"
                        required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        value="<%= escapeHtml(email) %>"
                        maxlength="254"
                        autocomplete="email"
                        placeholder="Enter your email address"
                        required>
                </div>

                <div class="form-group full-width">
                    <label for="phone">Phone Number</label>
                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        value="<%= escapeHtml(phone) %>"
                        maxlength="20"
                        autocomplete="tel"
                        placeholder="Enter your phone number"
                        required>
                </div>

                <div class="form-group full-width">
                    <label for="address">Delivery Address</label>
                    <textarea
                        id="address"
                        name="address"
                        maxlength="500"
                        autocomplete="street-address"
                        placeholder="Enter your complete delivery address"
                        required><%= escapeHtml(address) %></textarea>

                    <p class="form-note">
                        Include your house or flat number, street,
                        area and PIN code where applicable.
                    </p>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn save-btn">
                    <i class="fa-solid fa-check"></i>
                    Save Changes
                </button>

                <a href="<%= contextPath %>/profile"
                   class="btn cancel-btn">
                    Cancel
                </a>
            </div>

        </form>
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