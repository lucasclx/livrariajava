<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="pageTitle" value="Bem-vindo à Livraria Mil Páginas" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <%-- Inclui o cabeçalho com CSS e metatags --%>
    <jsp:include page="WEB-INF/view/common/head.jsp" />
</head>
<body class="d-flex flex-column h-100">

    <%-- Inclui o menu de navegação --%>
    <jsp:include page="WEB-INF/view/common/header.jsp" />

    <!-- Hero Section -->
    <section class="hero-section text-center fade-in-down">
        <div class="container">
            <h1 class="display-3 mb-4" style="font-family: var(--font-serif);">
                Onde cada página é uma nova jornada.
            </h1>
            <p class="lead col-lg-8 mx-auto mb-5">
                Mergulhe em universos de fantasia, desvende mistérios ou aprenda algo novo 
                com nossa vasta coleção de livros cuidadosamente selecionados.
            </p>
            <div class="d-flex flex-column flex-md-row justify-content-center gap-3">
                <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-gold btn-lg hover-lift">
                    <i class="fas fa-book-open me-2"></i>Explorar nosso Acervo
                </a>
                <a href="${pageContext.request.contextPath}/search" class="btn btn-outline-light btn-lg hover-lift">
                    <i class="fas fa-search me-2"></i>Buscar Livros
                </a>
            </div>
        </div>
    </section>

    <main class="container my-5 flex-shrink-0">

        <!-- Livros em Destaque -->
        <section id="destaques" class="mb-5 fade-in-up">
            <div class="text-center mb-5">
                <h2 class="page-title">Livros em Destaque</h2>
                <p class="lead text-muted">Descobrimentos literários selecionados especialmente para você</p>
            </div>
            
            <c:choose>
                <c:when test="${not empty livrosDestaque}">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                        <c:forEach var="livro" items="${livrosDestaque}" varStatus="status">
                            <div class="col">
                                <div class="card book-card h-100" style="animation-delay: ${status.index * 0.1}s;">
                                    <!-- Capa do Livro -->
                                    <div class="position-relative">
                                        <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                            <c:choose>
                                                <c:when test="${not empty livro.imagemUrl}">
                                                    <img src="${pageContext.request.contextPath}${livro.imagemUrl}" 
                                                         class="card-img-top book-cover" alt="Capa de ${livro.titulo}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top book-cover d-flex align-items-center justify-content-center bg-light">
                                                        <div class="text-center text-muted">
                                                            <i class="fas fa-book fa-3x mb-2"></i>
                                                            <p class="small mb-0">Sem Capa</p>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        
                                        <!-- Badge de Destaque -->
                                        <div class="position-absolute top-0 start-0 m-2">
                                            <span class="badge bg-gold">
                                                <i class="fas fa-star me-1"></i>Destaque
                                            </span>
                                        </div>
                                        
                                        <!-- Botão de Favorito -->
                                        <div class="position-absolute top-0 end-0 m-2">
                                            <button class="btn btn-light btn-sm rounded-circle" 
                                                    onclick="toggleFavorite(${livro.id})" 
                                                    data-bs-toggle="tooltip" title="Adicionar aos favoritos">
                                                <i class="far fa-heart"></i>
                                            </button>
                                        </div>
                                    </div>
                                    
                                    <!-- Conteúdo do Card -->
                                    <div class="card-body d-flex flex-column text-center">
                                        <h5 class="card-title h6 mb-2">
                                            <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                               class="text-decoration-none text-dark hover-gold">
                                                ${livro.titulo}
                                            </a>
                                        </h5>
                                        <p class="card-text small text-muted mb-2">
                                            <i class="fas fa-feather-alt me-1"></i>${livro.autor}
                                        </p>
                                        
                                        <!-- Categoria -->
                                        <c:if test="${not empty livro.categoria}">
                                            <div class="mb-2">
                                                <span class="badge badge-category small">${livro.categoria.nome}</span>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Preço e Ação -->
                                        <div class="mt-auto pt-2">
                                            <div class="mb-3">
                                                <c:choose>
                                                    <c:when test="${livro.temPromocao()}">
                                                        <div class="d-flex flex-column align-items-center">
                                                            <small class="text-muted text-decoration-line-through">
                                                                ${livro.precoOriginalFormatado}
                                                            </small>
                                                            <span class="price text-success fw-bold">${livro.precoFormatado}</span>
                                                            <small class="badge bg-danger">
                                                                ${livro.percentualDesconto}% OFF
                                                            </small>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="price">${livro.precoFormatado}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            
                                            <!-- Botões de Ação -->
                                            <div class="d-grid gap-2">
                                                <button class="btn btn-gold btn-sm hover-lift" 
                                                        onclick="addToCart(${livro.id})"
                                                        ${livro.estoque <= 0 ? 'disabled' : ''}>
                                                    <i class="fas fa-cart-plus me-2"></i>
                                                    ${livro.estoque > 0 ? 'Adicionar' : 'Sem Estoque'}
                                                </button>
                                                <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                                   class="btn btn-outline-elegant btn-sm">
                                                    <i class="fas fa-eye me-1"></i>Ver Detalhes
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <div class="card border-0 bg-transparent">
                            <div class="card-body">
                                <i class="fas fa-book fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Nenhum livro em destaque</h4>
                                <p class="text-muted">Em breve teremos novidades incríveis para você!</p>
                                <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary">
                                    Ver Catálogo Completo
                                </a>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Navegação por Categorias -->
        <section id="categorias" class="mb-5 fade-in-up">
            <div class="text-center mb-5">
                <h2 class="page-title">Navegar por Categorias</h2>
                <p class="lead text-muted">Encontre exatamente o que você procura</p>
            </div>
            
            <c:choose>
                <c:when test="${not empty categorias}">
                    <div class="row g-3">
                        <c:forEach var="categoria" items="${categorias}" varStatus="status">
                            <div class="col-6 col-md-4 col-lg-3">
                                <a href="${pageContext.request.contextPath}/loja/categoria/${categoria.slug}" 
                                   class="btn btn-outline-elegant w-100 h-100 d-flex flex-column align-items-center justify-content-center p-3 hover-lift"
                                   style="min-height: 100px;">
                                    <i class="fas fa-${categoria.icon != null ? categoria.icon : 'book'} fa-2x mb-2"></i>
                                    <span class="fw-semibold">${categoria.nome}</span>
                                    <small class="text-muted">${categoria.totalLivros} livros</small>
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="d-flex flex-wrap justify-content-center gap-2">
                        <!-- Categorias padrão caso não haja no banco -->
                        <a href="${pageContext.request.contextPath}/search?categoria=ficcao" class="btn btn-outline-elegant">Ficção</a>
                        <a href="${pageContext.request.contextPath}/search?categoria=nao-ficcao" class="btn btn-outline-elegant">Não Ficção</a>
                        <a href="${pageContext.request.contextPath}/search?categoria=infantil" class="btn btn-outline-elegant">Infantil</a>
                        <a href="${pageContext.request.contextPath}/search?categoria=tecnico" class="btn btn-outline-elegant">Técnico</a>
                        <a href="${pageContext.request.contextPath}/search?categoria=autoajuda" class="btn btn-outline-elegant">Autoajuda</a>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
        
        <!-- Mais Vendidos -->
        <section id="mais-vendidos" class="fade-in-up">
            <div class="text-center mb-5">
                <h2 class="page-title">Os Mais Vendidos</h2>
                <p class="lead text-muted">Os favoritos dos nossos leitores</p>
            </div>
            
            <c:choose>
                <c:when test="${not empty livrosMaisVendidos}">
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                        <c:forEach var="livro" items="${livrosMaisVendidos}" varStatus="status">
                            <div class="col">
                                <div class="card book-card h-100" style="animation-delay: ${status.index * 0.1}s;">
                                    <!-- Capa do Livro -->
                                    <div class="position-relative">
                                        <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}">
                                            <c:choose>
                                                <c:when test="${not empty livro.imagemUrl}">
                                                    <img src="${pageContext.request.contextPath}${livro.imagemUrl}" 
                                                         class="card-img-top book-cover" alt="Capa de ${livro.titulo}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="card-img-top book-cover d-flex align-items-center justify-content-center bg-light">
                                                        <div class="text-center text-muted">
                                                            <i class="fas fa-book fa-3x mb-2"></i>
                                                            <p class="small mb-0">Sem Capa</p>
                                                        </div>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </a>
                                        
                                        <!-- Badge de Mais Vendido -->
                                        <div class="position-absolute top-0 start-0 m-2">
                                            <span class="badge bg-success">
                                                <i class="fas fa-fire me-1"></i>#${status.index + 1}
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <!-- Conteúdo do Card -->
                                    <div class="card-body d-flex flex-column text-center">
                                        <h5 class="card-title h6 mb-2">
                                            <a href="${pageContext.request.contextPath}/loja/livro/${livro.id}" 
                                               class="text-decoration-none text-dark hover-gold">
                                                ${livro.titulo}
                                            </a>
                                        </h5>
                                        <p class="card-text small text-muted mb-2">
                                            <i class="fas fa-feather-alt me-1"></i>${livro.autor}
                                        </p>
                                        
                                        <!-- Avaliação (se disponível) -->
                                        <c:if test="${livro.avaliacaoMedia > 0}">
                                            <div class="mb-2">
                                                <div class="text-warning">
                                                    <c:forEach begin="1" end="5" var="star">
                                                        <i class="fa${star <= livro.avaliacaoMedia ? 's' : 'r'} fa-star"></i>
                                                    </c:forEach>
                                                </div>
                                                <small class="text-muted">(${livro.totalAvaliacoes} avaliações)</small>
                                            </div>
                                        </c:if>
                                        
                                        <!-- Preço e Ação -->
                                        <div class="mt-auto pt-2">
                                            <div class="mb-3">
                                                <span class="price">${livro.precoFormatado}</span>
                                            </div>
                                            
                                            <div class="d-grid gap-2">
                                                <button class="btn btn-gold btn-sm hover-lift" 
                                                        onclick="addToCart(${livro.id})"
                                                        ${livro.estoque <= 0 ? 'disabled' : ''}>
                                                    <i class="fas fa-cart-plus me-2"></i>
                                                    ${livro.estoque > 0 ? 'Adicionar' : 'Sem Estoque'}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <div class="card border-0 bg-transparent">
                            <div class="card-body">
                                <i class="fas fa-chart-line fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Ainda não temos dados de vendas</h4>
                                <p class="text-muted">Em breve você verá aqui nossos livros mais populares!</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Newsletter Section -->
        <section class="newsletter-section my-5 fade-in-up">
            <div class="card bg-gradient-primary text-white border-0">
                <div class="card-body text-center py-5">
                    <h3 class="mb-3">
                        <i class="fas fa-envelope me-2"></i>
                        Não perca nenhuma novidade!
                    </h3>
                    <p class="lead mb-4">
                        Receba em primeira mão nossos lançamentos, promoções e dicas de leitura.
                    </p>
                    <form action="${pageContext.request.contextPath}/newsletter/subscribe" method="POST" class="row g-3 justify-content-center">
                        <div class="col-md-6 col-lg-4">
                            <div class="input-group">
                                <input type="email" name="email" class="form-control" 
                                       placeholder="Seu melhor e-mail" required>
                                <button class="btn btn-gold" type="submit">
                                    <i class="fas fa-paper-plane"></i>
                                </button>
                            </div>
                        </div>
                    </form>
                    <small class="mt-3 d-block opacity-75">
                        <i class="fas fa-shield-alt me-1"></i>
                        Seus dados estão seguros. Não enviamos spam.
                    </small>
                </div>
            </div>
        </section>

    </main>

    <%-- Inclui o rodapé da página --%>
    <jsp:include page="WEB-INF/view/common/footer.jsp" />

    <!-- Scroll to Top Button -->
    <button class="scroll-to-top" onclick="scrollToTop()" title="Voltar ao topo">
        <i class="fas fa-chevron-up"></i>
    </button>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Funcionalidade do carrinho
        function addToCart(livroId) {
            fetch(`${pageContext.request.contextPath}/cart/add`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `livroId=${livroId}&quantity=1`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateCartCount();
                    showToast('Livro adicionado ao carrinho!', 'success');
                } else {
                    showToast(data.message || 'Erro ao adicionar ao carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showToast('Erro ao adicionar ao carrinho', 'error');
            });
        }

        // Toggle favoritos
        function toggleFavorite(livroId) {
            fetch(`${pageContext.request.contextPath}/favorites/toggle`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `livroId=${livroId}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const icon = event.target.closest('button').querySelector('i');
                    if (data.isFavorite) {
                        icon.classList.replace('far', 'fas');
                        icon.style.color = '#dc3545';
                        showToast('Adicionado aos favoritos!', 'success');
                    } else {
                        icon.classList.replace('fas', 'far');
                        icon.style.color = '';
                        showToast('Removido dos favoritos', 'info');
                    }
                } else {
                    showToast(data.message || 'Erro ao atualizar favoritos', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showToast('Erro ao atualizar favoritos', 'error');
            });
        }

        // Atualizar contagem do carrinho
        function updateCartCount() {
            fetch(`${pageContext.request.contextPath}/cart/count`)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('cart-count').textContent = data.count || 0;
                    }
                })
                .catch(error => console.error('Erro ao atualizar carrinho:', error));
        }

        // Toast notifications
        function showToast(message, type = 'info') {
            const toast = document.createElement('div');
            toast.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
            toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; max-width: 300px;';
            toast.innerHTML = `
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            document.body.appendChild(toast);
            
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.remove();
                }
            }, 5000);
        }

        // Scroll to top
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        }

        // Show/hide scroll to top button
        window.addEventListener('scroll', function() {
            const scrollBtn = document.querySelector('.scroll-to-top');
            if (window.pageYOffset > 300) {
                scrollBtn.classList.add('visible');
            } else {
                scrollBtn.classList.remove('visible');
            }
        });

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Atualizar contagem do carrinho
            updateCartCount();
            
            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl);
            });
            
            // Intersection Observer para animações
            const observerOptions = {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px'
            };
            
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            }, observerOptions);
            
            // Observer para seções
            document.querySelectorAll('.fade-in-up').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(30px)';
                el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                observer.observe(el);
            });
            
            // Observer para cards de livros
            document.querySelectorAll('.book-card').forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
                observer.observe(card);
            });
        });
    </script>
</body>
</html>