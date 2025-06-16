<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Meu Perfil" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .profile-hero {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .profile-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(218, 165, 32, 0.1) 0%, transparent 70%);
            animation: rotate 30s linear infinite;
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
            border: 5px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 1;
        }
        
        .stat-card {
            background: rgba(253, 246, 227, 0.9);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
            transition: all 0.3s ease;
            height: 100%;
            backdrop-filter: blur(5px);
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.2);
        }
        
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.5rem;
        }
        
        .stat-icon.primary { background: linear-gradient(135deg, var(--primary-brown) 0%, var(--dark-brown) 100%); color: white; }
        .stat-icon.success { background: linear-gradient(135deg, var(--forest-green) 0%, #1a6e1a 100%); color: white; }
        .stat-icon.danger { background: linear-gradient(135deg, var(--burgundy) 0%, #a00025 100%); color: white; }
        .stat-icon.warning { background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%); color: white; }
        
        .recent-item {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            border-left: 4px solid var(--gold);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        
        .recent-item:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .section-card {
            background: rgba(253, 246, 227, 0.7);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(139, 69, 19, 0.1);
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.08);
            overflow: hidden;
        }
        
        .section-header {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.1) 0%, rgba(139, 69, 19, 0.1) 100%);
            padding: 1.5rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 2rem 1rem;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .action-card:hover {
            border-color: var(--gold);
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(218, 165, 32, 0.2);
        }
        
        .action-card .icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 1rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            transition: all 0.3s ease;
        }
        
        .action-card:hover .icon {
            transform: scale(1.1);
        }
        
        .book-mini {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        
        .book-mini:hover {
            transform: scale(1.02);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .book-mini img {
            height: 100px;
            width: 100%;
            object-fit: cover;
        }
        
        .empty-state {
            text-align: center;
            padding: 3rem 2rem;
            color: var(--ink);
        }
        
        .empty-state i {
            font-size: 3rem;
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
    <section class="profile-hero">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Início</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Meu Perfil</li>
                </ol>
            </nav>
            
            <div class="row align-items-center">
                <div class="col-auto">
                    <div class="profile-avatar rounded-circle d-flex align-items-center justify-content-center">
                        <i class="fas fa-user fa-3x"></i>
                    </div>
                </div>
                <div class="col">
                    <h1 class="display-6 mb-2">Olá, ${fn:split(sessionScope.user.name, ' ')[0]}!</h1>
                    <p class="mb-2 opacity-90">
                        <i class="fas fa-envelope me-2"></i>${sessionScope.user.email}
                    </p>
                    <p class="mb-0 opacity-75">
                        <i class="fas fa-calendar me-2"></i>Cliente desde 
                        <fmt:formatDate value="${sessionScope.user.createdAt}" pattern="MMMM 'de' yyyy" />
                    </p>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/perfil/editar" class="btn btn-gold">
                        <i class="fas fa-edit me-2"></i>Editar Perfil
                    </a>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4 flex-grow-1">
        <!-- Estatísticas -->
        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="stat-card text-center p-4">
                    <div class="stat-icon primary">
                        <i class="fas fa-shopping-bag"></i>
                    </div>
                    <h3 class="mb-1">${totalPedidos != null ? totalPedidos : 0}</h3>
                    <p class="text-muted mb-0">Pedidos Realizados</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center p-4">
                    <div class="stat-icon success">
                        <i class="fas fa-book"></i>
                    </div>
                    <h3 class="mb-1">${totalLivrosComprados != null ? totalLivrosComprados : 0}</h3>
                    <p class="text-muted mb-0">Livros Comprados</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center p-4">
                    <div class="stat-icon danger">
                        <i class="fas fa-heart"></i>
                    </div>
                    <h3 class="mb-1">${livrosFavoritos != null ? livrosFavoritos : 0}</h3>
                    <p class="text-muted mb-0">Livros Favoritos</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card text-center p-4">
                    <div class="stat-icon warning">
                        <i class="fas fa-star"></i>
                    </div>
                    <h3 class="mb-1">${avaliacoesFeitas != null ? avaliacoesFeitas : 0}</h3>
                    <p class="text-muted mb-0">Avaliações</p>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <!-- Últimos Pedidos -->
            <div class="col-lg-6">
                <div class="section-card h-100">
                    <div class="section-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-clock me-2"></i>Últimos Pedidos
                        </h5>
                        <a href="${pageContext.request.contextPath}/perfil/pedidos" class="btn btn-sm btn-outline-elegant">
                            Ver Todos <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty ultimosPedidos}">
                                <div class="empty-state">
                                    <i class="fas fa-shopping-cart"></i>
                                    <h6>Nenhum pedido ainda</h6>
                                    <p class="text-muted small">Que tal começar explorando nosso catálogo?</p>
                                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary btn-sm">
                                        <i class="fas fa-book me-2"></i>Ver Livros
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="pedido" items="${ultimosPedidos}" varStatus="status">
                                    <c:if test="${status.index < 5}">
                                        <div class="recent-item">
                                            <div class="d-flex justify-content-between align-items-start">
                                                <div>
                                                    <h6 class="mb-1">Pedido #${pedido.orderNumber}</h6>
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar-alt me-1"></i>
                                                        <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </small>
                                                </div>
                                                <div class="text-end">
                                                    <div class="fw-bold text-success">
                                                        <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                                                    </div>
                                                    <span class="badge bg-${pedido.status == 'delivered' ? 'success' : pedido.status == 'shipped' ? 'info' : 'warning'} small">
                                                        ${pedido.statusLabel}
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Livros Favoritos -->
            <div class="col-lg-6">
                <div class="section-card h-100">
                    <div class="section-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-heart me-2"></i>Favoritos
                        </h5>
                        <a href="${pageContext.request.contextPath}/perfil/favoritos" class="btn btn-sm btn-outline-elegant">
                            Ver Todos <i class="fas fa-arrow-right ms-1"></i>
                        </a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty favoritos}">
                                <div class="empty-state">
                                    <i class="fas fa-heart"></i>
                                    <h6>Lista vazia</h6>
                                    <p class="text-muted small">Adicione livros aos seus favoritos para acessá-los rapidamente</p>
                                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary btn-sm">
                                        <i class="fas fa-search me-2"></i>Explorar
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-2">
                                    <c:forEach var="livro" items="${favoritos}" varStatus="status">
                                        <c:if test="${status.index < 6}">
                                            <div class="col-6 col-md-4">
                                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                                   class="text-decoration-none">
                                                    <div class="book-mini">
                                                        <c:choose>
                                                            <c:when test="${not empty livro.imagem}">
                                                                <img src="${pageContext.request.contextPath}/uploads/livros/${livro.imagem}" 
                                                                     alt="${livro.titulo}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div style="height: 100px; background: var(--aged-paper); display: flex; align-items: center; justify-content: center;">
                                                                    <i class="fas fa-book text-muted"></i>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div class="p-2">
                                                            <h6 class="small mb-0 text-truncate" title="${livro.titulo}">
                                                                ${livro.titulo}
                                                            </h6>
                                                            <div class="text-primary fw-bold small">
                                                                ${livro.precoFormatado}
                                                            </div>
                                                        </div>
                                                    </div>
                                                </a>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ações Rápidas -->
        <div class="section-card mt-5">
            <div class="section-header">
                <h5 class="mb-0">
                    <i class="fas fa-lightning me-2"></i>Ações Rápidas
                </h5>
            </div>
            <div class="card-body">
                <div class="row g-4">
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/perfil/editar" class="text-decoration-none">
                            <div class="action-card">
                                <div class="icon bg-primary text-white">
                                    <i class="fas fa-user-edit"></i>
                                </div>
                                <h6>Editar Perfil</h6>
                                <p class="text-muted small mb-0">Atualize suas informações</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/perfil/pedidos" class="text-decoration-none">
                            <div class="action-card">
                                <div class="icon bg-success text-white">
                                    <i class="fas fa-shopping-bag"></i>
                                </div>
                                <h6>Meus Pedidos</h6>
                                <p class="text-muted small mb-0">Acompanhe suas compras</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/perfil/enderecos" class="text-decoration-none">
                            <div class="action-card">
                                <div class="icon bg-info text-white">
                                    <i class="fas fa-map-marker-alt"></i>
                                </div>
                                <h6>Endereços</h6>
                                <p class="text-muted small mb-0">Gerencie endereços de entrega</p>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-3">
                        <a href="${pageContext.request.contextPath}/perfil/avaliacoes" class="text-decoration-none">
                            <div class="action-card">
                                <div class="icon bg-warning text-white">
                                    <i class="fas fa-star"></i>
                                </div>
                                <h6>Avaliações</h6>
                                <p class="text-muted small mb-0">Suas opiniões sobre livros</p>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
        // Animação suave ao carregar
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.stat-card, .section-card, .action-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>