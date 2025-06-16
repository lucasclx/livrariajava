<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Minhas Avaliações" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .page-hero {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .stats-card {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
            transition: all 0.3s ease;
            text-align: center;
            padding: 1.5rem;
            height: 100%;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.2);
        }
        
        .stats-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            color: white;
        }
        
        .review-card {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .review-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
        }
        
        .review-header {
            background: white;
            padding: 1.5rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .book-cover {
            width: 100px;
            height: 150px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .rating-stars {
            color: var(--gold);
            font-size: 1.2rem;
        }
        
        .rating-stars .empty {
            color: var(--light-brown);
        }
        
        .review-status {
            font-size: 0.875rem;
            padding: 0.25rem 1rem;
            border-radius: 20px;
            font-weight: 500;
        }
        
        .status-approved { 
            background: linear-gradient(135deg, rgba(34, 139, 34, 0.2) 0%, rgba(34, 139, 34, 0.1) 100%);
            color: var(--forest-green);
        }
        .status-pending { 
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.2) 0%, rgba(218, 165, 32, 0.1) 100%);
            color: var(--dark-gold);
        }
        
        .recommend-badge {
            background: linear-gradient(135deg, var(--forest-green) 0%, #1a6e1a 100%);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .not-recommend-badge {
            background: linear-gradient(135deg, var(--burgundy) 0%, #a00025 100%);
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .pros-cons {
            background: rgba(255, 255, 255, 0.5);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
        }
        
        .pros-cons h6 {
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .filter-card {
            background: rgba(245, 245, 220, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.1);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.08);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--ink);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--light-brown);
            margin-bottom: 1rem;
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
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <!-- Hero Section -->
    <section class="page-hero">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Início</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/perfil">Meu Perfil</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Avaliações</li>
                </ol>
            </nav>
            
            <div class="row align-items-center">
                <div class="col">
                    <h1 class="h3 mb-0">
                        <i class="fas fa-star me-2"></i>Minhas Avaliações
                    </h1>
                    <p class="mb-0 opacity-75">Acompanhe suas avaliações e compartilhe sua opinião</p>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-gold">
                        <i class="fas fa-plus me-2"></i>Avaliar Mais Livros
                    </a>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4 flex-grow-1">
        <!-- Estatísticas -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon">
                        <i class="fas fa-star"></i>
                    </div>
                    <h4 class="mb-1">${totalAvaliacoes != null ? totalAvaliacoes : 0}</h4>
                    <p class="text-muted mb-0 small">Total de Avaliações</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, var(--forest-green) 0%, #1a6e1a 100%);">
                        <i class="fas fa-check"></i>
                    </div>
                    <h4 class="mb-1" id="approvedCount">0</h4>
                    <p class="text-muted mb-0 small">Aprovadas</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%);">
                        <i class="fas fa-clock"></i>
                    </div>
                    <h4 class="mb-1" id="pendingCount">0</h4>
                    <p class="text-muted mb-0 small">Pendentes</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-icon" style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <h4 class="mb-1" id="avgRating">0.0</h4>
                    <p class="text-muted mb-0 small">Nota Média</p>
                </div>
            </div>
        </div>

        <!-- Filtros -->
        <div class="filter-card">
            <div class="row g-3">
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
        </div>

        <!-- Lista de Avaliações -->
        <c:choose>
            <c:when test="${empty avaliacoes}">
                <div class="empty-state">
                    <i class="fas fa-star"></i>
                    <h4>Nenhuma avaliação encontrada</h4>
                    <p class="text-muted">Você ainda não fez nenhuma avaliação ou nenhuma avaliação corresponde aos filtros aplicados.</p>
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary">
                        <i class="fas fa-star me-2"></i>Avaliar Livros
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div id="reviewsList">
                    <c:forEach var="avaliacao" items="${avaliacoes}">
                        <div class="review-card" data-status="${avaliacao.aprovado ? 'approved' : 'pending'}" 
                             data-rating="${avaliacao.rating}" data-title="${avaliacao.livro.titulo}">
                            <div class="review-header">
                                <div class="row">
                                    <!-- Capa do Livro -->
                                    <div class="col-auto">
                                        <c:choose>
                                            <c:when test="${not empty avaliacao.livro.imagem}">
                                                <img src="${pageContext.request.contextPath}/uploads/livros/${avaliacao.livro.imagem}" 
                                                     alt="${avaliacao.livro.titulo}" class="book-cover">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="book-cover d-flex align-items-center justify-content-center bg-light">
                                                    <i class="fas fa-book fa-2x text-muted"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    
                                    <!-- Conteúdo da Avaliação -->
                                    <div class="col">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h5 class="mb-1">${avaliacao.livro.titulo}</h5>
                                                <p class="text-muted mb-2">
                                                    <i class="fas fa-feather-alt me-1"></i>${avaliacao.livro.autor}
                                                </p>
                                                
                                                <!-- Rating -->
                                                <div class="rating-stars mb-2">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <i class="fas fa-star ${i <= avaliacao.rating ? '' : 'empty'}"></i>
                                                    </c:forEach>
                                                    <span class="ms-2 text-muted">(${avaliacao.rating}/5)</span>
                                                </div>
                                            </div>
                                            
                                            <div class="text-end">
                                                <div class="d-flex gap-2 mb-2">
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
                                                    <i class="fas fa-calendar-alt me-1"></i>
                                                    <fmt:formatDate value="${avaliacao.createdAt}" pattern="dd/MM/yyyy 'às' HH:mm" />
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-body">
                                <!-- Título da Avaliação -->
                                <c:if test="${not empty avaliacao.titulo}">
                                    <h6 class="mb-2">"${avaliacao.titulo}"</h6>
                                </c:if>
                                
                                <!-- Comentário -->
                                <c:if test="${not empty avaliacao.comentario}">
                                    <p class="mb-3">${avaliacao.comentario}</p>
                                </c:if>
                                
                                <!-- Prós e Contras -->
                                <c:if test="${not empty avaliacao.vantagens || not empty avaliacao.desvantagens}">
                                    <div class="row">
                                        <c:if test="${not empty avaliacao.vantagens}">
                                            <div class="col-md-6">
                                                <div class="pros-cons">
                                                    <h6 class="text-success">
                                                        <i class="fas fa-plus-circle me-1"></i>Pontos Positivos
                                                    </h6>
                                                    <p class="mb-0 small">${avaliacao.vantagens}</p>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${not empty avaliacao.desvantagens}">
                                            <div class="col-md-6">
                                                <div class="pros-cons">
                                                    <h6 class="text-danger">
                                                        <i class="fas fa-minus-circle me-1"></i>Pontos Negativos
                                                    </h6>
                                                    <p class="mb-0 small">${avaliacao.desvantagens}</p>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                                
                                <!-- Ações -->
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <div class="btn-group btn-group-sm" role="group">
                                        <button type="button" class="btn btn-outline-elegant" 
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
                                       class="btn btn-sm btn-primary">
                                        <i class="fas fa-book me-1"></i>Ver Livro
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Paginação -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Navegação de avaliações" class="mt-4">
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
    </main>

    <jsp:include page="../common/footer.jsp" />
    
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
                
            // Animação ao carregar
            reviewCards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });

        // Filtros em tempo real
        document.getElementById('searchReview').addEventListener('input', filterReviews);
        document.getElementById('statusFilter').addEventListener('change', filterReviews);
        document.getElementById('ratingFilter').addEventListener('change', filterReviews);
        document.getElementById('orderBy').addEventListener('change', sortReviews);

        function filterReviews() {
            const search = document.getElementById('searchReview').value.toLowerCase();
            const status = document.getElementById('statusFilter').value;
            const rating = document.getElementById('ratingFilter').value;

            const reviews = document.querySelectorAll('.review-card');

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
        }

        function sortReviews() {
            const orderBy = document.getElementById('orderBy').value;
            const container = document.getElementById('reviewsList');
            const reviews = Array.from(document.querySelectorAll('.review-card'));
            
            reviews.sort((a, b) => {
                switch (orderBy) {
                    case 'oldest':
                        // Implementar com base na data
                        return 0;
                    case 'rating_high':
                        return parseInt(b.dataset.rating) - parseInt(a.dataset.rating);
                    case 'rating_low':
                        return parseInt(a.dataset.rating) - parseInt(b.dataset.rating);
                    default: // newest
                        return 0;
                }
            });

            // Reorganizar no DOM
            reviews.forEach(review => {
                container.appendChild(review);
            });
        }

        // Funções de ação
        function editarAvaliacao(id) {
            // Redirecionar para página de edição
            window.location.href = `${pageContext.request.contextPath}/perfil/avaliacoes/${id}/editar`;
        }

        function excluirAvaliacao(id) {
            if (confirm('Tem certeza que deseja excluir esta avaliação?')) {
                fetch(`${pageContext.request.contextPath}/api/avaliacoes/${id}`, {
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
                        alert('Erro ao excluir avaliação: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao excluir avaliação');
                });
            }
        }

        function compartilharAvaliacao(id) {
            const url = `${window.location.origin}${pageContext.request.contextPath}/avaliacoes/${id}`;
            
            if (navigator.share) {
                navigator.share({
                    title: 'Minha avaliação na Livraria Mil Páginas',
                    text: 'Confira minha avaliação de livro!',
                    url: url
                });
            } else {
                // Fallback para copiar o link
                navigator.clipboard.writeText(url).then(() => {
                    alert('Link copiado para a área de transferência!');
                });
            }
        }
    </script>
</body>
</html>