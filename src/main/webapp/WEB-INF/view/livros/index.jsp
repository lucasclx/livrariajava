<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo da Biblioteca - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <!-- Include Header/Navigation -->
        <jsp:include page="/WEB-INF/views/layouts/admin-header.jsp" />
        
        <!-- Hero Section -->
        <div class="row mb-5">
            <div class="col-12">
                <div class="text-center py-5 position-relative">
                    <h1 class="page-title floating-book">📚 Nosso Acervo Literário</h1>
                    <p class="lead text-muted mt-3">
                        Descubra mundos infinitos através das páginas dos nossos livros
                    </p>
                </div>
            </div>
        </div>

        <!-- Actions Bar -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div class="d-flex align-items-center gap-3">
                <h2 class="mb-0">
                    <i class="fas fa-book-open text-primary me-2"></i>
                    Catálogo Completo
                </h2>
                <span class="badge badge-category">
                    ${livros.totalItems} livros encontrados
                </span>
            </div>
            <a href="${pageContext.request.contextPath}/livros/create" class="btn btn-gold">
                <i class="fas fa-plus-circle me-2"></i>
                Adicionar Novo Livro
            </a>
        </div>

        <!-- Search and Filters -->
        <div class="card filter-card mb-4">
            <div class="card-body">
                <form method="GET" action="${pageContext.request.contextPath}/livros" id="filterForm">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-search me-1"></i> Buscar Livros
                            </label>
                            <input type="text" name="busca" class="form-control" 
                                   value="${param.busca}" 
                                   placeholder="Digite o título, autor, ISBN ou editora...">
                        </div>
                        
                        <div class="col-md-2">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-tags me-1"></i> Categoria
                            </label>
                            <select name="categoria" class="form-select">
                                <option value="">Todas</option>
                                <c:forEach var="categoria" items="${categorias}">
                                    <option value="${categoria.id}" 
                                            ${param.categoria == categoria.id ? 'selected' : ''}>
                                        ${categoria.nome}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-warehouse me-1"></i> Estoque
                            </label>
                            <select name="estoque" class="form-select">
                                <option value="">Todos</option>
                                <option value="disponivel" ${param.estoque == 'disponivel' ? 'selected' : ''}>
                                    ✅ Disponível
                                </option>
                                <option value="baixo" ${param.estoque == 'baixo' ? 'selected' : ''}>
                                    ⚠️ Estoque Baixo
                                </option>
                                <option value="sem_estoque" ${param.estoque == 'sem_estoque' ? 'selected' : ''}>
                                    ❌ Sem Estoque
                                </option>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <label class="form-label fw-semibold">
                                <i class="fas fa-sort me-1"></i> Ordenar
                            </label>
                            <select name="ordem" class="form-select">
                                <option value="titulo" ${param.ordem == 'titulo' ? 'selected' : ''}>
                                    📖 Título
                                </option>
                                <option value="autor" ${param.ordem == 'autor' ? 'selected' : ''}>
                                    ✍️ Autor
                                </option>
                                <option value="preco" ${param.ordem == 'preco' ? 'selected' : ''}>
                                    💰 Preço
                                </option>
                                <option value="created_at" ${param.ordem == 'created_at' ? 'selected' : ''}>
                                    🆕 Mais Recentes
                                </option>
                            </select>
                        </div>
                        
                        <div class="col-md-2 d-flex align-items-end">
                            <div class="d-grid w-100">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search me-1"></i> Buscar
                                </button>
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${not empty param.busca or not empty param.categoria or not empty param.estoque or not empty param.ordem}">
                        <div class="row mt-3">
                            <div class="col-12">
                                <a href="${pageContext.request.contextPath}/livros" class="btn btn-outline-elegant btn-sm">
                                    <i class="fas fa-times me-1"></i> Limpar Filtros
                                </a>
                                <span class="text-muted ms-3">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Filtros aplicados - ${livros.totalItems} resultado(s)
                                </span>
                            </div>
                        </div>
                    </c:if>
                </form>
            </div>
        </div>

        <!-- Books Grid -->
        <c:choose>
            <c:when test="${not empty livros.items}">
                <div class="row">
                    <c:forEach var="livro" items="${livros.items}">
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="card book-card h-100">
                                <!-- Book Cover -->
                                <div class="position-relative book-cover">
                                    <c:choose>
                                        <c:when test="${not empty livro.imagem}">
                                            <img src="${pageContext.request.contextPath}/images/livros/${livro.imagem}" 
                                                 class="card-img-top" alt="${livro.titulo}" 
                                                 style="height: 250px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="card-img-top d-flex align-items-center justify-content-center" 
                                                 style="height: 250px; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);">
                                                <div class="text-center">
                                                    <i class="fas fa-book fa-4x text-muted mb-2"></i>
                                                    <p class="text-muted small mb-0">Sem Capa</p>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <!-- Stock Status Badge -->
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <c:choose>
                                            <c:when test="${livro.estoque > 5}">
                                                <span class="badge badge-stock-ok">Disponível</span>
                                            </c:when>
                                            <c:when test="${livro.estoque > 0}">
                                                <span class="badge badge-stock-low">Estoque Baixo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-stock-out">Sem Estoque</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Promotion Badge -->
                                    <c:if test="${livro.temPromocao()}">
                                        <div class="position-absolute top-0 start-0 m-2">
                                            <span class="badge bg-danger">
                                                -<fmt:formatNumber value="${livro.desconto}" pattern="#"/>% OFF
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Book Info -->
                                <div class="card-body d-flex flex-column">
                                    <div class="mb-auto">
                                        <h6 class="card-title fw-bold mb-2" style="min-height: 3rem; line-height: 1.5;">
                                            <c:choose>
                                                <c:when test="${fn:length(livro.titulo) > 50}">
                                                    ${fn:substring(livro.titulo, 0, 50)}...
                                                </c:when>
                                                <c:otherwise>
                                                    ${livro.titulo}
                                                </c:otherwise>
                                            </c:choose>
                                        </h6>
                                        
                                        <div class="mb-2">
                                            <small class="text-muted">
                                                <i class="fas fa-feather-alt me-1"></i>
                                                <strong>${livro.autor}</strong>
                                            </small>
                                        </div>
                                        
                                        <c:if test="${not empty livro.editora}">
                                            <div class="mb-2">
                                                <small class="text-muted">
                                                    <i class="fas fa-building me-1"></i>
                                                    ${livro.editora}
                                                </small>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty livro.categoria}">
                                            <div class="mb-2">
                                                <span class="badge badge-category small">
                                                    ${livro.categoria.nome}
                                                </span>
                                            </div>
                                        </c:if>
                                        
                                        <c:if test="${not empty livro.sinopse}">
                                            <p class="card-text small text-muted mb-3">
                                                <c:choose>
                                                    <c:when test="${fn:length(livro.sinopse) > 100}">
                                                        ${fn:substring(livro.sinopse, 0, 100)}...
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${livro.sinopse}
                                                    </c:otherwise>
                                                </c:choose>
                                            </p>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Price -->
                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <c:choose>
                                                <c:when test="${livro.temPromocao()}">
                                                    <div>
                                                        <small class="text-muted text-decoration-line-through">
                                                            ${livro.precoFormatado}
                                                        </small>
                                                        <br>
                                                        <span class="price fw-bold text-success">
                                                            ${livro.precoPromocionalFormatado}
                                                        </span>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="price fw-bold text-success">${livro.precoFormatado}</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <small class="text-muted">
                                                <i class="fas fa-boxes"></i> ${livro.estoque}
                                            </small>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Card Footer -->
                                <div class="card-footer bg-transparent border-0 pt-0">
                                    <div class="d-flex justify-content-between gap-1">
                                        <a href="${pageContext.request.contextPath}/livros/${livro.id}" 
                                           class="btn btn-outline-info btn-sm flex-fill" 
                                           data-bs-toggle="tooltip" title="Ver detalhes">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <a href="${pageContext.request.contextPath}/livros/${livro.id}/edit" 
                                           class="btn btn-outline-warning btn-sm flex-fill" 
                                           data-bs-toggle="tooltip" title="Editar">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger btn-sm flex-fill" 
                                                data-bs-toggle="tooltip" title="Excluir"
                                                onclick="confirmarExclusao(${livro.id}, '${livro.titulo}')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${livros.totalPages > 1}">
                    <div class="d-flex justify-content-center mt-4">
                        <nav aria-label="Navegação de páginas">
                            <ul class="pagination">
                                <!-- Previous Page -->
                                <c:if test="${livros.hasPrevious()}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${livros.previousPage}&busca=${param.busca}&categoria=${param.categoria}&ordem=${param.ordem}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <!-- Page Numbers -->
                                <c:forEach begin="1" end="${livros.totalPages}" var="pageNum">
                                    <c:if test="${pageNum <= 5 or (pageNum >= livros.currentPage - 2 and pageNum <= livros.currentPage + 2) or pageNum >= livros.totalPages - 4}">
                                        <li class="page-item ${pageNum == livros.currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${pageNum}&busca=${param.busca}&categoria=${param.categoria}&ordem=${param.ordem}">
                                                ${pageNum}
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                                
                                <!-- Next Page -->
                                <c:if test="${livros.hasNext()}">
                                    <li class="page-item">
                                        <a class="page-link" href="?page=${livros.nextPage}&busca=${param.busca}&categoria=${param.categoria}&ordem=${param.ordem}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <!-- Empty State -->
                <div class="text-center py-5">
                    <i class="fas fa-search fa-5x text-muted mb-3"></i>
                    <h4>Nenhum livro encontrado</h4>
                    <c:choose>
                        <c:when test="${not empty param.busca or not empty param.categoria or not empty param.estoque}">
                            <p class="text-muted">Tente ajustar os filtros de busca.</p>
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-outline-primary">
                                <i class="fas fa-list"></i> Ver Todos os Livros
                            </a>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted">Comece adicionando o primeiro livro ao seu catálogo.</p>
                            <a href="${pageContext.request.contextPath}/livros/create" class="btn btn-primary">
                                <i class="fas fa-plus"></i> Cadastrar Primeiro Livro
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Statistics Summary -->
        <c:if test="${not empty livros.items}">
            <div class="card mt-4 stats-card">
                <div class="card-header">
                    <h5><i class="fas fa-chart-bar"></i> Resumo do Catálogo</h5>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-md-3">
                            <div class="border-end">
                                <div class="stat-number">${estatisticas.total_livros}</div>
                                <small class="text-muted">Total de Livros</small>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="border-end">
                                <div class="stat-number">${estatisticas.livros_estoque}</div>
                                <small class="text-muted">Livros em Estoque</small>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="border-end">
                                <div class="stat-number">${estatisticas.estoque_baixo}</div>
                                <small class="text-muted">Estoque Baixo</small>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stat-number">${estatisticas.livros_destaque}</div>
                            <small class="text-muted">Em Destaque</small>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Modal de Confirmação de Exclusão -->
    <div class="modal fade" id="confirmDeleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirmar Exclusão</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Tem certeza que deseja excluir o livro <strong id="livroTitulo"></strong>?</p>
                    <p class="text-danger small">Esta ação não pode ser desfeita.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Sim, Excluir</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin.js"></script>
    
    <script>
        // Variáveis globais
        let livroIdToDelete = null;
        
        // Função para confirmar exclusão
        function confirmarExclusao(livroId, titulo) {
            livroIdToDelete = livroId;
            document.getElementById('livroTitulo').textContent = titulo;
            
            const modal = new bootstrap.Modal(document.getElementById('confirmDeleteModal'));
            modal.show();
        }
        
        // Event listener para confirmação de exclusão
        document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
            if (livroIdToDelete) {
                // Fazer requisição AJAX para excluir
                fetch(`${pageContext.request.contextPath}/livros/${livroIdToDelete}`, {
                    method: 'DELETE',
                    headers: {
                        'Content-Type': 'application/json',
                    }
                })
                .then(response => {
                    if (response.ok) {
                        // Recarregar a página ou remover o item da lista
                        location.reload();
                    } else {
                        alert('Erro ao excluir livro');
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao excluir livro');
                });
                
                // Fechar modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('confirmDeleteModal'));
                modal.hide();
            }
        });
        
        // Auto-submit do formulário quando filtros mudarem
        document.getElementById('filterForm').addEventListener('change', function(e) {
            if (e.target.name !== 'busca') {
                this.submit();
            }
        });
        
        // Submit do formulário ao pressionar Enter na busca
        document.querySelector('input[name="busca"]').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                document.getElementById('filterForm').submit();
            }
        });
        
        // Inicializar tooltips
        document.addEventListener('DOMContentLoaded', function() {
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        });
        
        // Animação dos cards
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.book-card');
            
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });
            
            cards.forEach(card => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(card);
            });
        });
    </script>
    
    <style>
        /* Custom CSS específico para esta página */
        .book-card {
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        
        .book-card::before {
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
        
        .book-card:hover::before {
            left: 100%;
        }
        
        .book-card:hover {
            transform: translateY(-12px) scale(1.02);
            box-shadow: 0 25px 50px rgba(139, 69, 19, 0.25);
        }
        
        .book-cover {
            position: relative;
            overflow: hidden;
            border-radius: 8px;
        }
        
        .book-cover::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, transparent 0%, rgba(139, 69, 19, 0.1) 100%);
        }
        
        .filter-card {
            background: rgba(245, 245, 220, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .badge-stock-ok {
            background: linear-gradient(135deg, #228B22 0%, #32CD32 100%);
        }
        
        .badge-stock-low {
            background: linear-gradient(135deg, #FFA500 0%, #FF8C00 100%);
        }
        
        .badge-stock-out {
            background: linear-gradient(135deg, #800020 0%, #DC143C 100%);
        }
        
        .stats-card {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.1) 0%, rgba(139, 69, 19, 0.1) 100%);
            border: 1px solid rgba(218, 165, 32, 0.3);
        }
        
        .stat-number {
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 2rem;
            background: linear-gradient(135deg, #DAA520 0%, #B8860B 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .filter-card, .stats-card {
            animation: fadeInUp 0.6s ease-out;
        }
        
        /* Pagination styling */
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 2px;
            border: 1px solid #dee2e6;
            color: #6c757d;
        }
        
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #8B4513 0%, #654321 100%);
            border-color: #8B4513;
        }
        
        .pagination .page-link:hover {
            background-color: #f8f9fa;
            border-color: #8B4513;
            color: #8B4513;
        }
    </style>
</body>
</html>