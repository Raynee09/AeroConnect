package com.aeroconnect.controller.admin;

import com.aeroconnect.dao.BookingDAO;
import com.aeroconnect.model.Booking;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * AdminBookingServlet — booking management at /admin/bookings.
 */
public class AdminBookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam != null) {
            try {
                long bookingId = Long.parseLong(idParam);
                Optional<Booking> booking = bookingDAO.findById(bookingId);
                if (booking.isEmpty()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                req.setAttribute("booking", booking.get());
                req.getRequestDispatcher("/WEB-INF/views/admin/bookingDetail.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            List<Booking> bookings = bookingDAO.findAll();
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/WEB-INF/views/admin/manageBookings.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String action = req.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                long bookingId = Long.parseLong(req.getParameter("bookingId"));
                Booking.Status status = Booking.Status.valueOf(req.getParameter("status").toUpperCase());
                bookingDAO.updateStatus(bookingId, status);
            } catch (Exception ignored) {}
        }
        resp.sendRedirect(req.getContextPath() + "/admin/bookings");
    }
}
