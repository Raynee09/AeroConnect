<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Create Account — AeroConnect</title>
</head>
<body class="page-wrapper">

<jsp:include page="../common/navbar.jsp"/>

<main class="main-content" id="main-content">
    <div class="container-narrow" style="padding-top: 3rem; padding-bottom: 3rem;">

        <div style="text-align:center; margin-bottom: 2rem;">
            <div style="font-size:2.5rem; margin-bottom:0.5rem;" aria-hidden="true">✈</div>
            <h1 class="page-title" style="font-size: 1.75rem;">Create your account</h1>
            <p class="page-subtitle" style="margin-bottom:0">Join AeroConnect to start booking flights</p>
        </div>

        <div class="card">
            <div class="card-body">

                <c:if test="${not empty error}">
                    <div class="alert alert-error" role="alert">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/auth/register" method="POST"
                      novalidate aria-label="Registration form">

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                        <div class="form-group">
                            <label class="form-label" for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" class="form-control"
                                   value="${firstName}" placeholder="John"
                                   required autocomplete="given-name" aria-required="true">
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" class="form-control"
                                   value="${lastName}" placeholder="Doe"
                                   required autocomplete="family-name" aria-required="true">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="email">Email address</label>
                        <input type="email" id="email" name="email" class="form-control"
                               value="${email}" placeholder="you@example.com"
                               required autocomplete="email" aria-required="true">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="phone">Phone number <span class="text-muted">(optional)</span></label>
                        <input type="tel" id="phone" name="phone" class="form-control"
                               value="${phone}" placeholder="+1-555-0100"
                               autocomplete="tel">
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control"
                               placeholder="Min. 8 characters" required autocomplete="new-password" aria-required="true">
                        <p class="text-small text-muted" style="margin-top:4px;">
                            Must include uppercase, lowercase, a digit, and a special character.
                        </p>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="confirmPassword">Confirm password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                               placeholder="••••••••" required autocomplete="new-password" aria-required="true">
                    </div>

                    <button type="submit" class="btn btn-primary btn-block btn-lg">
                        Create Account
                    </button>
                </form>
            </div>
            <div class="card-footer text-center">
                Already have an account?
                <a href="${pageContext.request.contextPath}/auth/login">Sign in</a>
            </div>
        </div>

    </div>
</main>

<jsp:include page="../common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
