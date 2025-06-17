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
        .cart-item {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }
        .cart-summary {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
            position: sticky;
            top: 2rem;
        }
        .book-image {
            width: 80px;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
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
                    <div>
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
                    <div class="col-lg-8">
                        <div id="cart-items">
                            <c:forEach var="item" items="${items}">
                                <div class="cart-item" data-item-id="${item.id}">
                                    <div class="row align-items-center">
                                        <div class="col-md-2 col-3">
                                            <img src="${pageContext.request.contextPath}/uploads/livros/${item.livro.imagem}" 
                                                 class="book-image" alt="${item.livro.titulo}">
                                        </div>
                                        <div class="col-md-4 col-9">
                                            <h6 class="mb-1 fw-bold">
                                                <a href="${pageContext.request.contextPath}/loja/livro/${item.livro.id}" 
                                                   class="text-decoration-none text-dark">${item.livro.titulo}</a>
                                            </h6>
                                            <p class="text-muted mb-1 small">${item.livro.autor}</p>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <div class="fw-bold">${item.priceFormatado}</div>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <span>${item.quantity}</span>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <div class="fw-bold text-success item-subtotal">${item.subtotalFormatado}</div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach> <%-- A TAG DE FECHAMENTO ESTAVA FALTANDO --%>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="cart-summary">
                            <h4 class="mb-4">Resumo do Pedido</h4>
                            <div class="summary-row">
                                <span>Subtotal (${totalItens} itens)</span>
                                <span class="fw-bold">R$ <fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="summary-row">
                                <span>Frete</span>
                                <span class="fw-bold">A calcular</span>
                            </div>
                            <div class="summary-row pt-3">
                                <span class="h5">Total</span>
                                <span class="h5 fw-bold">R$ <fmt:formatNumber value="${subtotal}" pattern="#,##0.00"/></span>
                            </div>
                            <div class="d-grid mt-4">
                                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-lg">
                                    Finalizar Compra <i class="fas fa-arrow-right ms-2"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-cart">
                    <i class="fas fa-shopping-bag"></i>
                    <h3 class="mb-3">Seu carrinho está vazio</h3>
                    <p class="text-muted">Explore nossos livros e adicione seus favoritos para vê-los aqui!</p>
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary mt-3">
                        Ver Catálogo de Livros
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

    </main>

    <jsp:include page="../common/footer.jsp" />
    <script>
        // Funções JS para limpar carrinho, etc. podem ser adicionadas aqui
    </script>
</body>
</html>