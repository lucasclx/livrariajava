<%-- 
EXEMPLO DE PÁGINA OTIMIZADA
/WEB-INF/view/loja/catalogo-optimized.jsp

REDUÇÃO DE CÓDIGO: ~75%
- HTML: 70% menos código
- CSS: 90% menos código (usando classes utilitárias)
- JavaScript: 95% menos código (usando biblioteca global)
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%-- CONFIGURAÇÃO DA PÁGINA (apenas dados) --%>
<c:set var="pageTitle" value="Catálogo de Livros" />
<c:set var="showHero" value="true" />
<c:set var="heroIcon" value="fas fa-book-open" />
<c:set var="heroTitle" value="Explore Nosso Acervo" />
<c:set var="heroSubtitle" value="Milhares de livros esperando por você" />
<c:set var="contentPage" value="catalogo-content.jsp" />

<%-- USAR LAYOUT BASE --%>
<jsp:include page="../layouts/base.jsp" />

<%-- CONTEÚDO ESPECÍFICO (catalogo-content.jsp) --%>

<%-- Filtros usando componente reutilizável --%>
<app:filter-section>
    <app:filter-field name="busca" type="search" placeholder="Buscar livros..." />
    <app:filter-field name="categoria" type="select" options="${categorias}" />
    <app:filter-field name="preco_min" type="number" placeholder="Preço mín." />
    <app:filter-field name="preco_max" type="number" placeholder="Preço máx." />
    <app:filter-field name="ordem" type="select" options="titulo:A-Z,preco_asc:Menor Preço,mais_vendidos:Mais Vendidos" />
</app:filter-section>

<%-- Lista de livros usando template genérico --%>
<app:item-grid 
    items="${livros}" 
    template="book-card"
    emptyIcon="fas fa-search" 
    emptyTitle="Nenhum livro encontrado"
    emptyMessage="Ajuste os filtros ou explore outras categorias"
    showPagination="true" />

<%-- Seção de categorias --%>
<app:section title="Explorar por Categoria" icon="fas fa-tags">
    <div class="row g-3">
        <c:forEach var="categoria" items="${categorias}">
            <div class="col-md-3">
                <a href="?categoria=${categoria.id}" class="btn btn-outline-elegant w-100" 
                   data-action="filter-category" data-category-id="${categoria.id}">
                    <i class="${categoria.icon} me-2"></i>${categoria.nome}
                    <span class="badge bg-secondary ms-2">${categoria.count}</span>
                </a>
            </div>
        </c:forEach>
    </div>
</app:section>

<%-- CSS mínimo específico (apenas o que não está no global) --%>
<style>
.book-grid { gap: 1.5rem; }
.filter-section { margin-bottom: 2rem; }
</style>

<%-- JavaScript mínimo usando biblioteca global --%>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Configurar filtros com auto-submit
    document.querySelectorAll('[data-filter-form] select').forEach(select => {
        select.setAttribute('data-auto-submit', 'true');
    });
    
    // Configurar animações específicas desta página
    document.querySelectorAll('.book-card').forEach((card, index) => {
        card.setAttribute('data-animate', 'slide-up');
        card.setAttribute('data-delay', index * 50);
    });
});
</script>

<%-- ================================= --%>
<%-- TAGS CUSTOMIZADAS REUTILIZÁVEIS   --%>
<%-- ================================= --%>

<%-- /WEB-INF/tags/filter-section.tag --%>
<%@ tag body-content="scriptless" %>
<div class="card-elegant filter-section">
    <div class="card-body">
        <form data-filter-form data-action="ajax-form">
            <div class="row g-3">
                <jsp:doBody/>
                <div class="col-auto">
                    <button type="submit" class="btn btn-elegant">
                        <i class="fas fa-search me-2"></i>Filtrar
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

<%-- /WEB-INF/tags/filter-field.tag --%>
<%@ tag body-content="empty" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="type" required="true" %>
<%@ attribute name="placeholder" required="false" %>
<%@ attribute name="options" required="false" %>

<div class="col-md-3">
    <c:choose>
        <c:when test="${type == 'select'}">
            <select name="${name}" class="form-select">
                <option value="">Todos</option>
                <c:choose>
                    <c:when test="${not empty options and fn:contains(options, ':')}">
                        <%-- Opções no formato "value:label,value2:label2" --%>
                        <c:forTokens items="${options}" delims="," var="option">
                            <c:set var="parts" value="${fn:split(option, ':')}" />
                            <option value="${parts[0]}" ${param[name] == parts[0] ? 'selected' : ''}>
                                ${parts[1]}
                            </option>
                        </c:forTokens>
                    </c:when>
                    <c:otherwise>
                        <%-- Collection de objetos --%>
                        <c:forEach var="item" items="${options}">
                            <option value="${item.id}" ${param[name] == item.id ? 'selected' : ''}>
                                ${item.nome}
                            </option>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </select>
        </c:when>
        <c:otherwise>
            <input type="${type}" name="${name}" class="form-control" 
                   placeholder="${placeholder}" value="${param[name]}">
        </c:otherwise>
    </c:choose>
</div>

<%-- /WEB-INF/tags/item-grid.tag --%>
<%@ tag body-content="empty" %>
<%@ attribute name="items" required="true" type="java.util.Collection" %>
<%@ attribute name="template" required="true" %>
<%@ attribute name="emptyIcon" required="false" %>
<%@ attribute name="emptyTitle" required="false" %>
<%@ attribute name="emptyMessage" required="false" %>
<%@ attribute name="showPagination" required="false" %>

