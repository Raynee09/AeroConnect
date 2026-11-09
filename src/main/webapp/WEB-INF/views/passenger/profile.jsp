<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>My Profile — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container-narrow">

        <h1 class="page-title">My Profile</h1>
        <p class="page-subtitle">Update your personal information and password.</p>

        <!-- Profile form -->
        <div class="card" style="margin-bottom:1.5rem;">
            <div class="card-header"><strong>Personal Information</strong></div>
            <div class="card-body">

                <c:if test="${not empty profileSuccess}">
                    <div class="alert alert-success" data-auto-dismiss>${profileSuccess}</div>
                </c:if>
                <c:if test="${not empty profileError}">
                    <div class="alert alert-error">${profileError}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/passenger/profile" method="POST"
                      aria-label="Profile update form">
                    <input type="hidden" name="action" value="updateProfile">

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                        <div class="form-group">
                            <label class="form-label" for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" class="form-control"
                                   value="${sessionScope.loggedInUser.firstName}" required aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" class="form-control"
                                   value="${sessionScope.loggedInUser.lastName}" required aria-required="true">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               value="${sessionScope.loggedInUser.phone}" autocomplete="tel">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control"
                               value="${sessionScope.loggedInUser.dateOfBirth}">
                    </div>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                        <div class="form-group">
                            <label class="form-label" for="passportNumber">Passport Number</label>
                            <input type="text" id="passportNumber" name="passportNumber" class="form-control"
                                   value="${sessionScope.loggedInUser.passportNumber}"
                                   style="text-transform:uppercase">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="nationality">Nationality</label>
                            <input type="text" id="nationality" name="nationality" class="form-control"
                                   value="${sessionScope.loggedInUser.nationality}">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </form>
            </div>
        </div>

        <!-- Password form -->
        <div class="card">
            <div class="card-header"><strong>Change Password</strong></div>
            <div class="card-body">

                <c:if test="${not empty passwordSuccess}">
                    <div class="alert alert-success" data-auto-dismiss>${passwordSuccess}</div>
                </c:if>
                <c:if test="${not empty passwordError}">
                    <div class="alert alert-error">${passwordError}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/passenger/profile" method="POST"
                      aria-label="Change password form">
                    <input type="hidden" name="action" value="changePassword">

                    <div class="form-group">
                        <label class="form-label" for="currentPassword">Current Password</label>
                        <input type="password" id="currentPassword" name="currentPassword"
                               class="form-control" required autocomplete="current-password" aria-required="true">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword"
                               class="form-control" required autocomplete="new-password" aria-required="true">
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm New Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               class="form-control" required autocomplete="new-password" aria-required="true">
                    </div>

                    <button type="submit" class="btn btn-primary">Update Password</button>
                </form>
            </div>
        </div>

    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
