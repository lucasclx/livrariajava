<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <title>Página não encontrada - Livraria Mil Páginas</title>
    
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
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --success-color: #27ae60;
            --white: #ffffff;
            --light-bg: #f8f9fa;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 70%, var(--accent-color) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
        }

        .error-container {
            background: var(--white);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
            padding: 3rem 2rem;
            text-align: center;
            max-width: 800px;
            width: 90%;
            margin: 2rem;
            position: relative;
            overflow: hidden;
            animation: slideInUp 0.6s ease-out;
        }

        .error-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color), var(--accent-color));
        }

        .error-animation {
            margin-bottom: 2rem;
            position: relative;
        }

        .error-number {
            font-size: 8rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--danger-color), var(--warning-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
            line-height: 1;
        }

        .error-icon {
            font-size: 4rem;
            color: var(--warning-color);
            margin-bottom: 1.5rem;
            animation: wobble 3s infinite;
        }

        .error-title {
            font-size: 2.5rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .error-subtitle {
            font-size: 1.2rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .error-description {
            background: var(--light-bg);
            border-left: 4px solid var(--warning-color);
            padding: 1.5rem;
            margin: 2rem 0;
            border-radius: 0 10px 10px 0;
            text-align: left;
        }

        .error-description h5 {
            color: var(--text-dark);
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .error-description ul {
            margin-bottom: 0;
            padding-left: 1.5rem;
        }

        .error-description li {
            margin-bottom: 0.5rem;
            color: var(--text-light);
        }

        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            justify-content: center;
            margin: 2rem 0;
        }

        .btn-custom {
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 500;
            border-radius: 50px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            min-width: 180px;
            justify-content: center;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: var(--white);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            color: var(--white);
        }

        .btn-outline-custom {
            background: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline-custom:hover {
            background: var(--primary-color);
            color: var(--white);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-success-custom {
            background: linear-gradient(135deg, var(--success-color), #2ecc71);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(39, 174, 96, 0.4);
        }

        .btn-success-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(39, 174, 96, 0.6);
            color: var(--white);
        }

        .suggestions-section {
            margin-top: 3rem;
            padding-top: 2rem;
            border-top: 1px solid #e9ecef;
        }

        .suggestions-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
        }

        .suggestions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .suggestion-card {
            background: var(--light-bg);
            padding: 1.5rem 1rem;
            border-radius: 10px;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .suggestion-card:hover {
            background: var(--white);
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            color: inherit;
            text-decoration: none;
        }

        .suggestion-icon {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .suggestion-title {
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
            font-size: 1rem;
        }

        .suggestion-desc {
            font-size: 0.9rem;
            color: var(--text-light);
            margin: 0;
        }

        .debug-info {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
        }

        .debug-info h6 {
            color: var(--text-dark);
            margin-bottom: 1rem;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
        }

        .debug-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .debug-item:last-child {
            border-bottom: none;
        }

        .debug-label {
            font-weight: 600;
            color: var(--text-dark);
            min-width: 140px;
        }

        .debug-value {
            color: var(--text-light);
            word-break: break-all;
            text-align: right;
            max-width: 70%;
        }

        .footer-info {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .back-to-top {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 50px;
            height: 50px;
            background: var(--primary-color);
            color: var(--white);
            border: none;
            border-radius: 50%;
            font-size: 1.2rem;
            cursor: pointer;
            transition: all 0.3s ease;
            opacity: 0;
            visibility: hidden;
            z-index: 1000;
        }

        .back-to-top.visible {
            opacity: 1;
            visibility: visible;
        }

        .back-to-top:hover {
            background: var(--secondary-color);
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }

        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }

        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }

        .shape:nth-child(1) {
            width: 80px;
            height: 80px;
            top: 10%;
            left: 10%;
            animation-delay: 0s;
        }

        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 70%;
            right: 10%;
            animation-delay: 2s;
        }

        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 10%;
            left: 20%;
            animation-delay: 4s;
        }

        .shape:nth-child(4) {
            width: 100px;
            height: 100px;
            top: 30%;
            right: 30%;
            animation-delay: 1s;
        }

        .shape:nth-child(5) {
            width: 70px;
            height: 70px;
            bottom: 40%;
            right: 15%;
            animation-delay: 3s;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes bounce {
            0%, 20%, 53%, 80%, 100% {
                animation-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);
                transform: translate3d(0, 0, 0);
            }
            40%, 43% {
                animation-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);
                transform: translate3d(0, -10px, 0);
            }
            70% {
                animation-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);
                transform: translate3d(0, -5px, 0);
            }
            90% {
                transform: translate3d(0, -2px, 0);
            }
        }

        @keyframes wobble {
            0% { transform: translateX(0%); }
            15% { transform: translateX(-25px) rotate(-5deg); }
            30% { transform: translateX(20px) rotate(3deg); }
            45% { transform: translateX(-15px) rotate(-3deg); }
            60% { transform: translateX(10px) rotate(2deg); }
            75% { transform: translateX(-5px) rotate(-1deg); }
            100% { transform: translateX(0%); }
        }

        @keyframes float {
            0%, 100% {
                transform: translateY(0px) rotate(0deg);
            }
            50% {
                transform: translateY(-20px) rotate(180deg);
            }
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

            .action-buttons {
                flex-direction: column;
                align-items: center;
            }

            .btn-custom {
                min-width: 250px;
            }

            .suggestions-grid {
                grid-template-columns: 1fr;
            }

            .debug-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.25rem;
            }

            .debug-value {
                text-align: left;
                max-width: 100%;
            }
        }

        @media (max-width: 480px) {
            .error-number {
                font-size: 4rem;
            }

            .error-title {
                font-size: 1.5rem;
            }
        }

        /* Print styles */
        @media print {
            .floating-shapes,
            .back-to-top,
            .action-buttons {
                display: none;
            }

            .error-container {
                box-shadow: none;
                background: white;
            }

            body {
                background: white;
            }
        }
    </style>
