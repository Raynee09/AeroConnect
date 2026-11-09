package com.aeroconnect.service;

import com.aeroconnect.dao.FlightDAO;
import com.aeroconnect.model.Flight;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * FlightService — business logic for flight search and management.
 */
public class FlightService {

    private final FlightDAO flightDAO = new FlightDAO();

    public List<Flight> searchFlights(String originCode, String destinationCode, LocalDate date) {
        if (originCode == null || destinationCode == null || date == null) {
            throw new IllegalArgumentException("Origin, destination, and date are required.");
        }
        if (originCode.equalsIgnoreCase(destinationCode)) {
            throw new IllegalArgumentException("Origin and destination cannot be the same.");
        }
        return flightDAO.search(originCode, destinationCode, date);
    }

    public Optional<Flight> findById(long id) {
        return flightDAO.findById(id);
    }

    public List<Flight> getAllFlights() {
        return flightDAO.findAll();
    }

    public long createFlight(Flight flight) {
        validateFlight(flight);
        return flightDAO.insert(flight);
    }

    public boolean updateFlight(Flight flight) {
        validateFlight(flight);
        return flightDAO.update(flight);
    }

    public boolean updateStatus(long flightId, Flight.Status status) {
        return flightDAO.updateStatus(flightId, status);
    }

    public int getFlightCount() {
        return flightDAO.count();
    }

    private void validateFlight(Flight flight) {
        if (flight.getFlightNumber() == null || flight.getFlightNumber().isBlank()) {
            throw new IllegalArgumentException("Flight number is required.");
        }
        if (flight.getDepartureTime() == null || flight.getArrivalTime() == null) {
            throw new IllegalArgumentException("Departure and arrival times are required.");
        }
        if (!flight.getArrivalTime().isAfter(flight.getDepartureTime())) {
            throw new IllegalArgumentException("Arrival time must be after departure time.");
        }
        if (flight.getBasePrice() == null || flight.getBasePrice().signum() <= 0) {
            throw new IllegalArgumentException("Base price must be positive.");
        }
    }
}
