<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.tap.model.Cart"%>
<%@ page import="com.tap.model.CartItem"%>
<%@ page import="com.tap.model.User"%>

<%!private String escapeHtml(String value) {
		if (value == null) {
			return "";
		}
		return value.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;")
				.replace("'", "&#39;");
	}

	private String money(double amount) {
		return String.format(java.util.Locale.US, "%.2f", amount);
	}%>

<%
String contextPath = request.getContextPath();
User user = (User) session.getAttribute("user");

if (user == null) {
	response.sendRedirect(contextPath + "/login?redirect=checkout");
	return;
}

Cart cart = (Cart) request.getAttribute("cart");
if (cart == null) {
	cart = (Cart) session.getAttribute("cart");
}

String fullName = request.getParameter("fullName") != null
		? request.getParameter("fullName")
		: (user.getUsername() == null ? "" : user.getUsername());

String phone = request.getParameter("phone") != null
		? request.getParameter("phone")
		: (user.getPhone() == null ? "" : user.getPhone());

String address = request.getParameter("address") != null
		? request.getParameter("address")
		: (user.getAddress() == null ? "" : user.getAddress());

String pinCode = request.getParameter("pinCode") == null
		? ""
		: request.getParameter("pinCode");

String paymentMode = request.getParameter("paymentMode");
String selectedPayment = paymentMode == null ? "" : paymentMode;
String error = request.getAttribute("error") == null
		? ""
		: request.getAttribute("error").toString();

boolean cartEmpty = cart == null
		|| cart.getItems() == null
		|| cart.getItems().isEmpty();

int cartItemCount = 0;
double orderTotal = 0.0;

if (!cartEmpty) {
	for (CartItem cartItem : cart.getItems().values()) {
		if (cartItem != null) {
			cartItemCount += cartItem.getQuantity();
		}
	}

	orderTotal = cart.getTotal();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Checkout | Bitezy</title>

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
:root {
	--green: #174c36;
	--green-hover: #236447;
	--dark: #222522;
	--muted: #858780;
	--border: #eee8df;
	--soft-green: #f3f7f3;
	--footer-green: #103e2e;
	--coral: #f15a3b;
}

* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
	font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
		Arial, sans-serif;
}

html {
	scroll-behavior: smooth;
	scroll-padding-top: 90px;
}

