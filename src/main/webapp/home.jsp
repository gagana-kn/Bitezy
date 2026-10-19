<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.tap.model.Restaurant"%>
<%@ page import="com.tap.dao.RestaurantDao"%>
<%@ page import="com.tap.daoimpl.RestaurantDaoImpl"%>

<%
String contextPath = request.getContextPath();

List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");

if (restaurants == null) {
	RestaurantDao restaurantDao = new RestaurantDaoImpl();
	restaurants = restaurantDao.getAllRestaurants();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bitezy | Delicious Food Delivered</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<style>
:root {
	--green: #174c36;
	--green-hover: #236447;
	--green-light: #edf5ef;
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
}

html {
	scroll-behavior: smooth;
	scroll-padding-top: 85px;
}

body {
	font-family: 'Poppins', sans-serif;
	color: var(--dark);
	background: var(--white);
	overflow-x: hidden;
}

a {
	color: inherit;
	text-decoration: none;
}

section {
	scroll-margin-top: 85px;
}

/* NAVBAR */
.navbar {
	min-height: 76px;
	padding: 0 6%;
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 25px;
	background: #fff;
	border-bottom: 1px solid var(--border);
	position: sticky;
	top: 0;
	z-index: 100;
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
	font-size: 24px;
	font-weight: 800;
	letter-spacing: -.8px;
}

.nav-actions {
	display: flex;
	align-items: center;
	gap: 31px;
}

.nav-action {
	display: inline-flex;
	align-items: center;
	gap: 8px;
	color: #353a35;
	font-size: 13px;
	font-weight: 500;
	transition: color .2s ease;
}

.nav-action:hover {
	color: var(--green);
}

/* HERO */
.hero {
	position: relative;
	width: 100%;
	height: calc(100vh - 76px);
	min-height: 500px;
	margin: 0;
	padding: 0;
	display: flex;
	align-items: center;
	overflow: hidden;
}

.hero video {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.hero-content {
	position: relative;
	z-index: 2;
	padding: 30px 7%;
}

.hero-overlay {
	position: absolute;
	inset: 0;
	z-index: 1;
	background: radial-gradient(ellipse at 78% 48%, rgba(241, 90, 59, .16),
		transparent 35%), linear-gradient(90deg, rgba(7, 24, 15, .93) 0%,
		rgba(7, 24, 15, .78) 38%, rgba(7, 24, 15, .34) 72%,
		rgba(7, 24, 15, .12) 100%);
}

.hero h1 {
	max-width: 720px;
	color: #fff;
	font-family: 'Playfair Display', Georgia, serif;
	font-size: clamp(46px, 6vw, 78px);
	line-height: 1.08;
	font-weight: 800;
	letter-spacing: -1.5px;
	margin-bottom: 23px;
}

.hero h1 span {
	color: #fff;
}

.hero p {
	max-width: 520px;
	color: rgba(255, 255, 255, .9);
	font-size: 16px;
	line-height: 1.9;
	margin-bottom: 32px;
}

.hero-eyebrow {
	display: inline-flex;
	align-items: center;
	gap: 9px;
	margin-bottom: 22px;
	padding: 10px 14px;
	border: 1px solid rgba(242, 199, 139, .42);
	border-radius: 999px;
	background: rgba(255, 255, 255, .08);
	color: #f2c78b;
	font-size: 11px;
	font-weight: 700;
	letter-spacing: 1.8px;
	backdrop-filter: blur(8px);
}

.hero-eyebrow i {
	font-size: 12px;
}

.hero-actions {
	display: flex;
	align-items: center;
	flex-wrap: wrap;
	gap: 22px;
}

.primary-btn {
	min-height: 52px;
	padding: 14px 25px;
	display: inline-flex;
	justify-content: center;
	align-items: center;
	gap: 12px;
	border: 1px solid var(--green);
	border-radius: 8px;
	background: var(--green);
	color: #fff;
	font-size: 14px;
	font-weight: 600;
	transition: transform .2s ease, background .2s ease;
}

.primary-btn:hover {
	background: var(--green-hover);
	border-color: var(--green-hover);
	color: #fff;
	transform: translateY(-2px);
}

.hero .primary-btn {
	background: #fff;
	color: var(--green);
	border-color: #fff;
}

.hero .primary-btn:hover {
	background: #f2c78b;
	border-color: #f2c78b;
	color: var(--green);
}

.primary-btn i {
	font-size: 14px;
}

.hero-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    padding: 14px 25px;
    margin-top: 25px;
    background: #f3f5f2;
    color: #174c36;
    border: 1px solid #f3f5f2;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 700;
    text-decoration: none;
    box-shadow: none;
    transition: none;
}

.hero-btn:hover,
.hero-btn:focus,
.hero-btn:active {
    background: #f3f5f2;
    color: #174c36;
    border-color: #f3f5f2;
    box-shadow: none;
    transform: none;
}

.hero-btn i {
    display: inline-block;
    color: #174c36;
    font-size: 14px;
}

/* COMMON SECTIONS */
.section-label {
	display: inline-block;
	margin-bottom: 11px;
	color: var(--green);
	font-size: 11px;
	font-weight: 700;
	letter-spacing: 1.7px;
	text-transform: uppercase;
}

.section-heading {
	text-align: center;
	max-width: 690px;
	margin: 0 auto 40px;
}

.section-heading h2 {
	color: #202720;
	font-family: 'Playfair Display', Georgia, serif;
	font-size: clamp(29px, 3.5vw, 41px);
	line-height: 1.3;
	letter-spacing: -.6px;
	margin-bottom: 13px;
}

.section-heading p {
	color: var(--muted);
	font-size: 13px;
	line-height: 1.9;
}

/* ABOUT */
.about-section {
	padding: 85px 7%;
	background: #fff;
}

.about-container {
	max-width: 1180px;
	margin: auto;
	display: grid;
	grid-template-columns: 1fr 1fr;
	align-items: center;
	gap: 65px;
}

.about-image-wrap {
	width: 100%;
	height: 400px;
	overflow: hidden;
	border-radius: 17px;
	background: #f4f2ec;
}

.about-image {
	width: 100%;
	height: 100%;
	object-fit: cover;
	display: block;
	transition: transform .4s ease;
}

.about-image-wrap:hover .about-image {
	transform: scale(1.035);
}

.about-content h2 {
	color: #202720;
	font-family: 'Playfair Display', Georgia, serif;
	font-size: clamp(30px, 3.3vw, 42px);
	line-height: 1.3;
	letter-spacing: -.6px;
	margin-bottom: 20px;
}

.about-content p {
	color: #777d76;
	font-size: 13px;
	line-height: 2;
	margin-bottom: 15px;
}

.about-points {
	display: grid;
	gap: 13px;
	margin-top: 23px;
}

.about-point {
	display: flex;
	align-items: center;
	gap: 12px;
	font-size: 13px;
	font-weight: 500;
}

.about-point i {
	width: 28px;
	height: 28px;
	display: grid;
	place-items: center;
	flex-shrink: 0;
	background: #eaf3ed;
	color: var(--green);
	border-radius: 50%;
	font-size: 12px;
}

/* RESTAURANTS */
.restaurant-section {
	padding: 80px 7% 85px;
	background: #fff;
}

.restaurant-heading-row {
	max-width: 1200px;
	margin: 0 auto 32px;
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	gap: 25px;
}

.restaurant-heading-row .section-heading {
	margin: 0;
	flex: 1;
	text-align: left;
}

.restaurant-heading-row .section-heading h2, .restaurant-heading-row .section-heading p
	{
	text-align: left;
}

.all-restaurants-link {
	flex-shrink: 0;
	display: inline-flex;
	align-items: center;
	gap: 9px;
	margin-bottom: 43px;
	color: var(--green);
	font-size: 13px;
	font-weight: 600;
	transition: gap .2s ease, color .2s ease;
}

.all-restaurants-link:hover {
	gap: 13px;
	color: var(--green-hover);
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
	transition: background .28s ease, transform .28s ease, box-shadow .28s
		ease, border-color .28s ease;
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
	overflow-wrap: anywhere;
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

.no-restaurants {
	grid-column: 1/-1;
	padding: 40px 20px;
	text-align: center;
	background: #fff;
	border: 1px dashed #d8ded7;
	border-radius: 12px;
	color: var(--muted);
	font-size: 13px;
	line-height: 1.8;
}

.no-restaurants i {
	display: block;
	margin-bottom: 12px;
	color: var(--green);
	font-size: 28px;
}

/* HOW IT WORKS */
.how-section {
	padding: 80px 7% 90px;
	background: #fff;
}

.steps-grid {
	max-width: 1100px;
	margin: auto;
	display: grid;
	grid-template-columns: repeat(3, minmax(0, 1fr));
	gap: 25px;
}

.step-card {
	padding: 32px 24px;
	text-align: center;
	background: #fff;
	border: 1px solid #eee8df;
	border-radius: 13px;
	transition: transform .25s ease, border-color .25s ease, box-shadow .25s
		ease;
}

.step-card:hover {
	transform: translateY(-5px);
	border-color: #dce9de;
	box-shadow: 0 10px 25px rgba(23, 76, 54, .08);
}

.step-icon {
	width: 64px;
	height: 64px;
	margin: 0 auto 20px;
	display: grid;
	place-items: center;
	background: #edf4ee;
	color: var(--green);
	border-radius: 15px;
	font-size: 24px;
	transition: background .25s ease, color .25s ease;
}

.step-card:hover .step-icon {
	background: var(--green);
	color: #fff;
}

.step-number {
	color: #8b9b8e;
	font-size: 10px;
	font-weight: 700;
	letter-spacing: 1.5px;
	margin-bottom: 9px;
}

.step-card h3 {
	color: #263329;
	font-size: 16px;
	margin-bottom: 10px;
}

.step-card p {
	color: #7b817b;
	font-size: 12px;
	line-height: 1.9;
}

/* FOOTER */
footer {
	background: #103e2e;
	color: #fff;
	padding: 45px 7% 20px;
}

.footer-container {
	max-width: 1150px;
	margin: auto;
	display: grid;
	grid-template-columns: 1.5fr 1fr 1fr 1fr;
	gap: 35px;
}

.footer-logo {
	display: inline-flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 15px;
}

.footer-logo .logo-box {
	background: #fff;
	color: var(--green);
}

.footer-logo .logo-name {
	color: #fff;
	font-size: 22px;
}

.footer-brand p {
	max-width: 260px;
	color: #d7e2da;
	font-size: 12px;
	line-height: 1.9;
}

.footer-column h3 {
	margin-bottom: 17px;
	font-size: 13px;
	font-weight: 600;
}

.footer-column a {
	display: block;
	margin-bottom: 12px;
	color: #d7e2da;
	font-size: 12px;
	transition: color .2s ease;
}

.footer-column a:hover {
	color: #f2c78b;
}

.copyright {
	max-width: 1150px;
	margin: 32px auto 0;
	padding-top: 19px;
	border-top: 1px solid #ffffff2a;
	color: #c8d7cd;
	text-align: center;
	font-size: 11px;
}

/* RESPONSIVE */
@media ( max-width : 1000px) {
	.navbar {
		padding: 0 4%;
	}
	.nav-actions {
		gap: 20px;
	}
	.hero {
		height: 540px;
	}
	.about-section, .restaurant-section, .how-section {
		padding-left: 5%;
		padding-right: 5%;
	}
	.about-container {
		gap: 38px;
	}
	.about-image-wrap {
		height: 340px;
	}
	.restaurant-grid {
		gap: 17px;
	}
	.card-image-container {
		height: 180px;
	}
	.card-content {
		padding: 15px;
	}
	.restaurant-title {
		font-size: 15px;
	}
	.btn-view-menu {
		padding: 10px;
		font-size: 10px;
	}
	.footer-container {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

@media ( max-width : 650px) {
	.navbar {
		min-height: 70px;
		padding: 12px 5%;
		align-items: flex-start;
		flex-direction: column;
		gap: 13px;
	}
	.logo-box {
		width: 36px;
		height: 36px;
		border-radius: 10px;
		font-size: 17px;
	}
	.logo-name {
		font-size: 21px;
	}
	.nav-actions {
		width: 100%;
		justify-content: space-between;
		gap: 13px;
		overflow-x: auto;
		padding-bottom: 4px;
	}
	.nav-action {
		flex-shrink: 0;
		font-size: 11px;
		white-space: nowrap;
	}
	.hero {
		height: 500px;
		min-height: 450px;
	}
	.hero-overlay {
		background: linear-gradient(90deg, rgba(8, 24, 16, .88),
			rgba(8, 24, 16, .60));
	}
	.hero-content {
		padding: 30px 6%;
	}
	.hero h1 {
		font-size: clamp(39px, 10vw, 48px);
		letter-spacing: -.7px;
	}
	.hero p {
		font-size: 13px;
		line-height: 1.9;
	}
	.primary-btn {
		min-height: 50px;
		padding: 13px 18px;
		font-size: 13px;
	}
	.about-section, .restaurant-section, .how-section {
		padding: 58px 5%;
	}
	.section-heading {
		margin-bottom: 29px;
	}
	.restaurant-heading-row {
		align-items: flex-start;
		flex-direction: column;
		gap: 10px;
	}
	.restaurant-heading-row .section-heading {
		width: 100%;
	}
	.all-restaurants-link {
		margin-bottom: 13px;
	}
	.restaurant-grid {
		grid-template-columns: 1fr;
		max-width: 430px;
	}
	.card-image-container {
		height: 220px;
	}
	.card-content {
		padding: 18px;
	}
	.restaurant-title {
		font-size: 17px;
	}
	.btn-view-menu {
		padding: 11px 13px;
		font-size: 11px;
	}
	.about-container {
		grid-template-columns: 1fr;
		gap: 28px;
	}
	.about-image-wrap {
		height: 270px;
	}
	.about-content h2 {
		font-size: 32px;
	}
	.steps-grid {
		grid-template-columns: 1fr;
		max-width: 430px;
	}
	.step-card {
		padding: 28px 22px;
	}
	.footer-container {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 28px 18px;
	}
	.footer-brand {
		grid-column: 1/-1;
	}
	footer {
		padding: 36px 6% 20px;
	}
}

@media ( max-width : 360px) {
	.nav-actions {
		gap: 11px;
	}
	.nav-action {
		font-size: 10px;
	}
	.card-bottom {
		align-items: flex-start;
	}
	.btn-view-menu {
		gap: 5px;
		padding: 10px 8px;
		font-size: 10px;
	}
	.footer-container {
		gap: 24px 12px;
	}
}

@media ( prefers-reduced-motion : reduce) {
	html {
		scroll-behavior: auto;
	}
	*, *::before, *::after {
		transition-duration: .01ms !important;
		animation-duration: .01ms !important;
		animation-iteration-count: 1 !important;
	}
}

/* Final responsive refinements */
@media ( max-width : 900px) {
	.restaurant-grid {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 18px;
	}
	.card-content {
		padding: 12px 2px 3px;
	}
	.restaurant-title {
		font-size: 16px;
	}
	.btn-view-menu {
		padding: 11px;
		font-size: 13px;
	}
	.hero {
		min-height: 500px;
	}
}

@media ( max-width : 560px) {
	.restaurant-grid {
		grid-template-columns: 1fr;
		max-width: 100%;
		gap: 18px;
	}
	.card-image-container {
		height: 225px;
	}
	.card-content {
		padding: 12px 2px 3px;
	}
	.restaurant-title {
		font-size: 16px;
	}
	.btn-view-menu {
		padding: 11px;
		font-size: 13px;
	}
	.hero {
		min-height: 460px;
	}
	.hero-content {
		padding: 55px 6% 65px;
	}
	.hero-actions {
		align-items: flex-start;
		flex-direction: column;
		gap: 16px;
	}
	@media ( max-width : 650px) {
		.hero {
			height: calc(100vh - 105px);
			min-height: 450px;
		}
		.hero-content {
			padding: 30px 6%;
		}
	}
}
</style>
</head>

<body>

	<header class="navbar">
		<a href="<%=contextPath%>/home" class="logo-container"> <span
			class="logo-box">B</span> <span class="logo-name">Bitezy</span>
		</a>

		<nav class="nav-actions">
			<a href="<%=contextPath%>/home#home" class="nav-action"> <i
				class="fa-solid fa-house"></i> Home
			</a> <a href="<%=contextPath%>/home#about" class="nav-action">About
				Us</a> <a href="#restaurants" class="nav-action">Explore</a> <a
				href="<%=contextPath%>/home#contact" class="nav-action">Contact
				Us</a>
		</nav>
	</header>

	<section class="hero" id="home">
		<video class="hero-video" autoplay muted loop playsinline
			poster="<%=contextPath%>/images/hero-food.png">
			<source src="<%=contextPath%>/videos/food-hero.mp4" type="video/mp4">
		</video>

		<div class="hero-overlay"></div>

		<div class="hero-content">
			<h1>
				Good Food,<br> Great <span>Moments.</span>
			</h1>

			<p>Discover your favourite restaurants and enjoy delicious meals
				delivered fresh to your doorstep. Your next favourite meal is just a
				few clicks away.</p>

			<div class="hero-actions">
				<a href="<%=request.getContextPath()%>/restaurant"
					class="hero-btn"> Explore Restaurants <i
					class="fa-solid fa-arrow-right"></i>
				</a>
			</div>
		</div>
	</section>

	<section class="about-section" id="about">
		<div class="about-container">
			<div class="about-image-wrap">
				<img src="<%=contextPath%>/images/about-food.png"
					alt="Freshly prepared delicious food" class="about-image"
					loading="lazy">
			</div>

			<div class="about-content">
				<span class="section-label">ABOUT BITEZY</span>
				<h2>Bringing Your Favourite Food Closer</h2>

				<p>At Bitezy, we believe that great food brings people together.
					We make it easy to discover delicious meals from restaurants around
					you.</p>

				<p>From comforting everyday favourites to exciting new flavours,
					we help you find something delicious whenever hunger strikes.</p>

				<div class="about-points">
					<div class="about-point">
						<i class="fa-solid fa-check"></i> Discover restaurants you love
					</div>

					<div class="about-point">
						<i class="fa-solid fa-check"></i> Explore menus with ease
					</div>

					<div class="about-point">
						<i class="fa-solid fa-check"></i> Enjoy a simple ordering
						experience
					</div>
				</div>
			</div>
		</div>
	</section>

	<section class="restaurant-section" id="restaurants">
		<div class="restaurant-heading-row">
			<div class="section-heading">
				<span class="section-label">EXPLORE BITEZY</span>
				<h2>Famous Restaurants</h2>

				<p>Discover great food from restaurants you'll love. Choose your
					favourite and find your next delicious meal.</p>
			</div>

			<a href="<%=contextPath%>/restaurant" class="all-restaurants-link">
				All Restaurants <i class="fa-solid fa-arrow-right"></i>
			</a>
		</div>

		<div class="restaurant-grid">
			<%
			int displayedRestaurants = 0;

			if (restaurants != null) {
				for (Restaurant restaurant : restaurants) {
					if (restaurant == null || !restaurant.isActive()) {
				continue;
					}

					if (displayedRestaurants >= 3) {
				break;
					}

					String imagePath = restaurant.getImagePath();

					if (imagePath == null || imagePath.trim().isEmpty()) {
				imagePath = contextPath + "/images/restaurant-placeholder.png";
					} else if (imagePath.startsWith("http://") || imagePath.startsWith("https://")) {
					} else if (imagePath.startsWith("/images/")) {
				imagePath = contextPath + imagePath;
					} else if (imagePath.startsWith("images/")) {
				imagePath = contextPath + "/" + imagePath;
					} else if (imagePath.startsWith("/")) {
				imagePath = contextPath + imagePath;
					} else {
				imagePath = contextPath + "/images/" + imagePath;
					}

					displayedRestaurants++;
			%>

			<article class="restaurant-card">
				<div class="card-image-container">
					<img src="<%=imagePath%>" alt="<%=restaurant.getName()%>"
						class="card-image" loading="lazy"
						onerror="this.onerror=null;this.src='<%=contextPath%>/images/restaurant-placeholder.png';">
				</div>

				<div class="card-content">
					<div class="card-title-row">
						<h3 class="restaurant-title"><%=restaurant.getName()%></h3>

						<span class="rating-badge"> <%=restaurant.getRating()%> <i
							class="fa-solid fa-star"></i>
						</span>
					</div>

					<p class="cuisine-type"><%=restaurant.getCuisineType()%></p>

					<div class="card-location">
						<i class="fa-solid fa-location-dot"></i> <span><%=restaurant.getAddress()%></span>
					</div>

					<div class="card-bottom">
						<span
							class="availability <%=restaurant.isActive() ? "available" : "unavailable"%>">
							<%=restaurant.isActive() ? "Available now" : "Currently unavailable"%>
						</span> <span class="delivery-time"> <i
							class="fa-regular fa-clock"></i> <%=restaurant.getDeliveryTime()%>
						</span>
					</div>

					<a class="btn-view-menu"
						href="<%=contextPath%>/menu?restaurantId=<%=restaurant.getRestaurantId()%>">
						View Menu <i class="fa-solid fa-arrow-right"></i>
					</a>
				</div>
			</article>

			<%
			}
			}

			if (displayedRestaurants == 0) {
			%>

			<div class="no-restaurants">
				<i class="fa-solid fa-utensils"></i> <strong>No restaurants
					to display right now.</strong>
				<p>Please check that active restaurants are available.</p>
			</div>

			<%
			}
			%>
		</div>
	</section>

	<section class="how-section" id="how-it-works">
		<div class="section-heading">
			<span class="section-label">SIMPLE AND CONVENIENT</span>
			<h2>How It Works</h2>
			<p>Great food is just a few simple steps away.</p>
		</div>

		<div class="steps-grid">
			<div class="step-card">
				<div class="step-icon">
					<i class="fa-solid fa-store"></i>
				</div>

				<div class="step-number">STEP 01</div>
				<h3>Choose a Restaurant</h3>
				<p>Explore restaurants and discover the dishes that make your
					mouth water.</p>
			</div>

			<div class="step-card">
				<div class="step-icon">
					<i class="fa-solid fa-bowl-food"></i>
				</div>

				<div class="step-number">STEP 02</div>
				<h3>Select Your Food</h3>
				<p>Browse the menu and choose the food you want to enjoy.</p>
			</div>

			<div class="step-card">
				<div class="step-icon">
					<i class="fa-solid fa-heart"></i>
				</div>

				<div class="step-number">STEP 03</div>
				<h3>Enjoy Your Meal</h3>
				<p>Complete your order and look forward to a delicious meal.</p>
			</div>
		</div>
	</section>

	<footer id="contact">
		<div class="footer-container">
			<div class="footer-brand">
				<a href="<%=contextPath%>/home" class="footer-logo"> <span
					class="logo-box">B</span> <span class="logo-name">Bitezy</span>
				</a>

				<p>Delicious food from your favourite restaurants, delivered
					fresh to your doorstep.</p>
			</div>

			<div class="footer-column">
				<h3>Company</h3>
				<a href="<%=contextPath%>/home#about">About Us</a> <a
					href="<%=contextPath%>/home#how-it-works">How It Works</a> <a
					href="<%=contextPath%>/home#contact">Contact</a>
			</div>

			<div class="footer-column">
				<h3>Support</h3>
				<a href="<%=contextPath%>/home#contact">Help Center</a> <a
					href="<%=contextPath%>/home#contact">FAQs</a> <a
					href="<%=contextPath%>/home#contact">Delivery Support</a>
			</div>

			<div class="footer-column">
				<h3>Legal</h3>
				<a href="<%=contextPath%>/home#contact">Privacy Policy</a> <a
					href="<%=contextPath%>/home#contact">Terms &amp; Conditions</a>
			</div>
		</div>

		<div class="copyright">&copy; 2026 Bitezy. All rights reserved.
		</div>
	</footer>

</body>
</html>