</head>
<body>
    <!-- Floating Background Shapes -->
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>

    <!-- Main Error Container -->
    <div class="error-container">
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
            A página que você está procurando pode ter sido movida, renomeada ou não existe mais. 
            Mas não se preocupe, temos várias opções para ajudá-lo!
        </p>

        <!-- Detailed Error Information -->
        <div class="error-description">
            <h5><i class="fas fa-lightbulb"></i> Possíveis causas:</h5>
            <ul>
                <li>A URL foi digitada incorretamente</li>
                <li>A página foi movida ou renomeada</li>
                <li>O link que você clicou está desatualizado</li>
                <li>A página pode estar temporariamente indisponível</li>
            </ul>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/" class="btn-custom btn-primary-custom">
                <i class="fas fa-home"></i>
                Página Inicial
            </a>
            
            <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn-custom btn-success-custom">
                <i class="fas fa-book"></i>
                Ver Catálogo
            </a>
            
            <button onclick="history.back()" class="btn-custom btn-outline-custom">
                <i class="fas fa-arrow-left"></i>
                Voltar
            </button>
        </div>

        <!-- Suggestions Section -->
        <div class="suggestions-section">
            <h3 class="suggestions-title">
                <i class="fas fa-compass"></i>
                Explore nosso site:
            </h3>

            <div class="suggestions-grid">
                <a href="${pageContext.request.contextPath}/loja/" class="suggestion-card">
                    <div class="suggestion-icon">
                        <i class="fas fa-store"></i>
                    </div>
                    <div class="suggestion-title">Loja Principal</div>
                    <p class="suggestion-desc">Explore nossa coleção completa</p>
                </a>

                <a href="${pageContext.request.contextPath}/loja/favoritos" class="suggestion-card">
                    <div class="suggestion-icon">
                        <i class="fas fa-heart"></i>
                    </div>
                    <div class="suggestion-title">Favoritos</div>
                    <p class="suggestion-desc">Seus livros favoritos</p>
                </a>

                <a href="${pageContext.request.contextPath}/cart/" class="suggestion-card">
                    <div class="suggestion-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="suggestion-title">Carrinho</div>
                    <p class="suggestion-desc">Seus itens salvos</p>
                </a>

                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <a href="${pageContext.request.contextPath}/perfil/" class="suggestion-card">
                            <div class="suggestion-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="suggestion-title">Meu Perfil</div>
                            <p class="suggestion-desc">Gerenciar sua conta</p>
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="suggestion-card">
                            <div class="suggestion-icon">
                                <i class="fas fa-sign-in-alt"></i>
                            </div>
                            <div class="suggestion-title">Login</div>
                            <p class="suggestion-desc">Acesse sua conta</p>
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Search Form -->
            <div class="mt-4">
                <form action="${pageContext.request.contextPath}/loja/buscar" method="GET" class="d-flex justify-content-center">
                    <div class="input-group" style="max-width: 400px;">
                        <input type="text" class="form-control" name="q" 
                               placeholder="Buscar livros..." 
                               value="${param.q}"
                               style="border-radius: 25px 0 0 25px; border-right: none;">
                        <button class="btn btn-primary" type="submit" 
                                style="border-radius: 0 25px 25px 0; background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); border: none;">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Debug Information (only in development) -->
        <c:set var="showDebug" value="${param.debug eq 'true' or (not empty pageContext.request.getParameter('debug'))}" />
        <c:if test="${showDebug or (not empty applicationScope.appEnvironment and applicationScope.appEnvironment eq 'development')}">
            <div class="debug-info">
                <h6><i class="fas fa-bug"></i> Informações de Debug</h6>
                
                <div class="debug-item">
                    <span class="debug-label">Status HTTP:</span>
                    <span class="debug-value">404 - Not Found</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">URL Solicitada:</span>
                    <span class="debug-value">${pageContext.request.requestURL}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">URI:</span>
                    <span class="debug-value">${pageContext.request.requestURI}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Context Path:</span>
                    <span class="debug-value">${pageContext.request.contextPath}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Query String:</span>
                    <span class="debug-value">${not empty pageContext.request.queryString ? pageContext.request.queryString : 'Nenhuma'}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Method:</span>
                    <span class="debug-value">${pageContext.request.method}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">User Agent:</span>
                    <span class="debug-value">${pageContext.request.getHeader('User-Agent')}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Referer:</span>
                    <span class="debug-value">${not empty pageContext.request.getHeader('Referer') ? pageContext.request.getHeader('Referer') : 'Nenhum'}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">IP do Cliente:</span>
                    <span class="debug-value">${pageContext.request.remoteAddr}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Timestamp:</span>
                    <span class="debug-value">
                        <fmt:formatDate value="<%= new java.util.Date() %>" 
                                       pattern="dd/MM/yyyy HH:mm:ss" />
                    </span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Sessão ID:</span>
                    <span class="debug-value">${pageContext.session.id}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Usuário Logado:</span>
                    <span class="debug-value">${not empty sessionScope.user ? sessionScope.user.name : 'Não logado'}</span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Servidor:</span>
                    <span class="debug-value"><%= application.getServerInfo() %></span>
                </div>
                
                <div class="debug-item">
                    <span class="debug-label">Java Version:</span>
                    <span class="debug-value"><%= System.getProperty("java.version") %></span>
                </div>
            </div>
        </c:if>

        <!-- Footer Information -->
        <div class="footer-info">
            <p>
                <i class="fas fa-info-circle"></i>
                Se você continuar enfrentando problemas, entre em contato com nosso suporte.
            </p>
            <p class="mb-0">
                <strong>Livraria Mil Páginas</strong> - 
                &copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" />
                Todos os direitos reservados.
            </p>
        </div>
    </div>

    <!-- Back to Top Button -->
    <button class="back-to-top" onclick="scrollToTop()" title="Voltar ao topo">
        <i class="fas fa-chevron-up"></i>
    </button>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            initializeErrorPage();
            setupBackToTop();
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

        // Setup back to top functionality
        function setupBackToTop() {
            const backToTopButton = document.querySelector('.back-to-top');
            
            window.addEventListener('scroll', function() {
                if (window.pageYOffset > 300) {
                    backToTopButton.classList.add('visible');
                } else {
                    backToTopButton.classList.remove('visible');
                }
            });
        }

        // Scroll to top function
        function scrollToTop() {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
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
                e.preventDefault();
                history.back();
            }

            // Ctrl/Cmd + S = Search
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                const searchInput = document.querySelector('input[name="q"]');
                if (searchInput) {
                    searchInput.focus();
                }
            }

            // Escape = Focus search
            if (e.key === 'Escape') {
                const searchInput = document.querySelector('input[name="q"]');
                if (searchInput && document.activeElement !== searchInput) {
                    searchInput.focus();
                }
            }
        });

        // Add tooltip functionality
        function initializeTooltips() {
            const tooltipElements = document.querySelectorAll('[title]');
            tooltipElements.forEach(element => {
                element.addEventListener('mouseenter', function() {
                    const tooltip = document.createElement('div');
                    tooltip.className = 'custom-tooltip';
                    tooltip.textContent = this.getAttribute('title');
                    tooltip.style.cssText = `
                        position: absolute;
                        background: rgba(0, 0, 0, 0.8);
                        color: white;
                        padding: 0.5rem;
                        border-radius: 4px;
                        font-size: 0.8rem;
                        z-index: 1000;
                        pointer-events: none;
                        opacity: 0;
                        transition: opacity 0.3s;
                    `;
                    
                    document.body.appendChild(tooltip);
                    
                    const rect = this.getBoundingClientRect();
                    tooltip.style.left = rect.left + (rect.width / 2) - (tooltip.offsetWidth / 2) + 'px';
                    tooltip.style.top = rect.top - tooltip.offsetHeight - 10 + 'px';
                    
                    setTimeout(() => tooltip.style.opacity = '1', 10);
                    
                    this.tooltipElement = tooltip;
                });

                element.addEventListener('mouseleave', function() {
                    if (this.tooltipElement) {
                        this.tooltipElement.remove();
                        this.tooltipElement = null;
                    }
                });
            });
        }

        // Initialize tooltips
        setTimeout(initializeTooltips, 1000);

        // Update page title with error info
        document.title = '404 - Página não encontrada | Livraria Mil Páginas';

        // Add custom console message
        console.log('%c🔍 Página não encontrada!', 'font-size: 20px; color: #e74c3c; font-weight: bold;');
        console.log('%cMas não se preocupe, nossa equipe já foi notificada.', 'font-size: 14px; color: #7f8c8d;');
        console.log('%cVisite nossa página inicial: ${pageContext.request.contextPath}/', 'font-size: 12px; color: #3498db;');

        // Easter egg - konami code
        let konamiCode = [];
        const konamiSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];

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
            const container = document.querySelector('.error-container');
            container.style.animation = 'rainbow 2s infinite';
            
            // Show special message
            const message = document.createElement('div');
            message.innerHTML = `
                <div style="
                    position: fixed;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    background: white;
                    padding: 2rem;
                    border-radius: 10px;
                    box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                    z-index: 10000;
                    text-align: center;
                    animation: slideInUp 0.5s ease;
                ">
                    <h3>🎉 Easter Egg Descoberto!</h3>
                    <p>Você encontrou nosso segredo! 🕵️‍♂️</p>
                    <button onclick="this.parentElement.parentElement.remove()" 
                            style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); 
                                   color: white; border: none; padding: 0.5rem 1rem; border-radius: 25px; cursor: pointer;">
                        Fechar
                    </button>
                </div>
            `;
            
            document.body.appendChild(message);
            
            setTimeout(() => {
                container.style.animation = '';
                if (message.parentNode) {
                    message.remove();
                }
            }, 5000);
        }

        // Add rainbow animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes rainbow {
                0% { filter: hue-rotate(0deg); }
                25% { filter: hue-rotate(90deg); }
                50% { filter: hue-rotate(180deg); }
                75% { filter: hue-rotate(270deg); }
                100% { filter: hue-rotate(360deg); }
            }
        `;
        document.head.appendChild(style);
    </script>

    <!-- Schema.org structured data for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebPage",
        "name": "Página não encontrada - 404",
        "description": "A página solicitada não foi encontrada no site da Livraria Mil Páginas",
        "url": "${pageContext.request.requestURL}",
        "mainEntity": {
            "@type": "ErrorPage",
            "name": "404 Error",
            "description": "Página não encontrada"
        },
        "breadcrumb": {
            "@type": "BreadcrumbList",
            "itemListElement": [{
                "@type": "ListItem",
                "position": 1,
                "name": "Home",
                "item": "${pageContext.request.contextPath}/"
            }, {
                "@type": "ListItem",
                "position": 2,
                "name": "404 - Página não encontrada"
            }]
        }
    }
    </script>
</body>
</html>