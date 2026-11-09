<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Search Flights — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container">
        <h1 class="page-title">Search Flights</h1>
        <p class="page-subtitle">Enter your route and travel date to find available flights.</p>

        <!-- Search form -->
        <div class="card" style="margin-bottom: 2rem;">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/flights/search" method="GET"
                      style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 1rem; align-items: end;"
                      aria-label="Flight search form">
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label" for="search-origin">From (IATA code)</label>
                        <input type="text" id="search-origin" name="origin" class="form-control"
                               value="${origin}" placeholder="e.g. JFK" maxlength="3"
                               style="text-transform:uppercase" required aria-required="true">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label" for="search-dest">To (IATA code)</label>
                        <input type="text" id="search-dest" name="destination" class="form-control"
                               value="${destination}" placeholder="e.g. LAX" maxlength="3"
                               style="text-transform:uppercase" required aria-required="true">
                    </div>
                    <div class="form-group" style="margin-bottom:0">
                        <label class="form-label" for="search-date">Date</label>
                        <input type="date" id="search-date" name="date" class="form-control"
                               value="${date}" data-min-today required aria-required="true">
                    </div>
                    <button type="submit" class="btn btn-primary btn-lg" aria-label="Search">
                        Search
                    </button>
                </form>
            </div>
        </div>

        <!-- Results -->
        <c:if test="${not empty errorMsg}">
            <div class="alert alert-info" role="status">${errorMsg}</div>
        </c:if>

        <c:if test="${not empty flights}">
            <h2 class="section-title" style="font-size: 1.25rem; margin-bottom:1rem;">
                ${flights.size()} flight<c:if test="${flights.size() != 1}">s</c:if>
                found — ${origin} → ${destination}
            </h2>

            <div style="display: flex; flex-direction: column; gap: 1rem;">
                <c:forEach var="flight" items="${flights}">
                    <article class="flight-card" style="display:flex; align-items:center; gap:2rem;"
                             aria-label="Flight ${flight.flightNumber}">

                        <div style="min-width:90px;">
                            <div style="font-size:0.75rem; font-weight:600; color:var(--color-taupe); text-transform:uppercase;">
                                ${flight.flightNumber}
                            </div>
                            <div style="font-size:0.7rem; color:var(--color-taupe-light); margin-top:2px;">
                                ${flight.aircraft.model}
                            </div>
                        </div>

                        <div class="flight-route" style="flex:1; margin-bottom:0;">
                            <div class="flight-airport">
                                <div class="code">${flight.originCode}</div>
                                <div class="city">${flight.originCity}</div>
                                <div style="font-size:0.7rem; color:var(--color-taupe); margin-top:2px;">
                                    ${flight.departureTime24}
                                </div>
                            </div>
                            <div class="flight-arrow">
                                <div class="flight-arrow-line">✈</div>
                                <div class="duration">${flight.durationFormatted}</div>
                            </div>
                            <div class="flight-airport">
                                <div class="code">${flight.destinationCode}</div>
                                <div class="city">${flight.destinationCity}</div>
                                <div style="font-size:0.7rem; color:var(--color-taupe); margin-top:2px;">
                                    ${flight.arrivalTime24}
                                </div>
                            </div>
                        </div>

                        <div style="text-align:right; min-width:160px;">
                            <div style="font-size:1.5rem; font-weight:700; color:var(--color-sky-dark);">
                                $<fmt:formatNumber value="${flight.basePrice}" pattern="#,##0.00"/>
                            </div>
                            <div style="font-size:0.7rem; color:var(--color-taupe); margin-bottom:0.5rem;">
                                from / person
                            </div>
                            <c:choose>
                                <c:when test="${not empty sessionScope.loggedInUser}">
                                    <a href="${pageContext.request.contextPath}/passenger/bookings?flightId=${flight.id}"
                                       class="btn btn-accent btn-sm" aria-label="Book flight ${flight.flightNumber}">
                                        Book Now
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/auth/login?redirect=/passenger/bookings?flightId=${flight.id}"
                                       class="btn btn-accent btn-sm">
                                        Log in to Book
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </article>
                </c:forEach>
            </div>
        </c:if>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
