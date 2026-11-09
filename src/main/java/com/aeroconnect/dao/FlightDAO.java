package com.aeroconnect.dao;

import com.aeroconnect.model.Aircraft;
import com.aeroconnect.model.Flight;
import com.aeroconnect.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * FlightDAO — all database operations for the `flights` table.
 */
public class FlightDAO {

    private static final Logger log = LoggerFactory.getLogger(FlightDAO.class);

    private static final String BASE_SELECT =
        "SELECT f.*, a.registration, a.model AS aircraft_model, a.manufacturer " +
        "FROM flights f " +
        "JOIN aircraft a ON f.aircraft_id = a.id ";

    private static final String SQL_FIND_BY_ID =
        BASE_SELECT + "WHERE f.id = ?";

    private static final String SQL_FIND_ALL =
        BASE_SELECT + "ORDER BY f.departure_time ASC";

    private static final String SQL_SEARCH =
        BASE_SELECT +
        "WHERE f.origin_code = ? AND f.destination_code = ? " +
        "AND DATE(f.departure_time) = ? " +
        "AND f.status NOT IN ('CANCELLED','ARRIVED') " +
        "ORDER BY f.departure_time ASC";

    private static final String SQL_INSERT =
        "INSERT INTO flights (flight_number, aircraft_id, origin_code, origin_city, " +
        "destination_code, destination_city, departure_time, arrival_time, base_price, " +
        "status, available_economy, available_business, available_first) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_UPDATE =
        "UPDATE flights SET flight_number=?, aircraft_id=?, origin_code=?, origin_city=?, " +
        "destination_code=?, destination_city=?, departure_time=?, arrival_time=?, " +
        "base_price=?, status=?, available_economy=?, available_business=?, available_first=?, " +
        "updated_at=CURRENT_TIMESTAMP WHERE id=?";

    private static final String SQL_UPDATE_STATUS =
        "UPDATE flights SET status=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";

    private static final String SQL_DECREMENT_SEATS =
        "UPDATE flights SET available_economy = available_economy - ? WHERE id=? AND seat_class_col='ECONOMY'";

    private static final String SQL_COUNT = "SELECT COUNT(*) FROM flights";

    // ---- public methods ----

