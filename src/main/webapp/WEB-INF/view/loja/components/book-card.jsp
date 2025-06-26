<%-- /WEB-INF/view/loja/components/book-card.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- 
  Este componente espera que uma variável 'livro' do tipo com.livraria.models.Livro 
  esteja disponível no escopo da página.
--%>

<style>
    .product-card {
        transition: all 0.3s ease;
        border: 1px solid #f0f0f0;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        position: relative;
        overflow: hidden;
    }
    
    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        border-color: #8B4513;
    }
    
    .card-img-container {
        position: relative;
        height: 280px;
        overflow: hidden;
        background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .card-img-top {
        width: auto;
        height: 100%;
        max-width: 100%;
        object-fit: cover;
        transition: transform 0.3s ease;
    }
    
    .product-card:hover .card-img-top {
        transform: scale(1.05);
    }
    
    .placeholder-image {
        width: 120px;
        height: 180px;
        background: linear-gradient(135deg, #dee2e6, #ced4da);
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        border: 2px dashed #adb5bd;
        color: #6c757d;
        font-size: 2.5rem;
    }
    
    .favorite-btn {
        position: absolute;
        top: 10px;
        right: 10px;
        background: rgba(255, 255, 255, 0.9);
        border: none;
        width: 35px;
        height: 35px;
        border-radius: 50%;
        color: #6c757d;
        cursor: pointer;
        transition: all 0.3s ease;
        z-index: 2;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .favorite-btn:hover,
    .favorite-btn.active {
        background: #dc3545;
        color: white;
        transform: scale(1.1);
    }
    
    .badge-container {
        position: absolute;
        top: 10px;
        left: 10px;
        z-index: 2;
    }
    
    .badge-destaque {
        background: #28a745 !important;
    }
    
    .badge-bestseller {
        background: #ffc107 !important;
        color: #000 !important;
    }
    
    .product-title a {
        color: #2c3e50;
        text-decoration: none;
        font-weight: 600;
        font-size: 1.1rem;
        line-height: 1.3;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    
    .product-title a:hover {
        color: #8B4513;
    }
    
    .book-category {
        color: #8B4513;
        font-size: 0.8rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 0.5rem;
    }
    
    .book-info {
        display: flex;
        gap: 1rem;
        margin-bottom: 0.75rem;
        font-size: 0.8rem;
        color: #6c757d;
        flex-wrap: wrap;
    }
    
    .book-info span {
        display: flex;
        align-items: center;
        gap: 0.3rem;
    }
    
    .book-rating {
        margin-bottom: 0.75rem;
    }
    
    .rating-stars {
        color: #ffc107;
        margin-right: 0.5rem;
    }
    
    .stock-indicator {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        font-size: 0.85rem;
        margin-top: 0.5rem;
    }
    
    .stock-dot {
        width: 8px;
        height: 8px;
        border-radius: 50%;
    }
    
    .stock-disponivel {
        background: #28a745;
    }
    
    .stock-baixo {
        background: #ffc107;
    }
    
    .stock-esgotado {
        background: #dc3545;
    }
    
    .btn-add-cart {
        background: #8B4513;
        border-color: #8B4513;
        font-weight: 600;
        transition: all 0.3s ease;
    }
    
    .btn-add-cart:hover {
        background: #B8860B;
        border-color: #B8860B;
        transform: translateY(-1px);
    }
    
    .btn-quick-view {
        background: transparent;
        border: 2px solid #8B4513;
        color: #8B4513;
        font-weight: 600;
        transition: all 0.3s ease;
    }
    
    .btn-quick-view:hover {
        background: #8B4513;
        color: white;
    }
    
    .price-section {
        text-align: center;
    }
    
    .discount-percentage {
        background: #dc3545;
        color: white;
        padding: 0.2rem 0.5rem;
        border-radius: 10px;
        font-size: 0.75rem;
        font-weight: 600;
        margin-left: 0.5rem;
    }
</style>

<div class="card h-100 product-card">
    <!-- Badge Container -->
    <div class="badge-container">
        <c:if test="${livro.destaque}">
            <span class="badge badge-destaque">Destaque</span>
        </c:if>
        <c:if test="${livro.vendasTotal > 100}">
            <span class="badge badge-bestseller">Bestseller</span>
        </c:if>
    </div>
    
    <!-- Botão Favorito -->
    <button class="favorite-btn js-favorite-toggle" data-livro-id="${livro.id}" title="Adicionar aos favoritos">
        <i class="far fa-heart"></i>
    </button>
    
    <!-- Container da Imagem -->
    <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
        <div class="card-img-container">
            <!-- Badge de Desconto -->
            <c:if test="${livro.temPromocao()}">
                <span class="badge bg-danger position-absolute top-0 end-0 m-2" style="z-index: 3;">
                    -${livro.desconto}%
                </span>
            </c:if>
            
            <!-- Imagem ou Placeholder -->
            <c:choose>
                <c:when test="${not empty livro.imagem}">
                    <img src="${pageContext.request.contextPath}/uploads/livros/${livro.imagem}" 
                         class="card-img-top" alt="${livro.titulo}"
                         onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                    <div class="placeholder-image" style="display: none;">
                        <i class="fas fa-book"></i>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="placeholder-image">
                        <i class="fas fa-book"></i>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </a>
    
    <!-- Corpo do Card -->
    <div class="card-body d-flex flex-column">
        <!-- Categoria -->
        <c:if test="${not empty livro.categoria}">
            <div class="book-category">${livro.categoria.nome}</div>
        </c:if>
        
        <!-- Título -->
        <h5 class="card-title product-title">
            <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">${livro.titulo}</a>
        </h5>
        
        <!-- Autor -->
        <p class="card-text text-muted small mb-2">${livro.autor}</p>
        
        <!-- Informações Adicionais -->
        <div class="book-info">
            <c:if test="${not empty livro.anoPublicacao}">
                <span><i class="fas fa-calendar-alt"></i> ${livro.anoPublicacao}</span>
            </c:if>
            <c:if test="${not empty livro.paginas}">
                <span><i class="fas fa-file-alt"></i> ${livro.paginas} pág</span>
            </c:if>
            <c:if test="${not empty livro.idioma}">
                <span><i class="fas fa-globe"></i> ${livro.idioma}</span>
            </c:if>
        </div>
        
        <!-- Avaliações -->
        <div class="book-rating mb-2">
            <span class="rating-stars">
                <c:set var="rating" value="${livro.avaliacaoMedia != null ? livro.avaliacaoMedia : 0}" />
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${rating >= i}">
                            <i class="fas fa-star"></i>
                        </c:when>
                        <c:when test="${rating > i - 1 && rating < i}">
                            <i class="fas fa-star-half-alt"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="far fa-star"></i>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </span>
            <span class="small text-muted">
                <c:choose>
                    <c:when test="${livro.totalAvaliacoes > 0}">
                        <fmt:formatNumber value="${rating}" maxFractionDigits="1" /> (${livro.totalAvaliacoes})
                    </c:when>
                    <c:otherwise>
                        Sem avaliações
                    </c:otherwise>
                </c:choose>
            </span>
        </div>
        
        <!-- Seção de Preços e Ações (sempre no final) -->
        <div class="mt-auto">
            <!-- Preços -->
            <div class="price-section mb-3">
                <c:choose>
                    <c:when test="${livro.temPromocao()}">
                        <div>
                            <span class="text-muted text-decoration-line-through me-2 small">
                                <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ " />
                            </span>
                        </div>
                        <div>
                            <span class="h5 text-success fw-bold">
                                <fmt:formatNumber value="${livro.precoPromocional}" type="currency" currencySymbol="R$ " />
                            </span>
                            <span class="discount-percentage">-${livro.desconto}%</span>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <span class="h5 fw-bold text-primary">
                             <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ " />
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Indicador de Estoque -->
            <div class="stock-indicator text-center mb-2">
                <c:choose>
                    <c:when test="${livro.estoque > livro.estoqueMinimo}">
                        <span class="stock-dot stock-disponivel"></span>
                        <span class="text-success">${livro.estoque} em estoque</span>
                    </c:when>
                    <c:when test="${livro.estoque > 0}">
                        <span class="stock-dot stock-baixo"></span>
                        <span class="text-warning">Últimas ${livro.estoque} unidades</span>
                    </c:when>
                    <c:otherwise>
                        <span class="stock-dot stock-esgotado"></span>
                        <span class="text-danger">Esgotado</span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Botões de Ação -->
            <div class="row g-2">
                <div class="col-8">
                    <c:choose>
                        <c:when test="${livro.estoque > 0}">
                             <button class="btn btn-add-cart btn-sm w-100 js-add-to-cart" data-livro-id="${livro.id}">
                                <i class="fas fa-shopping-cart me-1"></i> Adicionar
                            </button>
                        </c:when>
                        <c:otherwise>
                             <button class="btn btn-secondary btn-sm w-100" disabled>
                                <i class="fas fa-times-circle me-1"></i> Esgotado
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-4">
                    <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                       class="btn btn-quick-view btn-sm w-100" title="Ver detalhes">
                        <i class="fas fa-eye"></i>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Script para funcionalidade dos favoritos (adicione ao final da página se necessário)
document.addEventListener('DOMContentLoaded', function() {
    // Favoritos
    document.querySelectorAll('.js-favorite-toggle').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            const livroId = this.dataset.livroId;
            const icon = this.querySelector('i');
            const isFavorited = icon.classList.contains('fas');
            
            // Toggle visual
            if (isFavorited) {
                icon.classList.remove('fas');
                icon.classList.add('far');
                this.classList.remove('active');
            } else {
                icon.classList.remove('far');
                icon.classList.add('fas');
                this.classList.add('active');
            }
            
            // Fazer requisição AJAX para o servidor
            fetch('${pageContext.request.contextPath}/favorites/toggle/' + livroId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Mostrar notificação de sucesso
                    showNotification(data.message, 'success');
                } else {
                    // Reverter mudança visual em caso de erro
                    if (isFavorited) {
                        icon.classList.remove('far');
                        icon.classList.add('fas');
                        this.classList.add('active');
                    } else {
                        icon.classList.remove('fas');
                        icon.classList.add('far');
                        this.classList.remove('active');
                    }
                    showNotification(data.message || 'Erro ao atualizar favoritos', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                // Reverter mudança visual
                if (isFavorited) {
                    icon.classList.remove('far');
                    icon.classList.add('fas');
                    this.classList.add('active');
                } else {
                    icon.classList.remove('fas');
                    icon.classList.add('far');
                    this.classList.remove('active');
                }
                showNotification('Erro ao atualizar favoritos', 'error');
            });
        });
    });
    
    // Adicionar ao carrinho
    document.querySelectorAll('.js-add-to-cart').forEach(btn => {
        btn.addEventListener('click', function() {
            const livroId = this.dataset.livroId;
            const originalText = this.innerHTML;
            
            // Feedback visual
            this.disabled = true;
            this.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i> Adicionando...';
            
            // Fazer requisição AJAX
            fetch('${pageContext.request.contextPath}/cart/add/' + livroId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.innerHTML = '<i class="fas fa-check me-1"></i> Adicionado!';
                    showNotification('Livro adicionado ao carrinho!', 'success');
                    
                    // Atualizar contador do carrinho se existir
                    updateCartCount(data.cartCount);
                    
                    setTimeout(() => {
                        this.innerHTML = originalText;
                        this.disabled = false;
                    }, 2000);
                } else {
                    this.innerHTML = originalText;
                    this.disabled = false;
                    showNotification(data.message || 'Erro ao adicionar ao carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                this.innerHTML = originalText;
                this.disabled = false;
                showNotification('Erro ao adicionar ao carrinho', 'error');
            });
        });
    });
});

// Função para mostrar notificações (implemente conforme seu sistema)
function showNotification(message, type) {
    // Implementar conforme seu sistema de notificações
    console.log(type + ': ' + message);
}

// Função para atualizar contador do carrinho
function updateCartCount(count) {
    const cartBadge = document.querySelector('.cart-count');
    if (cartBadge) {
        cartBadge.textContent = count;
    }não
}
</script>