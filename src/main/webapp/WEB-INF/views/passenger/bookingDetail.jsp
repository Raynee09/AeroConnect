<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Booking ${booking.bookingReference} — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container-narrow">

        <div style="margin-bottom:1.5rem;">
            <a href="${pageContext.request.contextPath}/passenger/bookings"
               class="btn btn-sm btn-secondary">← Back to Bookings</a>
        </div>

        <h1 class="page-title">Booking Details</h1>

        <div class="card">
            <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <span style="font-size:0.75rem; font-weight:600; color:var(--color-taupe); text-transform:uppercase;">
                        Reference
                    </span>
                    <div style="font-size:1.5rem; font-weight:700;">${booking.bookingReference}</div>
                </div>
                <span class="badge badge-${booking.status.name().toLowerCase()}" style="font-size:0.8rem; padding:0.4rem 0.8rem;">
                    ${booking.status}
                </span>
            </div>
            <div class="card-body">

                <!-- Route summary -->
                <div class="flight-card" style="border:none; box-shadow:none; padding:0; margin-bottom:1.5rem;">
                    <div class="flight-route">
                        <div class="flight-airport">
                            <div class="code">${booking.flight.originCode}</div>
                            <div class="city">${booking.flight.originCity}</div>
                        </div>
                        <div class="flight-arrow">
                            <div class="flight-arrow-line">✈</div>
                            <div class="duration">${booking.flight.durationFormatted}</div>
                        </div>
                        <div class="flight-airport">
                            <div class="code">${booking.flight.destinationCode}</div>
                            <div class="city">${booking.flight.destinationCity}</div>
                        </div>
                    </div>
                </div>

                <!-- Details grid -->
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.5rem;">
                    <div>
                        <div class="text-small text-muted">Flight Number</div>
                        <div style="font-weight:600;">${booking.flight.flightNumber}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Seat Class</div>
                        <div style="font-weight:600;">${booking.seatClass}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Departure</div>
                        <div style="font-weight:600;">
                            ${booking.flight.departureFormatted}
                        </div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Arrival</div>
                        <div style="font-weight:600;">
                            ${booking.flight.arrivalFormatted}
                        </div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Passengers</div>
                        <div style="font-weight:600;">${booking.numPassengers}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Booked On</div>
                        <div style="font-weight:600;">
                            ${booking.createdAtFormatted}
                        </div>
                    </div>
                </div>

                <hr class="divider">
                <div style="text-align:right;">
                    <div class="text-small text-muted">Total Price</div>
                    <div style="font-size:1.75rem; font-weight:700; color:var(--color-sky-dark);">
                        $<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
