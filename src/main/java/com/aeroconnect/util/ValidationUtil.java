package com.aeroconnect.util;

import java.util.regex.Pattern;

/**
 * ValidationUtil — common input-validation helpers used across the application.
 */
public final class ValidationUtil {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");

    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[+]?[0-9\\s\\-().]{7,20}$");

    private static final Pattern PASSPORT_PATTERN =
            Pattern.compile("^[A-Z0-9]{6,12}$");

    // Password: min 8 chars, at least one uppercase, one lowercase, one digit, one special char
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&_#])[A-Za-z\\d@$!%*?&_#]{8,}$");

    private ValidationUtil() {}

    public static boolean isValidEmail(String email) {
        return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
    }

    public static boolean isValidPhone(String phone) {
        return phone == null || phone.isBlank() || PHONE_PATTERN.matcher(phone.trim()).matches();
    }

    public static boolean isValidPassport(String passport) {
        return passport == null || passport.isBlank()
                || PASSPORT_PATTERN.matcher(passport.trim().toUpperCase()).matches();
    }

    public static boolean isValidPassword(String password) {
        return password != null && PASSWORD_PATTERN.matcher(password).matches();
    }

    /**
     * Returns a sanitised, trimmed string or null if blank.
     */
    public static String sanitise(String input) {
        if (input == null) return null;
        String trimmed = input.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    public static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
