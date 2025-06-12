<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Livraria Mil Páginas - Explore nossa coleção de livros online">
    <meta name="keywords" content="livros, livraria online, literatura, comprar livros">
    <title>Loja - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --accent-color: #f093fb;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --success-color: #27ae60;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --light-bg: #f8f9fa;
            --white: #ffffff;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-hover: 0 8px 25px rgba(0, 0, 0, 0.15);
            --border-radius: 10px;
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            line-height: 1.6;
            color: var(--text-dark);
            background-color: var(--light-bg);
        }
        
        /* Navbar Styles */
        .navbar-custom {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            box-shadow: var(--shadow);
            padding: 1rem 0;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--white) !important;
        }
        
        .navbar-nav .nav-link {
            color: rgba(255, 255, 255, 0.9) !important;
            font-weight: 500;
            margin: 0 0.5rem;
            transition: var(--transition);
        }
        
        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-link.active {
            color: var(--white) !important;
            transform: translateY(-1px);
        }
        
        .dropdown-menu {
            border: none;
            box-shadow: var(--shadow-hover);
            border-radius: var(--border-radius);
        }
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 70%, var(--accent-color) 100%);
            color: var(--white);
            padding: 4rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="1"/></svg>') repeat;
            opacity: 0.1;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .hero-title {
            font-size: 3rem;
            font-weight: 700;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }
        
        .hero-subtitle {
            font-size: 1.2rem;
            font-weight: 300;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .hero-cta {
            background: var(--white);
            color: var(--primary-color);
            border: none;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
        }
        
        .hero-cta:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
            color: var(--primary-color);
        }
        
        .hero-icon {
            font-size: 6rem;
            opacity: 0.8;
            animation: float 3s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-15px); }
        }
        
        /* Stats Section */
        .stats-section {
            padding: 3rem 0;
            background: var(--white);
        }
        
        .stat-card {
            background: var(--white);
            border-radius: var(--border-radius);
            padding: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: none;
            height: 100%;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            display: block;
        }
        
        .stat-icon.primary { color: var(--primary-color); }
        .stat-icon.success { color: var(--success-color); }
        .stat-icon.info { color: #3498db; }
        .stat-icon.warning { color: var(--warning-color); }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            color: var(--text-light);
            font-weight: 500;
        }
        
        /* Books Section */
        .books-section {
            padding: 4rem 0;
        }
        
        .section-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 3rem;
            position: relative;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }
        
        .book-card {
            background: var(--white);
            border-radius: var(--border-radius);
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: var(--transition);
            border: none;
            height: 100%;
            position: relative;
        }
        
        .book-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--shadow-hover);
        }
        
        .book-image-container {
            position: relative;
            width: 100%;
            height: 280px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .book-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }
        
        .book-card:hover .book-image {
            transform: scale(1.05);
        }
        
        .book-placeholder {
            font-size: 3rem;
            color: var(--text-light);
            opacity: 0.5;
        }
        
        .book-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background: var(--danger-color);
            color: var(--white);
            padding: 0.25rem 0.5rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .book-content {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            height: calc(100% - 280px);
        }
        
        .book-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .book-author {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .book-footer {
            margin-top: auto;
        }
        
        .book-price {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .price-current {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--success-color);
        }
        
        .price-original {
            font-size: 0.9rem;
            color: var(--text-light);
            text-decoration: line-through;
        }
        
        .book-actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-view {
            flex: 1;
            background: var(--primary-color);
            color: var(--white);
            border: none;
            padding: 0.75rem;
            border-radius: var(--border-radius);
            font-weight: 500;
            transition: var(--transition);
            text-decoration: none;
            text-align: center;
            font-size: 0.9rem;
        }
        
        .btn-view:hover {
            background: var(--secondary-color);
            transform: translateY(-1px);
            color: var(--white);
        }
        
        .btn-favorite {
            background: transparent;
            border: 2px solid var(--text-light);
            color: var(--text-light);
            width: 45px;
            height: 45px;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
            cursor: pointer;
        }
        
        .btn-favorite:hover,
        .btn-favorite.active {
            border-color: var(--danger-color);
            color: var(--danger-color);
            background: rgba(231, 76, 60, 0.1);
        }
        
        /* Categories Section */
        .categories-section {
            padding: 4rem 0;
            background: var(--white);
        }
        
        .category-card {
            background: var(--white);
            border-radius: var(--border-radius);
            padding: 2rem 1rem;
            text-align: center;
            transition: var(--transition);
            border: 2px solid transparent;
            text-decoration: none;
            color: inherit;
            height: 100%;
            display: block;
        }
        
        .category-card:hover {
            border-color: var(--primary-color);
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.05) 0%, rgba(118, 75, 162, 0.05) 100%);
            transform: translateY(-5px);
            color: inherit;
            text-decoration: none;
        }
        
        .category-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            display: block;
        }
        
        .category-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        
        .category-count {
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        /* CTA Section */
        .cta-section {
            padding: 4rem 0;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: var(--white);
            text-align: center;
        }
        
        .cta-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 1rem;
        }
        
        .cta-subtitle {
            font-size: 1.1rem;
            margin-bottom: 2rem;
            opacity: 0.9;
        }
        
        .cta-button {
            background: var(--white);
            color: var(--primary-color);
            border: none;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            transition: var(--transition);
            text-decoration: none;
            display: inline-block;
        }
        
        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
            color: var(--primary-color);
        }
        
        /* Footer */
        .footer {
            background: var(--text-dark);
            color: var(--white);
            padding: 2rem 0;
        }
        
        .footer h5 {
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .footer p {
            opacity: 0.8;
            margin-bottom: 0.5rem;
        }
        
        .footer a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: var(--transition);
        }
        
        .footer a:hover {
            color: var(--white);
        }
        
        /* Animations */
        .fade-in {
            animation: fadeIn 0.6s ease-in;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .slide-in-left {
            animation: slideInLeft 0.6s ease-out;
        }
        
        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        .slide-in-right {
            animation: slideInRight 0.6s ease-out;
        }
        
        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(30px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2rem;
            }
            
            .hero-subtitle {
                font-size: 1rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
            
            .book-content {
                padding: 1rem;
            }
            
            .category-card {
                padding: 1.5rem 1rem;
            }
        }
        
        @media (max-width: 576px) {
            .hero-section {
                padding: 2rem 0;
            }
            
            .hero-title {
                font-size: 1.5rem;
            }
            
            .books-section,
            .categories-section,
            .cta-section {
                padding: 2rem 0;
            }
        }
        
        /* Loading States */
        .loading {
            opacity: 0.7;
            pointer-events: none;
        }
        
        .spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255, 255, 255, 0.3);
            border-radius: 50%;
            border-top-color: var(--white);
            animation: spin 1s ease-in-out infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        /* Utilities */
        .text-gradient {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .badge-new {
            background: var(--success-color);
        }
        
        .badge-sale {
            background: var(--danger-color);
        }
        
        .badge-popular {
            background: var(--warning-color);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-custom fixed-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/loja/">
                <i class="fas fa-book-open"></i> Livraria Mil Páginas
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/loja/">
                            <i class="fas fa-home"></i> Início
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/loja/catalogo">
                            <i class="fas fa-book"></i> Catálogo
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/loja/favoritos">
                            <i class="fas fa-heart"></i> Favoritos
                        </a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="categoriasDropdown" role="button" data-bs-toggle="dropdown">
                            <i class="fas fa-tags"></i> Categorias
                        </a>
                        <ul class="dropdown-menu">
                            <c:choose>
                                <c:when test="${categorias != null && !empty categorias}">
                                    <c:forEach var="categoria" items="${categorias}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/loja/categoria/${categoria.slug}">
                                                ${categoria.nome}
                                            </a>
                                        </li>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <li><a class="dropdown-item" href="#">Ficção</a></li>
                                    <li><a class="dropdown-item" href="#">Romance</a></li>
                                    <li><a class="dropdown-item" href="#">Técnico</a></li>
                                    <li><a class="dropdown-item" href="#">História</a></li>
                                    <li><a class="dropdown-item" href="#">Biografias</a></li>
                                    <li><a class="dropdown-item" href="#">Infantil</a></li>
                                </c:otherwise>
                            </c:choose>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/loja/catalogo">Ver Todas</a></li>
                        </ul>
                    </li>
                </ul>
                
                <!-- Search Form -->
                <form class="d-flex me-3" role="search" action="${pageContext.request.contextPath}/loja/buscar" method="GET">
                    <div class="input-group">
                        <input class="form-control" type="search" name="q" placeholder="Buscar livros..." aria-label="Search">
                        <button class="btn btn-outline-light" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
                
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart/">
                            <i class="fas fa-shopping-cart"></i> 
                            Carrinho
                            <span class="badge bg-warning rounded-pill" id="cart-count">0</span>
                        </a>
                    </li>
                    
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user"></i> 
                                    <c:choose>
                                        <c:when test="${fn:length(sessionScope.user.name) > 15}">
                                            ${fn:substring(sessionScope.user.name, 0, 15)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${sessionScope.user.name}
                                        </c:otherwise>
                                    </c:choose>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/">
                                        <i class="fas fa-user-circle"></i> Meu Perfil
                                    </a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/pedidos">
                                        <i class="fas fa-shopping-bag"></i> Meus Pedidos
                                    </a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/favoritos">
                                        <i class="fas fa-heart"></i> Meus Favoritos
                                    </a></li>
                                    <c:if test="${sessionScope.user.admin}">
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/">
                                            <i class="fas fa-cog"></i> Administração
                                        </a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                                        <i class="fas fa-sign-out-alt"></i> Sair
                                    </a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt"></i> Entrar
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">
                                    <i class="fas fa-user-plus"></i> Cadastrar
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section" style="margin-top: 76px;">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 hero-content slide-in-left">
                    <h1 class="hero-title">Bem-vindo à Livraria Mil Páginas</h1>
                    <p class="hero-subtitle">
                        Descubra um universo de conhecimento e aventuras em nossa vasta coleção de livros. 
                        Milhares de títulos esperando por você!
                    </p>
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="hero-cta">
                        <i class="fas fa-book-open"></i> Explorar Catálogo
                    </a>
                </div>
                <div class="col-lg-6 text-center slide-in-right">
                    <i class="fas fa-books hero-icon"></i>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card fade-in">
                        <div class="card-body">
                            <i class="fas fa-book stat-icon primary"></i>
                            <div class="stat-number">${totalLivros != null ? totalLivros : '150+'}</div>
                            <div class="stat-label">Livros Disponíveis</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card fade-in" style="animation-delay: 0.1s;">
                        <div class="card-body">
                            <i class="fas fa-tags stat-icon success"></i>
                            <div class="stat-number">${totalCategorias != null ? totalCategorias : '12+'}</div>
                            <div class="stat-label">Categorias</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card fade-in" style="animation-delay: 0.2s;">
                        <div class="card-body">
                            <i class="fas fa-users stat-icon info"></i>
                            <div class="stat-number">${totalAutores != null ? totalAutores : '85+'}</div>
                            <div class="stat-label">Autores</div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="card stat-card fade-in" style="animation-delay: 0.3s;">
                        <div class="card-body">
                            <i class="fas fa-warehouse stat-icon warning"></i>
                            <div class="stat-number">${livrosEstoque != null ? livrosEstoque : '120+'}</div>
                            <div class="stat-label">Em Estoque</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Books Section -->
    <section class="books-section">
        <div class="container">
            <h2 class="section-title fade-in">📚 Livros em Destaque</h2>
            <div class="row g-4">
                <c:choose>
                    <c:when test="${livrosDestaque != null && !empty livrosDestaque}">
                        <c:forEach var="livro" items="${livrosDestaque}" end="7" varStatus="status">
                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="card book-card fade-in" style="animation-delay: ${status.index * 0.1}s;">
                                    <div class="book-image-container">
                                        <c:choose>
                                            <c:when test="${livro.imagem != null && !empty livro.imagem}">
                                                <img src="${pageContext.request.contextPath}/uploads/livros/${livro.imagem}" 
                                                     alt="${livro.titulo}" class="book-image">
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-book book-placeholder"></i>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <c:if test="${livro.temPromocao}">
                                            <span class="book-badge badge-sale">
                                                -${livro.desconto}%
                                            </span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="book-content">
                                        <h6 class="book-title">${livro.titulo}</h6>
                                        <p class="book-author">por ${livro.autor}</p>
                                        
                                        <div class="book-footer">
                                            <div class="book-price">
                                                <div>
                                                    <div class="price-current">
                                                        <fmt:formatNumber value="${livro.precoFinal}" type="currency" currencySymbol="R$ "/>
                                                    </div>
                                                    <c:if test="${livro.temPromocao}">
                                                        <div class="price-original">
                                                            <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ "/>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                            
                                            <div class="book-actions">
                                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                                   class="btn-view">
                                                    <i class="fas fa-eye"></i> Ver Detalhes
                                                </a>
                                                <button class="btn-favorite" data-livro-id="${livro.id}" title="Adicionar aos favoritos">
                                                    <i class="far fa-heart"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Exemplo de livros quando não há dados no banco -->
                        <c:forEach begin="1" end="8" var="i">
                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="card book-card fade-in" style="animation-delay: ${(i-1) * 0.1}s;">
                                    <div class="book-image-container">
                                        <i class="fas fa-book book-placeholder"></i>
                                        <c:if test="${i % 3 == 0}">
                                            <span class="book-badge badge-sale">-25%</span>
                                        </c:if>
                                        <c:if test="${i % 4 == 0}">
                                            <span class="book-badge badge-new">Novo</span>
                                        </c:if>
                                    </div>
                                    
                                    <div class="book-content">
                                        <h6 class="book-title">Livro Exemplo ${i}</h6>
                                        <p class="book-author">por Autor Exemplo</p>
                                        
                                        <div class="book-footer">
                                            <div class="book-price">
                                                <div>
                                                    <div class="price-current">R$ ${(i * 15) + 29},90</div>
                                                    <c:if test="${i % 3 == 0}">
                                                        <div class="price-original">R$ ${(i * 20) + 39},90</div>
                                                    </c:if>
                                                </div>
                                            </div>
                                            
                                            <div class="book-actions">
                                                <a href="#" class="btn-view">
                                                    <i class="fas fa-eye"></i> Ver Detalhes
                                                </a>
                                                <button class="btn-favorite" data-livro-id="${i}" title="Adicionar aos favoritos">
                                                    <i class="far fa-heart"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/loja/catalogo" class="cta-button">
                    Ver Todos os Livros <i class="fas fa-arrow-right"></i>
                </a>
            </div>
        </div>
    </section>

    <!-- Categories Section -->
    <section class="categories-section">
        <div class="container">
            <h2 class="section-title fade-in">🏷️ Explore por Categorias</h2>
            <div class="row g-4">
                <c:choose>
                    <c:when test="${categorias != null && !empty categorias}">
                        <c:forEach var="categoria" items="${categorias}" end="5" varStatus="status">
                            <div class="col-lg-2 col-md-4 col-sm-6">
                                <a href="${pageContext.request.contextPath}/loja/categoria/${categoria.slug}" 
                                   class="category-card fade-in" style="animation-delay: ${status.index * 0.1}s;">
                                    <i class="fas fa-bookmark category-icon"></i>
                                    <div class="category-name">${categoria.nome}</div>
                                    <div class="category-count">
                                        ${categoria.livrosCount != null ? categoria.livrosCount : 0} livros
                                    </div>
                                </a>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <!-- Categorias de exemplo -->
                        <c:set var="categorias" value="Ficção,Romance,Técnico,História,Biografias,Infantil"/>
                        <c:set var="icons" value="fas fa-magic,fas fa-heart,fas fa-laptop-code,fas fa-landmark,fas fa-user-alt,fas fa-child"/>
                        <c:forEach var="categoria" items="${fn:split(categorias, ',')}" varStatus="status">
                            <div class="col-lg-2 col-md-4 col-sm-6">
                                <a href="#" class="category-card fade-in" style="animation-delay: ${status.index * 0.1}s;">
                                    <c:choose>
                                        <c:when test="${status.index == 0}"><i class="fas fa-magic category-icon"></i></c:when>
                                        <c:when test="${status.index == 1}"><i class="fas fa-heart category-icon"></i></c:when>
                                        <c:when test="${status.index == 2}"><i class="fas fa-laptop-code category-icon"></i></c:when>
                                        <c:when test="${status.index == 3}"><i class="fas fa-landmark category-icon"></i></c:when>
                                        <c:when test="${status.index == 4}"><i class="fas fa-user-alt category-icon"></i></c:when>
                                        <c:otherwise><i class="fas fa-child category-icon"></i></c:otherwise>
                                    </c:choose>
                                    <div class="category-name">${categoria}</div>
                                    <div class="category-count">${(status.index + 1) * 15} livros</div>
                                </a>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- Call to Action Section -->
    <section class="cta-section">
        <div class="container text-center">
            <h2 class="cta-title fade-in">Não encontrou o que procurava?</h2>
            <p class="cta-subtitle fade-in">
                Explore nosso catálogo completo com milhares de títulos em diversas categorias
            </p>
            <a href="${pageContext.request.contextPath}/loja/catalogo" class="cta-button fade-in">
                <i class="fas fa-search"></i> Explorar Catálogo Completo
            </a>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <h5><i class="fas fa-book-open"></i> Livraria Mil Páginas</h5>
                    <p>Sua livraria online de confiança desde 2024. Oferecemos uma vasta seleção de livros com entrega rápida e segura.</p>
                    <div class="social-links">
                        <a href="#" class="me-3"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="me-3"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-linkedin"></i></a>
                    </div>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5>Navegação</h5>
                    <p><a href="${pageContext.request.contextPath}/loja/">Início</a></p>
                    <p><a href="${pageContext.request.contextPath}/loja/catalogo">Catálogo</a></p>
                    <p><a href="${pageContext.request.contextPath}/loja/favoritos">Favoritos</a></p>
                    <p><a href="${pageContext.request.contextPath}/cart/">Carrinho</a></p>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5>Conta</h5>
                    <p><a href="${pageContext.request.contextPath}/login">Login</a></p>
                    <p><a href="${pageContext.request.contextPath}/register">Cadastro</a></p>
                    <p><a href="${pageContext.request.contextPath}/perfil/">Meu Perfil</a></p>
                    <p><a href="${pageContext.request.contextPath}/perfil/pedidos">Meus Pedidos</a></p>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5>Suporte</h5>
                    <p><a href="#">Ajuda</a></p>
                    <p><a href="#">Contato</a></p>
                    <p><a href="#">FAQ</a></p>
                    <p><a href="#">Política de Privacidade</a></p>
                </div>
                <div class="col-lg-2 col-md-6">
                    <h5>Contato</h5>
                    <p><i class="fas fa-envelope"></i> contato@livraria.com</p>
                    <p><i class="fas fa-phone"></i> (11) 99999-9999</p>
                    <p><i class="fas fa-map-marker-alt"></i> São Paulo, SP</p>
                </div>
            </div>
            <hr class="my-4">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0">&copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" /> Livraria Mil Páginas. Todos os direitos reservados.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p class="mb-0">
                        <a href="#" class="me-3">Termos de Uso</a>
                        <a href="#">Política de Privacidade</a>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Inicialização da aplicação
        document.addEventListener('DOMContentLoaded', function() {
            initializeApp();
            loadCartCount();
            setupEventListeners();
            setupAnimations();
        });

        // Inicialização principal
        function initializeApp() {
            console.log('Livraria Mil Páginas - Loja inicializada');
            
            // Verificar se há mensagens para exibir
            showMessages();
            
            // Configurar tooltips
            var tooltips = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            tooltips.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
        }

        // Carregar contador do carrinho
        function loadCartCount() {
            fetch('${pageContext.request.contextPath}/cart/count')
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        updateCartCount(data.data);
                    }
                })
                .catch(error => {
                    console.warn('Erro ao carregar contador do carrinho:', error);
                });
        }

        // Atualizar contador do carrinho
        function updateCartCount(count) {
            const cartCountElement = document.getElementById('cart-count');
            if (cartCountElement) {
                cartCountElement.textContent = count || 0;
                cartCountElement.style.display = count > 0 ? 'inline' : 'none';
            }
        }

        // Configurar event listeners
        function setupEventListeners() {
            // Botões de favoritos
            document.querySelectorAll('.btn-favorite').forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    toggleFavorite(this);
                });
            });

            // Busca ao pressionar Enter
            const searchInput = document.querySelector('input[name="q"]');
            if (searchInput) {
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        this.form.submit();
                    }
                });
            }

            // Smooth scroll para links internos
            document.querySelectorAll('a[href^="#"]').forEach(anchor => {
                anchor.addEventListener('click', function (e) {
                    e.preventDefault();
                    const target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });
        }

        // Toggle favorito
        function toggleFavorite(button) {
            const livroId = button.dataset.livroId;
            
            // Verificar se usuário está logado
            <c:choose>
                <c:when test="${sessionScope.user == null}">
                    showMessage('Você precisa estar logado para adicionar favoritos', 'warning');
                    setTimeout(() => {
                        window.location.href = '${pageContext.request.contextPath}/login';
                    }, 2000);
                    return;
                </c:when>
                <c:otherwise>
                    if (!livroId) return;
                    
                    button.disabled = true;
                    const icon = button.querySelector('i');
                    const originalClass = icon.className;
                    
                    // Animação de loading
                    icon.className = 'fas fa-spinner fa-spin';
                    
                    fetch(`${pageContext.request.contextPath}/favorites/toggle/${livroId}`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        }
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            const isFavorited = data.data.favorited;
                            icon.className = isFavorited ? 'fas fa-heart' : 'far fa-heart';
                            button.classList.toggle('active', isFavorited);
                            button.title = isFavorited ? 'Remover dos favoritos' : 'Adicionar aos favoritos';
                            
                            showMessage(isFavorited ? 'Adicionado aos favoritos!' : 'Removido dos favoritos!', 'success');
                        } else {
                            icon.className = originalClass;
                            showMessage(data.message || 'Erro ao atualizar favoritos', 'error');
                        }
                    })
                    .catch(error => {
                        console.error('Erro:', error);
                        icon.className = originalClass;
                        showMessage('Erro ao atualizar favoritos', 'error');
                    })
                    .finally(() => {
                        button.disabled = false;
                    });
                </c:otherwise>
            </c:choose>
        }

        // Configurar animações
        function setupAnimations() {
            // Intersection Observer para animações on scroll
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };

            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in');
                    }
                });
            }, observerOptions);

            // Observar elementos que devem animar
            document.querySelectorAll('.book-card, .stat-card, .category-card').forEach(el => {
                observer.observe(el);
            });
        }

        // Mostrar mensagens
        function showMessage(message, type = 'info') {
            // Remover mensagens existentes
            const existingAlerts = document.querySelectorAll('.alert-message');
            existingAlerts.forEach(alert => alert.remove());

            // Criar nova mensagem
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type === 'error' ? 'danger' : type} alert-dismissible fade show alert-message`;
            alertDiv.style.cssText = 'position: fixed; top: 90px; right: 20px; z-index: 1050; min-width: 300px;';
            
            alertDiv.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;

            document.body.appendChild(alertDiv);

            // Auto-remover após 5 segundos
            setTimeout(() => {
                if (alertDiv.parentNode) {
                    alertDiv.remove();
                }
            }, 5000);
        }

        // Mostrar mensagens do servidor
        function showMessages() {
            <c:if test="${param.success != null}">
                showMessage('${param.success}', 'success');
            </c:if>
            
            <c:if test="${param.error != null}">
                showMessage('${param.error}', 'error');
            </c:if>
            
            <c:if test="${param.info != null}">
                showMessage('${param.info}', 'info');
            </c:if>
        }

        // Adicionar ao carrinho (para uso futuro)
        function addToCart(livroId, quantity = 1) {
            fetch(`${pageContext.request.contextPath}/cart/add/${livroId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `quantity=${quantity}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('Livro adicionado ao carrinho!', 'success');
                    loadCartCount();
                } else {
                    showMessage(data.message || 'Erro ao adicionar ao carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao adicionar ao carrinho', 'error');
            });
        }

        // Busca instantânea (opcional)
        function setupInstantSearch() {
            const searchInput = document.querySelector('input[name="q"]');
            if (!searchInput) return;

            let searchTimeout;
            searchInput.addEventListener('input', function() {
                clearTimeout(searchTimeout);
                const query = this.value.trim();
                
                if (query.length >= 3) {
                    searchTimeout = setTimeout(() => {
                        performInstantSearch(query);
                    }, 500);
                }
            });
        }

        // Realizar busca instantânea
        function performInstantSearch(query) {
            fetch(`${pageContext.request.contextPath}/loja/busca-ajax?q=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        displaySearchResults(data.data);
                    }
                })
                .catch(error => {
                    console.warn('Erro na busca instantânea:', error);
                });
        }

        // Exibir resultados da busca instantânea
        function displaySearchResults(results) {
            // Implementar dropdown com resultados
            // Esta funcionalidade pode ser expandida conforme necessário
        }

        // Lazy loading para imagens
        function setupLazyLoading() {
            if ('IntersectionObserver' in window) {
                const imageObserver = new IntersectionObserver((entries, observer) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            const img = entry.target;
                            img.src = img.dataset.src;
                            img.classList.remove('lazy');
                            imageObserver.unobserve(img);
                        }
                    });
                });

                document.querySelectorAll('img[data-src]').forEach(img => {
                    imageObserver.observe(img);
                });
            }
        }

        // Easter egg - sequência de teclas especial
        let konamiCode = [];
        const konamiSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65]; // ↑↑↓↓←→←→BA

        document.addEventListener('keydown', function(e) {
            konamiCode.push(e.keyCode);
            if (konamiCode.length > konamiSequence.length) {
                konamiCode.shift();
            }

            if (JSON.stringify(konamiCode) === JSON.stringify(konamiSequence)) {
                activateEasterEgg();
            }
        });

        function activateEasterEgg() {
            // Adicionar efeito especial
            document.body.style.animation = 'rainbow 2s infinite';
            showMessage('🎉 Easter Egg Ativado! Você encontrou o segredo!', 'success');
            
            setTimeout(() => {
                document.body.style.animation = '';
            }, 5000);
        }

        // Inicializar funcionalidades opcionais
        // setupInstantSearch();
        // setupLazyLoading();
    </script>

    <style>
        @keyframes rainbow {
            0% { filter: hue-rotate(0deg); }
            25% { filter: hue-rotate(90deg); }
            50% { filter: hue-rotate(180deg); }
            75% { filter: hue-rotate(270deg); }
            100% { filter: hue-rotate(360deg); }
        }

        .lazy {
            opacity: 0;
            transition: opacity 0.3s;
        }

        .lazy.loaded {
            opacity: 1;
        }
    </style>
</body>
</html>