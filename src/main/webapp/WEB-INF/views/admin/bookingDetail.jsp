<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Booking ${booking.bookingReference} — AeroConnect Admin</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>
    <main class="admin-main" id="main-content">

        <div style="margin-bottom:1.5rem;">
            <a href="${pageContext.request.contextPath}/admin/bookings"
               class="btn btn-sm btn-secondary">← Back to Bookings</a>
        </div>

        <h1 class="page-title">Booking: ${booking.bookingReference}</h1>

        <div class="card" style="max-width:680px;">
            <div class="card-header" style="display:flex; justify-content:space-between;">
                <strong>Booking Details</strong>
                <span class="badge badge-${booking.status.name().toLowerCase()}">${booking.status}</span>
            </div>
            <div class="card-body">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.5rem; margin-bottom:1.5rem;">
                    <div>
                        <div class="text-small text-muted">Passenger</div>
                        <div><strong>${booking.user.fullName}</strong></div>
                        <div class="text-small">${booking.user.email}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Flight</div>
                        <div><strong>${booking.flight.flightNumber}</strong></div>
                        <div class="text-small">${booking.flight.originCode} → ${booking.flight.destinationCode}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Departure</div>
                        <div>${booking.flight.departureFormatted}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Arrival</div>
                        <div>${booking.flight.arrivalFormatted}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Seat Class</div>
                        <div>${booking.seatClass}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Passengers</div>
                        <div>${booking.numPassengers}</div>
                    </div>
                </div>

                <hr class="divider">

                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div>
                        <div class="text-small text-muted">Total Price</div>
                        <div style="font-size:1.5rem; font-weight:700; color:var(--color-sky-dark);">
                            $<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/admin/bookings" method="POST">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="bookingId" value="${booking.id}">
                        <div style="display:flex; gap:0.5rem; align-items:center;">
                            <select name="status" class="form-control" style="width:auto;"
                                    aria-label="Update booking status">
                                <option value="PENDING"   ${booking.status.name() == 'PENDING'   ? 'selected' : ''}>PENDING</option>
                                <option value="CONFIRMED" ${booking.status.name() == 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                                <option value="CANCELLED" ${booking.status.name() == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                                <option value="COMPLETED" ${booking.status.name() == 'COMPLETED' ? 'selected' : ''}>COMPLETED</option>
                            </select>
                            <button type="submit" class="btn btn-primary">Update</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>
</div>
<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
