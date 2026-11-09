<%-- Admin sidebar navigation — included in every admin view --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<aside class="admin-sidebar" role="complementary" aria-label="Admin navigation">
    <div class="sidebar-brand">Admin Panel</div>
    <ul class="sidebar-nav" role="list">
        <li>
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               aria-label="Dashboard">
                📊 Dashboard
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/flights"
               aria-label="Manage Flights">
                ✈ Manage Flights
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/passengers"
               aria-label="Manage Passengers">
                👤 Manage Passengers
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/bookings"
               aria-label="Manage Bookings">
                🎫 Manage Bookings
            </a>
        </li>
        <li style="margin-top: auto; border-top: 1px solid var(--color-gray-200); padding-top: 12px; margin-top: 24px;">
            <a href="${pageContext.request.contextPath}/auth/logout"
               aria-label="Sign out">
                🚪 Sign Out
            </a>
        </li>
    </ul>
</aside>
