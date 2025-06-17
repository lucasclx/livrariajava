<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Dashboard Administrativo" />

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --dark-color: #343a40;
            --light-color: #f8f9fa;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            margin: 0;
            padding: 0;
        }

        .sidebar {
            background: linear-gradient(135deg, var(--dark-color) 0%, #495057 100%);
            min-height: 100vh;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            position: relative;
        }

        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin: 0.25rem 0.5rem;
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .sidebar .nav-link:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }

        .sidebar .nav-link.active {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
        }

        .main-content {
            padding: 2rem;
            flex: 1;
        }

        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: none;
            transition: transform 0.3s ease;
            height: 100%;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stats-label {
            color: #6c757d;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .stats-change {
            font-size: 0.8rem;
            font-weight: 600;
        }

        .stats-icon {
            font-size: 2.5rem;
            opacity: 0.7;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }

        .activity-item {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 0.75rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border-left: 4px solid var(--primary-color);
            transition: transform 0.3s ease;
        }

        .activity-item:hover {
            transform: translateX(5px);
        }

        .alert-item {
            border-radius: 10px;
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 0.75rem;
        }

        .table-modern {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .table-modern th {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            font-weight: 600;
            padding: 1rem;
            border: none;
        }

        .table-modern td {
            padding: 1rem;
            border-color: #f8f9fa;
            vertical-align: middle;
        }

        .table-header {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
        }

        .badge-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 500;
            font-size: 0.8rem;
        }

        .header-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .canvas-container {
            position: relative;
            height: 300px;
            width: 100%;
        }

        /* Otimizações para mobile */
        @media (max-width: 768px) {
            .sidebar {
                position: fixed;
                top: 0;
                left: -250px;
                width: 250px;
                z-index: 1000;
                transition: left 0.3s ease;
            }

            .sidebar.show {
                left: 0;
            }

            .main-content {
                padding: 1rem;
            }

            .stats-card, .chart-container {
                box-shadow: 0 2px 8px rgba(0,0,0,0.1) !important;
            }

            .canvas-container {
                height: 250px;
            }
        }

        /* Otimização de performance */
        .chart-loading {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 300px;
        }

        /* Reduzir animações em dispositivos de baixo desempenho */
        @media (prefers-reduced-motion: reduce) {
            * {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 sidebar">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white">
                            <i class="fas fa-book-open me-2"></i>
                            Admin Panel
                        </h4>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="${pageContext.request.contextPath}/admin/dashboard">
                                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/livros">
                                <i class="fas fa-book me-2"></i> Livros
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/categorias">
                                <i class="fas fa-tags me-2"></i> Categorias
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/pedidos">
                                <i class="fas fa-shopping-cart me-2"></i> Pedidos
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/usuarios">
                                <i class="fas fa-users me-2"></i> Usuários
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/admin/relatorios">
                                <i class="fas fa-chart-bar me-2"></i> Relatórios
                            </a>
                        </li>
                        <li class="nav-item mt-3">
                            <a class="nav-link" href="${pageContext.request.contextPath}/loja/">
                                <i class="fas fa-store me-2"></i> Ver Loja
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Sair
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 main-content">
                <!-- Header -->
                <div class="header-section">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h1 class="h3 mb-1">Dashboard</h1>
                            <p class="text-muted mb-0">
                                <i class="fas fa-calendar me-1"></i>
                                <fmt:formatDate value="<%= new java.util.Date() %>" pattern="EEEE, dd MMMM yyyy" />
                            </p>
                        </div>
                        <div>
                            <span class="badge bg-success fs-6">
                                <i class="fas fa-circle me-1"></i>Sistema Online
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Alertas -->
                <c:if test="${not empty alertas}">
                    <div class="row mb-4">
                        <div class="col-12">
                            <c:forEach var="alerta" items="${alertas}">
                                <div class="alert alert-${alerta.type} alert-item d-flex align-items-center" role="alert">
                                    <i class="${alerta.icon} me-3 fs-4"></i>
                                    <div class="flex-grow-1">
                                        <strong>${alerta.title}</strong>
                                        <p class="mb-0">${alerta.description}</p>
                                    </div>
                                    <c:if test="${not empty alerta.action}">
                                        <a href="${pageContext.request.contextPath}${alerta.action}" class="btn btn-sm btn-outline-${alerta.type}">
                                            Ver Detalhes
                                        </a>
                                    </c:if>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number text-primary">${stats.totalLivros}</div>
                                    <div class="stats-label">Total de Livros</div>
                                    <small class="stats-change text-success">
                                        <i class="fas fa-arrow-up"></i> ${stats.livrosAtivos} ativos
                                    </small>
                                </div>
                                <div class="stats-icon text-primary">
                                    <i class="fas fa-book"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number text-success">${stats.totalPedidos}</div>
                                    <div class="stats-label">Total de Pedidos</div>
                                    <small class="stats-change text-success">
                                        <i class="fas fa-arrow-up"></i> ${stats.pedidosHoje} hoje
                                    </small>
                                </div>
                                <div class="stats-icon text-success">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number text-info">${stats.totalUsuarios}</div>
                                    <div class="stats-label">Usuários Cadastrados</div>
                                    <small class="stats-change text-info">
                                        <i class="fas fa-arrow-up"></i> ${stats.novosUsuariosSemana} esta semana
                                    </small>
                                </div>
                                <div class="stats-icon text-info">
                                    <i class="fas fa-users"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-3">
                        <div class="stats-card">
                            <div class="d-flex justify-content-between align-items-center">
                                <div>
                                    <div class="stats-number text-warning">
                                        <fmt:formatNumber value="${stats.valorEstoque}" type="currency" currencySymbol="R$ "/>
                                    </div>
                                    <div class="stats-label">Valor em Estoque</div>
                                    <small class="stats-change ${stats.estoqueBaixo > 0 ? 'text-warning' : 'text-success'}">
                                        <i class="fas ${stats.estoqueBaixo > 0 ? 'fa-exclamation-triangle' : 'fa-check'}"></i> 
                                        ${stats.estoqueBaixo} com estoque baixo
                                    </small>
                                </div>
                                <div class="stats-icon text-warning">
                                    <i class="fas fa-warehouse"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="row mb-4">
                    <div class="col-lg-8">
                        <div class="chart-container">
                            <h5 class="mb-3">
                                <i class="fas fa-chart-line me-2"></i>Vendas dos Últimos 30 Dias
                            </h5>
                            <div class="canvas-container">
                                <div id="salesChartLoading" class="chart-loading">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Carregando...</span>
                                    </div>
                                </div>
                                <canvas id="salesChart" style="display: none;"></canvas>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="chart-container">
                            <h5 class="mb-3">
                                <i class="fas fa-chart-pie me-2"></i>Vendas por Categoria
                            </h5>
                            <div class="canvas-container">
                                <div id="categoryChartLoading" class="chart-loading">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Carregando...</span>
                                    </div>
                                </div>
                                <canvas id="categoryChart" style="display: none;"></canvas>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tables Section -->
                <div class="row mb-4">
                    <!-- Recent Activities -->
                    <div class="col-lg-6">
                        <div class="chart-container">
                            <h5 class="mb-3">
                                <i class="fas fa-clock me-2"></i>Atividades Recentes
                            </h5>
                            <c:choose>
                                <c:when test="${not empty recentActivities}">
                                    <div class="activity-feed">
                                        <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                                            <c:if test="${status.index < 10}">
                                                <div class="activity-item">
                                                    <div class="d-flex align-items-center">
                                                        <div class="me-3">
                                                            <i class="${activity.icon}"></i>
                                                        </div>
                                                        <div class="flex-grow-1">
                                                            <h6 class="mb-1">${activity.title}</h6>
                                                            <p class="mb-1 text-muted small">${activity.description}</p>
                                                            <small class="text-muted">${activity.time}</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fas fa-clock fa-2x mb-2"></i>
                                        <p>Nenhuma atividade recente</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Top Books -->
                    <div class="col-lg-6">
                        <div class="chart-container">
                            <h5 class="mb-3">
                                <i class="fas fa-star me-2"></i>Livros Mais Vendidos
                            </h5>
                            <c:choose>
                                <c:when test="${not empty topLivros}">
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>Livro</th>
                                                    <th>Vendas</th>
                                                    <th>Estoque</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="livro" items="${topLivros}" varStatus="status">
                                                    <tr>
                                                        <td>${status.index + 1}</td>
                                                        <td>
                                                            <div>
                                                                <strong>${fn:substring(livro.titulo, 0, 30)}${fn:length(livro.titulo) > 30 ? '...' : ''}</strong>
                                                                <br><small class="text-muted">${livro.autor}</small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="badge bg-success">${livro.vendasTotal != null ? livro.vendasTotal : 0}</span>
                                                        </td>
                                                        <td>
                                                            <span class="badge ${livro.estoque > 5 ? 'bg-success' : livro.estoque > 0 ? 'bg-warning' : 'bg-danger'}">
                                                                ${livro.estoque}
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fas fa-book fa-2x mb-2"></i>
                                        <p>Nenhum dado de vendas disponível</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Latest Orders and Low Stock -->
                <div class="row">
                    <!-- Latest Orders -->
                    <div class="col-lg-6">
                        <div class="table-modern">
                            <div class="table-header p-3">
                                <h5 class="mb-0 text-white">
                                    <i class="fas fa-shopping-bag me-2"></i>Últimos Pedidos
                                </h5>
                            </div>
                            <c:choose>
                                <c:when test="${not empty ultimosPedidos}">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Pedido</th>
                                                    <th>Cliente</th>
                                                    <th>Valor</th>
                                                    <th>Status</th>
                                                    <th>Data</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="pedido" items="${ultimosPedidos}">
                                                    <tr>
                                                        <td>
                                                            <strong>#${pedido.id}</strong>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty pedido.user}">
                                                                    ${fn:substring(pedido.user.name, 0, 20)}${fn:length(pedido.user.name) > 20 ? '...' : ''}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Cliente não identificado
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ "/>
                                                        </td>
                                                        <td>
                                                            <span class="badge badge-status ${pedido.status == 'completed' ? 'bg-success' : pedido.status == 'pending' ? 'bg-warning' : 'bg-secondary'}">
                                                                ${pedido.statusLabel}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM HH:mm"/>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fas fa-shopping-cart fa-2x mb-2"></i>
                                        <p>Nenhum pedido encontrado</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Low Stock Books -->
                    <div class="col-lg-6">
                        <div class="table-modern">
                            <div class="table-header p-3">
                                <h5 class="mb-0 text-white">
                                    <i class="fas fa-exclamation-triangle me-2"></i>Estoque Baixo
                                </h5>
                            </div>
                            <c:choose>
                                <c:when test="${not empty livrosEstoqueBaixo}">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Livro</th>
                                                    <th>Autor</th>
                                                    <th>Estoque</th>
                                                    <th>Mín.</th>
                                                    <th>Ação</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="livro" items="${livrosEstoqueBaixo}">
                                                    <tr>
                                                        <td>
                                                            <strong>${fn:substring(livro.titulo, 0, 25)}${fn:length(livro.titulo) > 25 ? '...' : ''}</strong>
                                                        </td>
                                                        <td>
                                                            ${fn:substring(livro.autor, 0, 20)}${fn:length(livro.autor) > 20 ? '...' : ''}
                                                        </td>
                                                        <td>
                                                            <span class="badge ${livro.estoque == 0 ? 'bg-danger' : 'bg-warning'}">
                                                                ${livro.estoque}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <small class="text-muted">${livro.estoqueMinimo}</small>
                                                        </td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/admin/livros/${livro.id}/edit" 
                                                               class="btn btn-sm btn-outline-primary" 
                                                               data-bs-toggle="tooltip" 
                                                               title="Atualizar estoque">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-4 text-muted">
                                        <i class="fas fa-check-circle fa-2x mb-2 text-success"></i>
                                        <p>Todos os livros com estoque adequado</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="chart-container">
                            <h5 class="mb-3">
                                <i class="fas fa-lightning-bolt me-2"></i>Ações Rápidas
                            </h5>
                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/admin/livros/create" class="btn btn-primary w-100 py-3">
                                        <i class="fas fa-plus-circle mb-2 d-block fs-4"></i>
                                        Adicionar Livro
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/admin/categorias/create" class="btn btn-success w-100 py-3">
                                        <i class="fas fa-tags mb-2 d-block fs-4"></i>
                                        Nova Categoria
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/admin/pedidos" class="btn btn-info w-100 py-3">
                                        <i class="fas fa-shopping-cart mb-2 d-block fs-4"></i>
                                        Ver Pedidos
                                    </a>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <a href="${pageContext.request.contextPath}/admin/relatorios" class="btn btn-warning w-100 py-3">
                                        <i class="fas fa-chart-bar mb-2 d-block fs-4"></i>
                                        Relatórios
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Dashboard JavaScript Otimizado -->
    <script>
        // Variáveis globais para controlar instâncias
        let salesChart = null;
        let categoryChart = null;
        let refreshInterval = null;
        let isChartInitialized = false;
        
        // Cache para dados dos gráficos
        let chartDataCache = {
            salesData: null,
            categoryData: null,
            lastUpdate: null
        };

        // Função para limpar recursos anteriores
        function cleanup() {
            if (salesChart) {
                salesChart.destroy();
                salesChart = null;
            }
            if (categoryChart) {
                categoryChart.destroy();
                categoryChart = null;
            }
            if (refreshInterval) {
                clearInterval(refreshInterval);
                refreshInterval = null;
            }
        }

        // Função para gerar dados de vendas (cache para evitar regeneração)
        function getSalesData() {
            if (!chartDataCache.salesData) {
                chartDataCache.salesData = generateRandomData(30, 100, 1000);
                chartDataCache.lastUpdate = Date.now();
            }
            return chartDataCache.salesData;
        }

        // Função para gerar dados de categoria (cache)
        function getCategoryData() {
            if (!chartDataCache.categoryData) {
                chartDataCache.categoryData = [30, 25, 20, 15, 10];
            }
            return chartDataCache.categoryData;
        }

        // Função para inicializar gráficos com lazy loading
        function initializeCharts() {
            if (isChartInitialized) return;
            
            // Sales Chart
            const salesCtx = document.getElementById('salesChart');
            const salesLoading = document.getElementById('salesChartLoading');
            
            if (salesCtx) {
                try {
                    salesChart = new Chart(salesCtx.getContext('2d'), {
                        type: 'line',
                        data: {
                            labels: generateLastNDays(30),
                            datasets: [{
                                label: 'Vendas (R$)',
                                data: getSalesData(),
                                borderColor: 'rgb(102, 126, 234)',
                                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                                tension: 0.4,
                                fill: true,
                                pointRadius: 0,
                                pointHoverRadius: 5
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            interaction: {
                                intersect: false,
                                mode: 'index'
                            },
                            plugins: {
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    grid: {
                                        color: 'rgba(0,0,0,0.05)'
                                    }
                                },
                                x: {
                                    grid: {
                                        display: false
                                    }
                                }
                            },
                            animation: {
                                duration: 1000
                            },
                            elements: {
                                point: {
                                    radius: 0,
                                    hoverRadius: 5
                                }
                            }
                        }
                    });
                    
                    // Mostrar gráfico e ocultar loading
                    salesLoading.style.display = 'none';
                    salesCtx.style.display = 'block';
                } catch (error) {
                    console.error('Erro ao inicializar gráfico de vendas:', error);
                    salesLoading.innerHTML = '<div class="text-danger">Erro ao carregar gráfico</div>';
                }
            }

            // Category Chart
            const categoryCtx = document.getElementById('categoryChart');
            const categoryLoading = document.getElementById('categoryChartLoading');
            
            if (categoryCtx) {
                try {
                    categoryChart = new Chart(categoryCtx.getContext('2d'), {
                        type: 'doughnut',
                        data: {
                            labels: ['Ficção', 'Técnico', 'Infantil', 'Autoajuda', 'Outros'],
                            datasets: [{
                                data: getCategoryData(),
                                backgroundColor: [
                                    'rgb(102, 126, 234)',
                                    'rgb(118, 75, 162)',
                                    'rgb(40, 167, 69)',
                                    'rgb(255, 193, 7)',
                                    'rgb(220, 53, 69)'
                                ],
                                borderWidth: 0
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        padding: 20,
                                        usePointStyle: true
                                    }
                                }
                            },
                            animation: {
                                duration: 800
                            }
                        }
                    });
                    
                    // Mostrar gráfico e ocultar loading
                    categoryLoading.style.display = 'none';
                    categoryCtx.style.display = 'block';
                } catch (error) {
                    console.error('Erro ao inicializar gráfico de categorias:', error);
                    categoryLoading.innerHTML = '<div class="text-danger">Erro ao carregar gráfico</div>';
                }
            }
            
            isChartInitialized = true;
        }

        // Função para atualizar dados via AJAX (mais eficiente que reload)
        function updateDashboardData() {
            try {
                // Simular atualização de dados - substituir por chamada AJAX real
                console.log('Atualizando dados do dashboard...');
                
                // Exemplo de atualização dos gráficos com novos dados
                if (salesChart) {
                    // Invalidar cache para forçar novos dados
                    chartDataCache.salesData = null;
                    salesChart.data.datasets[0].data = getSalesData();
                    salesChart.update('none'); // Update sem animação para melhor performance
                }
                
                // Aqui você pode adicionar chamadas AJAX reais para atualizar outros dados
                // fetch('/admin/api/dashboard-stats')
                //     .then(response => response.json())
                //     .then(data => {
                //         // Atualizar elementos da página com novos dados
                //     })
                //     .catch(error => console.error('Erro ao atualizar dados:', error));
                
            } catch (error) {
                console.error('Erro ao atualizar dashboard:', error);
            }
        }

        // Inicialização quando DOM estiver pronto
        document.addEventListener('DOMContentLoaded', function() {
            // Limpar recursos anteriores (caso necessário)
            cleanup();
            
            // Inicializar gráficos com delay para melhor performance
            setTimeout(initializeCharts, 100);
            
            // Initialize tooltips de forma eficiente
            const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
            if (tooltipTriggerList.length > 0) {
                tooltipTriggerList.forEach(function(tooltipTriggerEl) {
                    new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
            
            // Auto-refresh CORRIGIDO - usando uma única instância global
            if (!window.dashboardRefreshActive) {
                window.dashboardRefreshActive = true;
                
                // Atualizar a cada 5 minutos (300000ms)
                refreshInterval = setInterval(updateDashboardData, 300000);
            }
        });

        // Cleanup quando a página for fechada/recarregada
        window.addEventListener('beforeunload', function() {
            cleanup();
            window.dashboardRefreshActive = false;
        });

        // Cleanup quando sair da página (para SPAs)
        window.addEventListener('pagehide', function() {
            cleanup();
            window.dashboardRefreshActive = false;
        });

        // Helper functions otimizadas
        function generateLastNDays(n) {
            const days = [];
            const today = new Date();
            
            for (let i = n - 1; i >= 0; i--) {
                const date = new Date(today);
                date.setDate(today.getDate() - i);
                days.push(date.toLocaleDateString('pt-BR', { 
                    day: '2-digit', 
                    month: '2-digit' 
                }));
            }
            return days;
        }

        function generateRandomData(count, min, max) {
            const data = [];
            for (let i = 0; i < count; i++) {
                data.push(Math.floor(Math.random() * (max - min + 1)) + min);
            }
            return data;
        }

        // Mobile sidebar toggle otimizado
        function toggleSidebar() {
            const sidebar = document.querySelector('.sidebar');
            if (sidebar) {
                sidebar.classList.toggle('show');
            }
        }

        // Configuração do menu mobile - executar apenas uma vez
        (function initMobileMenu() {
            if (window.innerWidth <= 768 && !document.querySelector('.mobile-menu-btn')) {
                const headerSection = document.querySelector('.header-section');
                if (headerSection) {
                    const flexContainer = headerSection.querySelector('.d-flex');
                    if (flexContainer) {
                        const mobileMenuBtn = document.createElement('button');
                        mobileMenuBtn.className = 'btn btn-outline-primary d-md-none mobile-menu-btn';
                        mobileMenuBtn.innerHTML = '<i class="fas fa-bars"></i>';
                        mobileMenuBtn.onclick = toggleSidebar;
                        mobileMenuBtn.setAttribute('aria-label', 'Toggle menu');
                        flexContainer.insertBefore(mobileMenuBtn, flexContainer.firstChild);
                    }
                }
            }
        })();

        // Fechar sidebar ao clicar fora (mobile)
        document.addEventListener('click', function(event) {
            const sidebar = document.querySelector('.sidebar');
            const mobileMenuBtn = document.querySelector('.mobile-menu-btn');
            
            if (window.innerWidth <= 768 && sidebar && sidebar.classList.contains('show')) {
                if (!sidebar.contains(event.target) && !mobileMenuBtn.contains(event.target)) {
                    sidebar.classList.remove('show');
                }
            }
        });

        // Otimização: Detectar vazamentos de memória (apenas em desenvolvimento)
        if (typeof performance !== 'undefined' && performance.memory) {
            let memoryWarningShown = false;
            const memoryCheckInterval = setInterval(function() {
                if (!memoryWarningShown) {
                    const used = performance.memory.usedJSHeapSize / 1048576; // MB
                    if (used > 150) { // Se usar mais de 150MB
                        console.warn('Alto uso de memória detectado:', used.toFixed(2) + 'MB');
                        memoryWarningShown = true;
                        
                        // Opcional: Mostrar alerta para o usuário
                        const alertDiv = document.createElement('div');
                        alertDiv.className = 'alert alert-warning alert-dismissible fade show position-fixed';
                        alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 300px;';
                        alertDiv.innerHTML = `
                            <strong>Aviso:</strong> Alto uso de memória detectado. 
                            Considere recarregar a página.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        `;
                        document.body.appendChild(alertDiv);
                        
                        // Limpar o intervalo para não continuar verificando
                        clearInterval(memoryCheckInterval);
                    }
                }
            }, 60000); // Verificar a cada 1 minuto
        }

        // Intersection Observer para lazy loading de elementos pesados
        if ('IntersectionObserver' in window) {
            const lazyElements = document.querySelectorAll('[data-lazy]');
            const lazyObserver = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const element = entry.target;
                        // Executar ação lazy loading aqui
                        element.classList.add('loaded');
                        lazyObserver.unobserve(element);
                    }
                });
            });
            
            lazyElements.forEach(element => {
                lazyObserver.observe(element);
            });
        }

        // Debounce para redimensionamento de janela
        let resizeTimeout;
        window.addEventListener('resize', function() {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(function() {
                // Redimensionar gráficos se necessário
                if (salesChart) salesChart.resize();
                if (categoryChart) categoryChart.resize();
            }, 250);
        });
    </script>
</body>
</html>