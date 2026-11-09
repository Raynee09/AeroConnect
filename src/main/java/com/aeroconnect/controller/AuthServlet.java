package com.aeroconnect.controller;

import com.aeroconnect.model.User;
import com.aeroconnect.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Optional;

/**
 * AuthServlet — handles /auth/login, /auth/logout, /auth/register.
 */
public class AuthServlet extends HttpServlet {

    private static final Logger log = LoggerFactory.getLogger(AuthServlet.class);
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = getAction(req);
        switch (action) {
            case "login"    -> req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
            case "register" -> req.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(req, resp);
            case "logout"   -> handleLogout(req, resp);
            default         -> resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = getAction(req);
        switch (action) {
            case "login"    -> handleLogin(req, resp);
            case "register" -> handleRegister(req, resp);
            default         -> resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    // ---- handlers ----

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String redirect = req.getParameter("redirect");

        Optional<User> result = authService.login(email, password);

        if (result.isEmpty()) {
            req.setAttribute("error", "Invalid email or password. Please try again.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/public/login.jsp").forward(req, resp);
            return;
        }

        User user = result.get();
        HttpSession session = req.getSession(true);
        session.setAttribute("loggedInUser", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("userRole", user.getRole().name());
        log.info("User {} logged in successfully.", user.getEmail());

        // Post-login redirect
        if (redirect != null && !redirect.isBlank() && redirect.startsWith("/")) {
            resp.sendRedirect(req.getContextPath() + redirect);
        } else if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            resp.sendRedirect(req.getContextPath() + "/passenger/dashboard");
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirmPassword");
        String firstName = req.getParameter("firstName");
        String lastName  = req.getParameter("lastName");
        String phone     = req.getParameter("phone");

        // Basic confirm-password check before hitting the service
        if (password == null || !password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("email", email);
            req.setAttribute("firstName", firstName);
            req.setAttribute("lastName", lastName);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(req, resp);
            return;
        }

        try {
            long userId = authService.register(email, password, firstName, lastName, phone);
            if (userId < 0) {
                throw new RuntimeException("Registration failed. Please try again.");
            }
            req.getSession(true).setAttribute("registrationSuccess",
                    "Account created successfully! Please log in.");
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("email", email);
            req.setAttribute("firstName", firstName);
            req.setAttribute("lastName", lastName);
            req.setAttribute("phone", phone);
            req.getRequestDispatcher("/WEB-INF/views/public/register.jsp").forward(req, resp);
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            log.info("User {} logged out.", session.getAttribute("loggedInUser") != null
                ? ((User) session.getAttribute("loggedInUser")).getEmail() : "unknown");
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }

    // ---- helpers ----

    /** Extracts the sub-action from the URL path: /auth/{action} */
    private String getAction(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) return "";
        return pathInfo.substring(1).toLowerCase();
    }
}
