package com.aeroconnect.util;

import java.security.SecureRandom;

/**
 * BookingReferenceUtil — generates unique, human-readable booking reference codes.
 * Format: ARC + 6 uppercase alphanumeric characters (e.g. ARCX4K2P9Q).
 */
public final class BookingReferenceUtil {

    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"; // Excludes O,0,1,I
    private static final int    LENGTH = 6;
    private static final SecureRandom RANDOM = new SecureRandom();

    private BookingReferenceUtil() {}

    public static String generate() {
        StringBuilder sb = new StringBuilder("ARC");
        for (int i = 0; i < LENGTH; i++) {
            sb.append(CHARS.charAt(RANDOM.nextInt(CHARS.length())));
        }
        return sb.toString();
    }
}
