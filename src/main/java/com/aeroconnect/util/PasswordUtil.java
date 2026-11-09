package com.aeroconnect.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * PasswordUtil — wraps BCrypt hashing and verification.
 *
 * Cost factor 12 is a reasonable default for 2024 hardware.
 * Increase to 13 or 14 for higher security (at the cost of login latency).
 */
public final class PasswordUtil {

    private static final int BCRYPT_COST = 12;

    private PasswordUtil() {}

    /**
     * Hashes a plain-text password using BCrypt.
     *
     * @param plainPassword the raw password entered by the user
     * @return the BCrypt hash string to store in the database
     */
    public static String hash(String plainPassword) {
        return BCrypt.withDefaults().hashToString(BCRYPT_COST, plainPassword.toCharArray());
    }

    /**
     * Verifies a plain-text password against a stored BCrypt hash.
     *
     * @param plainPassword the raw password to check
     * @param hash          the stored hash from the database
     * @return true if they match
     */
    public static boolean verify(String plainPassword, String hash) {
        BCrypt.Result result = BCrypt.verifyer().verify(plainPassword.toCharArray(), hash);
        return result.verified;
    }
}
