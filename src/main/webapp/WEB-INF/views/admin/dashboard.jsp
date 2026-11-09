<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Admin Dashboard — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>

    <main class="admin-main" id="main-content">
        <h1 class="page-title">Admin Dashboard</h1>
        <p class="page-subtitle">System overview and recent activity.</p>

        <!-- Stats -->
        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">👤</div>
                <div class="stat-label">Total Passengers</div>
                <div class="stat-value">${totalPassengers}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">✈</div>
                <div class="stat-label">Total Flights</div>
                <div class="stat-value">${totalFlights}</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" aria-hidden="true">🎫</div>
                <div class="stat-label">Total Bookings</div>
                <div class="stat-value">${totalBookings}</div>
            </div>
        </div>

        <!-- Quick Links -->
        <div style="display:flex; gap:1rem; margin-bottom:2rem; flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/admin/flights?action=new" class="btn btn-primary">
                + Add Flight
            </a>
            <a href="${pageContext.request.contextPath}/admin/flights"    class="btn btn-outline">Manage Flights</a>
            <a href="${pageContext.request.contextPath}/admin/passengers" class="btn btn-outline">Manage Passengers</a>
            <a href="${pageContext.request.contextPath}/admin/bookings"   class="btn btn-outline">Manage Bookings</a>
        </div>

        <!-- Recent Bookings -->
        <h2 class="section-title">Recent Bookings</h2>
        <c:choose>
            <c:when test="${empty recentBookings}">
                <p class="text-muted">No bookings yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table class="data-table" aria-label="Recent bookings">
                        <thead>
                            <tr>
                                <th>Reference</th>
                                <th>Passenger</th>
                                <th>Route</th>
                                <th>Departure</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${recentBookings}">
                                <tr>
                                    <td><strong>${booking.bookingReference}</strong></td>
                                    <td>${booking.user.fullName}</td>
                                    <td>${booking.flight.originCode} → ${booking.flight.destinationCode}</td>
                                    <td>
                                        ${booking.flight.departureFormatted}
                                    </td>
                                    <td>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge badge-${booking.status.name().toLowerCase()}">
                                            ${booking.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/bookings?id=${booking.id}"
                                           class="btn btn-sm btn-outline">View</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </main>
</div>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
