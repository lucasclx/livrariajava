<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .profile-avatar {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.2);
            border: 3px solid rgba(255,255,255,0.3);
        }
        .stat-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
        }
        .recent-item {
            border-left: 4px solid #667eea;
            padding-left: 1rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <!-- Header com navegação aqui -->
    
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-auto">
                    <div class="profile-avatar rounded-circle d-flex align-items-center justify-content-center">
                        <i class="fas fa-user fa-2x"></i>
                    </div>
                </div>
                <div class="col">
                    <h1 class="h3 mb-1">Olá, ${user.firstName}!</h1>
                    <p class="mb-0 opacity-75">Bem-vindo de volta ao seu perfil</p>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/perfil/editar" class="btn btn-light">
                        <i class="fas fa-edit me-2"></i>Editar Perfil
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <!-- Estatísticas -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <div class="text-primary mb-2">
                            <i class="fas fa-shopping-bag fa-2x"></i>
                        </div>
                        <h4 class="mb-0">${totalPedidos}</h4>
                        <small class="text-muted">Pedidos Realizados</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <div class="text-success mb-2">
                            <i class="fas fa-dollar-sign fa-2x"></i>
                        </div>
                        <h4 class="mb-0">
                            <fmt:formatNumber value="${valorTotalGasto}" type="currency" currencySymbol="R$ " />
                        </h4>
                        <small class="text-muted">Total Investido</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <div class="text-danger mb-2">
                            <i class="fas fa-heart fa-2x"></i>
                        </div>
                        <h4 class="mb-0">${livrosFavoritos}</h4>
                        <small class="text-muted">Livros Favoritos</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stat-card">
                    <div class="card-body text-center">
                        <div class="text-warning mb-2">
                            <i class="fas fa-star fa-2x"></i>
                        </div>
                        <h4 class="mb-0">${avaliacoesFeitas}</h4>
                        <small class="text-muted">Avaliações</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Últimos Pedidos -->
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-history me-2"></i>Últimos Pedidos
                        </h5>
                        <a href="${pageContext.request.contextPath}/perfil/pedidos" class="btn btn-sm btn-outline-primary">
                            Ver Todos
                        </a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty ultimosPedidos}">
                                <div class="text-center text-muted py-4">
                                    <i class="fas fa-shopping-cart fa-3x mb-3 opacity-50"></i>
                                    <p>Você ainda não fez nenhum pedido.</p>
                                    <a href="${pageContext.request.contextPath}/loja" class="btn btn-primary">
                                        Começar a Comprar
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="pedido" items="${ultimosPedidos}">
                                    <div class="recent-item">
                                        <div class="d-flex justify-content-between align-items-start">
                                            <div>
                                                <h6 class="mb-1">Pedido #${pedido.orderNumber}</h6>
                                                <small class="text-muted">
                                                    <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </small>
                                            </div>
                                            <div class="text-end">
                                                <div class="fw-bold">
                                                    <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                                                </div>
                                                <span class="badge bg-primary">${pedido.statusLabel}</span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Livros Favoritos -->
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-heart me-2"></i>Favoritos
                        </h5>
                        <a href="${pageContext.request.contextPath}/perfil/favoritos" class="btn btn-sm btn-outline-danger">
                            Ver Todos
                        </a>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty favoritos}">
                                <div class="text-center text-muted py-4">
                                    <i class="fas fa-heart fa-3x mb-3 opacity-50"></i>
                                    <p>Você ainda não tem livros favoritos.</p>
                                    <a href="${pageContext.request.contextPath}/loja" class="btn btn-danger">
                                        Explorar Livros
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="row g-2">
                                    <c:forEach var="livro" items="${favoritos}" varStatus="status">
                                        <c:if test="${status.index < 6}">
                                            <div class="col-6">
                                                <div class="card card-book-small">
                                                    <div class="row g-0">
                                                        <div class="col-4">
                                                            <img src="${livro.imagemUrl}" class="img-fluid rounded-start" 
                                                                 alt="${livro.titulo}" style="height: 80px; object-fit: cover;">
                                                        </div>
                                                        <div class="col-8">
                                                            <div class="card-body p-2">
                                                                <h6 class="card-title small mb-1" title="${livro.titulo}">
                                                                    ${livro.titulo.length() > 25 ? livro.titulo.substring(0, 25).concat('...') : livro.titulo}
                                                                </h6>
                                                                <p class="card-text small text-muted mb-1">${livro.autor}</p>
                                                                <div class="text-primary fw-bold small">${livro.precoFormatado}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
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
        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-bolt me-2"></i>Ações Rápidas
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/perfil/editar" class="btn btn-outline-primary w-100">
                                    <i class="fas fa-user-edit mb-2 d-block"></i>
                                    Editar Perfil
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/perfil/pedidos" class="btn btn-outline-success w-100">
                                    <i class="fas fa-list mb-2 d-block"></i>
                                    Meus Pedidos
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/perfil/favoritos" class="btn btn-outline-danger w-100">
                                    <i class="fas fa-heart mb-2 d-block"></i>
                                    Favoritos
                                </a>
                            </div>
                            <div class="col-md-3">
                                <a href="${pageContext.request.contextPath}/perfil/avaliacoes" class="btn btn-outline-warning w-100">
                                    <i class="fas fa-star mb-2 d-block"></i>
                                    Avaliações
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>