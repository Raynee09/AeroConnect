package com.aeroconnect.controller.passenger;

import com.aeroconnect.dao.BookingDAO;
import com.aeroconnect.model.Booking;
import com.aeroconnect.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * BookingServlet — lists and shows booking details for a passenger at /passenger/bookings.
 */
public class BookingServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("loggedInUser");
        String idParam = req.getParameter("id");

        if (idParam != null) {
            // Booking detail view
            try {
                long bookingId = Long.parseLong(idParam);
                Optional<Booking> booking = bookingDAO.findById(bookingId);

                if (booking.isEmpty() || !booking.get().getUserId().equals(user.getId())) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found.");
                    return;
                }
                req.setAttribute("booking", booking.get());
                req.getRequestDispatcher("/WEB-INF/views/passenger/bookingDetail.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
        } else {
            // Booking list
            List<Booking> bookings = bookingDAO.findByUser(user.getId());
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/WEB-INF/views/passenger/myBookings.jsp").forward(req, resp);
        }
    }
}
