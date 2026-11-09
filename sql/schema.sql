-- ============================================================
-- AeroConnect — Database Schema
-- MySQL 8.x compatible
-- Run this script once to initialise the database.
-- ============================================================

CREATE DATABASE IF NOT EXISTS aeroconnect
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE aeroconnect;

-- ============================================================
-- users
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id            BIGINT          UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    email         VARCHAR(255)    NOT NULL UNIQUE,
    password_hash VARCHAR(72)     NOT NULL,         -- BCrypt hash (max 72 chars)
    first_name    VARCHAR(100)    NOT NULL,
    last_name     VARCHAR(100)    NOT NULL,
    phone         VARCHAR(20),
    date_of_birth DATE,
    passport_number VARCHAR(50),
    nationality   VARCHAR(100),
    role          ENUM('PASSENGER','ADMIN') NOT NULL DEFAULT 'PASSENGER',
    is_active     BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email),
    INDEX idx_users_role  (role)
) ENGINE=InnoDB;

-- ============================================================
-- aircraft
-- ============================================================
CREATE TABLE IF NOT EXISTS aircraft (
    id              BIGINT      UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    registration    VARCHAR(20) NOT NULL UNIQUE,
    model           VARCHAR(100) NOT NULL,
    manufacturer    VARCHAR(100) NOT NULL,
    total_seats     INT         NOT NULL,
    economy_seats   INT         NOT NULL,
    business_seats  INT         NOT NULL DEFAULT 0,
    first_class_seats INT       NOT NULL DEFAULT 0,
    is_active       BOOLEAN     NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_aircraft_registration (registration)
) ENGINE=InnoDB;

