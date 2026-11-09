package com.aeroconnect.model;

import com.aeroconnect.util.DateFormatUtil;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.Duration;

/**
 * Flight model — maps to the `flights` table.
 */
public class Flight {

    public enum Status {
        SCHEDULED, BOARDING, DEPARTED, ARRIVED, CANCELLED, DELAYED
    }

    private Long          id;
    private String        flightNumber;
    private Long          aircraftId;
    private Aircraft      aircraft;        // populated on JOIN queries
    private String        originCode;
    private String        originCity;
    private String        destinationCode;
    private String        destinationCity;
    private LocalDateTime departureTime;
    private LocalDateTime arrivalTime;
    private BigDecimal    basePrice;
    private Status        status;
    private int           availableEconomy;
    private int           availableBusiness;
    private int           availableFirst;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Flight() {}

    // ---- derived helpers ----

    public String getDurationFormatted() {
        if (departureTime == null || arrivalTime == null) return "N/A";
        Duration d = Duration.between(departureTime, arrivalTime);
        return d.toHours() + "h " + d.toMinutesPart() + "m";
    }

    /** Returns departure as "dd MMM yyyy HH:mm" — for use in JSP EL. */
    public String getDepartureFormatted() { return DateFormatUtil.formatDateTime(departureTime); }
    /** Returns arrival as "dd MMM yyyy HH:mm" — for use in JSP EL. */
    public String getArrivalFormatted()   { return DateFormatUtil.formatDateTime(arrivalTime); }
    /** Returns departure time only as "HH:mm". */
    public String getDepartureTime24()    { return DateFormatUtil.formatTime(departureTime); }
    /** Returns arrival time only as "HH:mm". */
    public String getArrivalTime24()      { return DateFormatUtil.formatTime(arrivalTime); }

    public boolean hasAvailableSeats(String seatClass) {
        return switch (seatClass.toUpperCase()) {
            case "ECONOMY"  -> availableEconomy  > 0;
            case "BUSINESS" -> availableBusiness > 0;
            case "FIRST"    -> availableFirst    > 0;
            default         -> false;
        };
    }

    // ---- getters & setters ----

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getFlightNumber() { return flightNumber; }
    public void setFlightNumber(String flightNumber) { this.flightNumber = flightNumber; }

    public Long getAircraftId() { return aircraftId; }
    public void setAircraftId(Long aircraftId) { this.aircraftId = aircraftId; }

    public Aircraft getAircraft() { return aircraft; }
    public void setAircraft(Aircraft aircraft) { this.aircraft = aircraft; }

    public String getOriginCode() { return originCode; }
    public void setOriginCode(String originCode) { this.originCode = originCode; }

    public String getOriginCity() { return originCity; }
    public void setOriginCity(String originCity) { this.originCity = originCity; }

    public String getDestinationCode() { return destinationCode; }
    public void setDestinationCode(String destinationCode) { this.destinationCode = destinationCode; }

    public String getDestinationCity() { return destinationCity; }
    public void setDestinationCity(String destinationCity) { this.destinationCity = destinationCity; }

    public LocalDateTime getDepartureTime() { return departureTime; }
    public void setDepartureTime(LocalDateTime departureTime) { this.departureTime = departureTime; }

    public LocalDateTime getArrivalTime() { return arrivalTime; }
    public void setArrivalTime(LocalDateTime arrivalTime) { this.arrivalTime = arrivalTime; }

    public BigDecimal getBasePrice() { return basePrice; }
    public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }

    public Status getStatus() { return status; }
    public void setStatus(Status status) { this.status = status; }

    public int getAvailableEconomy() { return availableEconomy; }
    public void setAvailableEconomy(int availableEconomy) { this.availableEconomy = availableEconomy; }

    public int getAvailableBusiness() { return availableBusiness; }
    public void setAvailableBusiness(int availableBusiness) { this.availableBusiness = availableBusiness; }

    public int getAvailableFirst() { return availableFirst; }
    public void setAvailableFirst(int availableFirst) { this.availableFirst = availableFirst; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
