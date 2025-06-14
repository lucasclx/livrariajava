<%-- /WEB-INF/views/common/header.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <!-- Brand -->
            <a class="navbar-brand hover-gold" href="${pageContext.request.contextPath}/">
                Livraria Mil Páginas
            </a>
            
            <!-- Mobile Toggle -->
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" 
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <!-- Navigation -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto align-items-center">
                    <!-- Catálogo -->
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/loja/catalogo">
                            <i class="fas fa-book me-1"></i>Catálogo
                        </a>
                    </li>
                    
                    <!-- Busca Rápida -->
                    <li class="nav-item d-none d-lg-block">
                        <form action="${pageContext.request.contextPath}/search" method="GET" class="d-flex">
                            <div class="input-group input-group-sm" style="max-width: 200px;">
                                <input type="text" name="q" class="form-control form-control-sm" 
                                       placeholder="Buscar livros..." style="border-radius: 20px 0 0 20px;">
                                <button class="btn btn-gold btn-sm" type="submit" style="border-radius: 0 20px 20px 0;">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </li>
                    
                    <!-- User Authentication -->
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <!-- Logged User Menu -->
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="navbarDropdown" 
                                   role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <div class="rounded-circle bg-gold d-flex align-items-center justify-content-center me-2" 
                                         style="width: 32px; height: 32px;">
                                        <i class="fas fa-user text-white"></i>
                                    </div>
                                    <span class="d-none d-md-inline">${sessionScope.user.firstName}</span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="navbarDropdown">
                                    <li>
                                        <h6 class="dropdown-header">
                                            <i class="fas fa-user me-2"></i>${sessionScope.user.name}
                                        </h6>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">
                                            <i class="fas fa-user-circle me-2"></i>Meu Perfil
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/pedidos">
                                            <i class="fas fa-shopping-bag me-2"></i>Meus Pedidos
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/loja/favoritos">
                                            <i class="fas fa-heart me-2"></i>Favoritos
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/avaliacoes">
                                            <i class="fas fa-star me-2"></i>Avaliações
                                        </a>
                                    </li>
                                    <c:if test="${sessionScope.user.isAdmin()}">
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <a class="dropdown-item text-warning" href="${pageContext.request.contextPath}/admin/dashboard">
                                                <i class="fas fa-cogs me-2"></i>Painel Admin
                                            </a>
                                        </li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i>Sair
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <!-- Guest Menu -->
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt me-1"></i>Login
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-gold btn-sm ms-2">
                                    <i class="fas fa-user-plus me-1"></i>Cadastre-se
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Carrinho -->
                    <li class="nav-item ms-2">
                        <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                            <i class="fas fa-shopping-cart fs-5"></i>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" 
                                  id="cart-count" style="font-size: 0.7rem;">
                                0
                            </span>
                            <span class="d-none d-md-inline ms-1">Carrinho</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Search Mobile (visible only on small screens) -->
    <div class="container d-lg-none">
        <div class="py-2">
            <form action="${pageContext.request.contextPath}/search" method="GET">
                <div class="input-group">
                    <input type="text" name="q" class="form-control" placeholder="Buscar livros, autores, categorias...">
                    <button class="btn btn-gold" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>
</header>