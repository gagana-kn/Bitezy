<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String redirectTo = "checkout".equals(request.getParameter("redirect"))
            ? "checkout" : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Login | Bitezy</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI",
                 Roboto, Arial, sans-serif;
    background: #fff;
    color: #222522;
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 25px 20px;
}

.login-wrapper {
    width: 100%;
    max-width: 820px;
}

/* LOGIN CARD */

.login-card {
    display: grid;
    grid-template-columns: 0.9fr 1.1fr;
    background: #fff;
    border: 1px solid #eee8df;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(23, 76, 54, 0.08);
}

/* LEFT FOOD IMAGE */

.food-panel {
    position: relative;
    min-height: 410px;
    display: flex;
    align-items: flex-end;
    padding: 28px;
    color: #fff;

    background:
        linear-gradient(
            to top,
            rgba(16, 62, 46, 0.88),
            rgba(16, 62, 46, 0.05) 85%
        ),
        url("${pageContext.request.contextPath}/images/hero-biriyani.png")
        center / cover no-repeat;
}

.food-content h2 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 30px;
    line-height: 1.2;
    margin-bottom: 12px;
}

.food-content p {
    color: #f3eee6;
    font-size: 13px;
    line-height: 1.8;
}

/* RIGHT LOGIN FORM */

.form-panel {
    display: flex;
    align-items: center;
    padding: 38px;
}

.login-content {
    width: 100%;
}

.login-content h1 {
    font-family: Georgia, "Times New Roman", serif;
    font-size: 31px;
    font-weight: 600;
    letter-spacing: -0.6px;
    margin-bottom: 10px;
}

.subtitle {
    color: #858780;
    font-size: 14px;
    line-height: 1.7;
    margin-bottom: 27px;
}

/* FORM FIELDS */

.form-group {
    margin-bottom: 19px;
}

.form-group label {
    display: block;
    font-size: 13px;
    font-weight: 650;
    margin-bottom: 8px;
}

.form-group input {
    display: block;
    width: 100%;
    height: 46px;
    padding: 0 13px;
    border: 1px solid #eee8df;
    border-radius: 8px;
    background: #fff;
    color: #222522;
    font-family: inherit;
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
}

.form-group input::placeholder {
    color: #858780;
}

.form-group input:focus {
    border-color: #174c36;
    box-shadow: 0 0 0 3px rgba(23, 76, 54, 0.09);
}

/* LOGIN BUTTON */

.login-button {
    width: 100%;
    min-height: 47px;
    margin-top: 5px;
    border: none;
    border-radius: 8px;
    background: #174c36;
    color: #fff;
    font-family: inherit;
    font-size: 15px;
    font-weight: 650;
    cursor: pointer;
    transition: background 0.2s;
}

.login-button:hover {
    background: #236447;
}

/* SIGNUP LINK */

.signup-text {
    margin-top: 23px;
    text-align: center;
    color: #858780;
    font-size: 13px;
    line-height: 1.8;
}

.signup-text a {
    color: #174c36;
    font-weight: 700;
    text-decoration: none;
}

.signup-text a:hover {
    color: #f15a3b;
    text-decoration: underline;
}

/* COPYRIGHT */

.copyright {
    margin-top: 22px;
    text-align: center;
    color: #858780;
    font-size: 11px;
}

/* MOBILE RESPONSIVE DESIGN */

@media (max-width: 650px) {
    body {
        padding: 20px 15px;
    }

    .login-wrapper {
        max-width: 430px;
    }

    .login-card {
        grid-template-columns: 1fr;
    }

    .food-panel {
        min-height: 175px;
        padding: 22px;
        background-position: center 55%;
    }

    .food-content h2 {
        font-size: 25px;
        margin-bottom: 7px;
    }

    .food-content p {
        font-size: 12px;
        line-height: 1.6;
        max-width: 300px;
    }

    .form-panel {
        padding: 28px 24px;
    }

    .login-content h1 {
        font-size: 28px;
    }

    .subtitle {
        margin-bottom: 23px;
    }
}

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

<div class="login-wrapper">

    <main class="login-card">

        <!-- LEFT FOOD IMAGE -->
        <section class="food-panel">
            <div class="food-content">
                <h2>A little taste<br>of home.</h2>

                <p>
                    From crispy dosas to comforting meals,
                    discover the flavours you love, delivered
                    fresh to your doorstep.
                </p>
            </div>
        </section>

        <!-- RIGHT LOGIN FORM -->
        <section class="form-panel">
            <div class="login-content">

                <h1>Welcome back!</h1>

                <p class="subtitle">
                    Log in to continue your delicious journey.
                </p>

                <form action="${pageContext.request.contextPath}/login"
                      method="post">

                    <input
                        type="hidden"
                        name="redirect"
                        value="<%= redirectTo %>">

                    <div class="form-group">
                        <label for="email">Email address</label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            placeholder="Enter your email"
                            autocomplete="email"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>

                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Enter your password"
                            autocomplete="current-password"
                            required>
                    </div>

                    <button type="submit" class="login-button">
                        Log in
                    </button>

                </form>

                <p class="signup-text">
                    New to Bitezy?
                    <a href="${pageContext.request.contextPath}/signup.jsp">
                        Create an account
                    </a>
                </p>

            </div>
        </section>

    </main>

    <div class="copyright">
        © 2026 Bitezy. Made with love.
    </div>

</div>

</body>
</html>