<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.model.User"%>

<%!
    private int editDistance(String a, String b) {
        int[][] dp = new int[a.length() + 1][b.length() + 1];

        for (int i = 0; i <= a.length(); i++) {
            dp[i][0] = i;
        }

        for (int j = 0; j <= b.length(); j++) {
            dp[0][j] = j;
        }

        for (int i = 1; i <= a.length(); i++) {
            for (int j = 1; j <= b.length(); j++) {
                int cost = a.charAt(i - 1) == b.charAt(j - 1) ? 0 : 1;

                dp[i][j] = Math.min(
                    Math.min(dp[i - 1][j] + 1, dp[i][j - 1] + 1),
                    dp[i - 1][j - 1] + cost
                );
            }
        }

        return dp[a.length()][b.length()];
    }

    private boolean fuzzyWordMatch(String queryWord, String text) {
        if (queryWord == null || queryWord.isEmpty()) {
            return true;
        }

        if (text == null || text.isEmpty()) {
            return false;
        }

        String normalizedText = text.toLowerCase()
                .replaceAll("[^a-z0-9]+", " ")
                .trim();

        if (normalizedText.isEmpty()) {
            return false;
        }

        String[] words = normalizedText.split("\\s+");

        for (String word : words) {
            if (word.equals(queryWord)
                    || word.contains(queryWord)
                    || queryWord.contains(word)) {
                return true;
            }

            int allowedDistance = queryWord.length() >= 7 ? 2
                    : queryWord.length() >= 4 ? 1 : 0;

            if (allowedDistance > 0
                    && Math.abs(queryWord.length() - word.length())
                       <= allowedDistance
                    && editDistance(queryWord, word) <= allowedDistance) {
                return true;
            }
        }

        return false;
    }

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
    List<Restaurant> restaurants =
            (List<Restaurant>) request.getAttribute("restaurants");

    User user = (User) session.getAttribute("user");

    String search = request.getParameter("search");
    String cuisineFilter = request.getParameter("cuisine");

    if (search == null) {
        search = "";
    }

    if (cuisineFilter == null || cuisineFilter.trim().isEmpty()) {
        cuisineFilter = "all";
    }

    String searchLower = search.trim().toLowerCase();
    String cuisineLower = cuisineFilter.trim().toLowerCase();
    String contextPath = request.getContextPath();

    int visibleCount = 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Bitezy | Food Delivery</title>

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

/* HERO BANNER */

.hero {
    min-height: 365px;
    position: relative;
    display: flex;
    align-items: center;
    overflow: hidden;
    background-color: #21160f;
    background-image:
        linear-gradient(
            90deg,
            rgba(20, 13, 8, .90) 0%,
            rgba(20, 13, 8, .66) 42%,
            rgba(20, 13, 8, .10) 100%
        ),
        url("<%= contextPath %>/images/hero-biriyani.png");
    background-position: center;
    background-size: cover;
    background-repeat: no-repeat;
}

.hero-inner {
    width: 1120px;
    max-width: 86%;
    margin: auto;
    padding: 48px 0 60px;
}

.hero-copy {
    max-width: 490px;
    color: white;
}

.hero-eyebrow {
    color: #f2c78b;
    text-transform: uppercase;
    letter-spacing: 2px;
    font-size: 12px;
    font-weight: 700;
    margin-bottom: 17px;
}

.hero h1 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: clamp(38px, 5vw, 61px);
    line-height: 1.04;
    letter-spacing: -1.2px;
    margin-bottom: 17px;
}

.hero h1 span {
    color: #ff8b70;
    font-family: Georgia, "Times New Roman", serif;
}

.hero-description {
    max-width: 380px;
    color: #eee7df;
    font-size: 14px;
    line-height: 1.8;
}

/* COMMON LAYOUT */

.page-container {
    max-width: 1120px;
    width: 86%;
    margin: auto;
}

.section-heading {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 27px;
    line-height: 1.3;
    margin-bottom: 7px;
}

.section-heading span {
    color: var(--green);
    font-family: Georgia, "Times New Roman", serif;
}

.section-caption {
    font-size: 13px;
    color: var(--muted);
    line-height: 1.6;
}

/* SEARCH */

.search-panel {
    position: relative;
    z-index: 3;
    margin-top: -32px;
    padding: 22px 25px;
    background: #fff;
    border: 1px solid #f0e7d9;
    border-radius: 15px;
    box-shadow: 0 7px 24px #3b2b1610;
}

