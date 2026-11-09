<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>${editMode ? 'Edit' : 'New'} Flight — AeroConnect</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>
    <main class="admin-main" id="main-content">

        <div style="margin-bottom:1.5rem;">
            <a href="${pageContext.request.contextPath}/admin/flights"
               class="btn btn-sm btn-secondary">← Back to Flights</a>
        </div>

        <h1 class="page-title">${editMode ? 'Edit Flight' : 'Add New Flight'}</h1>

        <div class="card" style="max-width:680px;">
            <div class="card-body">
                <%-- Flight form — action will be wired to BookingServlet in next phase --%>
                <p class="alert alert-info">
                    Flight create/edit form will be wired to full CRUD in the next implementation phase.
                    The form structure and routing are ready.
                </p>

                <c:if test="${editMode && not empty flight}">
                    <div style="margin-bottom:1.5rem;">
                        <strong>Flight Number:</strong> ${flight.flightNumber}<br>
                        <strong>Route:</strong> ${flight.originCode} → ${flight.destinationCode}<br>
                        <strong>Status:</strong>
                        <span class="badge badge-${flight.status.name().toLowerCase()}">${flight.status}</span>
                    </div>
                </c:if>

                <form method="POST" aria-label="Flight form">
                    <input type="hidden" name="action" value="${editMode ? 'update' : 'create'}">
                    <c:if test="${editMode}"><input type="hidden" name="flightId" value="${flight.id}"></c:if>

                    <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem;">
                        <div class="form-group">
                            <label class="form-label" for="flightNumber">Flight Number</label>
                            <input type="text" id="flightNumber" name="flightNumber" class="form-control"
                                   value="${flight.flightNumber}" required aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="basePrice">Base Price (USD)</label>
                            <input type="number" id="basePrice" name="basePrice" class="form-control"
                                   value="${flight.basePrice}" min="0" step="0.01" required aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="originCode">Origin (IATA)</label>
                            <input type="text" id="originCode" name="originCode" class="form-control"
                                   value="${flight.originCode}" maxlength="3" style="text-transform:uppercase"
                                   required aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="destinationCode">Destination (IATA)</label>
                            <input type="text" id="destinationCode" name="destinationCode" class="form-control"
                                   value="${flight.destinationCode}" maxlength="3" style="text-transform:uppercase"
                                   required aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="departureTime">Departure Time</label>
                            <input type="datetime-local" id="departureTime" name="departureTime"
                                   class="form-control" required aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="arrivalTime">Arrival Time</label>
                            <input type="datetime-local" id="arrivalTime" name="arrivalTime"
                                   class="form-control" required aria-required="true">
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary">
                        ${editMode ? 'Update Flight' : 'Create Flight'}
                    </button>
                </form>
            </div>
        </div>
    </main>
</div>
<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
