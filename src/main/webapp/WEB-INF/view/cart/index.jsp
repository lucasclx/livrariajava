<strong>Referer:</strong> ${not empty pageContext.request.getHeader('Referer') ? pageContext.request.getHeader('Referer') : 'Nenhum'}<br>
                        <strong>IP:</strong> ${pageContext.request.remoteAddr}<br>
                        <strong>Timestamp:</strong> <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm:ss" /><br>
                        <strong>Sessão:</strong> ${pageContext.session.id}
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Footer Information -->
        <div class="mt-4 pt-4 border-top">
            <p class="mb-2">
                <strong>Livraria Mil Páginas</strong> - Onde cada página é uma nova jornada
            </p>
            <p class="mb-0 small text-muted">
                &copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" />
                Todos os direitos reservados.
            </p>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            initializeErrorPage();
            logError();
        });

        // Initialize error page functionality
        function initializeErrorPage() {
            console.log('Error 404 page initialized');
            
            // Add smooth animations
            const container = document.querySelector('.error-container');
            if (container) {
                container.style.opacity = '0';
                container.style.transform = 'translateY(30px)';
                
                setTimeout(() => {
                    container.style.transition = 'all 0.6s ease';
                    container.style.opacity = '1';
                    container.style.transform = 'translateY(0)';
                }, 100);
            }

            // Setup form focus effects
            const searchInput = document.querySelector('input[name="q"]');
            if (searchInput) {
                searchInput.addEventListener('focus', function() {
                    this.style.transform = 'scale(1.02)';
                    this.style.boxShadow = '0 4px 15px rgba(102, 126, 234, 0.3)';
                });

                searchInput.addEventListener('blur', function() {
                    this.style.transform = 'scale(1)';
                    this.style.boxShadow = 'none';
                });
            }

            // Add hover effects to suggestion cards
            const suggestionCards = document.querySelectorAll('.suggestion-card');
            suggestionCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    this.style.transform = 'translateY(-5px) scale(1.02)';
                });

                card.addEventListener('mouseleave', function() {
                    this.style.transform = 'translateY(0) scale(1)';
                });
            });
        }

        // Log error for analytics/debugging
        function logError() {
            const errorData = {
                url: window.location.href,
                referrer: document.referrer,
                userAgent: navigator.userAgent,
                timestamp: new Date().toISOString(),
                error: '404 - Page Not Found'
            };

            console.warn('404 Error logged:', errorData);

            // Send to analytics if available
            if (typeof gtag !== 'undefined') {
                gtag('event', '404_error', {
                    'page_location': errorData.url,
                    'page_referrer': errorData.referrer
                });
            }

            // Send to error tracking service if available
            if (typeof Sentry !== 'undefined') {
                Sentry.captureMessage('404 Page Not Found', {
                    extra: errorData,
                    level: 'warning'
                });
            }
        }

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + H = Home
            if ((e.ctrlKey || e.metaKey) && e.key === 'h') {
                e.preventDefault();
                window.location.href = '${pageContext.request.contextPath}/';
            }

            // Ctrl/Cmd + B = Back
            if ((e.ctrlKey || e.metaKey) && e.key === 'b') {
                e.preventDefault();<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Página não encontrada - Livraria Mil Páginas</title>
    
    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:ital,wght@0,400;0,600;1,400&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- Custom Styles -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, var(--aged-paper) 0%, var(--cream) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: var(--font-body);
        }

        .error-container {
            background: rgba(253, 246, 227, 0.95);
            backdrop-filter: blur(10px);
            border-radius: var(--border-radius-large);
            box-shadow: var(--shadow-extra-large);
            border: 1px solid rgba(139, 69, 19, 0.1);
            padding: 3rem 2rem;
            text-align: center;
            max-width: 800px;
            width: 90%;
            margin: 2rem;
            position: relative;
            overflow: hidden;
        }

        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--gradient-gold);
        }

        .error-animation {
            margin-bottom: 2rem;
            position: relative;
        }

        .error-number {
            font-size: 8rem;
            font-weight: 700;
            font-family: var(--font-serif);
            background: linear-gradient(135deg, var(--danger-color), var(--warning-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            line-height: 1;
            animation: bounce 2s infinite;
        }

        .error-icon {
            font-size: 4rem;
            color: var(--primary-brown);
            margin-bottom: 1.5rem;
            animation: float 3s ease-in-out infinite;
        }

        .error-title {
            font-size: 2.5rem;
            font-weight: 600;
            font-family: var(--font-serif);
            color: var(--dark-brown);
            margin-bottom: 1rem;
        }

        .error-subtitle {
            font-size: 1.2rem;
            color: var(--secondary-color);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .suggestions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin: 2rem 0;
        }

        .suggestion-card {
            background: white;
            padding: 1.5rem 1rem;
            border-radius: var(--border-radius-medium);
            text-decoration: none;
            color: inherit;
            transition: var(--transition-normal);
            border: 2px solid transparent;
            box-shadow: var(--shadow-small);
        }

        .suggestion-card:hover {
            background: var(--cream);
            border-color: var(--primary-brown);
            transform: translateY(-2px);
            box-shadow: var(--shadow-medium);
            color: inherit;
            text-decoration: none;
        }

        .suggestion-icon {
            font-size: 2rem;
            color: var(--primary-brown);
            margin-bottom: 0.5rem;
        }

        .suggestion-title {
            font-weight: 600;
            color: var(--dark-brown);
            margin-bottom: 0.25rem;
            font-size: 1rem;
        }

        .suggestion-desc {
            font-size: 0.9rem;
            color: var(--secondary-color);
            margin: 0;
        }

        .search-section {
            background: white;
            border-radius: var(--border-radius-medium);
            padding: 2rem;
            margin: 2rem 0;
            box-shadow: var(--shadow-small);
        }

        .floating-books {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
            overflow: hidden;
        }

        .floating-book {
            position: absolute;
            font-size: 2rem;
            color: rgba(139, 69, 19, 0.1);
            animation: floatAround 15s infinite linear;
        }

        .floating-book:nth-child(1) { top: 10%; left: 10%; animation-delay: 0s; }
        .floating-book:nth-child(2) { top: 20%; right: 10%; animation-delay: 3s; }
        .floating-book:nth-child(3) { bottom: 30%; left: 20%; animation-delay: 6s; }
        .floating-book:nth-child(4) { bottom: 10%; right: 30%; animation-delay: 9s; }
        .floating-book:nth-child(5) { top: 50%; left: 5%; animation-delay: 12s; }

        @keyframes floatAround {
            0% { transform: translateY(0px) rotate(0deg); opacity: 0.3; }
            25% { transform: translateY(-20px) rotate(90deg); opacity: 0.6; }
            50% { transform: translateY(-10px) rotate(180deg); opacity: 0.3; }
            75% { transform: translateY(-30px) rotate(270deg); opacity: 0.6; }
            100% { transform: translateY(0px) rotate(360deg); opacity: 0.3; }
        }

        .back-button {
            position: fixed;
            top: 2rem;
            left: 2rem;
            z-index: 1000;
        }

        .debug-info {
            background: rgba(248, 249, 250, 0.95);
            border: 1px solid #dee2e6;
            border-radius: var(--border-radius-medium);
            padding: 1.5rem;
            margin-top: 2rem;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
        }

        .breadcrumb-nav {
            background: rgba(139, 69, 19, 0.1);
            padding: 1rem;
            border-radius: var(--border-radius-medium);
            margin-bottom: 2rem;
        }

        @media (max-width: 768px) {
            .error-container {
                padding: 2rem 1rem;
                margin: 1rem;
            }

            .error-number {
                font-size: 5rem;
            }

            .error-title {
                font-size: 1.8rem;
            }

            .error-subtitle {
                font-size: 1rem;
            }

            .suggestions-grid {
                grid-template-columns: 1fr;
            }

            .back-button {
                position: static;
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Floating Books Background -->
    <div class="floating-books">
        <div class="floating-book">📚</div>
        <div class="floating-book">📖</div>
        <div class="floating-book">📕</div>
        <div class="floating-book">📗</div>
        <div class="floating-book">📘</div>
    </div>

    <!-- Back Button -->
    <div class="back-button">
        <button onclick="history.back()" class="btn btn-outline-elegant hover-lift">
            <i class="fas fa-arrow-left me-2"></i>Voltar
        </button>
    </div>

    <!-- Main Error Container -->
    <div class="error-container fade-in-up">
        <!-- Error Animation Section -->
        <div class="error-animation">
            <div class="error-icon">
                <i class="fas fa-book-dead"></i>
            </div>
            <div class="error-number">404</div>
        </div>

        <!-- Error Content -->
        <h1 class="error-title">Oops! Página não encontrada</h1>
        <p class="error-subtitle">
            Parece que a página que você está procurando se perdeu entre as estantes da nossa biblioteca digital. 
            Mas não se preocupe, temos várias opções para ajudá-lo a encontrar o que procura!
        </p>

        <!-- Breadcrumb Navigation -->
        <div class="breadcrumb-nav">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0 justify-content-center">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/" class="text-decoration-none hover-gold">
                            <i class="fas fa-home me-1"></i>Início
                        </a>
                    </li>
                    <li class="breadcrumb-item active">Página não encontrada</li>
                </ol>
            </nav>
            <small class="text-muted d-block mt-1">
                <i class="fas fa-link me-1"></i>
                URL solicitada: <code>${pageContext.request.requestURI}</code>
            </small>
        </div>

        <!-- Quick Search -->
        <div class="search-section">
            <h4 class="mb-3">
                <i class="fas fa-search me-2"></i>Que tal uma busca?
            </h4>
            <form action="${pageContext.request.contextPath}/search" method="GET">
                <div class="input-group input-group-lg">
                    <input type="text" name="q" class="form-control" 
                           placeholder="Buscar livros, autores, categorias..." 
                           value="${param.q}">
                    <button class="btn btn-primary" type="submit">
                        <i class="fas fa-search me-2"></i>Buscar
                    </button>
                </div>
            </form>
        </div>

        <!-- Navigation Suggestions -->
        <h3 class="mb-4">
            <i class="fas fa-compass me-2"></i>
            Explore nosso site:
        </h3>

        <div class="suggestions-grid">
            <a href="${pageContext.request.contextPath}/" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-home"></i>
                </div>
                <div class="suggestion-title">Página Inicial</div>
                <p class="suggestion-desc">Volte para nossa página principal</p>
            </a>

            <a href="${pageContext.request.contextPath}/loja/catalogo" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="suggestion-title">Catálogo</div>
                <p class="suggestion-desc">Explore nossa coleção completa</p>
            </a>

            <a href="${pageContext.request.contextPath}/search" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-search"></i>
                </div>
                <div class="suggestion-title">Buscar</div>
                <p class="suggestion-desc">Encontre livros específicos</p>
            </a>

            <c:choose>
                <c:when test="${sessionScope.user != null}">
                    <a href="${pageContext.request.contextPath}/perfil" class="suggestion-card hover-lift">
                        <div class="suggestion-icon">
                            <i class="fas fa-user"></i>
                        </div>
                        <div class="suggestion-title">Meu Perfil</div>
                        <p class="suggestion-desc">Gerencie sua conta</p>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="suggestion-card hover-lift">
                        <div class="suggestion-icon">
                            <i class="fas fa-sign-in-alt"></i>
                        </div>
                        <div class="suggestion-title">Login</div>
                        <p class="suggestion-desc">Acesse sua conta</p>
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/cart" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="suggestion-title">Carrinho</div>
                <p class="suggestion-desc">Seus itens salvos</p>
            </a>

            <a href="${pageContext.request.contextPath}/loja/favoritos" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-heart"></i>
                </div>
                <div class="suggestion-title">Favoritos</div>
                <p class="suggestion-desc">Seus livros favoritos</p>
            </a>

            <a href="${pageContext.request.contextPath}/contato" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-envelope"></i>
                </div>
                <div class="suggestion-title">Contato</div>
                <p class="suggestion-desc">Fale conosco</p>
            </a>

            <a href="${pageContext.request.contextPath}/ajuda" class="suggestion-card hover-lift">
                <div class="suggestion-icon">
                    <i class="fas fa-question-circle"></i>
                </div>
                <div class="suggestion-title">Ajuda</div>
                <p class="suggestion-desc">Central de ajuda</p>
            </a>
        </div>

        <!-- Action Buttons -->
        <div class="d-flex flex-column flex-md-row justify-content-center gap-3 mt-4">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-lg hover-lift">
                <i class="fas fa-home me-2"></i>Página Inicial
            </a>
            <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-gold btn-lg hover-lift">
                <i class="fas fa-book me-2"></i>Ver Catálogo
            </a>
            <button onclick="history.back()" class="btn btn-outline-elegant btn-lg hover-lift">
                <i class="fas fa-arrow-left me-2"></i>Voltar
            </button>
        </div>

        <!-- Help Section -->
        <div class="mt-5 p-4 bg-light rounded">
            <h5 class="mb-3">
                <i class="fas fa-lightbulb me-2"></i>
                Possíveis causas do erro:
            </h5>
            <ul class="text-start">
                <li>A URL foi digitada incorretamente</li>
                <li>A página foi movida ou renomeada</li>
                <li>O link que você clicou está desatualizado</li>
                <li>A página pode estar temporariamente indisponível</li>
            </ul>
            
            <div class="mt-3">
                <p class="mb-0">
                    <i class="fas fa-info-circle me-2"></i>
                    Se você continuar enfrentando problemas, 
                    <a href="${pageContext.request.contextPath}/contato" class="hover-gold">
                        entre em contato conosco
                    </a>.
                </p>
            </div>
        </div>

        <!-- Debug Information (only in development) -->
        <c:set var="showDebug" value="${param.debug eq 'true' or (not empty applicationScope.appEnvironment and applicationScope.appEnvironment eq 'development')}" />
        <c:if test="${showDebug}">
            <div class="debug-info">
                <h6><i class="fas fa-bug me-2"></i>Informações de Debug</h6>
                
                <div class="row g-3">
                    <div class="col-md-6">
                        <strong>Status HTTP:</strong> 404 - Not Found<br>
                        <strong>URL:</strong> ${pageContext.request.requestURL}<br>
                        <strong>URI:</strong> ${pageContext.request.requestURI}<br>
                        <strong>Context:</strong> ${pageContext.request.contextPath}<br>
                        <strong>Query:</strong> ${not empty pageContext.request.queryString ? pageContext.request.queryString : 'Nenhuma'}
                    </div>
                    <div class="col-md-6">
                        <strong>Method:</strong> ${pageContext.request.method}<br>
                        <strong>Referer:</strong> ${not empty pageContext.request.getHeader('Referer') ? pageContext.request.getHeader('Referer') : 'Nenhum