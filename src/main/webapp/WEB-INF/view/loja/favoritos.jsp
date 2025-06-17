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
        .favorites-header {
            background: linear-gradient(135deg, var(--burgundy) 0%, var(--dark-brown) 100%);
            color: white;
            padding: 3rem 0;
        }
        
        .empty-favorites {
            background: rgba(245, 245, 220, 0.9);
            border: 2px dashed var(--light-brown);
            border-radius: 20px;
            padding: 4rem 2rem;
            text-align: center;
            margin: 2rem 0;
        }
        
        .favorite-book-card {
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .favorite-book-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(139, 69, 19, 0.2);
        }
        
        .remove-favorite-btn {
            position: absolute;
            top: 10px;
            right: 10px;
            background: rgba(220, 53, 69, 0.9);
            border: none;
            border-radius: 50%;
            width: 35px;
            height: 35px;
            color: white;
            transition: all 0.3s ease;
            opacity: 0;
        }
        
        .favorite-book-card:hover .remove-favorite-btn {
            opacity: 1;
        }
        
        .remove-favorite-btn:hover {
            background: rgba(220, 53, 69, 1);
            transform: scale(1.1);
        }
        
        .favorite-badge {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(220, 20, 60, 0.9);
            color: white;
            padding: 0.25rem 0.5rem;
            border-radius: 10px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .stats-card {
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 8px 25px rgba(218, 165, 32, 0.3);
        }
        
        .suggestions-section {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.05) 0%, rgba(139, 69, 19, 0.05) 100%);
            border-radius: 20px;
            padding: 2rem;
            margin: 3rem 0;
        }
        
        .filter-tabs {
            background: white;
            border-radius: 15px;
            padding: 0.5rem;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
            margin-bottom: 2rem;
        }
        
        .filter-tab {
            border: none;
            background: transparent;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            transition: all 0.3s ease;
            color: var(--dark-brown);
            font-weight: 500;
        }
        
        .filter-tab.active {
            background: var(--primary-brown);
            color: white;
            box-shadow: 0 4px 10px rgba(139, 69, 19, 0.3);
        }
        
        .bulk-actions {
            background: rgba(139, 69, 19, 0.05);
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 2rem;
            display: none;
        }
        
        .bulk-actions.show {
            display: block;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <!-- Header Section -->
    <section class="favorites-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="h2 mb-2">
                        <i class="fas fa-heart me-3"></i>
                        Meus Livros Favoritos
                    </h1>
                    <p class="mb-0 opacity-75">
                        Seus livros salvos para leitura futura
                    </p>
                </div>
                <div class="col-md-4 text-md-end">
                    <div class="stats-card">
                        <h3 class="h4 mb-1">${totalFavoritos}</h3>
                        <small>Livro<c:if test="${totalFavoritos != 1}">s</c:if> Favorito<c:if test="${totalFavoritos != 1}">s</c:if></small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4">
        <c:choose>
            <c:when test="${!empty favoritos}">
                <!-- Filter Tabs -->
                <div class="filter-tabs d-flex flex-wrap justify-content-center">
                    <button class="filter-tab active" onclick="filterFavorites('all')">
                        <i class="fas fa-list me-2"></i>Todos (${totalFavoritos})
                    </button>
                    <button class="filter-tab" onclick="filterFavorites('disponivel')">
                        <i class="fas fa-check-circle me-2"></i>Disponíveis
                    </button>
                    <button class="filter-tab" onclick="filterFavorites('promocao')">
                        <i class="fas fa-tag me-2"></i>Em Promoção
                    </button>
                    <button class="filter-tab" onclick="filterFavorites('recent')">
                        <i class="fas fa-clock me-2"></i>Adicionados Recentemente
                    </button>
                </div>

                <!-- Bulk Actions -->
                <div class="bulk-actions" id="bulkActions">
                    <div class="d-flex justify-content-between align-items-center">
                        <span id="selectedCount">0 livros selecionados</span>
                        <div>
                            <button class="btn btn-success btn-sm me-2" onclick="addSelectedToCart()">
                                <i class="fas fa-shopping-cart me-1"></i>Adicionar ao Carrinho
                            </button>
                            <button class="btn btn-danger btn-sm" onclick="removeSelectedFavorites()">
                                <i class="fas fa-trash me-1"></i>Remover Selecionados
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Favorites Grid -->
                <div class="row">
                    <!-- Toolbar -->
                    <div class="col-12 mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="selectAll" onchange="toggleSelectAll()">
                                <label class="form-check-label" for="selectAll">
                                    Selecionar todos
                                </label>
                            </div>
                            <div class="d-flex gap-2">
                                <select class="form-select form-select-sm" style="width: auto;" onchange="sortFavorites(this.value)">
                                    <option value="recent">Mais Recentes</option>
                                    <option value="title">Título A-Z</option>
                                    <option value="author">Autor A-Z</option>
                                    <option value="price_asc">Menor Preço</option>
                                    <option value="price_desc">Maior Preço</option>
                                </select>
                                <button class="btn btn-outline-danger btn-sm" onclick="clearAllFavorites()">
                                    <i class="fas fa-trash me-1"></i>Limpar Todos
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4" id="favoritesGrid">
                    <c:forEach var="livro" items="${favoritos}">
                        <div class="col favorite-item" 
                             data-category="${livro.categoria.nome}"
                             data-available="${livro.emEstoque()}"
                             data-promotion="${livro.temPromocao()}"
                             data-price="${livro.precoFinal}"
                             data-title="${livro.titulo}"
                             data-author="${livro.autor}">
                            <div class="card favorite-book-card h-100">
                                <!-- Selection Checkbox -->
                                <div class="position-absolute" style="top: 10px; left: 50px; z-index: 10;">
                                    <input class="form-check-input favorite-checkbox" 
                                           type="checkbox" 
                                           value="${livro.id}"
                                           onchange="updateBulkActions()">
                                </div>

                                <!-- Favorite Badge -->
                                <div class="favorite-badge">
                                    <i class="fas fa-heart"></i> Favorito
                                </div>
                                
                                <!-- Remove Button -->
                                <button class="remove-favorite-btn" 
                                        onclick="removeFavorite(${livro.id})"
                                        title="Remover dos favoritos">
                                    <i class="fas fa-times"></i>
                                </button>
                                
                                <!-- Promotion Badge -->
                                <c:if test="${livro.temPromocao()}">
                                    <span class="badge bg-danger position-absolute" style="top: 50px; left: 10px; z-index: 5;">
                                        -${livro.desconto}%
                                    </span>
                                </c:if>
                                
                                <!-- Book Cover -->
                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                    <div class="book-cover">
                                        <c:choose>
                                            <c:when test="${!empty livro.imagem}">
                                                <img src="${pageContext.request.contextPath}/uploads/livros/${livro.imagem}" 
                                                     class="card-img-top" alt="${livro.titulo}"
                                                     style="height: 280px; object-fit: cover;">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                                     style="height: 280px;">
                                                    <div class="text-center text-muted">
                                                        <i class="fas fa-book fa-3x mb-2"></i>
                                                        <p class="small mb-0">Sem Capa</p>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </a>
                                
                                <!-- Card Body -->
                                <div class="card-body d-flex flex-column">
                                    <h6 class="card-title">
                                        <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                           class="text-decoration-none text-dark">
                                            <c:choose>
                                                <c:when test="${fn:length(livro.titulo) > 40}">
                                                    ${fn:substring(livro.titulo, 0, 40)}...
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
                                    
                                    <!-- Price -->
                                    <div class="mb-3">
                                        <c:choose>
                                            <c:when test="${livro.temPromocao()}">
                                                <small class="text-muted text-decoration-line-through">
                                                    R$ <fmt:formatNumber value="${livro.preco}" pattern="#,##0.00"/>
                                                </small>
                                                <br>
                                                <span class="h6 text-success fw-bold">
                                                    R$ <fmt:formatNumber value="${livro.precoPromocional}" pattern="#,##0.00"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="h6 fw-bold">
                                                    R$ <fmt:formatNumber value="${livro.preco}" pattern="#,##0.00"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Actions -->
                                    <div class="mt-auto">
                                        <div class="d-grid gap-2">
                                            <c:choose>
                                                <c:when test="${livro.emEstoque()}">
                                                    <button class="btn btn-primary btn-sm" 
                                                            onclick="addToCart(${livro.id})">
                                                        <i class="fas fa-shopping-cart me-2"></i>Adicionar ao Carrinho
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-secondary btn-sm" disabled>
                                                        <i class="fas fa-times-circle me-2"></i>Esgotado
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <div class="btn-group btn-group-sm" role="group">
                                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                                   class="btn btn-outline-primary">
                                                    <i class="fas fa-eye me-1"></i>Ver Detalhes
                                                </a>
                                                <button class="btn btn-outline-success" 
                                                        onclick="shareBook(${livro.id}, '${livro.titulo}')">
                                                    <i class="fas fa-share me-1"></i>Compartilhar
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <!-- Stock Status -->
                                        <div class="text-center mt-2 small">
                                            <c:choose>
                                                <c:when test="${livro.emEstoque()}">
                                                    <span class="text-success">
                                                        <i class="fas fa-check-circle me-1"></i>Disponível
                                                    </span>
                                                </c:when>
                                                <c:when test="${livro.estoqueBaixo}">
                                                    <span class="text-warning">
                                                        <i class="fas fa-exclamation-triangle me-1"></i>Últimas unidades
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger">
                                                        <i class="fas fa-times-circle me-1"></i>Esgotado
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-5">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i> Anterior
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="page">
                                <li class="page-item ${page == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="?page=${page}">${page}</a>
                                </li>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}">
                                        Próxima <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>

            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="empty-favorites">
                    <div class="mb-4">
                        <i class="fas fa-heart-broken fa-5x text-muted mb-3"></i>
                        <h3 class="h4 text-muted">Nenhum favorito ainda</h3>
                        <p class="text-muted mb-4">
                            Você ainda não adicionou nenhum livro aos seus favoritos.<br>
                            Explore nosso catálogo e salve os livros que mais te interessam!
                        </p>
                        <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-gold btn-lg">
                            <i class="fas fa-search me-2"></i>Explorar Catálogo
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Suggestions Section -->
        <c:if test="${!empty sugestoes}">
            <section class="suggestions-section">
                <h3 class="text-center mb-4">
                    <i class="fas fa-magic me-2"></i>
                    <c:choose>
                        <c:when test="${empty favoritos}">
                            Livros que Você Pode Gostar
                        </c:when>
                        <c:otherwise>
                            Baseado nos Seus Favoritos
                        </c:otherwise>
                    </c:choose>
                </h3>
                
                <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                    <c:forEach var="sugestao" items="${sugestoes}">
                        <div class="col">
                            <div class="card book-card h-100">
                                <a href="${pageContext.request.contextPath}/loja/livro/${sugestao.id}">
                                    <c:choose>
                                        <c:when test="${!empty sugestao.imagem}">
                                            <img src="${pageContext.request.contextPath}/uploads/livros/${sugestao.imagem}" 
                                                 class="card-img-top" alt="${sugestao.titulo}"
                                                 style="height: 250px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                                 style="height: 250px;">
                                                <i class="fas fa-book fa-3x text-muted"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <div class="card-body d-flex flex-column text-center">
                                    <h6 class="card-title">
                                        <a href="${pageContext.request.contextPath}/loja/livro/${sugestao.id}" 
                                           class="text-decoration-none text-dark">
                                            ${fn:length(sugestao.titulo) > 35 ? fn:substring(sugestao.titulo, 0, 35).concat('...') : sugestao.titulo}
                                        </a>
                                    </h6>
                                    <p class="card-text small text-muted mb-2">${sugestao.autor}</p>
                                    <div class="mt-auto">
                                        <p class="price mb-2">R$ <fmt:formatNumber value="${sugestao.precoFinal}" pattern="#,##0.00"/></p>
                                        <button class="btn btn-outline-primary btn-sm w-100" 
                                                onclick="addToFavorites(${sugestao.id})">
                                            <i class="far fa-heart me-1"></i>Adicionar aos Favoritos
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>
    </main>

    <jsp:include page="../common/footer.jsp" />

    <!-- JavaScript -->
    <script>
        // Toggle favorite
        function removeFavorite(livroId) {
            if (confirm('Tem certeza que deseja remover este livro dos favoritos?')) {
                fetch(`${pageContext.request.contextPath}/favorites/remove/${livroId}`, {
                    method: 'POST'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Erro ao remover favorito: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Erro ao remover favorito');
                });
            }
        }

        // Add to cart
        function addToCart(livroId) {
            fetch(`${pageContext.request.contextPath}/cart/add/${livroId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'quantity=1'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update cart count
                    updateCartCount();
                    showToast('Livro adicionado ao carrinho!', 'success');
                } else {
                    showToast('Erro ao adicionar ao carrinho: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Erro ao adicionar ao carrinho', 'error');
            });
        }

        // Add to favorites
        function addToFavorites(livroId) {
            fetch(`${pageContext.request.contextPath}/favorites/add/${livroId}`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showToast('Livro adicionado aos favoritos!', 'success');
                } else {
                    showToast('Erro: ' + data.message, 'error');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                showToast('Erro ao adicionar aos favoritos', 'error');
            });
        }

        // Filter favorites
        function filterFavorites(filter) {
            const items = document.querySelectorAll('.favorite-item');
            const tabs = document.querySelectorAll('.filter-tab');
            
            // Update active tab
            tabs.forEach(tab => tab.classList.remove('active'));
            event.target.classList.add('active');
            
            items.forEach(item => {
                let show = true;
                
                switch(filter) {
                    case 'disponivel':
                        show = item.dataset.available === 'true';
                        break;
                    case 'promocao':
                        show = item.dataset.promotion === 'true';
                        break;
                    case 'recent':
                        // Assume que os mais recentes estão no início
                        show = Array.from(items).indexOf(item) < 8;
                        break;
                    default:
                        show = true;
                }
                
                item.style.display = show ? 'block' : 'none';
            });
        }

        // Sort favorites
        function sortFavorites(sortBy) {
            const grid = document.getElementById('favoritesGrid');
            const items = Array.from(grid.children);
            
            items.sort((a, b) => {
                switch(sortBy) {
                    case 'title':
                        return a.dataset.title.localeCompare(b.dataset.title);
                    case 'author':
                        return a.dataset.author.localeCompare(b.dataset.author);
                    case 'price_asc':
                        return parseFloat(a.dataset.price) - parseFloat(b.dataset.price);
                    case 'price_desc':
                        return parseFloat(b.dataset.price) - parseFloat(a.dataset.price);
                    default:
                        return 0;
                }
            });
            
            items.forEach(item => grid.appendChild(item));
        }

        // Bulk actions
        function toggleSelectAll() {
            const selectAll = document.getElementById('selectAll');
            const checkboxes = document.querySelectorAll('.favorite-checkbox');
            
            checkboxes.forEach(checkbox => {
                checkbox.checked = selectAll.checked;
            });
            
            updateBulkActions();
        }

        function updateBulkActions() {
            const checkboxes = document.querySelectorAll('.favorite-checkbox:checked');
            const bulkActions = document.getElementById('bulkActions');
            const selectedCount = document.getElementById('selectedCount');
            
            if (checkboxes.length > 0) {
                bulkActions.classList.add('show');
                selectedCount.textContent = `${checkboxes.length} livro${checkboxes.length !== 1 ? 's' : ''} selecionado${checkboxes.length !== 1 ? 's' : ''}`;
            } else {
                bulkActions.classList.remove('show');
            }
        }

        function addSelectedToCart() {
            const checkboxes = document.querySelectorAll('.favorite-checkbox:checked');
            if (checkboxes.length === 0) return;
            
            let promises = [];
            checkboxes.forEach(checkbox => {
                promises.push(
                    fetch(`${pageContext.request.contextPath}/cart/add/${checkbox.value}`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'quantity=1'
                    })
                );
            });
            
            Promise.all(promises)
                .then(() => {
                    updateCartCount();
                    showToast(`${checkboxes.length} livro${checkboxes.length !== 1 ? 's adicionados' : ' adicionado'} ao carrinho!`, 'success');
                })
                .catch(error => {
                    console.error('Error:', error);
                    showToast('Erro ao adicionar livros ao carrinho', 'error');
                });
        }

        function removeSelectedFavorites() {
            const checkboxes = document.querySelectorAll('.favorite-checkbox:checked');
            if (checkboxes.length === 0) return;
            
            if (confirm(`Tem certeza que deseja remover ${checkboxes.length} livro${checkboxes.length !== 1 ? 's' : ''} dos favoritos?`)) {
                let promises = [];
                checkboxes.forEach(checkbox => {
                    promises.push(
                        fetch(`${pageContext.request.contextPath}/favorites/remove/${checkbox.value}`, {
                            method: 'POST'
                        })
                    );
                });
                
                Promise.all(promises)
                    .then(() => {
                        location.reload();
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        showToast('Erro ao remover favoritos', 'error');
                    });
            }
        }

        function clearAllFavorites() {
            if (confirm('Tem certeza que deseja remover TODOS os favoritos? Esta ação não pode ser desfeita.')) {
                fetch(`${pageContext.request.contextPath}/favorites/clear`, {
                    method: 'POST'
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
                    console.error('Error:', error);
                    showToast('Erro ao limpar favoritos', 'error');
                });
            }
        }

        // Share book
        function shareBook(livroId, title) {
            if (navigator.share) {
                navigator.share({
                    title: title,
                    url: `${window.location.origin}${pageContext.request.contextPath}/loja/livro/${livroId}`
                });
            } else {
                // Fallback: copy to clipboard
                const url = `${window.location.origin}${pageContext.request.contextPath}/loja/livro/${livroId}`;
                navigator.clipboard.writeText(url).then(() => {
                    showToast('Link copiado para a área de transferência!', 'success');
                });
            }
        }

        // Toast notifications
        function showToast(message, type) {
            const toast = document.createElement('div');
            toast.className = `toast align-items-center text-white bg-${type === 'success' ? 'success' : 'danger'} border-0`;
            toast.setAttribute('role', 'alert');
            toast.innerHTML = `
                <div class="d-flex">
                    <div class="toast-body">${message}</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
                </div>
            `;
            
            document.body.appendChild(toast);
            const bsToast = new bootstrap.Toast(toast);
            bsToast.show();
            
            toast.addEventListener('hidden.bs.toast', () => {
                document.body.removeChild(toast);
            });
        }

        // Update cart count
        function updateCartCount() {
            fetch('${pageContext.request.contextPath}/cart/count')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const cartCountEl = document.getElementById('cart-count');
                        if (cartCountEl) {
                            cartCountEl.textContent = data.data || 0;
                        }
                    }
                })
                .catch(error => console.error('Error updating cart count:', error));
        }
    </script>
</body>
</html>