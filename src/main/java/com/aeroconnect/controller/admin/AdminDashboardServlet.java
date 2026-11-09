package com.aeroconnect.controller.admin;

import com.aeroconnect.dao.BookingDAO;
import com.aeroconnect.dao.FlightDAO;
import com.aeroconnect.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * AdminDashboardServlet — admin overview page at /admin/dashboard.
 */
public class AdminDashboardServlet extends HttpServlet {

    private final UserDAO    userDAO    = new UserDAO();
    private final FlightDAO  flightDAO  = new FlightDAO();
    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("totalPassengers", userDAO.findByRole(
                com.aeroconnect.model.User.Role.PASSENGER).size());
        req.setAttribute("totalFlights",    flightDAO.count());
        req.setAttribute("totalBookings",   bookingDAO.count());
        req.setAttribute("recentBookings",  bookingDAO.findAll().stream().limit(10).toList());

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }
}
