package com.aeroconnect.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * DateFormatUtil — formatting helpers for LocalDateTime used in JSP EL expressions.
 *
 * Since JSTL's fmt:formatDate only accepts java.util.Date, use these static methods
 * or expose formatted strings via model getters.
 */
public final class DateFormatUtil {

    public static final DateTimeFormatter DISPLAY_DATETIME =
            DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm");

    public static final DateTimeFormatter DISPLAY_DATE =
            DateTimeFormatter.ofPattern("dd MMM yyyy");

    public static final DateTimeFormatter DISPLAY_TIME =
            DateTimeFormatter.ofPattern("HH:mm");

    public static final DateTimeFormatter DISPLAY_DATETIME_LONG =
            DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");

    private DateFormatUtil() {}

    public static String formatDateTime(LocalDateTime dt) {
        return dt != null ? dt.format(DISPLAY_DATETIME) : "";
    }

    public static String formatDate(LocalDateTime dt) {
        return dt != null ? dt.format(DISPLAY_DATE) : "";
    }

    public static String formatTime(LocalDateTime dt) {
        return dt != null ? dt.format(DISPLAY_TIME) : "";
    }

    public static String formatDate(LocalDate d) {
        return d != null ? d.format(DISPLAY_DATE) : "";
    }
}
