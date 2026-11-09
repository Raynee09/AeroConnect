<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>AeroConnect — Airline Reservation</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<!-- Hero -->
<section style="background: linear-gradient(135deg, #4aaacf 0%, #70C4E2 60%, #c2e8f5 100%);
                padding: 5rem 0 4rem; color: white; text-align: center;">
    <div class="container">
        <p style="font-size: 0.85rem; font-weight: 600; letter-spacing: 0.1em; text-transform: uppercase;
                  opacity: 0.85; margin-bottom: 1rem;">Welcome to AeroConnect</p>
        <h1 style="font-size: 3rem; font-weight: 700; margin-bottom: 1rem; line-height: 1.1;">
            Fly Anywhere.<br>Book Effortlessly.
        </h1>
        <p style="font-size: 1.15rem; opacity: 0.9; max-width: 500px; margin: 0 auto 2.5rem;">
            Search hundreds of routes and book your next journey in minutes.
        </p>

        <!-- Quick search form -->
        <div style="background: white; border-radius: 16px; padding: 2rem 2.5rem;
                    max-width: 700px; margin: 0 auto; box-shadow: 0 8px 32px rgba(0,0,0,0.12);">
            <form action="${pageContext.request.contextPath}/flights/search" method="GET"
                  style="display: grid; grid-template-columns: 1fr 1fr 1fr auto; gap: 1rem; align-items: end;">
                <div class="form-group" style="margin-bottom:0">
                    <label class="form-label" style="color: var(--color-taupe-dark)" for="home-origin">From</label>
                    <input type="text" id="home-origin" name="origin" class="form-control"
                           placeholder="e.g. JFK" maxlength="3" pattern="[A-Za-z]{3}"
                           style="text-transform:uppercase" required aria-required="true">
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label class="form-label" style="color: var(--color-taupe-dark)" for="home-dest">To</label>
                    <input type="text" id="home-dest" name="destination" class="form-control"
                           placeholder="e.g. LAX" maxlength="3" pattern="[A-Za-z]{3}"
                           style="text-transform:uppercase" required aria-required="true">
                </div>
                <div class="form-group" style="margin-bottom:0">
                    <label class="form-label" style="color: var(--color-taupe-dark)" for="home-date">Date</label>
                    <input type="date" id="home-date" name="date" class="form-control"
                           data-min-today required aria-required="true">
                </div>
                <button type="submit" class="btn btn-accent btn-lg" aria-label="Search flights">
                    Search
                </button>
            </form>
        </div>
    </div>
</section>

<!-- Upcoming Flights -->
<main class="main-content" id="main-content">
    <div class="container">
        <h2 class="section-title">Upcoming Flights</h2>

        <c:choose>
            <c:when test="${empty upcomingFlights}">
                <p class="text-muted">No upcoming flights available. Check back soon.</p>
            </c:when>
            <c:otherwise>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.25rem;">
                    <c:forEach var="flight" items="${upcomingFlights}">
                        <article class="flight-card" aria-label="Flight ${flight.flightNumber}">
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:1rem;">
                                <span style="font-size:0.75rem; font-weight:600; color:var(--color-taupe);
                                             text-transform:uppercase; letter-spacing:0.05em;">
                                    ${flight.flightNumber}
                                </span>
                                <span class="badge badge-${flight.status.name().toLowerCase()}">${flight.status}</span>
                            </div>
                            <div class="flight-route">
                                <div class="flight-airport">
                                    <div class="code">${flight.originCode}</div>
                                    <div class="city">${flight.originCity}</div>
                                </div>
                                <div class="flight-arrow">
                                    <div class="flight-arrow-line">✈</div>
                                    <div class="duration">${flight.durationFormatted}</div>
                                </div>
                                <div class="flight-airport">
                                    <div class="code">${flight.destinationCode}</div>
                                    <div class="city">${flight.destinationCity}</div>
                                </div>
                            </div>
                            <div style="display:flex; justify-content:space-between; align-items:center;
                                        border-top: 1px solid var(--color-gray-200); padding-top: 1rem; margin-top:0.5rem;">
                                <div>
                                    <div style="font-size:0.75rem; color:var(--color-taupe);">Departure</div>
                                    <div style="font-weight:600; font-size:0.875rem;">
                                        ${flight.departureFormatted}
                                    </div>
                                </div>
                                <div style="text-align:right">
                                    <div style="font-size:0.75rem; color:var(--color-taupe);">From</div>
                                    <div style="font-size:1.25rem; font-weight:700; color:var(--color-sky-dark);">
                                        $<fmt:formatNumber value="${flight.basePrice}" pattern="#,##0.00"/>
                                    </div>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>

                <div class="text-center mt-8">
                    <a href="${pageContext.request.contextPath}/flights/search" class="btn btn-outline btn-lg">
                        View All Flights
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