-- ============================================================
-- flights
-- ============================================================
CREATE TABLE IF NOT EXISTS flights (
    id                  BIGINT          UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    flight_number       VARCHAR(20)     NOT NULL UNIQUE,
    aircraft_id         BIGINT          UNSIGNED NOT NULL,
    origin_code         CHAR(3)         NOT NULL,   -- IATA airport code
    origin_city         VARCHAR(100)    NOT NULL,
    destination_code    CHAR(3)         NOT NULL,
    destination_city    VARCHAR(100)    NOT NULL,
    departure_time      DATETIME        NOT NULL,
    arrival_time        DATETIME        NOT NULL,
    base_price          DECIMAL(10,2)   NOT NULL,
    status              ENUM('SCHEDULED','BOARDING','DEPARTED','ARRIVED','CANCELLED','DELAYED')
                        NOT NULL DEFAULT 'SCHEDULED',
    available_economy   INT             NOT NULL,
    available_business  INT             NOT NULL DEFAULT 0,
    available_first     INT             NOT NULL DEFAULT 0,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_flights_aircraft FOREIGN KEY (aircraft_id)
        REFERENCES aircraft(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_flights_number         (flight_number),
    INDEX idx_flights_origin         (origin_code),
    INDEX idx_flights_destination    (destination_code),
    INDEX idx_flights_departure      (departure_time),
    INDEX idx_flights_status         (status)
) ENGINE=InnoDB;

-- ============================================================
-- seats
-- ============================================================
CREATE TABLE IF NOT EXISTS seats (
    id          BIGINT  UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    aircraft_id BIGINT  UNSIGNED NOT NULL,
    seat_number VARCHAR(5) NOT NULL,     -- e.g. 12A
    seat_class  ENUM('ECONOMY','BUSINESS','FIRST') NOT NULL DEFAULT 'ECONOMY',
    is_window   BOOLEAN NOT NULL DEFAULT FALSE,
    is_aisle    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_seats_aircraft FOREIGN KEY (aircraft_id)
        REFERENCES aircraft(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uq_seat_aircraft (aircraft_id, seat_number),
    INDEX idx_seats_aircraft (aircraft_id),
    INDEX idx_seats_class    (seat_class)
) ENGINE=InnoDB;

-- ============================================================
-- bookings
-- ============================================================
CREATE TABLE IF NOT EXISTS bookings (
    id              BIGINT          UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_reference VARCHAR(10)   NOT NULL UNIQUE,  -- e.g. ARC000001
    user_id         BIGINT          UNSIGNED NOT NULL,
    flight_id       BIGINT          UNSIGNED NOT NULL,
    seat_class      ENUM('ECONOMY','BUSINESS','FIRST') NOT NULL DEFAULT 'ECONOMY',
    num_passengers  INT             NOT NULL DEFAULT 1,
    total_price     DECIMAL(10,2)   NOT NULL,
    status          ENUM('PENDING','CONFIRMED','CANCELLED','COMPLETED')
                    NOT NULL DEFAULT 'PENDING',
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bookings_user   FOREIGN KEY (user_id)
        REFERENCES users(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_bookings_flight FOREIGN KEY (flight_id)
        REFERENCES flights(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_bookings_reference (booking_reference),
    INDEX idx_bookings_user      (user_id),
    INDEX idx_bookings_flight    (flight_id),
    INDEX idx_bookings_status    (status)
) ENGINE=InnoDB;

-- ============================================================
-- booking_seats  (which specific seat(s) each booking holds)
-- ============================================================
CREATE TABLE IF NOT EXISTS booking_seats (
    id          BIGINT  UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id  BIGINT  UNSIGNED NOT NULL,
    seat_id     BIGINT  UNSIGNED NOT NULL,
    passenger_name VARCHAR(200) NOT NULL,
    CONSTRAINT fk_bseats_booking FOREIGN KEY (booking_id)
        REFERENCES bookings(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bseats_seat    FOREIGN KEY (seat_id)
        REFERENCES seats(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY uq_booking_seat (booking_id, seat_id),
    INDEX idx_bseats_booking (booking_id),
    INDEX idx_bseats_seat    (seat_id)
) ENGINE=InnoDB;

-- ============================================================
-- payments
-- ============================================================
CREATE TABLE IF NOT EXISTS payments (
    id                  BIGINT          UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id          BIGINT          UNSIGNED NOT NULL,
    amount              DECIMAL(10,2)   NOT NULL,
    currency            CHAR(3)         NOT NULL DEFAULT 'USD',
    method              ENUM('CREDIT_CARD','DEBIT_CARD','BANK_TRANSFER','WALLET')
                        NOT NULL DEFAULT 'CREDIT_CARD',
    status              ENUM('PENDING','COMPLETED','FAILED','REFUNDED')
                        NOT NULL DEFAULT 'PENDING',
    transaction_ref     VARCHAR(100),
    paid_at             TIMESTAMP       NULL,
    created_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_payments_booking FOREIGN KEY (booking_id)
        REFERENCES bookings(id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_payments_booking (booking_id),
    INDEX idx_payments_status  (status)
) ENGINE=InnoDB;

-- ============================================================
-- boarding_passes
-- ============================================================
CREATE TABLE IF NOT EXISTS boarding_passes (
    id              BIGINT      UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id      BIGINT      UNSIGNED NOT NULL,
    seat_id         BIGINT      UNSIGNED NOT NULL,
    passenger_name  VARCHAR(200) NOT NULL,
    barcode         VARCHAR(100) NOT NULL UNIQUE,
    gate            VARCHAR(10),
    boarding_time   DATETIME    NULL,
    issued_at       TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bp_booking FOREIGN KEY (booking_id)
        REFERENCES bookings(id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_bp_seat    FOREIGN KEY (seat_id)
        REFERENCES seats(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_bp_booking  (booking_id),
    INDEX idx_bp_barcode  (barcode)
) ENGINE=InnoDB;


-- ============================================================
-- SEED DATA
-- ============================================================

-- Admin user  (password: Admin@123)
-- Hash generated with BCrypt cost 12 — replace if you change the password.
INSERT INTO users (email, password_hash, first_name, last_name, role) VALUES
('admin@aeroconnect.com',
 '$2a$12$K8fIfRIBRtLSXuUzONwDX.F2U9ZrEHxExkdCWOWJRBdnb3CXN30KW',
 'System', 'Admin', 'ADMIN')
ON DUPLICATE KEY UPDATE id = id;

-- Sample passenger (password: Pass@1234)
INSERT INTO users (email, password_hash, first_name, last_name, phone, role) VALUES
('john.doe@example.com',
 '$2a$12$Wl5dAh7j1OKNNTGqjMZ4d.HwJBPq2m2Y.wRJHJ3VgqpjU0HlN5wIC',
 'John', 'Doe', '+1-555-0101', 'PASSENGER')
ON DUPLICATE KEY UPDATE id = id;

-- Aircraft
INSERT INTO aircraft (registration, model, manufacturer, total_seats, economy_seats, business_seats, first_class_seats) VALUES
('AC-737-001', 'Boeing 737-800',  'Boeing',   162, 144, 18, 0),
('AC-320-001', 'Airbus A320neo', 'Airbus',   150, 132, 18, 0),
('AC-777-001', 'Boeing 777-300', 'Boeing',   368, 304, 48, 16),
('AC-321-001', 'Airbus A321XLR','Airbus',   180, 156, 24, 0)
ON DUPLICATE KEY UPDATE id = id;

-- Flights (sample data — adjust dates to future dates as needed)
INSERT INTO flights
  (flight_number, aircraft_id, origin_code, origin_city, destination_code, destination_city,
   departure_time, arrival_time, base_price, status, available_economy, available_business, available_first)
VALUES
  ('AC101', 1, 'JFK', 'New York',     'LAX', 'Los Angeles',
   DATE_ADD(NOW(), INTERVAL 3 DAY),  DATE_ADD(NOW(), INTERVAL 3 DAY) + INTERVAL 6 HOUR,
   199.99, 'SCHEDULED', 144, 18, 0),

  ('AC202', 2, 'LAX', 'Los Angeles',  'ORD', 'Chicago',
   DATE_ADD(NOW(), INTERVAL 4 DAY),  DATE_ADD(NOW(), INTERVAL 4 DAY) + INTERVAL 4 HOUR,
   149.99, 'SCHEDULED', 132, 18, 0),

  ('AC303', 3, 'JFK', 'New York',     'LHR', 'London',
   DATE_ADD(NOW(), INTERVAL 5 DAY),  DATE_ADD(NOW(), INTERVAL 6 DAY) - INTERVAL 2 HOUR,
   599.99, 'SCHEDULED', 304, 48, 16),

  ('AC404', 4, 'ORD', 'Chicago',      'MIA', 'Miami',
   DATE_ADD(NOW(), INTERVAL 6 DAY),  DATE_ADD(NOW(), INTERVAL 6 DAY) + INTERVAL 3 HOUR,
   129.99, 'SCHEDULED', 156, 24, 0),

  ('AC505', 1, 'MIA', 'Miami',        'JFK', 'New York',
   DATE_ADD(NOW(), INTERVAL 7 DAY),  DATE_ADD(NOW(), INTERVAL 7 DAY) + INTERVAL 3 HOUR,
   139.99, 'SCHEDULED', 140, 16, 0),

  ('AC606', 2, 'LHR', 'London',       'CDG', 'Paris',
   DATE_ADD(NOW(), INTERVAL 8 DAY),  DATE_ADD(NOW(), INTERVAL 8 DAY) + INTERVAL 1 HOUR,
   99.99,  'SCHEDULED', 130, 18, 0),

  ('AC707', 3, 'CDG', 'Paris',        'DXB', 'Dubai',
   DATE_ADD(NOW(), INTERVAL 9 DAY),  DATE_ADD(NOW(), INTERVAL 9 DAY) + INTERVAL 7 HOUR,
   449.99, 'SCHEDULED', 300, 45, 14),

  ('AC808', 4, 'DXB', 'Dubai',        'SIN', 'Singapore',
   DATE_ADD(NOW(), INTERVAL 10 DAY), DATE_ADD(NOW(), INTERVAL 10 DAY) + INTERVAL 7 HOUR,
   399.99, 'SCHEDULED', 155, 22, 0)
ON DUPLICATE KEY UPDATE id = id;

-- Generate seats for aircraft 1 (Boeing 737-800 — 162 seats: 18 business + 144 economy)
-- Business: rows 1-3 (A-F = 18 seats)
INSERT INTO seats (aircraft_id, seat_number, seat_class, is_window, is_aisle) VALUES
(1,'1A','BUSINESS',TRUE,FALSE),(1,'1B','BUSINESS',FALSE,TRUE),(1,'1C','BUSINESS',FALSE,FALSE),
(1,'1D','BUSINESS',FALSE,FALSE),(1,'1E','BUSINESS',FALSE,TRUE),(1,'1F','BUSINESS',TRUE,FALSE),
(1,'2A','BUSINESS',TRUE,FALSE),(1,'2B','BUSINESS',FALSE,TRUE),(1,'2C','BUSINESS',FALSE,FALSE),
(1,'2D','BUSINESS',FALSE,FALSE),(1,'2E','BUSINESS',FALSE,TRUE),(1,'2F','BUSINESS',TRUE,FALSE),
(1,'3A','BUSINESS',TRUE,FALSE),(1,'3B','BUSINESS',FALSE,TRUE),(1,'3C','BUSINESS',FALSE,FALSE),
(1,'3D','BUSINESS',FALSE,FALSE),(1,'3E','BUSINESS',FALSE,TRUE),(1,'3F','BUSINESS',TRUE,FALSE)
ON DUPLICATE KEY UPDATE id = id;

-- Economy rows 4–27 for aircraft 1 (24 rows × 6 = 144 seats)
INSERT INTO seats (aircraft_id, seat_number, seat_class, is_window, is_aisle)
SELECT 1,
       CONCAT(r.rn, c.col),
       'ECONOMY',
       c.col IN ('A','F'),
       c.col IN ('C','D')
FROM
  (SELECT 4 AS rn UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
   UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
   UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION SELECT 21
   UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27) r
CROSS JOIN
  (SELECT 'A' AS col UNION SELECT 'B' UNION SELECT 'C' UNION SELECT 'D' UNION SELECT 'E' UNION SELECT 'F') c
ON DUPLICATE KEY UPDATE id = id;
