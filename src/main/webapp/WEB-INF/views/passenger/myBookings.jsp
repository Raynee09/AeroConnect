<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>My Bookings — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container">

        <h1 class="page-title">My Bookings</h1>
        <p class="page-subtitle">All your flight reservations in one place.</p>

        <c:choose>
            <c:when test="${empty bookings}">
                <div class="card">
                    <div class="card-body text-center" style="padding:3rem;">
                        <p class="text-muted">You have no bookings yet.</p>
                        <a href="${pageContext.request.contextPath}/flights/search"
                           class="btn btn-primary" style="margin-top:1rem;">
                            Search Flights
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table class="data-table" aria-label="My bookings">
                        <thead>
                            <tr>
                                <th>Reference</th>
                                <th>Flight</th>
                                <th>Route</th>
                                <th>Departure</th>
                                <th>Passengers</th>
                                <th>Class</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td><strong>${booking.bookingReference}</strong></td>
                                    <td>${booking.flight.flightNumber}</td>
                                    <td>${booking.flight.originCode} → ${booking.flight.destinationCode}</td>
                                    <td>
                                        ${booking.flight.departureFormatted}
                                    </td>
                                    <td>${booking.numPassengers}</td>
                                    <td>${booking.seatClass}</td>
                                    <td>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge badge-${booking.status.name().toLowerCase()}">
                                            ${booking.status}
                                        </span>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/passenger/bookings?id=${booking.id}"
                                           class="btn btn-sm btn-outline">Details</a>
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
