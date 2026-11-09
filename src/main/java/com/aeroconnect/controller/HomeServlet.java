package com.aeroconnect.controller;

import com.aeroconnect.dao.FlightDAO;
import com.aeroconnect.model.Flight;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

/**
 * HomeServlet — serves the public home page.
 */
public class HomeServlet extends HttpServlet {

    private final FlightDAO flightDAO = new FlightDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Show up to 6 upcoming scheduled flights on the home page
        List<Flight> upcomingFlights = flightDAO.findAll().stream()
                .filter(f -> f.getStatus() == Flight.Status.SCHEDULED)
                .limit(6)
                .toList();

        req.setAttribute("upcomingFlights", upcomingFlights);
        req.getRequestDispatcher("/WEB-INF/views/public/home.jsp")
        .forward(req, resp);
    }
}
