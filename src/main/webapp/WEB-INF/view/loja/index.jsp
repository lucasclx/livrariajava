<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Bem-vindo à Livraria Mil Páginas" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <%-- Inclui o cabeçalho com CSS e metatags --%>
    <jsp:include page="../common/head.jsp" />
    <style>
        .hero-section {
            background: url('https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=1974&auto=format&fit=crop') no-repeat center center;
            background-size: cover;
            padding: 8rem 0;
            position: relative;
            color: white;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.7);
        }
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(81, 45, 19, 0.6);
        }
        .hero-section .container {
            position: relative;
            z-index: 2;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">

    <%-- Inclui o menu de navegação --%>
    <jsp:include page="../common/header.jsp" />

    <section class="hero-section text-center">
        <div class="container">
            <h1 class="display-3" style="font-family: 'Playfair Display', serif;">Onde cada página é uma nova jornada.</h1>
            <p class="lead col-lg-8 mx-auto">Mergulhe em universos de fantasia, desvende mistérios ou aprenda algo novo com nossa vasta coleção de livros.</p>
            <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-gold btn-lg mt-3">Explorar nosso Acervo</a>
        </div>
    </section>

    <main class="container my-5 flex-shrink-0">

        <section id="destaques" class="mb-5">
            <h2 class="page-title text-center">Livros em Destaque</h2>
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                <c:forEach var="livro" items="${livrosDestaque}">
                    <div class="col">
                        <div class="card book-card">
                             <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                <img src="${pageContext.request.contextPath}${livro.imagemUrl}" class="card-img-top book-cover" alt="Capa de ${livro.titulo}">
                            </a>
                            <div class="card-body d-flex flex-column text-center">
                                <h5 class="card-title h6"><a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" class="text-decoration-none text-dark">${livro.titulo}</a></h5>
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
        </section>

        <section id="categorias" class="mb-5">
            <h2 class="page-title text-center">Navegar por Categorias</h2>
            <div class="d-flex flex-wrap justify-content-center gap-2">
                 <c:forEach var="categoria" items="${categorias}">
                    <a href="${pageContext.request.contextPath}/loja/categoria/${categoria.slug}" class="btn btn-outline-elegant">${categoria.nome}</a>
                </c:forEach>
            </div>
        </section>
        
        <section id="mais-vendidos">
            <h2 class="page-title text-center">Os Mais Vendidos</h2>
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                <c:forEach var="livro" items="${livrosMaisVendidos}">
                     <div class="col">
                        <div class="card book-card">
                             <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                <img src="${pageContext.request.contextPath}${livro.imagemUrl}" class="card-img-top book-cover" alt="Capa de ${livro.titulo}">
                            </a>
                            <div class="card-body d-flex flex-column text-center">
                                <h5 class="card-title h6"><a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" class="text-decoration-none text-dark">${livro.titulo}</a></h5>
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
        </section>

    </main>

    <%-- Inclui o rodapé da página --%>
    <jsp:include page="../common/footer.jsp" />

</body>
</html>