package com.aeroconnect.dao;

import com.aeroconnect.model.Booking;
import com.aeroconnect.model.Flight;
import com.aeroconnect.model.User;
import com.aeroconnect.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * BookingDAO — database operations for the `bookings` table.
 * Methods that need atomicity accept a {@link Connection} parameter
 * so the caller can control the transaction.
 */
public class BookingDAO {

    private static final Logger log = LoggerFactory.getLogger(BookingDAO.class);

    private static final String BASE_SELECT =
        "SELECT b.*, " +
        "  u.first_name, u.last_name, u.email, " +
        "  f.flight_number, f.origin_code, f.origin_city, " +
        "  f.destination_code, f.destination_city, f.departure_time, f.arrival_time " +
        "FROM bookings b " +
        "JOIN users u ON b.user_id = u.id " +
        "JOIN flights f ON b.flight_id = f.id ";

    private static final String SQL_FIND_BY_ID =
        BASE_SELECT + "WHERE b.id = ?";

    private static final String SQL_FIND_BY_REFERENCE =
        BASE_SELECT + "WHERE b.booking_reference = ?";

    private static final String SQL_FIND_BY_USER =
        BASE_SELECT + "WHERE b.user_id = ? ORDER BY b.created_at DESC";

    private static final String SQL_FIND_ALL =
        BASE_SELECT + "ORDER BY b.created_at DESC";

    private static final String SQL_INSERT =
        "INSERT INTO bookings (booking_reference, user_id, flight_id, seat_class, " +
        "num_passengers, total_price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_UPDATE_STATUS =
        "UPDATE bookings SET status=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";

    private static final String SQL_COUNT = "SELECT COUNT(*) FROM bookings";

    // ---- public methods ----

    public Optional<Booking> findById(long id) {
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

    public Optional<Booking> findByReference(String reference) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_REFERENCE)) {
            ps.setString(1, reference.toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            log.error("findByReference({}) failed", reference, e);
        }
        return Optional.empty();
    }

    public List<Booking> findByUser(long userId) {
        List<Booking> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_USER)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            log.error("findByUser({}) failed", userId, e);
        }
        return list;
    }

    public List<Booking> findAll() {
        List<Booking> list = new ArrayList<>();
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
     * Inserts a booking within the given (caller-managed) connection/transaction.
     */
    public long insert(Connection conn, Booking booking) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, booking.getBookingReference());
            ps.setLong(2, booking.getUserId());
            ps.setLong(3, booking.getFlightId());
            ps.setString(4, booking.getSeatClass().name());
            ps.setInt(5, booking.getNumPassengers());
            ps.setBigDecimal(6, booking.getTotalPrice());
            ps.setString(7, booking.getStatus().name());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        }
        return -1L;
    }

    public boolean updateStatus(long bookingId, Booking.Status status) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_STATUS)) {
            ps.setString(1, status.name());
            ps.setLong(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("updateStatus(bookingId={}) failed", bookingId, e);
        }
        return false;
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

    private Booking mapRow(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getLong("id"));
        b.setBookingReference(rs.getString("booking_reference"));
        b.setUserId(rs.getLong("user_id"));
        b.setFlightId(rs.getLong("flight_id"));
        b.setSeatClass(Booking.SeatClass.valueOf(rs.getString("seat_class")));
        b.setNumPassengers(rs.getInt("num_passengers"));
        b.setTotalPrice(rs.getBigDecimal("total_price"));
        b.setStatus(Booking.Status.valueOf(rs.getString("status")));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) b.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) b.setUpdatedAt(updated.toLocalDateTime());

        // Embed a lightweight User
        User user = new User();
        user.setId(rs.getLong("user_id"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setEmail(rs.getString("email"));
        b.setUser(user);

        // Embed a lightweight Flight
        Flight flight = new Flight();
        flight.setId(rs.getLong("flight_id"));
        flight.setFlightNumber(rs.getString("flight_number"));
        flight.setOriginCode(rs.getString("origin_code"));
        flight.setOriginCity(rs.getString("origin_city"));
        flight.setDestinationCode(rs.getString("destination_code"));
        flight.setDestinationCity(rs.getString("destination_city"));
        flight.setDepartureTime(rs.getTimestamp("departure_time").toLocalDateTime());
        flight.setArrivalTime(rs.getTimestamp("arrival_time").toLocalDateTime());
        b.setFlight(flight);

        return b;
    }
}
