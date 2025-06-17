<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Meus Favoritos" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .favorites-hero {
            background: linear-gradient(135deg, var(--burgundy) 0%, #a00025 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .favorites-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: pulse 4s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); opacity: 0.8; }
            50% { transform: scale(1.1); opacity: 1; }
        }
        
        .favorite-card {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(139, 69, 19, 0.1);
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .favorite-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(218, 165, 32, 0.3), transparent);
            transition: left 0.6s ease;
            z-index: 1;
        }
        
        .favorite-card:hover::before {
            left: 100%;
        }
        
        .favorite-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 40px rgba(139, 69, 19, 0.2);
            border-color: var(--gold);
        }
        
        .favorite-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, var(--burgundy) 0%, #a00025 100%);
            color: white;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            z-index: 2;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .favorite-badge:hover {
            transform: scale(1.1);
            background: linear-gradient(135deg, #a00025 0%, var(--burgundy) 100%);
        }
        
        .favorite-badge.removing {
            animation: heartBreak 0.6s ease-out;
        }
        
        @keyframes heartBreak {
            0% { transform: scale(1); }
            25% { transform: scale(1.2) rotate(-10deg); }
            50% { transform: scale(0.8) rotate(10deg); }
            75% { transform: scale(1.1) rotate(-5deg); }
            100% { transform: scale(0) rotate(0deg); }
        }
        
        .book-cover-favorites {
            width: 140px;
            height: 200px;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            transition: all 0.3s ease;
        }
        
        .favorite-card:hover .book-cover-favorites {
            transform: scale(1.05);
            box-shadow: 0 12px 35px rgba(0, 0, 0, 0.25);
        }
        
        .favorite-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }
        
        .btn-favorite-action {
            flex: 1;
            padding: 0.75rem;
            border-radius: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            position: relative;
            overflow: hidden;
        }
        
        .btn-favorite-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.6s ease;
        }
        
        .btn-favorite-action:hover::before {
            left: 100%;
        }
        
        .btn-cart {
            background: linear-gradient(135deg, var(--forest-green) 0%, #1a6e1a 100%);
            color: white;
        }
        
        .btn-cart:hover {
            background: linear-gradient(135deg, #1a6e1a 0%, var(--forest-green) 100%);
            color: white;
            transform: translateY(-2px);
        }
        
        .btn-view {
            background: linear-gradient(135deg, var(--primary-brown) 0%, var(--dark-brown) 100%);
            color: white;
        }
        
        .btn-view:hover {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
            color: white;
            transform: translateY(-2px);
        }
        
        .filter-section {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .sort-dropdown {
            border: 2px solid rgba(139, 69, 19, 0.3);
            border-radius: 10px;
            padding: 0.5rem 1rem;
            background: white;
        }
        
        .sort-dropdown:focus {
            border-color: var(--gold);
            outline: none;
            box-shadow: 0 0 0 3px rgba(218, 165, 32, 0.2);
        }
        
        .empty-favorites {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--ink);
        }
        
        .empty-favorites i {
            font-size: 5rem;
            color: var(--light-brown);
            margin-bottom: 2rem;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }
        
        .stats-row {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
        }
        
        .stat-item {
            text-align: center;
            padding: 1rem;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .stat-label {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-top: 0.5rem;
        }
        
        .pagination-favorites {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 1rem;
            margin: 3rem 0;
        }
        
        .page-btn {
            background: white;
            border: 2px solid rgba(139, 69, 19, 0.3);
            color: var(--dark-brown);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .page-btn:hover,
        .page-btn.active {
            background: var(--gold);
            border-color: var(--gold);
            color: white;
            text-decoration: none;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1rem;
        }
        
        .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
        }
        
        .breadcrumb-item.active {
            color: white;
        }
        
        .loading-heart {
            display: inline-block;
            color: var(--burgundy);
            animation: heartbeat 1.5s infinite;
        }
        
        @keyframes heartbeat {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.2); }
        }
        
        .share-favorites {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.1) 0%, rgba(139, 69, 19, 0.1) 100%);
            border: 1px solid rgba(218, 165, 32, 0.3);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        
        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .quick-action {
            background: white;
            border: 1px solid rgba(139, 69, 19, 0.3);
            color: var(--dark-brown);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .quick-action:hover {
            background: var(--gold);
            color: white;
            border-color: var(--gold);
            text-decoration: none;
        }
        
        @media (max-width: 768px) {
            .favorite-card {
                margin-bottom: 1rem;
            }
            
            .book-cover-favorites {
                width: 100px;
                height: 150px;
            }
            
            .favorite-actions {
                flex-direction: column;
            }
            
            .stats-row .row {
                text-align: center;
            }
            
            .stat-item {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <!-- Hero Section -->
    <section class="favorites-hero">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Início</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/perfil">Meu Perfil</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Favoritos</li>
                </ol>
            </nav>
            
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-5 mb-3">
                        <i class="fas fa-heart me-3"></i>Meus Favoritos
                    </h1>
                    <p class="lead mb-0 opacity-90">
                        Seus livros preferidos em um só lugar
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="text-white">
                        <div class="h4 mb-1">${totalFavoritos}</div>
                        <div class="small opacity-75">
                            ${totalFavoritos == 1 ? 'Livro favorito' : 'Livros favoritos'}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4 flex-grow-1">
        <!-- Statistics -->
        <c:if test="${not empty favoritos}">
            <div class="stats-row">
                <div class="row">
                    <div class="col-md-3">
                        <div class="stat-item">
                            <div class="stat-number">${totalFavoritos}</div>
                            <div class="stat-label">Total de Favoritos</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-item">
                            <div class="stat-number">${categoriasCount}</div>
                            <div class="stat-label">Categorias Diferentes</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-item">
                            <div class="stat-number">
                                R$ <fmt:formatNumber value="${valorTotal}" pattern="#,##0.00"/>
                            </div>
                            <div class="stat-label">Valor Total</div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="stat-item">
                            <div class="stat-number">${disponiveis}</div>
                            <div class="stat-label">Disponíveis</div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Share Favorites -->
        <c:if test="${not empty favoritos}">
            <div class="share-favorites">
                <h5 class="mb-3">
                    <i class="fas fa-share-alt me-2"></i>Compartilhe seus Favoritos
                </h5>
                <p class="text-muted mb-3">
                    Mostre para seus amigos quais livros você mais gosta
                </p>
                <div class="d-flex justify-content-center gap-2">
                    <button class="btn btn-outline-primary btn-sm" onclick="shareList('whatsapp')">
                        <i class="fab fa-whatsapp me-1"></i>WhatsApp
                    </button>
                    <button class="btn btn-outline-info btn-sm" onclick="shareList('twitter')">
                        <i class="fab fa-twitter me-1"></i>Twitter
                    </button>
                    <button class="btn btn-outline-success btn-sm" onclick="shareList('copy')">
                        <i class="fas fa-copy me-1"></i>Copiar Link
                    </button>
                </div>
            </div>
        </c:if>

        <!-- Filters and Actions -->
        <c:if test="${not empty favoritos}">
            <div class="filter-section">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <div class="quick-actions">
                            <a href="?sort=recent" class="quick-action ${param.sort == 'recent' || empty param.sort ? 'active' : ''}">
                                <i class="fas fa-clock me-1"></i>Mais Recentes
                            </a>
                            <a href="?sort=title" class="quick-action ${param.sort == 'title' ? 'active' : ''}">
                                <i class="fas fa-sort-alpha-down me-1"></i>A-Z
                            </a>
                            <a href="?sort=price" class="quick-action ${param.sort == 'price' ? 'active' : ''}">
                                <i class="fas fa-dollar-sign me-1"></i>Preço
                            </a>
                            <a href="?categoria=" class="quick-action ${empty param.categoria ? 'active' : ''}">
                                <i class="fas fa-th-large me-1"></i>Todas
                            </a>
                        </div>
                    </div>
                    
                    <div class="col-md-6 text-md-end">
                        <div class="d-flex align-items-center justify-content-md-end gap-3">
                            <select class="sort-dropdown" onchange="applySorting(this.value)">
                                <option value="recent" ${param.sort == 'recent' || empty param.sort ? 'selected' : ''}>
                                    Adicionados Recentemente
                                </option>
                                <option value="title" ${param.sort == 'title' ? 'selected' : ''}>
                                    Título (A-Z)
                                </option>
                                <option value="author" ${param.sort == 'author' ? 'selected' : ''}>
                                    Autor (A-Z)
                                </option>
                                <option value="price_asc" ${param.sort == 'price_asc' ? 'selected' : ''}>
                                    Menor Preço
                                </option>
                                <option value="price_desc" ${param.sort == 'price_desc' ? 'selected' : ''}>
                                    Maior Preço
                                </option>
                                <option value="category" ${param.sort == 'category' ? 'selected' : ''}>
                                    Categoria
                                </option>
                            </select>
                            
                            <button class="btn btn-outline-danger btn-sm" onclick="clearAllFavorites()">
                                <i class="fas fa-heart-broken me-1"></i>Limpar Tudo
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Favorites List -->
        <div id="favorites-container">
            <c:choose>
                <c:when test="${not empty favoritos}">
                    <div class="row">
                        <c:forEach var="favorito" items="${favoritos}">
                            <div class="col-lg-6 mb-4" data-favorite-id="${favorito.id}">
                                <div class="favorite-card">
                                    <!-- Favorite Badge -->
                                    <div class="favorite-badge" onclick="removeFavorite(${favorito.livro.id})" 
                                         title="Remover dos favoritos">
                                        <i class="fas fa-heart"></i>
                                    </div>
                                    
                                    <div class="card-body p-4">
                                        <div class="row">
                                            <!-- Book Cover -->
                                            <div class="col-auto">
                                                <a href="${pageContext.request.contextPath}/loja/livro/${favorito.livro.id}">
                                                    <c:choose>
                                                        <c:when test="${not empty favorito.livro.imagem}">
                                                            <img src="${pageContext.request.contextPath}/uploads/livros/${favorito.livro.imagem}" 
                                                                 alt="${favorito.livro.titulo}" class="book-cover-favorites">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="book-cover-favorites d-flex align-items-center justify-content-center bg-light">
                                                                <i class="fas fa-book fa-3x text-muted"></i>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </a>
                                            </div>
                                            
                                            <!-- Book Info -->
                                            <div class="col">
                                                <div class="mb-2">
                                                    <h5 class="mb-2">
                                                        <a href="${pageContext.request.contextPath}/loja/livro/${favorito.livro.id}" 
                                                           class="text-decoration-none text-dark">
                                                            ${favorito.livro.titulo}
                                                        </a>
                                                    </h5>
                                                    <p class="text-muted mb-2">
                                                        <i class="fas fa-feather-alt me-1"></i>${favorito.livro.autor}
                                                    </p>
                                                    
                                                    <c:if test="${not empty favorito.livro.categoria}">
                                                        <p class="mb-2">
                                                            <span class="badge bg-secondary">${favorito.livro.categoria.nome}</span>
                                                        </p>
                                                    </c:if>
                                                </div>
                                                
                                                <!-- Price -->
                                                <div class="mb-3">
                                                    <c:choose>
                                                        <c:when test="${favorito.livro.temPromocao()}">
                                                            <div class="text-muted text-decoration-line-through small">
                                                                ${favorito.livro.precoFormatado}
                                                            </div>
                                                            <div class="price h5 fw-bold text-success mb-1">
                                                                ${favorito.livro.precoPromocionalFormatado}
                                                            </div>
                                                            <span class="badge bg-danger small">
                                                                -${favorito.livro.desconto}% OFF
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="price h5 fw-bold text-success">
                                                                ${favorito.livro.precoFormatado}
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <!-- Availability -->
                                                <div class="mb-3">
                                                    <c:choose>
                                                        <c:when test="${favorito.livro.estoque > 0}">
                                                            <small class="text-success">
                                                                <i class="fas fa-check-circle me-1"></i>
                                                                Disponível (${favorito.livro.estoque} em estoque)
                                                            </small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-danger">
                                                                <i class="fas fa-times-circle me-1"></i>
                                                                Temporariamente esgotado
                                                            </small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                
                                                <!-- Added Date -->
                                                <div class="mb-3">
                                                    <small class="text-muted">
                                                        <i class="fas fa-heart me-1"></i>
                                                        Adicionado em <fmt:formatDate value="${favorito.createdAt}" pattern="dd/MM/yyyy" />
                                                    </small>
                                                </div>
                                                
                                                <!-- Actions -->
                                                <div class="favorite-actions">
                                                    <c:choose>
                                                        <c:when test="${favorito.livro.estoque > 0}">
                                                            <button class="btn btn-favorite-action btn-cart" 
                                                                    onclick="addToCart(${favorito.livro.id})">
                                                                <i class="fas fa-shopping-cart me-1"></i>
                                                                Adicionar ao Carrinho
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <button class="btn btn-favorite-action btn-secondary" disabled>
                                                                <i class="fas fa-bell me-1"></i>
                                                                Avisar Quando Chegar
                                                            </button>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                    <a href="${pageContext.request.contextPath}/loja/livro/${favorito.livro.id}" 
                                                       class="btn btn-favorite-action btn-view">
                                                        <i class="fas fa-eye me-1"></i>
                                                        Ver Detalhes
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-favorites">
                            <c:if test="${currentPage > 1}">
                                <a href="?page=${currentPage - 1}&sort=${param.sort}&categoria=${param.categoria}" 
                                   class="page-btn">
                                    <i class="fas fa-chevron-left me-1"></i>Anterior
                                </a>
                            </c:if>
                            
                            <span class="text-muted">
                                Página ${currentPage} de ${totalPages}
                            </span>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a href="?page=${currentPage + 1}&sort=${param.sort}&categoria=${param.categoria}" 
                                   class="page-btn">
                                    Próxima<i class="fas fa-chevron-right ms-1"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <!-- Empty State -->
                    <div class="empty-favorites">
                        <i class="fas fa-heart-broken"></i>
                        <h3>Sua lista de favoritos está vazia</h3>
                        <p class="text-muted mb-4">
                            Que tal explorar nosso catálogo e adicionar alguns livros que você gostaria de ler?
                        </p>
                        <div class="d-flex justify-content-center gap-3">
                            <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary btn-lg">
                                <i class="fas fa-search me-2"></i>Explorar Catálogo
                            </a>
                            <a href="${pageContext.request.contextPath}/loja/" class="btn btn-outline-elegant btn-lg">
                                <i class="fas fa-star me-2"></i>Ver Destaques
                            </a>
                        </div>
                        
                        <div class="mt-4 p-4 bg-light rounded">
                            <h6><i class="fas fa-lightbulb me-2"></i>Dica:</h6>
                            <p class="small text-muted mb-0">
                                Clique no ícone <i class="fas fa-heart text-danger"></i> em qualquer livro 
                                para adicioná-lo aos seus favoritos e acessá-lo facilmente depois.
                            </p>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Modal de Confirmação -->
    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmModalTitle">Confirmar Ação</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="confirmModalBody">
                    <!-- Conteúdo será preenchido via JavaScript -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-danger" id="confirmModalBtn">Confirmar</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
        let pendingAction = null;
        
        // Remove favorite
        function removeFavorite(livroId) {
            const badge = event.currentTarget;
            
            // Animation
            badge.classList.add('removing');
            
            fetch(`${pageContext.request.contextPath}/api/favoritos/${livroId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove card with animation
                    const card = badge.closest('[data-favorite-id]');
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '0';
                    card.style.transform = 'scale(0.8) translateY(-20px)';
                    
                    setTimeout(() => {
                        card.remove();
                        
                        // Check if no more favorites
                        const remainingCards = document.querySelectorAll('[data-favorite-id]');
                        if (remainingCards.length === 0) {
                            location.reload();
                        }
                    }, 600);
                    
                    showToast('Livro removido dos favoritos', 'success');
                } else {
                    badge.classList.remove('removing');
                    showToast('Erro ao remover favorito: ' + data.message, 'error');
                }
            })
            .catch(error => {
                badge.classList.remove('removing');
                console.error('Erro:', error);
                showToast('Erro ao remover favorito', 'error');
            });
        }
        
        // Clear all favorites
        function clearAllFavorites() {
            showConfirmModal(
                'Limpar Todos os Favoritos',
                'Tem certeza que deseja remover todos os livros da sua lista de favoritos? Esta ação não pode ser desfeita.',
                () => {
                    fetch(`${pageContext.request.contextPath}/api/favoritos/clear`, {
                        method: 'DELETE',
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            showToast('Erro ao limpar favoritos: ' + data.message, 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Erro:', error);
                        showToast('Erro ao limpar favoritos', 'error');
                    });
                }
            );
        }
        
        // Add to cart
        function addToCart(livroId) {
            const button = event.currentTarget;
            const originalContent = button.innerHTML;
            
            // Loading state
            button.innerHTML = '<span class="loading-heart"><i class="fas fa-heart"></i></span> Adicionando...';
            button.disabled = true;
            
            fetch(`${pageContext.request.contextPath}/api/cart/add`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    livroId: livroId,
                    quantity: 1
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Success state
                    button.innerHTML = '<i class="fas fa-check me-1"></i> Adicionado!';
                    button.classList.remove('btn-cart');
                    button.classList.add('btn-success');
                    
                    // Update cart count
                    updateCartCount();
                    
                    // Reset button after 2 seconds
                    setTimeout(() => {
                        button.innerHTML = originalContent;
                        button.classList.remove('btn-success');
                        button.classList.add('btn-cart');
                        button.disabled = false;
                    }, 2000);
                    
                    showToast('Livro adicionado ao carrinho!', 'success');
                } else {
                    // Error state
                    button.innerHTML = originalContent;
                    button.disabled = false;
                    showToast('Erro ao adicionar ao carrinho: ' + data.message, 'error');
                }
            })
            .catch(error => {
                button.innerHTML = originalContent;
                button.disabled = false;
                console.error('Erro:', error);
                showToast('Erro ao adicionar ao carrinho', 'error');
            });
        }
        
        // Apply sorting
        function applySorting(sortValue) {
            const params = new URLSearchParams(window.location.search);
            params.set('sort', sortValue);
            params.delete('page'); // Reset to first page
            window.location.href = '?' + params.toString();
        }
        
        // Share favorites list
        function shareList(platform) {
            const url = window.location.href;
            const text = `Confira minha lista de livros favoritos na Livraria Mil Páginas!`;
            
            switch (platform) {
                case 'whatsapp':
                    window.open(`https://wa.me/?text=${encodeURIComponent(text + ' ' + url)}`);
                    break;
                case 'twitter':
                    window.open(`https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(url)}`);
                    break;
                case 'copy':
                    navigator.clipboard.writeText(url).then(() => {
                        showToast('Link copiado para a área de transferência!', 'success');
                    });
                    break;
            }
        }
        
        // Show confirmation modal
        function showConfirmModal(title, message, callback) {
            document.getElementById('confirmModalTitle').textContent = title;
            document.getElementById('confirmModalBody').innerHTML = message;
            
            const confirmBtn = document.getElementById('confirmModalBtn');
            confirmBtn.onclick = () => {
                callback();
                bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
            };
            
            new bootstrap.Modal(document.getElementById('confirmModal')).show();
        }
        
        // Show toast notification
        function showToast(message, type = 'info') {
            const toast = document.createElement('div');
            toast.className = `alert alert-${type === 'success' ? 'success' : type === 'error' ? 'danger' : 'info'} alert-dismissible fade show position-fixed`;
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
            toast.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.remove();
                }
            }, 4000);
        }
        
        // Update cart count
        function updateCartCount() {
            fetch(`${pageContext.request.contextPath}/api/cart/count`)
                .then(response => response.json())
                .then(data => {
                    const cartCountEl = document.getElementById('cart-count');
                    if (cartCountEl && data.success) {
                        cartCountEl.textContent = data.count || 0;
                    }
                })
                .catch(error => console.error('Erro ao atualizar contador do carrinho:', error));
        }
        
        // Infinite scroll for large lists
        let isLoadingMore = false;
        function setupInfiniteScroll() {
            window.addEventListener('scroll', () => {
                if (isLoadingMore) return;
                
                const scrollPosition = window.innerHeight + window.scrollY;
                const threshold = document.body.offsetHeight - 1000;
                
                if (scrollPosition >= threshold) {
                    loadMoreFavorites();
                }
            });
        }
        
        function loadMoreFavorites() {
            const currentPage = ${currentPage};
            const totalPages = ${totalPages};
            
            if (currentPage >= totalPages) return;
            
            isLoadingMore = true;
            
            // Show loading indicator
            const loadingDiv = document.createElement('div');
            loadingDiv.className = 'text-center py-4';
            loadingDiv.innerHTML = `
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Carregando mais favoritos...</span>
                </div>
            `;
            document.getElementById('favorites-container').appendChild(loadingDiv);
            
            // Fetch next page (this would be implemented server-side)
            setTimeout(() => {
                loadingDiv.remove();
                isLoadingMore = false;
            }, 1000);
        }
        
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            // Animation for cards
            const cards = document.querySelectorAll('.favorite-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.8s cubic-bezier(0.4, 0, 0.2, 1)';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
            
            // Setup infinite scroll if there are many items
            if (${totalPages} > 1) {
                setupInfiniteScroll();
            }
            
            // Update cart count on load
            updateCartCount();
            
            // Add keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                // Ctrl/Cmd + A = Select all (future feature)
                if ((e.ctrlKey || e.metaKey) && e.key === 'a') {
                    e.preventDefault();
                    // Implementation for selecting all favorites
                }
                
                // Delete key = Remove selected (future feature)
                if (e.key === 'Delete') {
                    // Implementation for removing selected favorites
                }
            });
        });
        
        // Auto-refresh favorites count every 5 minutes
        setInterval(() => {
            fetch(`${pageContext.request.contextPath}/api/favoritos/count`)
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.count !== ${totalFavoritos}) {
                        // Favorites count changed, maybe show a notification
                        console.log('Favorites count updated:', data.count);
                    }
                })
                .catch(error => console.error('Erro ao verificar favoritos:', error));
        }, 300000); // 5 minutes
        
        // Add hover effects for better UX
        document.querySelectorAll('.favorite-badge').forEach(badge => {
            badge.addEventListener('mouseenter', function() {
                this.style.transform = 'scale(1.1)';
                this.style.backgroundColor = '#a00025';
            });
            
            badge.addEventListener('mouseleave', function() {
                if (!this.classList.contains('removing')) {
                    this.style.transform = 'scale(1)';
                    this.style.backgroundColor = '';
                }
            });
        });
        
        // Add ripple effect to buttons
        document.querySelectorAll('.btn-favorite-action').forEach(button => {
            button.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                const rect = this.getBoundingClientRect();
                const size = Math.max(rect.width, rect.height);
                const x = e.clientX - rect.left - size / 2;
                const y = e.clientY - rect.top - size / 2;
                
                ripple.style.cssText = `
                    position: absolute;
                    border-radius: 50%;
                    background: rgba(255, 255, 255, 0.6);
                    transform: scale(0);
                    animation: ripple 0.6s linear;
                    width: ${size}px;
                    height: ${size}px;
                    left: ${x}px;
                    top: ${y}px;
                `;
                
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });
        
        // Add CSS for ripple animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
            
            .btn-favorite-action {
                position: relative;
                overflow: hidden;
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>