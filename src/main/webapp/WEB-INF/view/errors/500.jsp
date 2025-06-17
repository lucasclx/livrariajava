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
    <title>Erro Interno - Livraria Mil Páginas</title>
    
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
            --danger-color: #e74c3c;
            --warning-color: #f39c12;
            --success-color: #27ae60;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
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
            background: linear-gradient(135deg, var(--danger-color) 0%, #c0392b 70%, var(--warning-color) 100%);
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
            background: linear-gradient(90deg, var(--danger-color), var(--warning-color));
        }

        .error-animation {
            margin-bottom: 2rem;
            position: relative;
        }

        .error-number {
            font-size: 6rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--danger-color), var(--warning-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
            line-height: 1;
        }

        .error-icon {
            font-size: 3rem;
            color: var(--danger-color);
            margin-bottom: 1.5rem;
            animation: shake 3s infinite;
        }

        .error-title {
            font-size: 2rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .error-subtitle {
            font-size: 1.1rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .error-description {
            background: var(--light-bg);
            border-left: 4px solid var(--danger-color);
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

        .btn-danger-custom {
            background: linear-gradient(135deg, var(--danger-color), #c0392b);
            color: var(--white);
            box-shadow: 0 4px 15px rgba(231, 76, 60, 0.4);
        }

        .btn-danger-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(231, 76, 60, 0.6);
            color: var(--white);
        }

        .technical-details {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
            text-align: left;
            font-family: 'Courier New', monospace;
            font-size: 0.9rem;
        }

        .technical-details h6 {
            color: var(--text-dark);
            margin-bottom: 1rem;
            font-family: 'Poppins', sans-serif;
            font-weight: 600;
        }

        .tech-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }

        .tech-item:last-child {
            border-bottom: none;
        }

        .tech-label {
            font-weight: 600;
            color: var(--text-dark);
            min-width: 140px;
        }

        .tech-value {
            color: var(--text-light);
            word-break: break-all;
            text-align: right;
            max-width: 70%;
        }

        .error-id {
            background: linear-gradient(135deg, var(--danger-color), var(--warning-color));
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 500;
            display: inline-block;
            margin-bottom: 1rem;
        }

        .support-section {
            background: var(--light-bg);
            border-radius: 15px;
            padding: 2rem;
            margin: 2rem 0;
            border: 1px solid #dee2e6;
        }

        .support-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }

        .support-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .support-item {
            background: white;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }

        .support-item:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
        }

        .support-icon {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .footer-info {
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e9ecef;
            font-size: 0.9rem;
            color: var(--text-light);
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

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
            20%, 40%, 60%, 80% { transform: translateX(5px); }
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
                font-size: 4rem;
            }

            .error-title {
                font-size: 1.5rem;
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

            .support-grid {
                grid-template-columns: 1fr;
            }

            .tech-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.25rem;
            }

            .tech-value {
                text-align: left;
                max-width: 100%;
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
    </div>

    <!-- Main Error Container -->
    <div class="error-container">
        <!-- Error Animation Section -->
        <div class="error-animation">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="error-number">500</div>
        </div>

        <!-- Error ID -->
        <c:set var="errorId" value="ERR-${System.currentTimeMillis()}" />
        <div class="error-id">
            <i class="fas fa-hashtag"></i> ID do Erro: ${errorId}
        </div>

        <!-- Error Content -->
        <h1 class="error-title">Ops! Algo deu errado</h1>
        <p class="error-subtitle">
            Encontramos um problema interno em nossos servidores. 
            Nossa equipe técnica foi automaticamente notificada e está trabalhando para resolver.
        </p>

        <!-- Detailed Error Information -->
        <div class="error-description">
            <h5><i class="fas fa-info-circle"></i> O que aconteceu:</h5>
            <ul>
                <li>Erro interno do servidor (HTTP 500)</li>
                <li>O problema não está relacionado à sua conexão</li>
                <li>Nossos engenheiros foram notificados automaticamente</li>
                <li>Geralmente resolvemos estes problemas rapidamente</li>
            </ul>
        </div>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/" class="btn-custom btn-primary-custom">
                <i class="fas fa-home"></i>
                Página Inicial
            </a>
            
            <button onclick="history.back()" class="btn-custom btn-outline-custom">
                <i class="fas fa-arrow-left"></i>
                Voltar
            </button>
            
            <button onclick="location.reload()" class="btn-custom btn-outline-custom">
                <i class="fas fa-redo"></i>
                Tentar Novamente
            </button>
            
            <a href="#support" class="btn-custom btn-danger-custom" onclick="toggleSupport()">
                <i class="fas fa-life-ring"></i>
                Preciso de Ajuda
            </a>
        </div>

        <!-- Support Section -->
        <div class="support-section" id="support-section" style="display: none;">
            <h3 class="support-title">
                <i class="fas fa-headset"></i>
                Central de Suporte
            </h3>

            <div class="support-grid">
                <div class="support-item">
                    <div class="support-icon">
                        <i class="fas fa-envelope"></i>
                    </div>
                    <h6>Email</h6>
                    <p class="mb-2 small">suporte@livrariamilpaginas.com</p>
                    <small class="text-muted">Resposta em até 2 horas</small>
                </div>

                <div class="support-item">
                    <div class="support-icon">
                        <i class="fas fa-phone"></i>
                    </div>
                    <h6>Telefone</h6>
                    <p class="mb-2 small">(11) 0000-0000</p>
                    <small class="text-muted">Seg-Sex: 8h às 18h</small>
                </div>

                <div class="support-item">
                    <div class="support-icon">
                        <i class="fab fa-whatsapp"></i>
                    </div>
                    <h6>WhatsApp</h6>
                    <p class="mb-2 small">(11) 99999-9999</p>
                    <small class="text-muted">Seg-Dom: 8h às 22h</small>
                </div>

                <div class="support-item">
                    <div class="support-icon">
                        <i class="fas fa-comments"></i>
                    </div>
                    <h6>Chat Online</h6>
                    <p class="mb-2 small">Suporte instantâneo</p>
                    <small class="text-muted">Disponível agora</small>
                </div>
            </div>

            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                <strong>Dica:</strong> Ao entrar em contato, mencione o ID do erro (${errorId}) 
                para um atendimento mais rápido.
            </div>
        </div>

        <!-- Technical Details (only in development) -->
        <c:set var="showDebug" value="${param.debug eq 'true' or (not empty applicationScope.appEnvironment and applicationScope.appEnvironment eq 'development')}" />
        <c:if test="${showDebug}">
            <div class="technical-details">
                <h6><i class="fas fa-code"></i> Detalhes Técnicos (Desenvolvimento)</h6>
                
                <div class="tech-item">
                    <span class="tech-label">Status HTTP:</span>
                    <span class="tech-value">500 - Internal Server Error</span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">URL Solicitada:</span>
                    <span class="tech-value">${pageContext.request.requestURL}</span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">Método:</span>
                    <span class="tech-value">${pageContext.request.method}</span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">User Agent:</span>
                    <span class="tech-value">${pageContext.request.getHeader('User-Agent')}</span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">IP do Cliente:</span>
                    <span class="tech-value">${pageContext.request.remoteAddr}</span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">Timestamp:</span>
                    <span class="tech-value">
                        <fmt:formatDate value="<%= new java.util.Date() %>" 
                                       pattern="dd/MM/yyyy HH:mm:ss" />
                    </span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">ID da Sessão:</span>
                    <span class="tech-value">${pageContext.session.id}</span>
                </div>
                
                <div class="tech-item">
                    <span class="tech-label">Servidor:</span>
                    <span class="tech-value"><%= application.getServerInfo() %></span>
                </div>
                
                <c:if test="${not empty exception}">
                    <div class="tech-item">
                        <span class="tech-label">Exceção:</span>
                        <span class="tech-value">${exception.class.simpleName}</span>
                    </div>
                    
                    <c:if test="${not empty exception.message}">
                        <div class="tech-item">
                            <span class="tech-label">Mensagem:</span>
                            <span class="tech-value">${exception.message}</span>
                        </div>
                    </c:if>
                </c:if>
            </div>
        </c:if>

        <!-- Footer Information -->
        <div class="footer-info">
            <p>
                <i class="fas fa-shield-alt"></i>
                Seus dados estão seguros. Este erro não afeta a segurança da sua conta.
            </p>
            <p class="mb-0">
                <strong>Livraria Mil Páginas</strong> - 
                &copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" />
                Todos os direitos reservados.
            </p>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Custom JavaScript -->
    <script>
        // Função para mostrar/ocultar seção de suporte
        function toggleSupport() {
            const supportSection = document.getElementById('support-section');
            if (supportSection.style.display === 'none') {
                supportSection.style.display = 'block';
                supportSection.scrollIntoView({ behavior: 'smooth' });
            } else {
                supportSection.style.display = 'none';
            }
        }

        // Log error for analytics/debugging
        function logError() {
            const errorData = {
                errorId: '${errorId}',
                url: window.location.href,
                userAgent: navigator.userAgent,
                timestamp: new Date().toISOString(),
                error: '500 - Internal Server Error'
            };

            console.error('500 Error logged:', errorData);

            // Send to analytics if available
            if (typeof gtag !== 'undefined') {
                gtag('event', '500_error', {
                    'page_location': errorData.url,
                    'error_id': errorData.errorId
                });
            }

            // Send to error tracking service if available
            if (typeof Sentry !== 'undefined') {
                Sentry.captureMessage('500 Internal Server Error', {
                    extra: errorData,
                    level: 'error'
                });
            }
        }

        // Auto-refresh suggestion
        let refreshCount = 0;
        function suggestRefresh() {
            refreshCount++;
            if (refreshCount >= 3) {
                const refreshBtn = document.querySelector('button[onclick="location.reload()"]');
                if (refreshBtn) {
                    refreshBtn.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>Problema Persistente?';
                    refreshBtn.onclick = () => toggleSupport();
                    refreshBtn.classList.remove('btn-outline-custom');
                    refreshBtn.classList.add('btn-danger-custom');
                }
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function() {
            logError();
            
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

            // Setup retry button enhancement
            const retryBtn = document.querySelector('button[onclick="location.reload()"]');
            if (retryBtn) {
                retryBtn.addEventListener('click', suggestRefresh);
            }
        });

        // Keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + H = Home
            if ((e.ctrlKey || e.metaKey) && e.key === 'h') {
                e.preventDefault();
                window.location.href = '${pageContext.request.contextPath}/';
            }

            // Ctrl/Cmd + R = Reload (with counter)
            if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
                suggestRefresh();
            }

            // Ctrl/Cmd + S = Support
            if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                e.preventDefault();
                toggleSupport();
            }
        });

        // Service worker check (if available)
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.getRegistrations().then(registrations => {
                if (registrations.length > 0) {
                    console.log('Service Worker detectado - modo offline pode estar disponível');
                    // Could show offline message or cached page option
                }
            });
        }

        // Update page title with error info
        document.title = 'Erro 500 - Livraria Mil Páginas';

        // Console styling
        console.log('%c🚨 Erro 500 - Internal Server Error', 'font-size: 20px; color: #e74c3c; font-weight: bold;');
        console.log('%cID do Erro: ${errorId}', 'font-size: 14px; color: #7f8c8d;');
        console.log('%cNossa equipe foi notificada automaticamente.', 'font-size: 12px; color: #3498db;');
    </script>

    <!-- Schema.org structured data for SEO -->
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebPage",
        "name": "Erro interno do servidor - 500",
        "description": "Página de erro interno do servidor da Livraria Mil Páginas",
        "url": "${pageContext.request.requestURL}",
        "mainEntity": {
            "@type": "ErrorPage",
            "name": "500 Error",
            "description": "Erro interno do servidor"
        }
    }
    </script>
</body>
</html>