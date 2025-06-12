<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- O 'livro' e 'livrosRelacionados' devem ser enviados pelo LojaController --%>
<c:set var="pageTitle" value="${livro.titulo}" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .book-detail-cover {
            max-width: 100%;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            border: 5px solid white;
        }
        .book-meta-table {
            font-size: 0.9rem;
        }
        .book-meta-table td {
            padding-top: 0.75rem;
            padding-bottom: 0.75rem;
        }
        .book-meta-table tr:last-child td {
            border-bottom: none;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <main class="container my-5">
        <c:choose>
            <c:when test="${!empty livro}">
                <div class="card p-4">
                    <div class="row g-5">
                        <div class="col-lg-4 text-center">
                            <img src="${pageContext.request.contextPath}${livro.imagemUrl}" class="book-detail-cover" alt="Capa de ${livro.titulo}">
                        </div>
                        <div class="col-lg-8 d-flex flex-column">
                            <h1>${livro.titulo}</h1>
                            <h2 class="h4 text-muted mb-3 fw-normal">por ${livro.autor}</h2>
                            
                            <div class="d-flex align-items-center mb-3">
                               <span class="price display-6 me-3">${livro.precoFormatado}</span>
                               <%-- Lógica para preço promocional (se houver) --%>
                               <c:if test="${livro.temPromocao}">
                                    <span class="old-price text-muted fs-5">${livro.preco}</span>
                               </c:if>
                            </div>

                            <p class="lead">${livro.sinopse}</p>

                            <div class="d-flex align-items-center gap-3 my-4">
                                <form action="${pageContext.request.contextPath}/cart/add/${livro.id}" method="POST">
                                     <input type="hidden" name="quantity" value="1">
                                     <button type="submit" class="btn btn-gold btn-lg"><i class="fas fa-cart-plus me-2"></i>Adicionar ao Carrinho</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/favorites/toggle/${livro.id}" method="POST">
                                    <button type="submit" class="btn btn-outline-elegant"><i class="far fa-heart me-2"></i>Favoritar</button>
                                </form>
                            </div>

                            <div class="mt-auto">
                                <h4 class="h5">Detalhes do Produto</h4>
                                <table class="table table-sm book-meta-table">
                                    <tbody>
                                        <tr><td class="fw-bold">Editora</td><td>${livro.editora}</td></tr>
                                        <tr><td class="fw-bold">Ano de Publicação</td><td>${livro.anoPublicacao}</td></tr>
                                        <tr><td class="fw-bold">Número de Páginas</td><td>${livro.paginas}</td></tr>
                                        <tr><td class="fw-bold">ISBN</td><td>${livro.isbn}</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <section id="relacionados" class="mt-5 pt-4">
                    <h2 class="page-title text-center">Você também pode gostar</h2>
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                        <c:forEach var="relacionado" items="${livrosRelacionados}">
                            <div class="col">
                                <div class="card book-card">
                                    <a href="${pageContext.request.contextPath}/loja/livro/${relacionado.id}">
                                        <img src="${pageContext.request.contextPath}${relacionado.imagemUrl}" class="card-img-top book-cover" alt="Capa de ${relacionado.titulo}">
                                    </a>
                                    <div class="card-body text-center">
                                        <h5 class="card-title h6"><a href="${pageContext.request.contextPath}/loja/livro/${relacionado.id}" class="text-decoration-none text-dark">${relacionado.titulo}</a></h5>
                                        <p class="small text-muted mb-2">${relacionado.autor}</p>
                                        <p class="price mb-0">${relacionado.precoFormatado}</p>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>

            </c:when>
            <c:otherwise>
                 <div class="text-center p-5 card">
                    <h2>Livro não encontrado</h2>
                    <p>O livro que você está procurando não foi encontrado em nosso sistema.</p>
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary mt-3">Voltar ao Catálogo</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>