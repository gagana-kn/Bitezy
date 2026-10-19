
package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private void redirectToMenu(HttpServletRequest req,
                                HttpServletResponse resp,
                                int restaurantId,
                                String extraParameter)
            throws IOException {

        StringBuilder url = new StringBuilder(
                req.getContextPath()
                + "/menu?restaurantId="
                + restaurantId
        );

        String scrollY = req.getParameter("scrollY");

        if (scrollY != null && scrollY.matches("\\d+")) {
            url.append("&scrollY=").append(scrollY);
        }

        if ("true".equals(req.getParameter("cartOpen"))) {
            url.append("&cartOpen=true");
        }

        if (extraParameter != null && !extraParameter.isEmpty()) {
            url.append("&").append(extraParameter);
        }

        resp.sendRedirect(url.toString());
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {

            MenuDaoImpl menuDao = new MenuDaoImpl();
            int menuId = Integer.parseInt(req.getParameter("menuId"));

            Menu menu = menuDao.getMenu(menuId);

            if (menu != null && menu.isAvailable()) {

                HttpSession session = req.getSession();

                Cart cart = (Cart) session.getAttribute("cart");

                if (cart == null) {
                    cart = new Cart();
                    session.setAttribute("cart", cart);
                }

                boolean added = cart.addItem(menu);

                if (added) {
                    redirectToMenu(
                            req,
                            resp,
                            menu.getRestaurantId(),
                            null
                    );
                } else {
                    redirectToMenu(
                            req,
                            resp,
                            menu.getRestaurantId(),
                            "cartError=differentRestaurant"
                    );
                }
            }

        } else if ("update".equals(action)) {

            int quantity = Integer.parseInt(req.getParameter("quantity"));
            int menuId = Integer.parseInt(req.getParameter("menuId"));

            HttpSession session = req.getSession();

            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null) {
                cart.updateQuantity(menuId, quantity);
            }

            String source = req.getParameter("source");

            if ("menu".equals(source)) {

                int restaurantId = Integer.parseInt(
                        req.getParameter("restaurantId")
                );

                redirectToMenu(req, resp, restaurantId, null);

            } else {
                resp.sendRedirect(req.getContextPath() + "/cart");
            }

        } else if ("remove".equals(action)) {

            HttpSession session = req.getSession();

            Cart cart = (Cart) session.getAttribute("cart");
            int menuId = Integer.parseInt(req.getParameter("menuId"));

            if (cart != null) {
                cart.removeItem(menuId);
            }

            resp.sendRedirect(req.getContextPath() + "/cart");

        } else if ("clear".equals(action)) {

            HttpSession session = req.getSession();

            Cart cart = (Cart) session.getAttribute("cart");

            if (cart != null) {
                cart.clear();
            }

            String source = req.getParameter("source");

            if ("menu".equals(source)) {

                String restaurantId = req.getParameter("restaurantId");

                if (restaurantId != null
                        && restaurantId.matches("\\d+")) {

                    redirectToMenu(
                            req,
                            resp,
                            Integer.parseInt(restaurantId),
                            null
                    );
                } else {
                    resp.sendRedirect(
                            req.getContextPath() + "/restaurant"
                    );
                }

            } else {
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");

        req.setAttribute("cart", cart);

        RequestDispatcher rd =
                req.getRequestDispatcher("/cart.jsp");

        rd.forward(req, resp);
    }
}
