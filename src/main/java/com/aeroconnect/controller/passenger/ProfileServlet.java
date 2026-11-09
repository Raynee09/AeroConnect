package com.aeroconnect.controller.passenger;

import com.aeroconnect.dao.UserDAO;
import com.aeroconnect.model.User;
import com.aeroconnect.util.PasswordUtil;
import com.aeroconnect.util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 * ProfileServlet — view and update a passenger's profile at /passenger/profile.
 */
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user   = (User) req.getSession().getAttribute("loggedInUser");
        String action = req.getParameter("action");

        if ("updateProfile".equals(action)) {
            handleUpdateProfile(req, resp, user);
        } else if ("changePassword".equals(action)) {
            handleChangePassword(req, resp, user);
        } else {
            resp.sendRedirect(req.getContextPath() + "/passenger/profile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {

        String firstName = ValidationUtil.sanitise(req.getParameter("firstName"));
        String lastName  = ValidationUtil.sanitise(req.getParameter("lastName"));
        String phone     = ValidationUtil.sanitise(req.getParameter("phone"));
        String passport  = ValidationUtil.sanitise(req.getParameter("passportNumber"));
        String nationality = ValidationUtil.sanitise(req.getParameter("nationality"));
        String dobStr    = req.getParameter("dateOfBirth");

        if (ValidationUtil.isBlank(firstName) || ValidationUtil.isBlank(lastName)) {
            req.setAttribute("profileError", "First and last name are required.");
            req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
            return;
        }

        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setPhone(phone);
        user.setPassportNumber(passport);
        user.setNationality(nationality);

        if (dobStr != null && !dobStr.isBlank()) {
            try {
                user.setDateOfBirth(LocalDate.parse(dobStr));
            } catch (DateTimeParseException ignored) {}
        }

        boolean updated = userDAO.update(user);
        if (updated) {
            req.getSession().setAttribute("loggedInUser", user);
            req.setAttribute("profileSuccess", "Profile updated successfully.");
        } else {
            req.setAttribute("profileError", "Failed to update profile. Please try again.");
        }
        req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {

        String current = req.getParameter("currentPassword");
        String newPwd  = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        if (!PasswordUtil.verify(current, user.getPasswordHash())) {
            req.setAttribute("passwordError", "Current password is incorrect.");
            req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
            return;
        }
        if (!ValidationUtil.isValidPassword(newPwd)) {
            req.setAttribute("passwordError",
                "New password must be at least 8 characters with uppercase, lowercase, digit, and special character.");
            req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
            return;
        }
        if (!newPwd.equals(confirm)) {
            req.setAttribute("passwordError", "Passwords do not match.");
            req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
            return;
        }

        boolean changed = userDAO.updatePassword(user.getId(), PasswordUtil.hash(newPwd));
        if (changed) {
            user.setPasswordHash(PasswordUtil.hash(newPwd));
            req.getSession().setAttribute("loggedInUser", user);
            req.setAttribute("passwordSuccess", "Password changed successfully.");
        } else {
            req.setAttribute("passwordError", "Failed to change password. Please try again.");
        }
        req.getRequestDispatcher("/WEB-INF/views/passenger/profile.jsp").forward(req, resp);
    }
}