    public Optional<Flight> findById(long id) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            log.error("findById({}) failed", id, e);
        }
        return Optional.empty();
    }

    public List<Flight> findAll() {
        List<Flight> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            log.error("findAll() failed", e);
        }
        return list;
    }

    /**
     * Searches for flights matching origin, destination, and departure date.
     *
     * @param originCode      IATA code (e.g. "JFK")
     * @param destinationCode IATA code (e.g. "LAX")
     * @param date            departure date
     */
    public List<Flight> search(String originCode, String destinationCode, LocalDate date) {
        List<Flight> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_SEARCH)) {
            ps.setString(1, originCode.toUpperCase());
            ps.setString(2, destinationCode.toUpperCase());
            ps.setDate(3, Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            log.error("search({} -> {} on {}) failed", originCode, destinationCode, date, e);
        }
        return list;
    }

    public long insert(Flight flight) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, flight.getFlightNumber());
            ps.setLong(2, flight.getAircraftId());
            ps.setString(3, flight.getOriginCode().toUpperCase());
            ps.setString(4, flight.getOriginCity());
            ps.setString(5, flight.getDestinationCode().toUpperCase());
            ps.setString(6, flight.getDestinationCity());
            ps.setTimestamp(7, Timestamp.valueOf(flight.getDepartureTime()));
            ps.setTimestamp(8, Timestamp.valueOf(flight.getArrivalTime()));
            ps.setBigDecimal(9, flight.getBasePrice());
            ps.setString(10, flight.getStatus().name());
            ps.setInt(11, flight.getAvailableEconomy());
            ps.setInt(12, flight.getAvailableBusiness());
            ps.setInt(13, flight.getAvailableFirst());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        } catch (SQLException e) {
            log.error("insert(Flight) failed for flightNumber={}", flight.getFlightNumber(), e);
        }
        return -1L;
    }

    public boolean update(Flight flight) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, flight.getFlightNumber());
            ps.setLong(2, flight.getAircraftId());
            ps.setString(3, flight.getOriginCode().toUpperCase());
            ps.setString(4, flight.getOriginCity());
            ps.setString(5, flight.getDestinationCode().toUpperCase());
            ps.setString(6, flight.getDestinationCity());
            ps.setTimestamp(7, Timestamp.valueOf(flight.getDepartureTime()));
            ps.setTimestamp(8, Timestamp.valueOf(flight.getArrivalTime()));
            ps.setBigDecimal(9, flight.getBasePrice());
            ps.setString(10, flight.getStatus().name());
            ps.setInt(11, flight.getAvailableEconomy());
            ps.setInt(12, flight.getAvailableBusiness());
            ps.setInt(13, flight.getAvailableFirst());
            ps.setLong(14, flight.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("update(Flight id={}) failed", flight.getId(), e);
        }
        return false;
    }

    public boolean updateStatus(long flightId, Flight.Status status) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_STATUS)) {
            ps.setString(1, status.name());
            ps.setLong(2, flightId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("updateStatus(flightId={}) failed", flightId, e);
        }
        return false;
    }

    /**
     * Decrements available seats atomically — uses a conditional UPDATE.
     * Returns true only if seats were actually decremented (i.e. enough were available).
     */
    public boolean decrementSeats(Connection conn, long flightId, String seatClass, int count)
            throws SQLException {
        String sql = switch (seatClass.toUpperCase()) {
            case "ECONOMY"  ->
                "UPDATE flights SET available_economy  = available_economy  - ? " +
                "WHERE id = ? AND available_economy  >= ?";
            case "BUSINESS" ->
                "UPDATE flights SET available_business = available_business - ? " +
                "WHERE id = ? AND available_business >= ?";
            case "FIRST"    ->
                "UPDATE flights SET available_first    = available_first    - ? " +
                "WHERE id = ? AND available_first    >= ?";
            default -> throw new IllegalArgumentException("Unknown seat class: " + seatClass);
        };
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, count);
            ps.setLong(2, flightId);
            ps.setInt(3, count);
            return ps.executeUpdate() > 0;
        }
    }

    public int count() {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_COUNT);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            log.error("count() failed", e);
        }
        return 0;
    }

    // ---- mapping ----

    private Flight mapRow(ResultSet rs) throws SQLException {
        Flight f = new Flight();
        f.setId(rs.getLong("id"));
        f.setFlightNumber(rs.getString("flight_number"));
        f.setAircraftId(rs.getLong("aircraft_id"));
        f.setOriginCode(rs.getString("origin_code"));
        f.setOriginCity(rs.getString("origin_city"));
        f.setDestinationCode(rs.getString("destination_code"));
        f.setDestinationCity(rs.getString("destination_city"));
        f.setDepartureTime(rs.getTimestamp("departure_time").toLocalDateTime());
        f.setArrivalTime(rs.getTimestamp("arrival_time").toLocalDateTime());
        f.setBasePrice(rs.getBigDecimal("base_price"));
        f.setStatus(Flight.Status.valueOf(rs.getString("status")));
        f.setAvailableEconomy(rs.getInt("available_economy"));
        f.setAvailableBusiness(rs.getInt("available_business"));
        f.setAvailableFirst(rs.getInt("available_first"));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) f.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) f.setUpdatedAt(updated.toLocalDateTime());

        // Populate embedded Aircraft from the JOIN
        Aircraft aircraft = new Aircraft();
        aircraft.setId(rs.getLong("aircraft_id"));
        aircraft.setRegistration(rs.getString("registration"));
        aircraft.setModel(rs.getString("aircraft_model"));
        aircraft.setManufacturer(rs.getString("manufacturer"));
        f.setAircraft(aircraft);

        return f;
    }
}
