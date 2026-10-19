<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Sign Up | Bitezy</title>

<style>
:root {
    --green: #174c36;
    --green-hover: #236447;
    --dark: #222522;
    --muted: #858780;
    --border: #eee8df;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                 Roboto, Arial, sans-serif;
    background: #fff;
    color: var(--dark);

    min-height: 100vh;
    min-height: 100svh;

    display: flex;
    flex-direction: column;
    align-items: center;

    padding: 12px 15px;
}

/* SIGNUP CARD */

.signup-wrapper {
    width: 100%;
    max-width: 480px;
    margin: auto;
}

.signup-card {
    width: 100%;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 14px;
    overflow: hidden;
    box-shadow: 0 6px 24px rgba(23, 76, 54, 0.08);
}

/* TOP FOOD IMAGE */

.food-panel {
    height: 72px;
    padding: 9px 22px;
    display: flex;
    align-items: flex-end;
    color: #fff;

    background:
        linear-gradient(
            to top,
            rgba(16, 62, 46, 0.90),
            rgba(16, 62, 46, 0.12)
        ),
        url("${pageContext.request.contextPath}/images/hero-biriyani.png")
        center 55% / cover no-repeat;
}

.food-panel h2 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 22px;
    line-height: 1.25;
    margin-bottom: 2px;
}

.food-panel p {
    color: #f3eee6;
    font-size: 12px;
    line-height: 1.4;
}

/* FORM SECTION */

.form-panel {
    padding: 17px 28px 17px;
}

.signup-content h1 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 27px;
    line-height: 1.3;
    font-weight: 600;
    letter-spacing: -0.4px;
    margin-bottom: 5px;
}

.subtitle {
    color: var(--muted);
    font-size: 13px;
    line-height: 1.6;
    margin-bottom: 13px;
}

/* ERROR MESSAGE */

.error-message {
    background: #fff0ee;
    color: #c62828;
    border: 1px solid #f3d4cf;
    border-radius: 7px;
    padding: 8px 10px;
    margin-bottom: 10px;
    font-size: 13px;
    line-height: 1.4;
    overflow-wrap: anywhere;
}

/* FORM FIELDS */

.form-group {
    margin-bottom: 9px;
}

.form-group label {
    display: block;
    margin-bottom: 4px;
    color: var(--dark);
    font-size: 13px;
    line-height: 1.4;
    font-weight: 650;
}

.form-group input,
.form-group textarea {
    display: block;
    width: 100%;
    padding: 8px 12px;
    border: 1px solid var(--border);
    border-radius: 7px;
    background: #fff;
    color: var(--dark);
    font-family: inherit;
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
}

.form-group input {
    height: 38px;
}

.form-group textarea {
    height: 43px;
    min-height: 43px;
    resize: none;
}

.form-group input::placeholder,
.form-group textarea::placeholder {
    color: #858780;
    opacity: 1;
}

.form-group input:focus,
.form-group textarea:focus {
    border-color: var(--green);
    box-shadow: 0 0 0 3px rgba(23, 76, 54, 0.08);
}

/* CREATE ACCOUNT BUTTON */

.signup-button {
    display: block;
    width: 100%;
    height: 42px;
    margin-top: 2px;
    border: none;
    border-radius: 7px;
    background: var(--green);
    color: #fff;
    font-family: inherit;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s;
}

.signup-button:hover {
    background: var(--green-hover);
}

/* LOGIN LINK */

.login-link {
    margin-top: 11px;
    text-align: center;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.5;
}

.login-link a {
    color: var(--green);
    font-weight: 700;
    text-decoration: none;
}

.login-link a:hover {
    color: var(--green-hover);
    text-decoration: underline;
}

/* MOBILE */

@media (max-width: 480px) {
    body {
        padding: 10px;
    }

    .food-panel {
        height: 75px;
        padding: 9px 17px;
    }

    .food-panel h2 {
        font-size: 21px;
    }

    .form-panel {
        padding: 17px 18px;
    }

    .signup-content h1 {
        font-size: 26px;
    }

    .form-group {
        margin-bottom: 9px;
    }
}

/* REDUCED MOTION */

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        transition: none !important;
    }
}
</style>
</head>

<body>

<main class="signup-wrapper">

    <section class="signup-card">

        <!-- FOOD IMAGE AT THE TOP -->
        <div class="food-panel">
            <div>
                <h2>A little taste of home.</h2>
                <p>Join Bitezy and discover your favourite flavours.</p>
            </div>
        </div>

        <!-- SIGNUP FORM -->
        <section class="form-panel">
            <div class="signup-content">

                <h1>Create Account</h1>

                <p class="subtitle">
                    Join Bitezy and order your favourite food.
                </p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="error-message">
                        <%= request.getAttribute("error") %>
                    </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/signup"
                      method="post">

                    <!-- FULL NAME -->
                    <div class="form-group">
                        <label for="username">Full Name</label>
                        <input
                            type="text"
                            id="username"
                            name="username"
                            placeholder="Enter your full name"
                            autocomplete="name"
                            required>
                    </div>

                    <!-- EMAIL ADDRESS -->
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>
                    </div>

                    <!-- PASSWORD -->
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a password"
                            autocomplete="new-password"
                            required>
                    </div>

                    <!-- ADDRESS -->
                    <div class="form-group">
                        <label for="address">Address</label>
                        <textarea
                            id="address"
                            name="address"
                            placeholder="Enter your address"
                            autocomplete="off"
                            required></textarea>
                    </div>

                    <!-- PHONE NUMBER -->
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input
                            type="tel"
                            id="phone"
                            name="phone"
                            placeholder="Enter your phone number"
                            autocomplete="tel"
                            required>
                    </div>

                    <button type="submit" class="signup-button">
                        Create Account
                    </button>

                </form>

                <p class="login-link">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/login">
                        Log in
                    </a>
                </p>

            </div>
        </section>

    </section>

</main>

</body>
</html>