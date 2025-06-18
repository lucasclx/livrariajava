<!-- /WEB-INF/view/common/head-minimal.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${pageTitle} - Livraria Mil Páginas</title>

<!-- CSS unificado -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/app.min.css" rel="stylesheet">

<!-- CSS específico da página (se necessário) -->
<c:if test="${not empty pageCSS}">
    <style>${pageCSS}</style>
</c:if>