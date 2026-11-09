package com.aeroconnect.controller.passenger;

import com.aeroconnect.dao.BookingDAO;
import com.aeroconnect.model.Booking;
import com.aeroconnect.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * PassengerDashboardServlet — passenger home page at /passenger/dashboard.
 */
public class PassengerDashboardServlet extends HttpServlet {

    private final BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("loggedInUser");
        List<Booking> bookings = bookingDAO.findByUser(user.getId());

        long confirmed  = bookings.stream().filter(b -> b.getStatus() == Booking.Status.CONFIRMED).count();
        long pending    = bookings.stream().filter(b -> b.getStatus() == Booking.Status.PENDING).count();
        long cancelled  = bookings.stream().filter(b -> b.getStatus() == Booking.Status.CANCELLED).count();

        // Show the 5 most recent bookings
        List<Booking> recentBookings = bookings.stream().limit(5).toList();

        req.setAttribute("recentBookings", recentBookings);
        req.setAttribute("confirmedCount", confirmed);
        req.setAttribute("pendingCount",   pending);
        req.setAttribute("cancelledCount", cancelled);
        req.setAttribute("totalBookings",  bookings.size());

        req.getRequestDispatcher("/WEB-INF/views/passenger/dashboard.jsp").forward(req, resp);
    }
}
