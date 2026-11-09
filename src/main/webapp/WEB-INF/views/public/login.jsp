<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Log In — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container-narrow" style="padding-top: 3rem; padding-bottom: 3rem;">

        <div style="text-align:center; margin-bottom: 2rem;">
            <div style="font-size:2.5rem; margin-bottom:0.5rem;" aria-hidden="true">✈</div>
            <h1 class="page-title" style="font-size: 1.75rem;">Welcome back</h1>
            <p class="page-subtitle" style="margin-bottom:0">Sign in to your AeroConnect account</p>
        </div>

        <div class="card">
            <div class="card-body">

                <%-- Registration success flash --%>
                <c:if test="${not empty sessionScope.registrationSuccess}">
                    <div class="alert alert-success" data-auto-dismiss>
                        ${sessionScope.registrationSuccess}
                    </div>
                    <c:remove var="registrationSuccess" scope="session"/>
                </c:if>

                <%-- Error message --%>
                <c:if test="${not empty error}">
                    <div class="alert alert-error" role="alert">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/auth/login" method="POST"
                      novalidate aria-label="Login form">
                    <c:if test="${not empty param.redirect}">
                        <input type="hidden" name="redirect" value="${param.redirect}">
                    </c:if>

                    <div class="form-group">
                        <label class="form-label" for="email">Email address</label>
                        <input type="email" id="email" name="email" class="form-control"
                               value="${email}" placeholder="you@example.com"
                               required autocomplete="email" aria-required="true">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="••••••••" required autocomplete="current-password" aria-required="true">
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:0.5rem;">
                        Sign In
                    </button>
                </form>
            </div>
            <div class="card-footer text-center">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/auth/register">Create one</a>
            </div>
        </div>

    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
