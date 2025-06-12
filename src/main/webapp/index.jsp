<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livraria Mil Páginas - Sua livraria online</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4rem 0;
        }
        .card-hover {
            transition: transform 0.3s;
        }
        .card-hover:hover {
            transform: translateY(-5px);
        }
        .feature-icon {
            font-size: 3rem;
            color: #667eea;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book"></i> Livraria Mil Páginas
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">Início</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/loja/catalogo">Catálogo</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="categoriasDropdown" role="button" data-bs-toggle="dropdown">
                            Categorias
                        </a>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/loja/categoria/ficcao">Ficção</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/loja/categoria/romance">Romance</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/loja/categoria/tecnologia">Tecnologia</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/loja/categoria/biografia">Biografia</a></li>
                        </ul>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart"></i> Carrinho
                        </a>
                    </li>
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user"></i> ${sessionScope.user.firstName}
                                </a>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">Meu Perfil</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/pedidos">Meus Pedidos</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/favoritos">Favoritos</a></li>
                                    <c:if test="${sessionScope.user.admin}">
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin">Administração</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Sair</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Entrar</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/register">Cadastrar</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="display-4 fw-bold mb-4">Bem-vindo à Livraria Mil Páginas</h1>
                    <p class="lead mb-4">Descubra um mundo de conhecimento e aventuras. Milhares de livros esperando por você!</p>
                    <div class="d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-light btn-lg">
                            <i class="fas fa-book"></i> Explorar Catálogo
                        </a>
                        <a href="${pageContext.request.contextPath}/loja/ofertas" class="btn btn-outline-light btn-lg">
                            <i class="fas fa-tags"></i> Ofertas
                        </a>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="text-center">
                        <i class="fas fa-book-open" style="font-size: 15rem; opacity: 0.7;"></i>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Busca -->
    <section class="py-4 bg-light">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8">
                    <form action="${pageContext.request.contextPath}/loja/buscar" method="GET" class="d-flex">
                        <input type="text" name="q" class="form-control me-2" placeholder="Buscar livros, autores..." required>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Buscar
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Features -->
    <section class="py-5">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-4 mb-4">
                    <div class="card h-100 border-0 card-hover">
                        <div class="card-body">
                            <i class="fas fa-shipping-fast feature-icon mb-3"></i>
                            <h5 class="card-title">Entrega Rápida</h5>
                            <p class="card-text">Receba seus livros em casa com entregas rápidas e seguras para todo o Brasil.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 border-0 card-hover">
                        <div class="card-body">
                            <i class="fas fa-shield-alt feature-icon mb-3"></i>
                            <h5 class="card-title">Compra Segura</h5>
                            <p class="card-text">Suas informações protegidas com certificado SSL e pagamentos seguros.</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card h-100 border-0 card-hover">
                        <div class="card-body">
                            <i class="fas fa-heart feature-icon mb-3"></i>
                            <h5 class="card-title">Atendimento</h5>
                            <p class="card-text">Equipe especializada pronta para ajudar você a encontrar o livro perfeito.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="py-5 bg-primary text-white">
        <div class="container">
            <div class="row text-center">
                <div class="col-12">
                    <h2 class="mb-4">Pronto para começar sua próxima leitura?</h2>
                    <p class="lead mb-4">Cadastre-se agora e ganhe 10% de desconto na sua primeira compra!</p>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-light btn-lg">
                        <i class="fas fa-user-plus"></i> Cadastre-se Agora
                    </a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5><i class="fas fa-book"></i> Livraria Mil Páginas</h5>
                    <p>Sua livraria online de confiança desde 2024.</p>
                </div>
                <div class="col-md-6">
                    <h6>Links Úteis</h6>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/loja/catalogo" class="text-light text-decoration-none">Catálogo</a></li>
                        <li><a href="${pageContext.request.contextPath}/contato" class="text-light text-decoration-none">Contato</a></li>
                        <li><a href="${pageContext.request.contextPath}/sobre" class="text-light text-decoration-none">Sobre</a></li>
                    </ul>
                </div>
            </div>
            <hr>
            <div class="text-center">
                <p>&copy; 2024 Livraria Mil Páginas. Todos os direitos reservados.</p>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>