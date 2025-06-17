<%-- /livrariajava/src/main/webapp/WEB-INF/view/_partials/header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty param.title ? param.title : 'Livraria Mil Páginas'}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/loja/">
                <i class="fas fa-book-open me-2"></i>
                Livraria Mil Páginas
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/loja/catalogo">Catálogo</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Categorias</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Lançamentos</a>
                    </li>
                </ul>
                
                <form class="d-flex mx-lg-auto" action="${pageContext.request.contextPath}/search" method="get">
                    <input class="form-control me-2" type="search" name="q" placeholder="Buscar por título ou autor..." aria-label="Buscar">
                    <button class="btn btn-outline-light" type="submit"><i class="fas fa-search"></i></button>
                </form>

                <ul class="navbar-nav">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarUserDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="fas fa-user me-1"></i> ${sessionScope.user.name}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarUserDropdown">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">Meu Perfil</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil/pedidos">Meus Pedidos</a></li>
                                    <c:if test="${sessionScope.user.isAdmin()}">
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Painel Admin</a></li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Sair</a></li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/login">Login</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link btn btn-primary btn-sm text-white" href="${pageContext.request.contextPath}/register">Registrar</a>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <li class="nav-item ms-lg-2">
                        <a href="${pageContext.request.contextPath}/cart" class="nav-link">
                            <i class="fas fa-shopping-cart"></i>
                            <c:if test="${not empty sessionScope.cart_count && sessionScope.cart_count > 0}">
                                <span class="badge rounded-pill bg-danger">${sessionScope.cart_count}</span>
                            </c:if>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</header>