.search-layout {
    display: grid;
    grid-template-columns: .9fr 1.5fr;
    align-items: center;
    gap: 25px;
}

.search-title {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 23px;
    line-height: 1.3;
    margin-bottom: 5px;
}

.search-title span {
    color: var(--green);
    font-family: Georgia, "Times New Roman", serif;
}

.search-form {
    display: flex;
    gap: 10px;
    min-width: 0;
}

.search-field {
    flex: 1;
    min-width: 0;
    display: flex;
    align-items: center;
    gap: 11px;
    padding: 0 15px;
    min-height: 45px;
    background: white;
    border: 1px solid #e6e1d8;
    border-radius: 9px;
    transition: border-color .2s, box-shadow .2s;
}

.search-field:focus-within {
    border-color: var(--green);
    box-shadow: 0 0 0 3px #174c3610;
}

.search-field i {
    color: var(--green);
}

.search-field input {
    width: 100%;
    min-width: 0;
    border: none;
    outline: none;
    background: transparent;
    color: var(--dark);
    font-size: 13px;
}

.search-field input::placeholder {
    color: #999b95;
}

.search-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    border: 0;
    border-radius: 9px;
    padding: 0 22px;
    background: var(--green);
    color: white;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    transition: background .2s, transform .2s;
}

.search-button:hover {
    background: var(--green-hover);
    transform: translateY(-1px);
}

/* CUISINES */

.cuisine-section {
    padding-top: 38px;
    padding-bottom: 12px;
}

.cuisine-circles {
    display: grid;
    grid-template-columns: repeat(7, minmax(0, 1fr));
    gap: 18px;
    padding: 20px 0 10px;
}

.cuisine-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 9px;
    min-width: 0;
    color: #272a27;
    font-size: 14px;
    font-weight: 500;
    text-align: center;
}

.cuisine-image {
    display: block;
    width: min(100%, 112px);
    aspect-ratio: 1;
    border-radius: 50%;
    overflow: hidden;
    background: #f2ede5;
    border: 2px solid transparent;
    box-shadow: 0 3px 12px #0000000c;
    transition: transform .25s, box-shadow .25s, border-color .25s;
}

.cuisine-image img {
    width: 100%;
    height: 100%;
    display: block;
    object-fit: cover;
}

.cuisine-item:hover .cuisine-image {
    transform: translateY(-4px) scale(1.04);
    border-color: var(--green);
    box-shadow: 0 9px 20px #174c3620;
}

.cuisine-item.active .cuisine-image {
    border-color: var(--green);
}

.cuisine-item.active > span:last-child {
    color: var(--green);
    font-weight: 700;
}

/* RESTAURANTS */

.restaurant-section {
    padding-top: 30px;
    padding-bottom: 65px;
    scroll-margin-top: 90px;
}

.section-top {
    margin-bottom: 22px;
}

.restaurant-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 24px;
    align-items: start;
}

.restaurant-card {
    min-width: 0;
    padding: 10px;
    background: transparent;
    border: 1px solid transparent;
    border-radius: 17px;
    transition: background .28s ease, transform .28s ease,
                box-shadow .28s ease, border-color .28s ease;
}

.restaurant-card:hover {
    background: #fff;
    border-color: #eee8df;
    transform: translateY(-5px);
    box-shadow: 0 12px 28px rgba(0, 0, 0, .09);
}

.card-image-container {
    position: relative;
    height: 205px;
    overflow: hidden;
    background: #eee8de;
    border-radius: 13px;
}

.card-image {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform .4s ease;
}

.restaurant-card:hover .card-image {
    transform: scale(1.055);
}

.card-content {
    padding: 12px 2px 3px;
}

.card-title-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    margin-bottom: 8px;
}

.restaurant-title {
    min-width: 0;
    font-size: 16px;
    font-weight: 650;
    line-height: 1.4;
    color: #242824;
    overflow-wrap: anywhere;
}

.rating-badge {
    flex-shrink: 0;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
    padding: 4px 7px;
    background: #176c3b;
    color: #fff;
    border-radius: 5px;
    font-size: 11px;
    font-weight: 800;
    white-space: nowrap;
}

.rating-badge i {
    font-size: 9px;
}