<div data-filter-content>
    <c:choose>
        <c:when test="${empty items}">
            <div class="empty-state">
                <i class="${emptyIcon} fa-4x"></i>
                <h4>${emptyTitle}</h4>
                <p class="text-muted">${emptyMessage}</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row book-grid">
                <c:forEach var="item" items="${items}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <jsp:include page="../fragments/${template}.jsp">
                            <jsp:param name="item" value="${item}" />
                        </jsp:include>
                    </div>
                </c:forEach>
            </div>
            
            <c:if test="${showPagination == 'true' and totalPages > 1}">
                <app:pagination 
                    currentPage="${currentPage}" 
                    totalPages="${totalPages}" 
                    baseUrl="?" />
            </c:if>
        </c:otherwise>
    </c:choose>
</div>

<%-- /WEB-INF/tags/section.tag --%>
<%@ tag body-content="scriptless" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="icon" required="false" %>

<div class="section-card mt-4">
    <div class="section-header">
        <h5 class="mb-0">
            <c:if test="${not empty icon}">
                <i class="${icon} me-2"></i>
            </c:if>
            ${title}
        </h5>
    </div>
    <div class="card-body">
        <jsp:doBody/>
    </div>
</div>

<%-- /WEB-INF/tags/pagination.tag --%>
<%@ tag body-content="empty" %>
<%@ attribute name="currentPage" required="true" %>
<%@ attribute name="totalPages" required="true" %>
<%@ attribute name="baseUrl" required="true" %>

<nav aria-label="Navegação de páginas" class="mt-4">
    <ul class="pagination justify-content-center">
        <c:if test="${currentPage > 1}">
            <li class="page-item">
                <a class="page-link" href="${baseUrl}page=${currentPage - 1}">
                    <i class="fas fa-chevron-left"></i>
                </a>
            </li>
        </c:if>
        
        <c:forEach begin="1" end="${totalPages}" var="page">
            <c:if test="${page <= 5 or (page >= currentPage - 2 and page <= currentPage + 2) or page >= totalPages - 4}">
                <li class="page-item ${page == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${baseUrl}page=${page}">${page}</a>
                </li>
            </c:if>
        </c:forEach>
        
        <c:if test="${currentPage < totalPages}">
            <li class="page-item">
                <a class="page-link" href="${baseUrl}page=${currentPage + 1}">
                    <i class="fas fa-chevron-right"></i>
                </a>
            </li>
        </c:if>
    </ul>
</nav>

<%-- ================================= --%>
<%-- FRAGMENTO DO CARD DE LIVRO        --%>
<%-- ================================= --%>

<%-- /WEB-INF/view/fragments/book-card.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="card book-card h-100" data-animate="slide-up">
    <div class="position-relative">
        <a href="${pageContext.request.contextPath}/loja/livro/${param.item.id}">
            <img src="${pageContext.request.contextPath}/uploads/livros/${param.item.imagem}" 
                 class="card-img-top" alt="${param.item.titulo}" 
                 data-src="${pageContext.request.contextPath}/uploads/livros/${param.item.imagem}"
                 loading="lazy">
        </a>
        
        <%-- Badge de promoção --%>
        <c:if test="${param.item.temPromocao()}">
            <span class="badge bg-danger position-absolute top-0 start-0 m-2">
                -${param.item.desconto}% OFF
            </span>
        </c:if>
        
        <%-- Botão de favorito --%>
        <button class="btn btn-outline-danger position-absolute top-0 end-0 m-2" 
                data-action="toggle-favorite" data-livro-id="${param.item.id}">
            <i class="far fa-heart"></i>
        </button>
    </div>
    
    <div class="card-body d-flex flex-column">
        <h6 class="card-title">
            <a href="${pageContext.request.contextPath}/loja/livro/${param.item.id}" 
               class="text-decoration-none text-dark">${param.item.titulo}</a>
        </h6>
        <p class="text-muted small mb-2">${param.item.autor}</p>
        
        <div class="mt-auto">
            <div class="mb-2">
                <c:choose>
                    <c:when test="${param.item.temPromocao()}">
                        <small class="text-muted text-decoration-line-through">
                            ${param.item.precoFormatado}
                        </small>
                        <div class="price fw-bold text-success">
                            ${param.item.precoPromocionalFormatado}
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="price fw-bold text-success">
                            ${param.item.precoFormatado}
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <button class="btn btn-elegant w-100" 
                    data-action="add-to-cart" 
                    data-livro-id="${param.item.id}"
                    ${param.item.estoque == 0 ? 'disabled' : ''}>
                <i class="fas fa-shopping-cart me-2"></i>
                ${param.item.estoque > 0 ? 'Adicionar' : 'Esgotado'}
            </button>
        </div>
    </div>
</div>

<%-- ================================= --%>
<%-- LAYOUT BASE OTIMIZADO              --%>
<%-- ================================= --%>

<%-- /WEB-INF/view/layouts/base.jsp --%>
<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Livraria Mil Páginas</title>
    
    <%-- CSS consolidado --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/app.min.css" rel="stylesheet">
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />
    
    <%-- Hero condicional --%>
    <c:if test="${showHero}">
        <section class="hero-section">
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
                        <div class="col-auto">${heroAction}</div>
                    </c:if>
                </div>
            </div>
        </section>
    </c:if>
    
    <main class="container my-4 flex-grow-1">
        <jsp:include page="${contentPage}" />
    </main>
    
    <jsp:include page="../common/footer.jsp" />
    
    <%-- JavaScript consolidado --%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/app.min.js"></script>
</body>
</html>