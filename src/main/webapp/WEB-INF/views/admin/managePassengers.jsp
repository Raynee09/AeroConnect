<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Manage Passengers — AeroConnect</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>
    <main class="admin-main" id="main-content">

        <h1 class="page-title">Manage Passengers</h1>

        <c:choose>
            <c:when test="${empty passengers}">
                <p class="text-muted">No passengers registered yet.</p>
            </c:when>
            <c:otherwise>
                <div class="table-wrapper">
                    <table class="data-table" aria-label="Passengers list">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Joined</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="passenger" items="${passengers}">
                                <tr>
                                    <td><strong>${passenger.fullName}</strong></td>
                                    <td>${passenger.email}</td>
                                    <td>${passenger.phone != null ? passenger.phone : '—'}</td>
                                    <td>
                                        ${passenger.createdAtFormatted}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${passenger.active}">
                                                <span class="badge badge-confirmed">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-cancelled">Inactive</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/passengers?id=${passenger.id}"
                                           class="btn btn-sm btn-outline">View</a>
                                        <c:if test="${passenger.active}">
                                            <form action="${pageContext.request.contextPath}/admin/passengers"
                                                  method="POST" style="display:inline;">
                                                <input type="hidden" name="action" value="deactivate">
                                                <input type="hidden" name="userId" value="${passenger.id}">
                                                <button type="submit" class="btn btn-sm btn-danger"
                                                        data-confirm="Deactivate this passenger's account?">
                                                    Deactivate
                                                </button>
                                            </form>
                                        </c:if>
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