.cuisine-type {
    color: #777d77;
    font-size: 13px;
    line-height: 1.5;
    margin-bottom: 8px;
    overflow-wrap: anywhere;
}

.card-location {
    display: flex;
    align-items: flex-start;
    gap: 7px;
    color: #858981;
    font-size: 12px;
    line-height: 1.6;
    margin-bottom: 11px;
}

.card-location i {
    flex-shrink: 0;
    margin-top: 3px;
    color: #92968e;
}

.card-location span {
    min-width: 0;
    overflow-wrap: anywhere;
}

.card-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    padding-top: 10px;
    border-top: 1px solid #f0eee9;
    font-size: 12px;
}

.availability {
    min-width: 0;
    display: inline-flex;
    align-items: center;
    gap: 6px;
    overflow-wrap: anywhere;
    line-height: 1.5;
}

.availability::before {
    content: "";
    width: 7px;
    height: 7px;
    flex-shrink: 0;
    border-radius: 50%;
}

.availability.available {
    color: #65766a;
}

.availability.available::before {
    background: #76a886;
}

.availability.unavailable {
    color: #858585;
}

.availability.unavailable::before {
    background: #b3b3b3;
}

.delivery-time {
    flex-shrink: 0;
    display: inline-flex;
    align-items: center;
    gap: 5px;
    color: #696d67;
    white-space: nowrap;
}

.delivery-time i {
    color: #858981;
}

.btn-view-menu {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    width: 100%;
    margin-top: 13px;
    padding: 11px;
    background: var(--green);
    color: white;
    border: 1px solid var(--green);
    border-radius: 8px;
    font-size: 13px;
    font-weight: 700;
    transition: background .2s, border-color .2s;
}

.btn-view-menu:hover {
    background: var(--green-hover);
    border-color: var(--green-hover);
}

.btn-view-menu.disabled {
    background: #f0f0ed;
    color: #777b74;
    border-color: #f0f0ed;
    cursor: not-allowed;
}

/* EMPTY RESULTS */

.no-results {
    grid-column: 1 / -1;
    padding: 45px 20px;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 13px;
    text-align: center;
}

.no-results > i {
    font-size: 30px;
    color: var(--green);
    margin-bottom: 14px;
}

.no-results h3 {
    font-size: 20px;
    margin-bottom: 8px;
}

.no-results p {
    color: var(--muted);
    font-size: 14px;
    line-height: 1.6;
}

