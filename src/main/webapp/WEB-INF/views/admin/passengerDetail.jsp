<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>${passenger.fullName} — AeroConnect Admin</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<div class="admin-layout">
    <jsp:include page="../common/adminSidebar.jsp"/>
    <main class="admin-main" id="main-content">

        <div style="margin-bottom:1.5rem;">
            <a href="${pageContext.request.contextPath}/admin/passengers"
               class="btn btn-sm btn-secondary">← Back to Passengers</a>
        </div>

        <h1 class="page-title">${passenger.fullName}</h1>

        <div class="card" style="max-width:600px;">
            <div class="card-body">
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1.5rem;">
                    <div>
                        <div class="text-small text-muted">Email</div>
                        <div>${passenger.email}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Phone</div>
                        <div>${passenger.phone != null ? passenger.phone : '—'}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Date of Birth</div>
                        <div>${passenger.dateOfBirth != null ? passenger.dateOfBirth : '—'}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Passport</div>
                        <div>${passenger.passportNumber != null ? passenger.passportNumber : '—'}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Nationality</div>
                        <div>${passenger.nationality != null ? passenger.nationality : '—'}</div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Account Status</div>
                        <div>
                            <c:choose>
                                <c:when test="${passenger.active}">
                                    <span class="badge badge-confirmed">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-cancelled">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div>
                        <div class="text-small text-muted">Registered</div>
                        <div>
                            ${passenger.createdAtFormatted}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
