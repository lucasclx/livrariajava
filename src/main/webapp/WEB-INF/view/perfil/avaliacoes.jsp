<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Minhas Avaliações - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .review-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.2s;
        }
        .review-card:hover {
            transform: translateY(-2px);
        }
        .book-cover {
            width: 80px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
        }
        .rating-stars {
            color: #ffc107;
            font-size: 1.2rem;
        }
        .rating-stars .far {
            color: #dee2e6;
        }
        .review-status {
            font-size: 0.75rem;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
        }
        .status-approved { background: #d1e7dd; color: #0f5132; }
        .status-pending { background: #fff3cd; color: #664d03; }
        .status-rejected { background: #f8d7da; color: #842029; }
        .recommend-badge {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border: none;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.75rem;
        }
        .not-recommend-badge {
            background: linear-gradient(45deg, #dc3545, #fd7e14);
            color: white;
            border: none;
            padding: 0.25rem 0.75rem;
            border-radius: 15px;
            font-size: 0.75rem;
        }
    </style>
</head>
<body>
    <!-- Header com navegação aqui -->
    
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-2">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/perfil" class="text-white-50">
                                    <i class="fas fa-user"></i> Perfil
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Avaliações</li>
                        </ol>
                    </nav>
                    <h1 class="h3 mb-0">
                        <i class="fas fa-star me-2"></i>Minhas Avaliações
                    </h1>
                    <p class="mb-0 opacity-75">Acompanhe suas avaliações e compartilhe sua opinião</p>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/loja" class="btn btn-light">
                        <i class="fas fa-plus me-2"></i>Avaliar Mais Livros
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <!-- Estatísticas das Avaliações -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="text-warning mb-2">
                            <i class="fas fa-star fa-2x"></i>
                        </div>
                        <h4 class="mb-0">${totalAvaliacoes != null ? totalAvaliacoes : 0}</h4>
                        <small class="text-muted">Total de Avaliações</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="text-success mb-2">
                            <i class="fas fa-thumbs-up fa-2x"></i>
                        </div>
                        <h4 class="mb-0" id="approvedCount">0</h4>
                        <small class="text-muted">Aprovadas</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="text-warning mb-2">
                            <i class="fas fa-clock fa-2x"></i>
                        </div>
                        <h4 class="mb-0" id="pendingCount">0</h4>
                        <small class="text-muted">Pendentes</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card text-center">
                    <div class="card-body">
                        <div class="text-info mb-2">
                            <i class="fas fa-chart-line fa-2x"></i>
                        </div>
                        <h4 class="mb-0" id="avgRating">0.0</h4>
                        <small class="text-muted">Nota Média</small>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filtros -->
        <div class="row mb-4">
            <div class="col-md-4">
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-search"></i>
                    </span>
                    <input type="text" class="form-control" placeholder="Buscar por título do livro..." 
                           id="searchReview">
                </div>
            </div>
            <div class="col-md-3">
                <select class="form-select" id="statusFilter">
                    <option value="">Todos os Status</option>
                    <option value="approved">Aprovadas</option>
                    <option value="pending">Pendentes</option>
                    <option value="rejected">Rejeitadas</option>
                </select>
            </div>
            <div class="col-md-3">
                <select class="form-select" id="ratingFilter">
                    <option value="">Todas as Notas</option>
                    <option value="5">5 Estrelas</option>
                    <option value="4">4 Estrelas</option>
                    <option value="3">3 Estrelas</option>
                    <option value="2">2 Estrelas</option>
                    <option value="1">1 Estrela</option>
                </select>
            </div>
            <div class="col-md-2">
                <select class="form-select" id="orderBy">
                    <option value="newest">Mais Recentes</option>
                    <option value="oldest">Mais Antigas</option>
                    <option value="rating_high">Maior Nota</option>
                    <option value="rating_low">Menor Nota</option>
                </select>
            </div>
        </div>

        <!-- Lista de Avaliações -->
        <c:choose>
            <c:when test="${empty avaliacoes}">
                <div class="text-center py-5">
                    <i class="fas fa-star fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Nenhuma avaliação encontrada</h4>
                    <p class="text-muted">Você ainda não fez nenhuma avaliação ou nenhuma avaliação corresponde aos filtros aplicados.</p>
                    <a href="${pageContext.request.contextPath}/loja" class="btn btn-warning">
                        <i class="fas fa-star me-2"></i>Avaliar Livros
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="avaliacao" items="${avaliacoes}">
                        <div class="col-12">
                            <div class="review-card card" data-status="${avaliacao.aprovado ? 'approved' : 'pending'}" 
                                 data-rating="${avaliacao.rating}" data-title="${avaliacao.livro.titulo}">
                                <div class="card-body">
                                    <div class="row">
                                        <!-- Capa do Livro -->
                                        <div class="col-auto">
                                            <img src="${avaliacao.livro.imagemUrl}" alt="${avaliacao.livro.titulo}" 
                                                 class="book-cover">
                                        </div>
                                        
                                        <!-- Conteúdo da Avaliação -->
                                        <div class="col">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <div>
                                                    <h5 class="card-title mb-1">${avaliacao.livro.titulo}</h5>
                                                    <p class="text-muted mb-2">${avaliacao.livro.autor}</p>
                                                </div>
                                                <div class="text-end">
                                                    <div class="d-flex align-items-center gap-2 mb-2">
                                                        <c:choose>
                                                            <c:when test="${avaliacao.aprovado}">
                                                                <span class="review-status status-approved">
                                                                    <i class="fas fa-check me-1"></i>Aprovada
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="review-status status-pending">
                                                                    <i class="fas fa-clock me-1"></i>Pendente
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        
                                                        <c:if test="${avaliacao.recomenda}">
                                                            <span class="recommend-badge">
                                                                <i class="fas fa-thumbs-up me-1"></i>Recomendo
                                                            </span>
                                                        </c:if>
                                                        <c:if test="${!avaliacao.recomenda}">
                                                            <span class="not-recommend-badge">
                                                                <i class="fas fa-thumbs-down me-1"></i>Não Recomendo
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${avaliacao.createdAt}" pattern="dd/MM/yyyy 'às' HH:mm" />
                                                    </small>
                                                </div>
                                            </div>

                                            <!-- Rating -->
                                            <div class="rating-stars mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fa${i <= avaliacao.rating ? 's' : 'r'} fa-star"></i>
                                                </c:forEach>
                                                <span class="ms-2 text-muted">(${avaliacao.rating}/5)</span>
                                            </div>

                                            <!-- Título da Avaliação -->
                                            <c:if test="${not empty avaliacao.titulo}">
                                                <h6 class="mb-2">"${avaliacao.titulo}"</h6>
                                            </c:if>

                                            <!-- Comentário -->
                                            <c:if test="${not empty avaliacao.comentario}">
                                                <p class="card-text mb-2">${avaliacao.comentario}</p>
                                            </c:if>

                                            <!-- Vantagens e Desvantagens -->
                                            <c:if test="${not empty avaliacao.vantagens || not empty avaliacao.desvantagens}">
                                                <div class="row mt-3">
                                                    <c:if test="${not empty avaliacao.vantagens}">
                                                        <div class="col-md-6">
                                                            <div class="card bg-light">
                                                                <div class="card-body p-2">
                                                                    <h6 class="text-success mb-1">
                                                                        <i class="fas fa-plus me-1"></i>Pontos Positivos
                                                                    </h6>
                                                                    <small>${avaliacao.vantagens}</small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${not empty avaliacao.desvantagens}">
                                                        <div class="col-md-6">
                                                            <div class="card bg-light">
                                                                <div class="card-body p-2">
                                                                    <h6 class="text-danger mb-1">
                                                                        <i class="fas fa-minus me-1"></i>Pontos Negativos
                                                                    </h6>
                                                                    <small>${avaliacao.desvantagens}</small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </c:if>

                                            <!-- Ações -->
                                            <div class="d-flex justify-content-between align-items-center mt-3">
                                                <div class="btn-group btn-group-sm" role="group">
                                                    <button type="button" class="btn btn-outline-primary" 
                                                            onclick="editarAvaliacao(${avaliacao.id})">
                                                        <i class="fas fa-edit me-1"></i>Editar
                                                    </button>
                                                    <button type="button" class="btn btn-outline-danger" 
                                                            onclick="excluirAvaliacao(${avaliacao.id})">
                                                        <i class="fas fa-trash me-1"></i>Excluir
                                                    </button>
                                                    <button type="button" class="btn btn-outline-info" 
                                                            onclick="compartilharAvaliacao(${avaliacao.id})">
                                                        <i class="fas fa-share me-1"></i>Compartilhar
                                                    </button>
                                                </div>
                                                
                                                <a href="${pageContext.request.contextPath}/loja/livro/${avaliacao.livro.id}" 
                                                   class="btn btn-sm btn-outline-secondary">
                                                    <i class="fas fa-book me-1"></i>Ver Livro
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Paginação -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Navegação de avaliações">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="page">
                                <c:choose>
                                    <c:when test="${page == currentPage}">
                                        <li class="page-item active">
                                            <span class="page-link">${page}</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${page}">${page}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Calcular estatísticas
        document.addEventListener('DOMContentLoaded', function() {
            const reviewCards = document.querySelectorAll('.review-card');
            let approvedCount = 0;
            let pendingCount = 0;
            let totalRating = 0;
            let totalReviews = reviewCards.length;

            reviewCards.forEach(card => {
                const status = card.dataset.status;
                const rating = parseInt(card.dataset.rating);

                if (status === 'approved') {
                    approvedCount++;
                } else {
                    pendingCount++;
                }

                totalRating += rating;
            });

            document.getElementById('approvedCount').textContent = approvedCount;
            document.getElementById('pendingCount').textContent = pendingCount;
            document.getElementById('avgRating').textContent = totalReviews > 0 ? 
                (totalRating / totalReviews).toFixed(1) : '0.0';
        });

        // Filtros em tempo real
        document.getElementById('searchReview').addEventListener('input', filterReviews);
        document.getElementById('statusFilter').addEventListener('change', filterReviews);
        document.getElementById('ratingFilter').addEventListener('change', filterReviews);
        document.getElementById('orderBy').addEventListener('change', filterReviews);

        function filterReviews() {
            const search = document.getElementById('searchReview').value.toLowerCase();
            const status = document.getElementById('statusFilter').value;
            const rating = document.getElementById('ratingFilter').value;
            const orderBy = document.getElementById('orderBy').value;

            const reviews = Array.from(document.querySelectorAll('.review-card'));

            // Filtrar
            reviews.forEach(review => {
                const title = review.dataset.title.toLowerCase();
                const reviewStatus = review.dataset.status;
                const reviewRating = review.dataset.rating;

                let show = true;

                if (search && !title.includes(search)) {
                    show = false;
                }

                if (status && reviewStatus !== status) {
                    show = false;
                }

                if (rating && reviewRating !== rating) {
                    show = false;
                }

                review.style.display = show ? 'block' : 'none';
            });

            // Ordenar
            const container = document.querySelector('.row');
            const visibleReviews = reviews.filter(review => review.style.display !== 'none');
            
            visibleReviews.sort((a, b) => {
                switch (orderBy) {
                    case 'oldest':
                        return new Date(a.querySelector('small').textContent) - new Date(b.querySelector('small').textContent);
                    case 'rating_high':
                        return parseInt(b.dataset.rating) - parseInt(a.dataset.rating);
                    case 'rating_low':
                        return parseInt(a.dataset.rating) - parseInt(b.dataset.rating);
                    default: // newest
                        return new Date(b.querySelector('small').textContent) - new Date(a.querySelector('small').textContent);
                }
            });

            // Reorganizar no DOM
            visibleReviews.forEach(review => {
                container.appendChild(review.parentElement);
            });
        }

        // Funções de ação
        function editarAvaliacao(id) {
            // Implementar modal de edição ou redirecionar para página de edição
            alert('Funcionalidade de edição será implementada em breve.');
        }

        function excluirAvaliacao(id) {
            if (confirm('Tem certeza que deseja excluir esta avaliação?')) {
                // Implementar exclusão via AJAX
                alert('Funcionalidade de exclusão será implementada em breve.');
            }
        }

        function compartilharAvaliacao(id) {
            if (navigator.share) {
                navigator.share({
                    title: 'Minha avaliação na Livraria Mil Páginas',
                    text: 'Confira minha avaliação de livro!',
                    url: window.location.href
                });
            } else {
                // Fallback para cópia do link
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('Link copiado para a área de transferência!');
                });
            }
        }
    </script>
</body>
</html>