/* FOOTER */

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

    .restaurant-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .cuisine-circles {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 22px;
    }

    .search-layout {
        grid-template-columns: 1fr;
        gap: 16px;
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

    .hero {
        min-height: 330px;
        background-position: center;
    }

    .hero-inner {
        max-width: 92%;
        padding: 38px 0 55px;
    }

    .hero h1 {
        font-size: 40px;
    }

    .search-panel {
        margin-top: -24px;
        padding: 19px 15px;
    }

    .search-form {
        flex-wrap: wrap;
    }

    .search-field {
        flex-basis: 100%;
        min-height: 45px;
    }

    .search-button {
        width: 100%;
        min-height: 44px;
    }

    .cuisine-circles {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 19px 10px;
    }

    .cuisine-image {
        width: min(100%, 100px);
    }

    .cuisine-item {
        font-size: 13px;
    }

    .restaurant-grid {
        grid-template-columns: 1fr;
        gap: 18px;
    }

    .card-image-container {
        height: 225px;
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
        <a href="<%= contextPath %>/home.jsp" class="nav-action">
            <i class="fa-solid fa-house"></i>
            Home
        </a>

        <a href="#restaurants" class="nav-action">
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

<!-- HERO -->

<section class="hero">
    <div class="hero-inner">
        <div class="hero-copy">
            <p class="hero-eyebrow">Good food, good moments</p>

            <h1>
                Good Food,<br>
                Right When<br>
                You <span>Want It.</span>
            </h1>

            <p class="hero-description">
                Your favourite meals, prepared by restaurants
                around you and delivered to your doorstep.
            </p>
        </div>
    </div>
</section>

<!-- SEARCH -->

<div class="page-container">
    <section class="search-panel">
        <div class="search-layout">
            <div>
                <h2 class="search-title">
                    Find Restaurants<br>
                    <span>Near You</span>
                </h2>

                <p class="section-caption">
                    Discover delicious food from your favourite
                    local restaurants.
                </p>
            </div>

            <form class="search-form"
                  action="<%= contextPath %>/restaurant#restaurants"
                  method="get">

                <div class="search-field">
                    <i class="fa-solid fa-magnifying-glass"></i>

                    <input type="search"
                           name="search"
                           value="<%= escapeHtml(search) %>"
                           placeholder="Search restaurants, food or cuisine..."
                           aria-label="Search restaurants or cuisine">
                </div>

                <% if (!"all".equals(cuisineLower)) { %>
                    <input type="hidden"
                           name="cuisine"
                           value="<%= escapeHtml(cuisineFilter) %>">
                <% } %>

                <button type="submit" class="search-button">
                    Search
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        </div>
    </section>
</div>

<!-- CUISINES -->

<section class="cuisine-section page-container" id="cuisines">
    <h2 class="section-heading">
        Explore <span>Cuisines</span>
    </h2>

    <p class="section-caption">
        Pick your craving and discover matching restaurants.
    </p>

    <div class="cuisine-circles">
        <a class="cuisine-item <%= "all".equals(cuisineLower) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=all#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine1.jpg"
                     alt="All cuisines" loading="lazy">
            </span>
            <span>All</span>
        </a>

        <a class="cuisine-item <%= "pizza".equals(cuisineLower) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=pizza#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine2.jpg"
                     alt="Pizza" loading="lazy">
            </span>
            <span>Pizza</span>
        </a>

        <a class="cuisine-item <%= "burger".equals(cuisineLower) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=burger#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine3.jpg"
                     alt="Burger" loading="lazy">
            </span>
            <span>Burger</span>
        </a>

        <a class="cuisine-item <%= "south indian".equals(cuisineLower) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=south%20indian#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine4.jpg"
                     alt="South Indian" loading="lazy">
            </span>
            <span>South Indian</span>
        </a>

        <a class="cuisine-item <%= "chicken".equals(cuisineLower) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=chicken#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine5.jpg"
                     alt="Chicken" loading="lazy">
            </span>
            <span>Chicken</span>
        </a>

        <a class="cuisine-item <%= ("biryani".equals(cuisineLower) || "biriyani".equals(cuisineLower)) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=biryani#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine6.jpg"
                     alt="Biryani" loading="lazy">
            </span>
            <span>Biryani</span>
        </a>

        <!-- ADDED: DESSERT CUISINE -->
        <a class="cuisine-item <%= "dessert".equals(cuisineLower) || "desserts".equals(cuisineLower) ? "active" : "" %>"
           href="<%= contextPath %>/restaurant?cuisine=dessert#restaurants">
            <span class="cuisine-image">
                <img src="<%= contextPath %>/images/cusine7.jpg"
                     alt="Dessert" loading="lazy">
            </span>
            <span>Dessert</span>
        </a>
    </div>
</section>

<!-- RESTAURANTS -->

<section class="restaurant-section page-container" id="restaurants">
    <div class="section-top">
        <h2 class="section-heading">
            Restaurants <span>Near You</span>
        </h2>

        <p class="section-caption">
            Discover your next favourite meal.
        </p>
    </div>

    <div class="restaurant-grid">

    <%
        if (restaurants != null && !restaurants.isEmpty()) {
            for (Restaurant restaurant : restaurants) {

                String name = restaurant.getName() == null
                        ? "" : restaurant.getName();

                String cuisine = restaurant.getCuisineType() == null
                        ? "" : restaurant.getCuisineType();

                String address = restaurant.getAddress() == null
                        ? "" : restaurant.getAddress();

                String image = restaurant.getImagePath() == null
                        ? "" : restaurant.getImagePath();

                String deliveryTime = restaurant.getDeliveryTime() == null
                        ? "" : restaurant.getDeliveryTime();

                String nameLower = name.toLowerCase();
                String restaurantCuisineLower = cuisine.toLowerCase();

                String searchableText = (
                        name + " " + cuisine + " " + address
                ).toLowerCase()
                 .replaceAll("\\s+", " ")
                 .trim();

                boolean matchesSearch = true;

                if (!searchLower.isEmpty()) {
                    String[] searchWords = searchLower
                            .replaceAll("[^a-z0-9]+", " ")
                            .trim()
                            .split("\\s+");

                    for (String word : searchWords) {
                        if (word.isEmpty()) {
                            continue;
                        }

                        if (!fuzzyWordMatch(word, searchableText)) {
                            matchesSearch = false;
                            break;
                        }
                    }
                }

                boolean matchesCuisine;

                if ("all".equals(cuisineLower)) {
                    matchesCuisine = true;
                } else {
                    String normalizedFilter = cuisineLower
                            .replace("-", " ")
                            .trim();

                    if ("biriyani".equals(normalizedFilter)
                            || "biryani".equals(normalizedFilter)) {
                        normalizedFilter = "biryani";
                    }

                    if ("south indian".equals(normalizedFilter)) {
                        matchesCuisine =
                                nameLower.contains("south indian")
                                || restaurantCuisineLower.contains("south indian")
                                || restaurantCuisineLower.contains("south-indian");
                    } else if ("biryani".equals(normalizedFilter)) {
                        matchesCuisine =
                                nameLower.contains("biryani")
                                || nameLower.contains("biriyani")
                                || restaurantCuisineLower.contains("biryani")
                                || restaurantCuisineLower.contains("biriyani");
                    } else {
                        matchesCuisine =
                                fuzzyWordMatch(normalizedFilter, nameLower)
                                || fuzzyWordMatch(normalizedFilter,
                                                  restaurantCuisineLower);
                    }
                }

                if (!matchesSearch || !matchesCuisine) {
                    continue;
                }

                visibleCount++;

                String rating = String.valueOf(restaurant.getRating());

                String cardImage = image.trim();

                if (!cardImage.isEmpty()
                        && !cardImage.startsWith("http://")
                        && !cardImage.startsWith("https://")
                        && !cardImage.startsWith("/")) {

                    if (cardImage.startsWith("images/")) {
                        cardImage = contextPath + "/" + cardImage;
                    } else {
                        cardImage = contextPath + "/images/" + cardImage;
                    }

                } else if (cardImage.startsWith("/images/")) {
                    cardImage = contextPath + cardImage;
                }

                String safeName = escapeHtml(name);
                String safeCuisine = escapeHtml(cuisine);
                String safeAddress = escapeHtml(address);
                String safeDeliveryTime = escapeHtml(deliveryTime);
    %>

        <article class="restaurant-card">
            <div class="card-image-container">
                <% if (!cardImage.isEmpty()) { %>
                    <img src="<%= escapeHtml(cardImage) %>"
                         alt="<%= safeName %>"
                         class="card-image"
                         loading="lazy">
                <% } else { %>
                    <img src="<%= contextPath %>/images/biriyani.jpg"
                         alt="<%= safeName %>"
                         class="card-image"
                         loading="lazy">
                <% } %>
            </div>

            <div class="card-content">
                <div class="card-title-row">
                    <h3 class="restaurant-title"><%= safeName %></h3>

                    <span class="rating-badge">
                        <%= escapeHtml(rating) %>
                        <i class="fa-solid fa-star"></i>
                    </span>
                </div>

                <p class="cuisine-type"><%= safeCuisine %></p>

                <div class="card-location">
                    <i class="fa-solid fa-location-dot"></i>
                    <span><%= safeAddress %></span>
                </div>

                <div class="card-bottom">
                    <span class="availability <%= restaurant.isActive()
                            ? "available" : "unavailable" %>">
                        <%= restaurant.isActive()
                                ? "Available now"
                                : "Currently unavailable" %>
                    </span>

                    <span class="delivery-time">
                        <i class="fa-regular fa-clock"></i>
                        <%= safeDeliveryTime %>
                    </span>
                </div>

                <% if (restaurant.isActive()) { %>
                    <a href="<%= contextPath %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
                       class="btn-view-menu">
                        View Menu
                        <i class="fa-solid fa-arrow-right"></i>
                    </a>
                <% } else { %>
                    <span class="btn-view-menu disabled">
                        Currently Unavailable
                    </span>
                <% } %>
            </div>
        </article>

    <%
            }
        }

        if (visibleCount == 0) {
    %>

        <div class="no-results">
            <i class="fa-solid fa-utensils"></i>

            <h3>No restaurants found</h3>

            <p>
                Try a different spelling or search for a cuisine,
                such as biryani, pizza or South Indian.
            </p>

            <a href="<%= contextPath %>/restaurant"
               class="btn-view-menu"
               style="max-width:190px;margin:18px auto 0;">
                Show All Restaurants
            </a>
        </div>

    <%
        }
    %>

    </div>
</section>

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