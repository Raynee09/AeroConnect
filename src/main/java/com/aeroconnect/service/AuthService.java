package com.aeroconnect.service;

import com.aeroconnect.dao.UserDAO;
import com.aeroconnect.model.User;
import com.aeroconnect.util.PasswordUtil;
import com.aeroconnect.util.ValidationUtil;

import java.util.Optional;

/**
 * AuthService — handles user registration and authentication logic.
 */
public class AuthService {

    private final UserDAO userDAO = new UserDAO();

    /**
     * Authenticates a user by email and password.
     *
     * @return the authenticated User, or empty if credentials are invalid or account is inactive
     */
    public Optional<User> login(String email, String password) {
        if (ValidationUtil.isBlank(email) || ValidationUtil.isBlank(password)) {
            return Optional.empty();
        }
        Optional<User> found = userDAO.findByEmail(email.trim().toLowerCase());
        if (found.isEmpty()) return Optional.empty();

        User user = found.get();
        if (!user.isActive()) return Optional.empty();
        if (!PasswordUtil.verify(password, user.getPasswordHash())) return Optional.empty();

        return Optional.of(user);
    }

    /**
     * Registers a new passenger account.
     *
     * @return the generated user ID, or -1 if registration failed
     * @throws IllegalArgumentException if validation fails or email is already taken
     */
    public long register(String email, String password, String firstName, String lastName,
                         String phone) {
        email     = ValidationUtil.sanitise(email);
        firstName = ValidationUtil.sanitise(firstName);
        lastName  = ValidationUtil.sanitise(lastName);

        if (!ValidationUtil.isValidEmail(email)) {
            throw new IllegalArgumentException("Invalid email address.");
        }
        if (!ValidationUtil.isValidPassword(password)) {
            throw new IllegalArgumentException(
                "Password must be at least 8 characters with uppercase, lowercase, digit, and special character.");
        }
        if (ValidationUtil.isBlank(firstName) || ValidationUtil.isBlank(lastName)) {
            throw new IllegalArgumentException("First name and last name are required.");
        }
        if (userDAO.emailExists(email)) {
            throw new IllegalArgumentException("An account with that email address already exists.");
        }

        User user = new User();
        user.setEmail(email.toLowerCase());
        user.setPasswordHash(PasswordUtil.hash(password));
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(ValidationUtil.sanitise(phone));
        user.setRole(User.Role.PASSENGER);
        user.setActive(true);

        return userDAO.insert(user);
    }
}
