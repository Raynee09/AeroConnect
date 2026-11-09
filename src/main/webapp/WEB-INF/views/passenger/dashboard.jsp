<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>My Dashboard — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container">

        <h1 class="page-title">
            Welcome back, ${sessionScope.loggedInUser.firstName}
        </h1>
        <p class="page-subtitle">Here's an overview of your travel activity.</p>

        <!-- Stats -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">🎫</div>
                <div class="stat-label">Total Bookings</div>
                <div class="stat-value">${totalBookings}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">✅</div>
                <div class="stat-label">Confirmed</div>
                <div class="stat-value">${confirmedCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">⏳</div>
                <div class="stat-label">Pending</div>
                <div class="stat-value">${pendingCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">❌</div>
                <div class="stat-label">Cancelled</div>
                <div class="stat-value">${cancelledCount}</div>
            </div>
        </div>

        <!-- Quick links -->
        <div style="display:flex; gap:1rem; margin-bottom:2rem; flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/flights/search" class="btn btn-primary">
                Search Flights
            </a>
            <a href="${pageContext.request.contextPath}/passenger/bookings" class="btn btn-outline">
                View All Bookings
            </a>
            <a href="${pageContext.request.contextPath}/passenger/profile" class="btn btn-secondary">
                My Profile
            </a>
        </div>

        <!-- Recent bookings -->
        <h2 class="section-title">Recent Bookings</h2>
        <c:choose>
            <c:when test="${empty recentBookings}">
                <div class="card">
                    <div class="card-body text-center" style="padding: 3rem;">
                        <p class="text-muted">You haven't made any bookings yet.</p>
                        <a href="${pageContext.request.contextPath}/flights/search"
                           class="btn btn-primary" style="margin-top:1rem;">
                            Book Your First Flight
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table class="data-table" aria-label="Recent bookings">
                        <thead>
                            <tr>
                                <th>Reference</th>
                                <th>Route</th>
                                <th>Departure</th>
                                <th>Class</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${recentBookings}">
                                <tr>
                                    <td><strong>${booking.bookingReference}</strong></td>
                                    <td>${booking.flight.originCode} → ${booking.flight.destinationCode}</td>
                                    <td>
                                        ${booking.flight.departureFormatted}
                                    </td>
                                    <td>${booking.seatClass}</td>
                                    <td>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge badge-${booking.status.name().toLowerCase()}">
                                            ${booking.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/passenger/bookings?id=${booking.id}"
                                           class="btn btn-sm btn-outline">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
