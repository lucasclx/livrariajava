<%-- /WEB-INF/views/loja/catalogo.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Catálogo de Livros" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <main class="container my-5">
        <div class="text-center">
            <h1 class="page-title">Nosso Catálogo</h1>
            <p class="lead mb-5 col-md-8 mx-auto">Encontre sua próxima grande aventura literária em nossa coleção cuidadosamente selecionada.</p>
        </div>
        
        <%-- A variável 'livros' deve ser populada e enviada pelo seu LojaController --%>
        <c:choose>
            <c:when test="${!empty livros}">
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                    <c:forEach var="livro" items="${livros}">
                        <div class="col">
                            <div class="card book-card">
                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                    <img src="${pageContext.request.contextPath}${livro.imagemUrl}" class="card-img-top book-cover" alt="Capa de ${livro.titulo}">
                                </a>
                                <div class="card-body d-flex flex-column text-center">
                                    <h5 class="card-title h6">
                                        <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" class="text-decoration-none text-dark">${livro.titulo}</a>
                                    </h5>
                                    <p class="card-text small text-muted mb-2">${livro.autor}</p>
                                    <div class="mt-auto pt-2">
                                        <p class="price mb-2">${livro.precoFormatado}</p>
                                        <a href="#" class="btn btn-sm btn-gold w-100"><i class="fas fa-cart-plus me-2"></i>Adicionar</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center p-5 card">
                    <h3>Nenhum livro encontrado</h3>
                    <p>Parece que não temos livros para exibir no momento. Tente novamente mais tarde.</p>
                </div>
            </c:otherwise>
        </c:choose>
        
        <%-- TODO: Adicionar a lógica de paginação baseada nas variáveis enviadas pelo controller --%>
        
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>