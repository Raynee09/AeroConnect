<%-- Public navigation bar — used on all public-facing pages --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar" role="navigation" aria-label="Main navigation">
    <div class="navbar-inner">
        <a href="${pageContext.request.contextPath}/" class="navbar-brand" aria-label="AeroConnect home">
            <div class="navbar-logo-icon" aria-hidden="true">✈</div>
            Aero<span>Connect</span>
        </a>

        <button id="nav-toggle" class="btn btn-sm btn-secondary" aria-expanded="false"
                aria-controls="nav-menu" aria-label="Toggle navigation"
                style="display:none">Menu</button>

        <ul class="navbar-nav" id="nav-menu" role="list">
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/flights/search">Search Flights</a></li>
            <c:if test="${not empty sessionScope.loggedInUser}">
                <c:choose>
                    <c:when test="${sessionScope.loggedInUser.admin}">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/passenger/dashboard">My Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/passenger/bookings">My Bookings</a></li>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </ul>

        <div class="navbar-actions">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser}">
                    <span class="text-small text-muted" style="margin-right: 4px">
                        ${sessionScope.loggedInUser.firstName}
                    </span>
                    <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-sm btn-secondary">
                        Sign Out
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/auth/login"    class="btn btn-sm btn-outline">Log In</a>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-sm btn-primary">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>
