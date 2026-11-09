package com.aeroconnect.controller.admin;

import com.aeroconnect.model.Flight;
import com.aeroconnect.service.FlightService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

/**
 * AdminFlightServlet — CRUD management for flights at /admin/flights.
 */
public class AdminFlightServlet extends HttpServlet {

    private final FlightService flightService = new FlightService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("edit".equals(action)) {
            String idStr = req.getParameter("id");
            try {
                long id = Long.parseLong(idStr);
                Optional<Flight> flight = flightService.findById(id);
                if (flight.isEmpty()) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
                req.setAttribute("flight", flight.get());
                req.setAttribute("editMode", true);
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/admin/flightForm.jsp").forward(req, resp);
        } else if ("new".equals(action)) {
            req.setAttribute("editMode", false);
            req.getRequestDispatcher("/WEB-INF/views/admin/flightForm.jsp").forward(req, resp);
        } else {
            List<Flight> flights = flightService.getAllFlights();
            req.setAttribute("flights", flights);
            req.getRequestDispatcher("/WEB-INF/views/admin/manageFlights.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("updateStatus".equals(action)) {
            handleStatusUpdate(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/flights");
        }
    }

    private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            long flightId = Long.parseLong(req.getParameter("flightId"));
            Flight.Status status = Flight.Status.valueOf(req.getParameter("status").toUpperCase());
            flightService.updateStatus(flightId, status);
        } catch (Exception e) {
            // Log and fall through to redirect
        }
        resp.sendRedirect(req.getContextPath() + "/admin/flights");
    }
}
