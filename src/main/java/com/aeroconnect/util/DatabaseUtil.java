package com.aeroconnect.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * DatabaseUtil — lightweight connection factory.
 *
 * Reads credentials from (in order of priority):
 *   1. Environment variables: AEROCONNECT_DB_URL, AEROCONNECT_DB_USER, AEROCONNECT_DB_PASSWORD
 *   2. Classpath resource: db.properties
 *
 * For a production deployment, consider replacing this with a JNDI DataSource
 * configured in Tomcat's context.xml.
 */
public final class DatabaseUtil {

    private static final Logger log = LoggerFactory.getLogger(DatabaseUtil.class);

    private static final String DB_URL;
    private static final String DB_USER;
    private static final String DB_PASSWORD;

    static {
        // Attempt to load from environment variables first
        String envUrl  = System.getenv("AEROCONNECT_DB_URL");
        String envUser = System.getenv("AEROCONNECT_DB_USER");
        String envPass = System.getenv("AEROCONNECT_DB_PASSWORD");

        if (envUrl != null && !envUrl.isBlank()) {
            DB_URL      = envUrl;
            DB_USER     = envUser != null ? envUser : "";
            DB_PASSWORD = envPass != null ? envPass : "";
            log.info("Database credentials loaded from environment variables.");
        } else {
            // Fall back to db.properties on the classpath
            Properties props = new Properties();
            try (InputStream in = DatabaseUtil.class.getClassLoader()
                    .getResourceAsStream("db.properties")) {
                if (in == null) {
                    throw new IllegalStateException(
                        "db.properties not found on classpath. " +
                        "Create src/main/resources/db.properties or set environment variables.");
                }
                props.load(in);
            } catch (IOException e) {
                throw new IllegalStateException("Failed to load db.properties", e);
            }
            DB_URL      = props.getProperty("db.url");
            DB_USER     = props.getProperty("db.username");
            DB_PASSWORD = props.getProperty("db.password");
            log.info("Database credentials loaded from db.properties.");
        }

        // Eagerly load the MySQL driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new IllegalStateException("MySQL JDBC driver not found on classpath.", e);
        }
    }

    private DatabaseUtil() {}

    /**
     * Opens and returns a new JDBC connection.
     * The caller is responsible for closing it (preferably via try-with-resources).
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    /**
     * Quietly closes a Connection, suppressing any SQLException.
     */
    public static void closeQuietly(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }

    /**
     * Rolls back a connection silently (used inside catch blocks).
     */
    public static void rollbackQuietly(Connection conn) {
        if (conn != null) {
            try { conn.rollback(); } catch (SQLException ignored) {}
        }
    }
}
