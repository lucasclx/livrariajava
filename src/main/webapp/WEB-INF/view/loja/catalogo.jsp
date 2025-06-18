<!-- /WEB-INF/view/loja/catalogo.jsp - CORRIGIR -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <main class="container my-4">
        <h1 class="page-title text-center">Nosso Catálogo</h1>
        
        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
            <c:forEach var="livro" items="${livros}">
                <div class="col">
                    <c:set var="livro" value="${livro}" scope="request"/>
                    <jsp:include page="components/book-card.jsp" />
                </div>
            </c:forEach>
        </div>

        <!-- Paginação -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:forEach begin="1" end="${totalPages}" var="page">
                        <li class="page-item ${page == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${page}">${page}</a>
                        </li>
                    </c:forEach>
                </ul>
            </nav>
        </c:if>
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>