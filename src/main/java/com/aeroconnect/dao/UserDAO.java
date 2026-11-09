package com.aeroconnect.dao;

import com.aeroconnect.model.User;
import com.aeroconnect.util.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * UserDAO — all database operations for the `users` table.
 * Uses PreparedStatements throughout; no SQL is concatenated from user input.
 */
public class UserDAO {

    private static final Logger log = LoggerFactory.getLogger(UserDAO.class);

    // ---- SQL constants ----
    private static final String SQL_FIND_BY_ID =
        "SELECT * FROM users WHERE id = ?";

    private static final String SQL_FIND_BY_EMAIL =
        "SELECT * FROM users WHERE email = ?";

    private static final String SQL_INSERT =
        "INSERT INTO users (email, password_hash, first_name, last_name, phone, " +
        "date_of_birth, passport_number, nationality, role, is_active) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_UPDATE =
        "UPDATE users SET email=?, first_name=?, last_name=?, phone=?, " +
        "date_of_birth=?, passport_number=?, nationality=?, updated_at=CURRENT_TIMESTAMP " +
        "WHERE id=?";

    private static final String SQL_UPDATE_PASSWORD =
        "UPDATE users SET password_hash=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";

    private static final String SQL_FIND_ALL =
        "SELECT * FROM users ORDER BY created_at DESC";

    private static final String SQL_FIND_BY_ROLE =
        "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";

    private static final String SQL_COUNT =
        "SELECT COUNT(*) FROM users";

    private static final String SQL_DEACTIVATE =
        "UPDATE users SET is_active=FALSE, updated_at=CURRENT_TIMESTAMP WHERE id=?";

    // ---- public methods ----

    public Optional<User> findById(long id) {
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

    public Optional<User> findByEmail(String email) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_EMAIL)) {
            ps.setString(1, email.trim().toLowerCase());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) {
            log.error("findByEmail({}) failed", email, e);
        }
        return Optional.empty();
    }

    /**
     * Inserts a new user and returns the generated primary key.
     * @return generated ID, or -1 on failure
     */
    public long insert(User user) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getEmail().trim().toLowerCase());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getFirstName());
            ps.setString(4, user.getLastName());
            ps.setString(5, user.getPhone());
            ps.setObject(6, user.getDateOfBirth());
            ps.setString(7, user.getPassportNumber());
            ps.setString(8, user.getNationality());
            ps.setString(9, user.getRole().name());
            ps.setBoolean(10, user.isActive());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
        } catch (SQLException e) {
            log.error("insert(User) failed for email={}", user.getEmail(), e);
        }
        return -1L;
    }

    /**
     * Updates profile fields (does NOT update password or role).
     */
    public boolean update(User user) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            ps.setString(1, user.getEmail().trim().toLowerCase());
            ps.setString(2, user.getFirstName());
            ps.setString(3, user.getLastName());
            ps.setString(4, user.getPhone());
            ps.setObject(5, user.getDateOfBirth());
            ps.setString(6, user.getPassportNumber());
            ps.setString(7, user.getNationality());
            ps.setLong(8, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("update(User id={}) failed", user.getId(), e);
        }
        return false;
    }

    public boolean updatePassword(long userId, String newHash) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_PASSWORD)) {
            ps.setString(1, newHash);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("updatePassword(userId={}) failed", userId, e);
        }
        return false;
    }

    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            log.error("findAll() failed", e);
        }
        return list;
    }

    public List<User> findByRole(User.Role role) {
        List<User> list = new ArrayList<>();
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ROLE)) {
            ps.setString(1, role.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            log.error("findByRole({}) failed", role, e);
        }
        return list;
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

    public boolean deactivate(long userId) {
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DEACTIVATE)) {
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            log.error("deactivate(userId={}) failed", userId, e);
        }
        return false;
    }

    public boolean emailExists(String email) {
        return findByEmail(email).isPresent();
    }

    // ---- mapping ----

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setPhone(rs.getString("phone"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) u.setDateOfBirth(dob.toLocalDate());
        u.setPassportNumber(rs.getString("passport_number"));
        u.setNationality(rs.getString("nationality"));
        u.setRole(User.Role.valueOf(rs.getString("role")));
        u.setActive(rs.getBoolean("is_active"));
        Timestamp created = rs.getTimestamp("created_at");
        if (created != null) u.setCreatedAt(created.toLocalDateTime());
        Timestamp updated = rs.getTimestamp("updated_at");
        if (updated != null) u.setUpdatedAt(updated.toLocalDateTime());
        return u;
    }
}
