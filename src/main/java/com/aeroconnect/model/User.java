package com.aeroconnect.model;

import com.aeroconnect.util.DateFormatUtil;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * User model — maps to the `users` table.
 */
public class User {

    public enum Role { PASSENGER, ADMIN }

    private Long          id;
    private String        email;
    private String        passwordHash;
    private String        firstName;
    private String        lastName;
    private String        phone;
    private LocalDate     dateOfBirth;
    private String        passportNumber;
    private String        nationality;
    private Role          role;
    private boolean       active;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public User() {}

    // ---- derived helpers ----

    public String getFullName() {
        return firstName + " " + lastName;
    }

    public boolean isAdmin() {
        return Role.ADMIN.equals(role);
    }

    /** Returns createdAt as "dd MMM yyyy" — for use in JSP EL. */
    public String getCreatedAtFormatted() { return DateFormatUtil.formatDate(createdAt); }

    // ---- getters & setters ----

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getPassportNumber() { return passportNumber; }
    public void setPassportNumber(String passportNumber) { this.passportNumber = passportNumber; }

    public String getNationality() { return nationality; }
    public void setNationality(String nationality) { this.nationality = nationality; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
