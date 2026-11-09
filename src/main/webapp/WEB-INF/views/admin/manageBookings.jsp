<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Manage Bookings — AeroConnect</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>
    <main class="admin-main" id="main-content">

        <h1 class="page-title">Manage Bookings</h1>

        <c:choose>
            <c:when test="${empty bookings}">
                <p class="text-muted">No bookings in the system yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table class="data-table" aria-label="All bookings">
                        <thead>
                            <tr>
                                <th>Reference</th>
                                <th>Passenger</th>
                                <th>Route</th>
                                <th>Flight</th>
                                <th>Departure</th>
                                <th>Passengers</th>
                                <th>Total</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td><strong>${booking.bookingReference}</strong></td>
                                    <td>${booking.user.fullName}</td>
                                    <td>${booking.flight.originCode} → ${booking.flight.destinationCode}</td>
                                    <td>${booking.flight.flightNumber}</td>
                                    <td>
                                        ${booking.flight.departureFormatted}
                                    </td>
                                    <td>${booking.numPassengers}</td>
                                    <td>$<fmt:formatNumber value="${booking.totalPrice}" pattern="#,##0.00"/></td>
                                    <td>
                                        <span class="badge badge-${booking.status.name().toLowerCase()}">
                                            ${booking.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display:flex; gap:0.5rem; flex-wrap:wrap;">
                                            <a href="${pageContext.request.contextPath}/admin/bookings?id=${booking.id}"
                                               class="btn btn-sm btn-outline">View</a>
                                            <form action="${pageContext.request.contextPath}/admin/bookings"
                                                  method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="bookingId" value="${booking.id}">
                                                <select name="status" class="form-control"
                                                        style="width:auto; padding:0.25rem 0.5rem; font-size:0.75rem;"
                                                        onchange="this.form.submit()"
                                                        aria-label="Change booking status">
                                                    <c:forEach var="s" items="${['PENDING','CONFIRMED','CANCELLED','COMPLETED']}">
                                                        <option value="${s}" ${booking.status.name() == s ? 'selected' : ''}>${s}</option>
                                                    </c:forEach>
                                                </select>
                                            </form>
                                        </div>
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
