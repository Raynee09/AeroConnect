<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Manage Flights — AeroConnect</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>
    <main class="admin-main" id="main-content">

        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1.5rem;">
            <h1 class="page-title" style="margin-bottom:0;">Manage Flights</h1>
            <a href="${pageContext.request.contextPath}/admin/flights?action=new" class="btn btn-primary">
                + Add Flight
            </a>
        </div>

        <c:choose>
            <c:when test="${empty flights}">
                <p class="text-muted">No flights in the system yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table class="data-table" aria-label="All flights">
                        <thead>
                            <tr>
                                <th>Flight #</th>
                                <th>Route</th>
                                <th>Aircraft</th>
                                <th>Departure</th>
                                <th>Arrival</th>
                                <th>Base Price</th>
                                <th>Avail. Economy</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="flight" items="${flights}">
                                <tr>
                                    <td><strong>${flight.flightNumber}</strong></td>
                                    <td>${flight.originCode} → ${flight.destinationCode}</td>
                                    <td>${flight.aircraft.model}</td>
                                    <td>
                                        ${flight.departureFormatted}
                                    </td>
                                    <td>
                                        ${flight.arrivalFormatted}
                                    </td>
                                    <td>$<fmt:formatNumber value="${flight.basePrice}" pattern="#,##0.00"/></td>
                                    <td>${flight.availableEconomy}</td>
                                    <td>
                                        <span class="badge badge-${flight.status.name().toLowerCase()}">
                                            ${flight.status}
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display:flex; gap:0.5rem; flex-wrap:wrap;">
                                            <a href="${pageContext.request.contextPath}/admin/flights?action=edit&id=${flight.id}"
                                               class="btn btn-sm btn-outline">Edit</a>
                                            <form action="${pageContext.request.contextPath}/admin/flights" method="POST"
                                                  style="display:inline;">
                                                <input type="hidden" name="action" value="updateStatus">
                                                <input type="hidden" name="flightId" value="${flight.id}">
                                                <select name="status" class="form-control"
                                                        style="width:auto; padding:0.25rem 0.5rem; font-size:0.75rem;"
                                                        onchange="this.form.submit()"
                                                        aria-label="Change flight status">
                                                    <c:forEach var="s" items="${['SCHEDULED','BOARDING','DEPARTED','ARRIVED','CANCELLED','DELAYED']}">
                                                        <option value="${s}" ${flight.status.name() == s ? 'selected' : ''}>${s}</option>
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
