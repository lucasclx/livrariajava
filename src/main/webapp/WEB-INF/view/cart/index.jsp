<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Meu Carrinho" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .cart-container {
            background: rgba(245, 245, 220, 0.8);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(139, 69, 19, 0.15);
            border: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .cart-item {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.08);
            border: 1px solid rgba(139, 69, 19, 0.05);
            transition: all 0.3s ease;
        }
        
        .cart-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
        }
        
        .cart-summary {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.1) 0%, rgba(139, 69, 19, 0.1) 100%);
            border: 2px solid rgba(218, 165, 32, 0.3);
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.1);
            position: sticky;
            top: 2rem;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            border-radius: 25px;
            padding: 0.25rem;
            max-width: 120px;
        }
        
        .quantity-control button {
            border: none;
            background: white;
            color: var(--primary-brown);
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }
        
        .quantity-control button:hover {
            background: var(--primary-brown);
            color: white;
            transform: scale(1.1);
        }
        
        .quantity-control input {
            border: none;
            background: transparent;
            text-align: center;
            width: 40px;
            font-weight: 600;
        }
        
        .remove-item {
            color: #dc3545;
            transition: all 0.3s ease;
        }
        
        .remove-item:hover {
            color: #a71e2a;
            transform: scale(1.2);
        }
        
        .empty-cart {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--ink);
        }
        
        .empty-cart i {
            font-size: 4rem;
            color: var(--light-brown);
            margin-bottom: 1rem;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .summary-row:last-child {
            border-bottom: none;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--dark-brown);
        }
        
        .shipping-info {
            background: rgba(34, 139, 34, 0.1);
            border: 1px solid rgba(34, 139, 34, 0.2);
            border-radius: 10px;
            padding: 1rem;
            margin: 1rem 0;
        }
        
        .book-image {
            width: 80px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .suggestions-section {
            background: rgba(253, 246, 227, 0.7);
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
            border: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        
        .loading-spinner {
            background: white;
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <main class="container my-5 flex-grow-1">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="page-title">
                        <i class="fas fa-shopping-cart me-3"></i>Meu Carrinho
                    </h1>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-outline-elegant">
                            <i class="fas fa-arrow-left me-2"></i>Continuar Comprando
                        </a>
                        <c:if test="${not empty items}">
                            <button type="button" class="btn btn-outline-danger" onclick="clearCart()">
                                <i class="fas fa-trash me-2"></i>Limpar Carrinho
                            </button>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty items}">
                <div class="row">
                    <!-- Cart Items -->
                    <div class="col-lg-8">
                        <div class="cart-container p-4">
                            <div id="cart-items">
                                <c:forEach var="item" items="${items}" varStatus="status">
                                    <div class="cart-item" data-item-id="${item.id}">
                                        <div class="row align-items-center">
                                            <!-- Book Image -->
                                            <div class="col-md-2 col-3">
                                                <c:choose>
                                                    <c:when test="${not empty item.livro.imagem}">
                                                        <img src="${pageContext.request.contextPath}/uploads/livros/${item.livro.imagem}" 
                                                             class="book-image" alt="${item.livro.titulo}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="book-image d-flex align-items-center justify-content-center bg-light">
                                                            <i class="fas fa-book text-muted"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <!-- Book Info -->
                                            <div class="col-md-4 col-9">
                                                <h6 class="mb-1 fw-bold">
                                                    <a href="${pageContext.request.contextPath}/loja/livro/${item.livro.id}" 
                                                       class="text-decoration-none text-dark">
                                                        ${item.livro.titulo}
                                                    </a>
                                                </h6>
                                                <p class="text-muted mb-1 small">
                                                    <i class="fas fa-feather-alt me-1"></i>${item.livro.autor}
                                                </p>
                                                <c:if test="${not empty item.livro.categoria}">
                                                    <span class="badge bg-secondary small">${item.livro.categoria.nome}</span>
                                                </c:if>
                                                
                                                <!-- Mobile Actions -->
                                                <div class="d-md-none mt-2">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <div class="quantity-control">
                                                            <button type="button" onclick="updateQuantity(${item.id}, ${item.quantity - 1})">
                                                                <i class="fas fa-minus"></i>
                                                            </button>
                                                            <input type="number" value="${item.quantity}" readonly>
                                                            <button type="button" onclick="updateQuantity(${item.id}, ${item.quantity + 1})">
                                                                <i class="fas fa-plus"></i>
                                                            </button>
                                                        </div>
                                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeItem(${item.id})">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Quantity Controls (Desktop) -->
                                            <div class="col-md-2 d-none d-md-block">
                                                <div class="quantity-control mx-auto">
                                                    <button type="button" onclick="updateQuantity(${item.id}, ${item.quantity - 1})" 
                                                            ${item.quantity <= 1 ? 'disabled' : ''}>
                                                        <i class="fas fa-minus"></i>
                                                    </button>
                                                    <input type="number" value="${item.quantity}" readonly min="1" max="10">
                                                    <button type="button" onclick="updateQuantity(${item.id}, ${item.quantity + 1})" 
                                                            ${item.quantity >= 10 ? 'disabled' : ''}>
                                                        <i class="fas fa-plus"></i>
                                                    </button>
                                                </div>
                                                <small class="text-muted d-block text-center mt-1">
                                                    Estoque: ${item.livro.estoque}
                                                </small>
                                            </div>
                                            
                                            <!-- Price -->
                                            <div class="col-md-2 d-none d-md-block text-center">
                                                <div class="price fw-bold">${item.priceFormatado}</div>
                                                <c:if test="${item.livro.temPromocao()}">
                                                    <small class="text-muted text-decoration-line-through">
                                                        R$ <fmt:formatNumber value="${item.livro.preco}" pattern="#,##0.00"/>
                                                    </small>
                                                </c:if>
                                            </div>
                                            
                                            <!-- Subtotal -->
                                            <div class="col-md-2 d-none d-md-block text-center">
                                                <div class="fw-bold text-success item-subtotal">
                                                    ${item.subtotalFormatado}