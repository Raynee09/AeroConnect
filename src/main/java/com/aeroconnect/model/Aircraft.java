package com.aeroconnect.model;

import java.time.LocalDateTime;

/**
 * Aircraft model — maps to the `aircraft` table.
 */
public class Aircraft {

    private Long          id;
    private String        registration;
    private String        model;
    private String        manufacturer;
    private int           totalSeats;
    private int           economySeats;
    private int           businessSeats;
    private int           firstClassSeats;
    private boolean       active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Aircraft() {}

    // ---- getters & setters ----

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getRegistration() { return registration; }
    public void setRegistration(String registration) { this.registration = registration; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }

    public int getEconomySeats() { return economySeats; }
    public void setEconomySeats(int economySeats) { this.economySeats = economySeats; }

    public int getBusinessSeats() { return businessSeats; }
    public void setBusinessSeats(int businessSeats) { this.businessSeats = businessSeats; }

    public int getFirstClassSeats() { return firstClassSeats; }
    public void setFirstClassSeats(int firstClassSeats) { this.firstClassSeats = firstClassSeats; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
