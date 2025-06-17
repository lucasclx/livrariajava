<%-- /WEB-INF/view/loja/components/book-card.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 
  Este componente espera que uma variável 'livro' do tipo com.livraria.models.Livro 
  esteja disponível no escopo da página.
--%>
<div class="card h-100 product-card">
    <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
        <div class="card-img-container">
            <c:if test="${livro.temPromocao()}">
                <span class="badge bg-danger position-absolute top-0 start-0 m-2">
                    -${livro.desconto}%
                </span>
            </c:if>
            <img src="${pageContext.request.contextPath}${livro.imagemUrl}" class="card-img-top" alt="${livro.titulo}">
        </div>
    </a>
    <div class="card-body d-flex flex-column">
        <h5 class="card-title product-title">
            <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">${livro.titulo}</a>
        </h5>
        <p class="card-text text-muted small">${livro.autor}</p>
        
        <div class="mt-auto">
            <div class="price-section mb-2">
                <c:choose>
                    <c:when test="${livro.temPromocao()}">
                        <span class="text-muted text-decoration-line-through me-2">
                            <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ " />
                        </span>
                        <span class="h5 text-danger fw-bold">
                            <fmt:formatNumber value="${livro.precoPromocional}" type="currency" currencySymbol="R$ " />
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="h5 fw-bold">
                             <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ " />
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="d-grid">
                <c:choose>
                    <c:when test="${livro.emEstoque()}">
                         <button class="btn btn-primary btn-sm add-to-cart-btn" data-livro-id="${livro.id}">
                            <i class="fas fa-shopping-cart me-2"></i> Adicionar ao Carrinho
                        </button>
                    </c:when>
                    <c:otherwise>
                         <button class="btn btn-secondary btn-sm" disabled>
                            <i class="fas fa-times-circle me-2"></i> Esgotado
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="text-center mt-2 small text-${livro.statusEstoque.cor}">
                ${livro.statusEstoque.texto}
            </div>
        </div>
    </div>
</div>