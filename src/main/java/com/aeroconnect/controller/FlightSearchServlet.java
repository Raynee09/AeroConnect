package com.aeroconnect.controller;

import com.aeroconnect.model.Flight;
import com.aeroconnect.service.FlightService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.util.List;

/**
 * FlightSearchServlet — handles the public flight search at /flights/search.
 */
public class FlightSearchServlet extends HttpServlet {

    private final FlightService flightService = new FlightService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String origin      = req.getParameter("origin");
        String destination = req.getParameter("destination");
        String dateStr     = req.getParameter("date");

        // If no search parameters, just show the search form
        if (origin == null || origin.isBlank()) {
            req.getRequestDispatcher("/WEB-INF/views/public/flightSearch.jsp").forward(req, resp);
            return;
        }

        List<Flight> results = Collections.emptyList();
        String errorMsg = null;

        try {
            LocalDate date = LocalDate.parse(dateStr);
            results = flightService.searchFlights(origin.trim().toUpperCase(),
                                                  destination.trim().toUpperCase(), date);
            if (results.isEmpty()) {
                errorMsg = "No flights found for the selected route and date.";
            }
        } catch (DateTimeParseException e) {
            errorMsg = "Invalid date format. Please use YYYY-MM-DD.";
        } catch (IllegalArgumentException e) {
            errorMsg = e.getMessage();
        }

        req.setAttribute("flights",     results);
        req.setAttribute("errorMsg",    errorMsg);
        req.setAttribute("origin",      origin);
        req.setAttribute("destination", destination);
        req.setAttribute("date",        dateStr);
        req.getRequestDispatcher("/WEB-INF/views/public/flightSearch.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Redirect POST to GET to support page refresh without re-submitting
        String origin      = req.getParameter("origin");
        String destination = req.getParameter("destination");
        String date        = req.getParameter("date");
        resp.sendRedirect(req.getContextPath() + "/flights/search?origin=" + origin
                + "&destination=" + destination + "&date=" + date);
    }
}
