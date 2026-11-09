package com.aeroconnect.model;

import com.aeroconnect.util.DateFormatUtil;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Booking model — maps to the `bookings` table.
 */
public class Booking {

    public enum Status { PENDING, CONFIRMED, CANCELLED, COMPLETED }
    public enum SeatClass { ECONOMY, BUSINESS, FIRST }

    private Long          id;
    private String        bookingReference;
    private Long          userId;
    private User          user;            // populated on JOIN
    private Long          flightId;
    private Flight        flight;          // populated on JOIN
    private SeatClass     seatClass;
    private int           numPassengers;
    private BigDecimal    totalPrice;
    private Status        status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Booking() {}

    /** Returns booking creation date as "dd MMM yyyy" — for use in JSP EL. */
    public String getCreatedAtFormatted() { return DateFormatUtil.formatDate(createdAt); }

    // ---- getters & setters ----

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getBookingReference() { return bookingReference; }
    public void setBookingReference(String bookingReference) { this.bookingReference = bookingReference; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public Long getFlightId() { return flightId; }
    public void setFlightId(Long flightId) { this.flightId = flightId; }

    public Flight getFlight() { return flight; }
    public void setFlight(Flight flight) { this.flight = flight; }

    public SeatClass getSeatClass() { return seatClass; }
    public void setSeatClass(SeatClass seatClass) { this.seatClass = seatClass; }

    public int getNumPassengers() { return numPassengers; }
    public void setNumPassengers(int numPassengers) { this.numPassengers = numPassengers; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
