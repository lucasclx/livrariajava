<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Buscar Livros" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .search-header {
            background: linear-gradient(135deg, var(--primary-brown) 0%, var(--dark-brown) 100%);
            color: white;
            padding: 2rem 0;
        }
        
        .filter-card {
            background: rgba(245, 245, 220, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
        }
        
        .search-stats {
            background: rgba(218, 165, 32, 0.1);
            border-left: 4px solid var(--gold);
            padding: 1rem;
            border-radius: 0 10px 10px 0;
        }
        
        .price-range {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
        }
        
        .suggestions-section {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.05) 0%, rgba(139, 69, 19, 0.05) 100%);
            border-radius: 15px;
            padding: 2rem;
            margin: 2rem 0;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <!-- Search Header -->
    <section class="search-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="h2 mb-2">
                        <i class="fas fa-search me-2"></i>
                        <c:choose>
                            <c:when test="${!empty query}">
                                Resultados para: "<em>${query}</em>"
                            </c:when>
                            <c:otherwise>
                                Explorar Catálogo
                            </c:otherwise>
                        </c:choose>
                    </h1>
                    <c:if test="${totalLivros > 0}">
                        <p class="mb-0 opacity-75">
                            <fmt:formatNumber value="${totalLivros}" /> 
                            livro<c:if test="${totalLivros != 1}">s</c:if> encontrado<c:if test="${totalLivros != 1}">s</c:if>
                        </p>
                    </c:if>
                </div>
                <div class="col-md-4 text-md-end">
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-gold">
                        <i class="fas fa-list me-2"></i>Ver Todo Catálogo
                    </a>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4">
        <!-- Search Form -->
        <div class="card filter-card mb-4">
            <div class="card-body">
                <form method="GET" action="${pageContext.request.contextPath}/search" id="searchForm">
                    <div class="row g-3">
                        <!-- Search Query -->
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-search me-1"></i> Buscar
                            </label>
                            <div class="input-group">
                                <input type="text" name="q" class="form-control" 
                                       value="${query}" 
                                       placeholder="Título, autor, ISBN..."
                                       list="suggestions">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                            <datalist id="suggestions">
                                <!-- Será preenchido via JavaScript -->
                            </datalist>
                        </div>
                        
                        <!-- Category Filter -->
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-tags me-1"></i> Categoria
                            </label>
                            <select name="categoria" class="form-select">
                                <option value="">Todas as categorias</option>
                                <c:forEach var="cat" items="${categorias}">
                                    <option value="${cat.id}" 
                                            ${categoriaFiltro == cat.id.toString() ? 'selected' : ''}>
                                        ${cat.nome}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <!-- Price Range -->
                        <div class="col-md-3">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-dollar-sign me-1"></i> Faixa de Preço
                            </label>
                            <div class="row g-1">
                                <div class="col-6">
                                    <input type="number" name="preco_min" class="form-control form-control-sm" 
                                           value="${precoMin}" placeholder="Min" min="0" step="0.01">
                                </div>
                                <div class="col-6">
                                    <input type="number" name="preco_max" class="form-control form-control-sm" 
                                           value="${precoMax}" placeholder="Max" min="0" step="0.01">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Sort -->
                        <div class="col-md-2">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-sort me-1"></i> Ordenar
                            </label>
                            <select name="ordem" class="form-select">
                                <option value="titulo" ${ordenacao == 'titulo' ? 'selected' : ''}>A-Z</option>
                                <option value="preco_asc" ${ordenacao == 'preco_asc' ? 'selected' : ''}>Menor Preço</option>
                                <option value="preco_desc" ${ordenacao == 'preco_desc' ? 'selected' : ''}>Maior Preço</option>
                                <option value="mais_vendidos" ${ordenacao == 'mais_vendidos' ? 'selected' : ''}>Mais Vendidos</option>
                                <option value="mais_recentes" ${ordenacao == 'mais_recentes' ? 'selected' : ''}>Mais Recentes</option>
                                <option value="avaliacao" ${ordenacao == 'avaliacao' ? 'selected' : ''}>Melhor Avaliados</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Active Filters -->
                    <c:if test="${!empty query || !empty categoriaFiltro || !empty precoMin || !empty precoMax}">
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="d-flex flex-wrap gap-2 align-items-center">
                                    <small class="text-muted me-2">Filtros ativos:</small>
                                    
                                    <c:if test="${!empty query}">
                                        <span class="badge bg-primary">
                                            Busca: ${query}
                                            <a href="?categoria=${categoriaFiltro}&preco_min=${precoMin}&preco_max=${precoMax}&ordem=${ordenacao}" 
                                               class="text-white ms-1">×</a>
                                        </span>
                                    </c:if>
                                    
                                    <c:if test="${!empty categoriaFiltro}">
                                        <span class="badge bg-info">
                                            <c:forEach var="cat" items="${categorias}">
                                                <c:if test="${cat.id == categoriaFiltro}">Categoria: ${cat.nome}</c:if>
                                            </c:forEach>
                                            <a href="?q=${query}&preco_min=${precoMin}&preco_max=${precoMax}&ordem=${ordenacao}" 
                                               class="text-white ms-1">×</a>
                                        </span>
                                    </c:if>
                                    
                                    <c:if test="${!empty precoMin || !empty precoMax}">
                                        <span class="badge bg-success">
                                            Preço: R$ ${!empty precoMin ? precoMin : '0'} - R$ ${!empty precoMax ? precoMax : '∞'}
                                            <a href="?q=${query}&categoria=${categoriaFiltro}&ordem=${ordenacao}" 
                                               class="text-white ms-1">×</a>
                                        </span>
                                    </c:if>
                                    
                                    <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-secondary btn-sm">
                                        <i class="fas fa-times me-1"></i>Limpar Filtros
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- Search Results -->
        <c:choose>
            <c:when test="${!empty livros}">
                <!-- Results Stats -->
                <div class="search-stats mb-4">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5 class="mb-1">
                                <fmt:formatNumber value="${totalLivros}" /> 
                                resultado<c:if test="${totalLivros != 1}">s</c:if> encontrado<c:if test="${totalLivros != 1}">s</c:if>
                            </h5>
                            <small class="text-muted">
                                Página ${currentPage} de ${totalPages}
                                <c:if test="${!empty query}">
                                    | Busca por "${query}"
                                </c:if>
                            </small>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <small class="text-muted">
                                Mostrando ${(currentPage-1)*12 + 1} - ${fn:length(livros) + (currentPage-1)*12} de ${totalLivros}
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Books Grid -->
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4 mb-5">
                    <c:forEach var="livro" items="${livros}">
                        <div class="col">
                            <div class="card book-card h-100">
                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                    <c:choose>
                                        <c:when test="${!empty livro.imagem}">
                                            <img src="${pageContext.request.contextPath}/uploads/livros/${livro.imagem}" 
                                                 class="card-img-top book-cover" alt="${livro.titulo}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                                 style="height: 250px;">
                                                <div class="text-center text-muted">
                                                    <i class="fas fa-book fa-3x mb-2"></i>
                                                    <p class="small mb-0">Sem Capa</p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                
                                <div class="card-body d-flex flex-column">
                                    <h6 class="card-title">
                                        <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                           class="text-decoration-none text-dark">
                                            <c:choose>
                                                <c:when test="${fn:length(livro.titulo) > 45}">
                                                    ${fn:substring(livro.titulo, 0, 45)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${livro.titulo}
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                    </h6>
                                    
                                    <p class="card-text small text-muted mb-2">
                                        <i class="fas fa-feather-alt me-1"></i>${livro.autor}
                                    </p>
                                    
                                    <c:if test="${!empty livro.categoria}">
                                        <p class="card-text small mb-2">
                                            <span class="badge bg-secondary">${livro.categoria.nome}</span>
                                        </p>
                                    </c:if>
                                    
                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${livro.temPromocao()}">
                                                        <small class="text-muted text-decoration-line-through">
                                                            R$ <fmt:formatNumber value="${livro.preco}" pattern="#,##0.00"/>
                                                        </small