<!-- /WEB-INF/view/layouts/base.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <c:if test="${not empty additionalCSS}">
        <link rel="stylesheet" href="${additionalCSS}">
    </c:if>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />
    
    <c:if test="${showHero}">
        <section class="page-hero">
            <div class="container">
                <jsp:include page="../fragments/breadcrumb.jsp" />
                <div class="row align-items-center">
                    <div class="col">
                        <h1 class="h3 mb-0">
                            <i class="${heroIcon} me-2"></i>${heroTitle}
                        </h1>
                        <p class="mb-0 opacity-75">${heroSubtitle}</p>
                    </div>
                    <c:if test="${not empty heroAction}">
                        <div class="col-auto">
                            ${heroAction}
                        </div>
                    </c:if>
                </div>
            </div>
        </section>
    </c:if>
    
    <main class="container my-4 flex-grow-1">
        <jsp:include page="${contentPage}" />
    </main>
    
    <jsp:include page="../common/footer.jsp" />
    
    <c:if test="${not empty additionalJS}">
        <script src="${additionalJS}"></script>
    </c:if>
</body>
</html>