package com.aeroconnect.filter;

import com.aeroconnect.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * AuthFilter — enforces session-based authentication and role-based access.
 *
 * Applied to:
 *   /passenger/*  — requires any authenticated user
 *   /admin/*      — requires ADMIN role
 */
public class AuthFilter implements Filter {

    private static final Logger log = LoggerFactory.getLogger(AuthFilter.class);

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession         session = req.getSession(false);

        String path = req.getRequestURI().substring(req.getContextPath().length());
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            log.debug("Unauthenticated access attempt to: {}", path);
            resp.sendRedirect(req.getContextPath() + "/auth/login?redirect=" +
                    java.net.URLEncoder.encode(path, "UTF-8"));
            return;
        }

        // Admin-only section
        if (path.startsWith("/admin/") && !loggedInUser.isAdmin()) {
            log.warn("Non-admin user {} attempted admin access to: {}", loggedInUser.getEmail(), path);
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access this area.");
            return;
        }

        chain.doFilter(request, response);
    }
}
