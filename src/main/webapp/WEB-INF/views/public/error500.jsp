<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <jsp:include page="../common/head.jsp"/>
    <title>Server Error — AeroConnect</title>
</head>
<body class="page-wrapper">
<jsp:include page="../common/navbar.jsp"/>
<main class="main-content flex-center" id="main-content">
    <div class="text-center" style="padding: 4rem 2rem;">
        <div style="font-size:5rem; margin-bottom:1rem;" aria-hidden="true">⚠️</div>
        <h1 style="font-size:6rem; font-weight:700; color:var(--color-peach); margin-bottom:0.5rem;">500</h1>
        <h2 style="font-size:1.5rem; font-weight:600; margin-bottom:1rem;">Something Went Wrong</h2>
        <p class="text-muted" style="max-width:400px; margin:0 auto 2rem;">
            An unexpected error occurred. Please try again later.
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg">Go Home</a>
    </div>
</main>
<jsp:include page="../common/footer.jsp"/>
</body>
</html>