body {
	min-height: 100vh;
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

button, input, textarea {
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
	white-space: nowrap;
	transition: color .2s;
}

.nav-action:hover, .nav-action:focus-visible {
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
	background: var(--soft-green);
	color: var(--green);
}

/* CHECKOUT LAYOUT */
.checkout-container {
	flex: 1;
	width: 86%;
	max-width: 1120px;
	margin: 42px auto 65px;
	min-width: 0;
}

.breadcrumb {
	display: flex;
	align-items: center;
	gap: 9px;
	margin-bottom: 24px;
	color: var(--muted);
	font-size: 12px;
}

.breadcrumb a:hover {
	color: var(--green);
}

.breadcrumb i {
	font-size: 9px;
}

.page-heading {
	margin-bottom: 27px;
}

.page-heading .eyebrow {
	margin-bottom: 9px;
	color: var(--green);
	font-size: 11px;
	font-weight: 800;
	letter-spacing: 1.6px;
	text-transform: uppercase;
}

.page-heading h1 {
	margin-bottom: 9px;
	font-family: Georgia, "Times New Roman", serif;
	font-size: clamp(30px, 3.5vw, 39px);
	line-height: 1.2;
	font-weight: 600;
	letter-spacing: -.6px;
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

.checkout-layout {
	display: grid;
	grid-template-columns: minmax(0, 1.35fr) minmax(300px, .85fr);
	gap: 23px;
	align-items: start;
}

.checkout-left, .checkout-right {
	min-width: 0;
}

.checkout-section {
	min-width: 0;
	padding: 25px;
	margin-bottom: 20px;
	background: #fff;
	border: 1px solid var(--border);
	border-radius: 14px;
	box-shadow: 0 4px 18px rgba(38, 42, 35, .035);
}

.section-heading {
	display: flex;
	align-items: center;
	gap: 12px;
	margin-bottom: 23px;
}

.section-number {
	width: 36px;
	height: 36px;
	flex-shrink: 0;
	display: grid;
	place-items: center;
	border-radius: 9px;
	background: var(--soft-green);
	color: var(--green);
	font-size: 14px;
	font-weight: 800;
}

.section-heading h2 {
	font-size: 18px;
	line-height: 1.4;
}

.section-heading p {
	margin-top: 4px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.5;
}

.form-grid {
	display: grid;
	grid-template-columns: repeat(2, minmax(0, 1fr));
	gap: 18px 16px;
}

.form-group {
	min-width: 0;
}

.form-group.full-width {
	grid-column: 1/-1;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	color: #353a35;
	font-size: 12px;
	font-weight: 700;
}

.form-group input {
	display: block;
	width: 100%;
	min-width: 0;
	height: 45px;
	padding: 0 12px;
	border: 1px solid #e2ddd5;
	border-radius: 8px;
	outline: none;
	background: #fff;
	color: var(--dark);
	font-size: 13px;
}

.form-group input::placeholder {
	color: #a2a39e;
}

.form-group input:focus {
	border-color: var(--green);
	box-shadow: 0 0 0 3px #174c3610;
}

.form-note {
	margin-top: 8px;
	color: var(--muted);
	font-size: 11px;
	line-height: 1.6;
}

/* PAYMENT */
.payment-options {
	display: grid;
	gap: 11px;
}

.payment-option {
	display: flex;
	align-items: center;
	gap: 12px;
	min-width: 0;
	padding: 14px;
	border: 1px solid #e5e1d9;
	border-radius: 9px;
	background: #fff;
	cursor: pointer;
	transition: border-color .2s, background .2s;
}

.payment-option:hover {
	border-color: #adc4b3;
}

.payment-option input {
	width: 17px;
	height: 17px;
	flex-shrink: 0;
	accent-color: var(--green);
	cursor: pointer;
}

.payment-option:has(input:checked) {
	border-color: var(--green);
	background: var(--soft-green);
}

.payment-option-text {
	min-width: 0;
}

.payment-option-text strong {
	display: block;
	margin-bottom: 5px;
	font-size: 13px;
}

.payment-option-text small {
	display: block;
	color: var(--muted);
	font-size: 11px;
	line-height: 1.5;
}

/* ORDER SUMMARY */
.checkout-right {
	position: sticky;
	top: 95px;
}

.summary-card {
	padding: 24px;
}

.summary-heading {
	margin-bottom: 7px;
	font-family: Georgia, "Times New Roman", serif;
	font-size: 23px;
	color: var(--green);
}

.summary-subtitle {
	margin-bottom: 15px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.6;
}

.item-count {
	color: var(--muted);
	font-size: 11px;
	font-weight: 600;
}

.order-item {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	gap: 12px;
	min-width: 0;
	padding: 15px 0;
	border-bottom: 1px solid #f0eee9;
}

.item-info {
	min-width: 0;
	flex: 1;
}

.item-name {
	font-size: 13px;
	font-weight: 700;
	line-height: 1.5;
	overflow-wrap: anywhere;
}

.item-details {
	margin-top: 5px;
	color: var(--muted);
	font-size: 12px;
	line-height: 1.5;
}

.item-price {
	flex-shrink: 0;
	padding-top: 2px;
	font-size: 13px;
	font-weight: 700;
	white-space: nowrap;
}

.summary-total {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 10px;
	margin-top: 20px;
	padding-top: 18px;
	border-top: 1px dashed #d9ded8;
}

.summary-total span:first-child {
	font-size: 15px;
	font-weight: 750;
}

.summary-total span:last-child {
	color: var(--green);
	font-size: 23px;
	font-weight: 800;
	white-space: nowrap;
}

.summary-note {
	margin-top: 17px;
	padding: 12px;
	border-radius: 8px;
	background: #f6f7f4;
	color: #686e67;
	font-size: 11px;
	line-height: 1.7;
}

.error-message {
	display: flex;
	gap: 10px;
	padding: 13px 15px;
	margin-bottom: 20px;
	background: #fff2ef;
	color: #a52b20;
	border: 1px solid #f2d2cb;
	border-radius: 8px;
	font-size: 13px;
	line-height: 1.6;
	overflow-wrap: anywhere;
}

.confirm-btn {
	display: flex;
	align-items: center;
	justify-content: center;
	gap: 9px;
	width: 100%;
	min-height: 47px;
	margin-top: 20px;
	padding: 12px 15px;
	border: 1px solid var(--green);
	border-radius: 8px;
	background: var(--green);
	color: #fff;
	font-size: 13px;
	font-weight: 750;
	transition: background .2s, opacity .2s;
}

.confirm-btn:hover:not(:disabled) {
	background: var(--green-hover);
	border-color: var(--green-hover);
}

.confirm-btn:disabled {
	background: #a5b5aa;
	border-color: #a5b5aa;
	color: #fff;
	cursor: not-allowed;
	opacity: .8;
}

.secure-note {
	margin-top: 12px;
	color: var(--muted);
	font-size: 11px;
	line-height: 1.6;
	text-align: center;
}

/* FOOTER */
footer {
	margin-top: auto;
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

@media (max-width: 950px) {
	.checkout-container {
		width: 92%;
	}

	.checkout-layout {
		grid-template-columns: minmax(0, 1fr) 300px;
		gap: 16px;
	}

	.checkout-section {
		padding: 20px;
	}

	.summary-card {
		padding: 19px;
	}

	.nav-actions {
		gap: 15px;
	}

	.footer-container {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}
}

@media (max-width: 800px) {
	.checkout-layout {
		grid-template-columns: minmax(0, 1fr);
	}

	.checkout-right {
		position: static;
	}
}

@media (max-width: 600px) {
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

	.checkout-container {
		width: 92%;
		margin-top: 28px;
		margin-bottom: 45px;
	}

	.checkout-section {
		padding: 19px 15px;
	}

	.form-grid {
		grid-template-columns: minmax(0, 1fr);
		gap: 17px;
	}

	.form-group.full-width {
		grid-column: auto;
	}

	.page-heading h1 {
		font-size: 30px;
	}

	.footer-container {
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 27px 20px;
	}
}

@media (max-width: 380px) {
	.nav-actions {
		gap: 9px;
	}

	.nav-action {
		font-size: 11px;
	}

	.checkout-section {
		padding: 17px 13px;
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
		<a href="<%=contextPath%>/restaurant" class="logo-container">
			<span class="logo-box">B</span>
			<span class="logo-name">Bitezy</span>
		</a>

		<nav class="nav-actions">
			<a href="<%=contextPath%>/restaurant" class="nav-action">
				<i class="fa-solid fa-house"></i> Home
			</a>

			<a href="<%=contextPath%>/restaurant#restaurants"
				class="nav-action">Restaurants</a>

			<a href="<%=contextPath%>/cart" class="nav-action">
				<i class="fa-solid fa-cart-shopping"></i> Cart
			</a>

			<a href="<%=contextPath%>/orders" class="nav-action">
				<i class="fa-solid fa-box"></i> Orders
			</a>

			<div class="profile-dropdown">
				<button type="button" class="nav-action profile-toggle">
					<i class="fa-regular fa-user"></i>
					<%=escapeHtml(user.getUsername())%>
					<i class="fa-solid fa-chevron-down"></i>
				</button>

				<div class="profile-menu">
					<a href="<%=contextPath%>/profile">My Profile</a>
					<a href="<%=contextPath%>/logout">Logout</a>
				</div>
			</div>
		</nav>
	</header>

	<main class="checkout-container">

		<div class="breadcrumb">
			<a href="<%=contextPath%>/restaurant">Home</a>
			<i class="fa-solid fa-chevron-right"></i>
			<a href="<%=contextPath%>/cart">Cart</a>
			<i class="fa-solid fa-chevron-right"></i>
			<span>Checkout</span>
		</div>

		<div class="page-heading">
			<div class="eyebrow">Almost there</div>
			<h1>Secure <span>Checkout</span></h1>
			<p>Confirm your delivery details and review your order before
				placing it.</p>
		</div>

		<%
		if (!error.isEmpty()) {
		%>
		<div class="error-message">
			<i class="fa-solid fa-circle-exclamation"></i>
			<span><%=escapeHtml(error)%></span>
		</div>
		<%
		}
		%>

		<!-- Checkout is always displayed, even if the cart is empty. -->
		<form action="<%=contextPath%>/checkout" method="post">
			<div class="checkout-layout">

				<div class="checkout-left">

					<!-- DELIVERY DETAILS -->
					<section class="checkout-section">
						<div class="section-heading">
							<div class="section-number">
								<i class="fa-solid fa-location-dot"></i>
							</div>
							<div>
								<h2>Delivery Details</h2>
								<p>Where should we deliver your order?</p>
							</div>
						</div>

						<div class="form-grid">

							<div class="form-group">
								<label for="fullName">Full Name</label>
								<input type="text"
									id="fullName"
									name="fullName"
									value="<%=escapeHtml(fullName)%>"
									maxlength="100"
									autocomplete="name"
									placeholder="Enter your full name"
									required>
							</div>

							<div class="form-group">
								<label for="phone">Phone Number</label>
								<input type="tel"
									id="phone"
									name="phone"
									value="<%=escapeHtml(phone)%>"
									pattern="[0-9]{10}"
									maxlength="10"
									inputmode="numeric"
									autocomplete="tel"
									placeholder="10-digit mobile number"
									required>
							</div>

							<div class="form-group full-width">
								<label for="address">Delivery Address</label>
								<input type="text"
									id="address"
									name="address"
									value="<%=escapeHtml(address)%>"
									maxlength="500"
									autocomplete="street-address"
									placeholder="House number, street, area"
									required>
							</div>

							<div class="form-group">
								<label for="pinCode">PIN Code</label>
								<input type="text"
									id="pinCode"
									name="pinCode"
									value="<%=escapeHtml(pinCode)%>"
									pattern="[0-9]{6}"
									maxlength="6"
									inputmode="numeric"
									autocomplete="postal-code"
									placeholder="6-digit PIN code"
									required>
							</div>

						</div>

						<p class="form-note">
							Please check your address and contact number before
							placing the order.
						</p>
					</section>

					<!-- PAYMENT METHOD -->
					<section class="checkout-section">
						<div class="section-heading">
							<div class="section-number">
								<i class="fa-solid fa-credit-card"></i>
							</div>
							<div>
								<h2>Payment Method</h2>
								<p>Select your preferred payment option.</p>
							</div>
						</div>

						<div class="payment-options">

							<label class="payment-option">
								<input type="radio"
									id="paymentCOD"
									name="paymentMode"
									value="COD"
									<%=("COD".equals(selectedPayment) || selectedPayment.isEmpty()) ? "checked" : ""%>
									required>

								<span class="payment-option-text">
									<strong>Cash on Delivery</strong>
									<small>Pay when your order arrives.</small>
								</span>
							</label>

							<label class="payment-option">
								<input type="radio"
									id="paymentUPI"
									name="paymentMode"
									value="UPI"
									<%="UPI".equals(selectedPayment) ? "checked" : ""%>
									required>

								<span class="payment-option-text">
									<strong>UPI</strong>
									<small>Online UPI processing is not enabled yet.</small>
								</span>
							</label>

							<label class="payment-option">
								<input type="radio"
									id="paymentCard"
									name="paymentMode"
									value="Card"
									<%="Card".equals(selectedPayment) ? "checked" : ""%>
									required>

								<span class="payment-option-text">
									<strong>Credit / Debit Card</strong>
									<small>Online card processing is not enabled yet.</small>
								</span>
							</label>

						</div>
					</section>

				</div>

				<!-- ORDER SUMMARY -->
				<aside class="checkout-right">
					<section class="checkout-section summary-card">

						<h2 class="summary-heading">Order Summary</h2>

						<p class="summary-subtitle">
							Review your items before placing your order.
						</p>

						<p class="item-count">
							<%=cartItemCount%> item(s) in your cart
						</p>

						<%
						if (!cartEmpty) {
							for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
								CartItem item = entry.getValue();

								if (item == null || item.getMenu() == null) {
									continue;
								}

								String itemName = item.getMenu().getItemName() == null
										? "Menu item"
										: item.getMenu().getItemName();
						%>

						<div class="order-item">
							<div class="item-info">
								<div class="item-name">
									<%=escapeHtml(itemName)%>
								</div>

								<div class="item-details">
									₹<%=money(item.getMenu().getPrice())%>
									×
									<%=item.getQuantity()%>
								</div>
							</div>

							<div class="item-price">
								₹<%=money(item.getSubtotal())%>
							</div>
						</div>

						<%
							}
						} else {
						%>

						<p class="summary-subtitle">
							Your cart is currently empty. Add food to your cart
							before placing an order.
						</p>

						<%
						}
						%>

						<div class="summary-total">
							<span>Total</span>
							<span>₹<%=money(orderTotal)%></span>
						</div>

						<div class="summary-note">
							<i class="fa-solid fa-circle-info"></i>
							Cash on Delivery is selected by default. UPI and card
							choices are shown, but online payment processing is not
							enabled yet.
						</div>

						<button type="submit"
							class="confirm-btn"
							<%=cartEmpty ? "disabled" : ""%>>
							<% if (cartEmpty) { %>
								<i class="fa-solid fa-cart-shopping"></i>
								Add Items to Place Order
							<% } else { %>
								Place Order
								<i class="fa-solid fa-arrow-right"></i>
							<% } %>
						</button>

						<p class="secure-note">
							<i class="fa-solid fa-shield-halved"></i>
							Please review your details before confirming your order.
						</p>

					</section>
				</aside>

			</div>
		</form>

	</main>

	<!-- FOOTER -->
	<footer>
		<div class="footer-container">

			<div class="footer-brand">
				<a href="<%=contextPath%>/restaurant" class="footer-logo">
					<span class="logo-box">B</span>
					<span class="logo-name">Bitezy</span>
				</a>

				<p>
					Delicious food from your favourite restaurants, delivered
					fresh to your doorstep.
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