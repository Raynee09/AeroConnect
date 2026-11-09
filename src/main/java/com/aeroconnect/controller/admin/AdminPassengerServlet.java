package com.aeroconnect.controller.admin;

import com.aeroconnect.dao.UserDAO;
import com.aeroconnect.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * AdminPassengerServlet — passenger management at /admin/passengers.
 */
public class AdminPassengerServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam != null) {
            try {
                long userId = Long.parseLong(idParam);
                Optional<User> user = userDAO.findById(userId);
                if (user.isEmpty()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                req.setAttribute("passenger", user.get());
                req.getRequestDispatcher("/WEB-INF/views/admin/passengerDetail.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            List<User> passengers = userDAO.findByRole(User.Role.PASSENGER);
            req.setAttribute("passengers", passengers);
            req.getRequestDispatcher("/WEB-INF/views/admin/managePassengers.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String action = req.getParameter("action");
        if ("deactivate".equals(action)) {
            try {
                long userId = Long.parseLong(req.getParameter("userId"));
                userDAO.deactivate(userId);
            } catch (NumberFormatException ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/passengers");
    }
}
