<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Livraria Mil Páginas - Sua livraria online de confiança">
    <meta name="keywords" content="livros, livraria, leitura, literatura, educação">
    <meta name="author" content="Livraria Mil Páginas">
    <title>Livraria Mil Páginas - Sua Livraria Online de Confiança</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body { 
            font-family: 'Poppins', sans-serif;
            margin: 0; 
            padding: 0; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        .hero-container { 
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(102, 126, 234, 0.9) 0%, rgba(118, 75, 162, 0.9) 100%);
            z-index: 1;
        }
        
        .content-wrapper {
            position: relative;
            z-index: 2;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            padding: 60px 40px;
            text-align: center;
            max-width: 900px;
            margin: 20px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .logo-section {
            margin-bottom: 40px;
        }
        
        .logo-icon {
            font-size: 4rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 20px;
            display: block;
        }
        
        .main-title {
            font-size: 3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .subtitle {
            font-size: 1.3rem;
            color: #7f8c8d;
            margin-bottom: 40px;
            font-weight: 300;
        }
        
        .status-card {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            border: 1px solid #a3d9a4;
            color: #155724;
            padding: 25px;
            border-radius: 15px;
            margin: 30px 0;
            box-shadow: 0 4px 15px rgba(21, 87, 36, 0.1);
        }
        
        .status-icon {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #28a745;
        }
        
        .action-buttons {
            margin: 40px 0;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }
        
        .btn-custom {
            padding: 15px 30px;
            font-size: 1.1rem;
            font-weight: 600;
            border-radius: 50px;
            text-decoration: none;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            min-width: 200px;
            justify-content: center;
        }
        
        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.6);
            color: white;
        }
        
        .btn-outline-custom {
            background: transparent;
            border: 2px solid #667eea;
            color: #667eea;
        }
        
        .btn-outline-custom:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .info-section {
            margin-top: 50px;
            padding-top: 30px;
            border-top: 1px solid #e9ecef;
        }
        
        .info-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 25px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        
        .info-item strong {
            color: #2c3e50;
            display: block;
            margin-bottom: 5px;
        }
        
        .links-section {
            margin-top: 30px;
        }
        
        .link-item {
            display: inline-block;
            margin: 5px 10px;
            padding: 8px 16px;
            background: #e9ecef;
            color: #495057;
            text-decoration: none;
            border-radius: 20px;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        
        .link-item:hover {
            background: #667eea;
            color: white;
            text-decoration: none;
            transform: translateY(-1px);
        }
        
        .footer-info {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .floating-shapes {
            position: absolute;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 0;
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
            top: 20%;
            left: 10%;
            animation-delay: 0s;
        }
        
        .shape:nth-child(2) {
            width: 120px;
            height: 120px;
            top: 60%;
            right: 15%;
            animation-delay: 2s;
        }
        
        .shape:nth-child(3) {
            width: 60px;
            height: 60px;
            bottom: 20%;
            left: 20%;
            animation-delay: 4s;
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        
        @media (max-width: 768px) {
            .content-wrapper {
                padding: 40px 20px;
                margin: 10px;
            }
            
            .main-title {
                font-size: 2rem;
            }
            
            .subtitle {
                font-size: 1.1rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn-custom {
                min-width: 250px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
        }
        
        .pulse {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="hero-container">
        <div class="floating-shapes">
            <div class="shape"></div>
            <div class="shape"></div>
            <div class="shape"></div>
        </div>
        
        <div class="content-wrapper">
            <div class="logo-section">
                <i class="fas fa-book-open logo-icon pulse"></i>
                <h1 class="main-title">Livraria Mil Páginas</h1>
                <p class="subtitle">Sua jornada literária começa aqui</p>
            </div>
            
            <div class="status-card">
                <div class="status-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h3><strong>Sistema Online e Operacional!</strong></h3>
                <p class="mb-0">
                    Bem-vindo ao nosso sistema de livraria online. 
                    Explore milhares de títulos e descubra seu próximo livro favorito.
                </p>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/loja/" class="btn-custom btn-primary-custom">
                    <i class="fas fa-store"></i>
                    Explorar Loja
                </a>
                
                <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn-custom btn-outline-custom">
                    <i class="fas fa-book"></i>
                    Ver Catálogo
                </a>
                
                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <a href="${pageContext.request.contextPath}/perfil/" class="btn-custom btn-outline-custom">
                            <i class="fas fa-user"></i>
                            Meu Perfil
                        </a>
                        
                        <c:if test="${sessionScope.user.admin}">
                            <a href="${pageContext.request.contextPath}/admin/" class="btn-custom btn-outline-custom">
                                <i class="fas fa-cog"></i>
                                Administração
                            </a>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn-custom btn-outline-custom">
                            <i class="fas fa-sign-in-alt"></i>
                            Fazer Login
                        </a>
                        
                        <a href="${pageContext.request.contextPath}/register" class="btn-custom btn-outline-custom">
                            <i class="fas fa-user-plus"></i>
                            Cadastrar-se
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="info-section">
                <h3 class="info-title">
                    <i class="fas fa-info-circle"></i>
                    Informações do Sistema
                </h3>
                
                <div class="info-grid">
                    <div class="info-item">
                        <strong><i class="fas fa-globe"></i> Context Path:</strong>
                        <code>${pageContext.request.contextPath}</code>
                    </div>
                    
                    <div class="info-item">
                        <strong><i class="fas fa-server"></i> Servidor:</strong>
                        <%= application.getServerInfo() %>
                    </div>
                    
                    <div class="info-item">
                        <strong><i class="fab fa-java"></i> Versão Java:</strong>
                        <%= System.getProperty("java.version") %>
                    </div>
                    
                    <div class="info-item">
                        <strong><i class="fas fa-clock"></i> Data/Hora:</strong>
                        <fmt:formatDate value="<%= new java.util.Date() %>" 
                                       pattern="dd/MM/yyyy HH:mm:ss" />
                    </div>
                    
                    <div class="info-item">
                        <strong><i class="fas fa-code"></i> Versão App:</strong>
                        <%= application.getInitParameter("app.version") != null ? 
                            application.getInitParameter("app.version") : "1.0.0" %>
                    </div>
                    
                    <div class="info-item">
                        <strong><i class="fas fa-cogs"></i> Ambiente:</strong>
                        <%= application.getInitParameter("app.environment") != null ? 
                            application.getInitParameter("app.environment") : "development" %>
                    </div>
                </div>
                
                <div class="links-section">
                    <h4><i class="fas fa-link"></i> Links da API:</h4>
                    <a href="${pageContext.request.contextPath}/api/health" class="link-item">
                        <i class="fas fa-heartbeat"></i> Health Check
                    </a>
                    <a href="${pageContext.request.contextPath}/api/livros" class="link-item">
                        <i class="fas fa-book"></i> API Livros
                    </a>
                    <a href="${pageContext.request.contextPath}/api/categorias" class="link-item">
                        <i class="fas fa-tags"></i> API Categorias
                    </a>
                </div>
                
                <div class="links-section">
                    <h4><i class="fas fa-sitemap"></i> Navegação:</h4>
                    <a href="${pageContext.request.contextPath}/loja/favoritos" class="link-item">
                        <i class="fas fa-heart"></i> Favoritos
                    </a>
                    <a href="${pageContext.request.contextPath}/cart/" class="link-item">
                        <i class="fas fa-shopping-cart"></i> Carrinho
                    </a>
                    <a href="${pageContext.request.contextPath}/loja/buscar" class="link-item">
                        <i class="fas fa-search"></i> Buscar
                    </a>
                </div>
            </div>
            
            <div class="footer-info">
                <p>
                    <i class="fas fa-copyright"></i> 
                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" /> 
                    Livraria Mil Páginas. Desenvolvido com Java Servlets e JSP.
                </p>
                <p class="mb-0">
                    <small>
                        Sistema de gerenciamento de livraria online com funcionalidades completas
                        para administração, vendas e controle de estoque.
                    </small>
                </p>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript customizado -->
    <script>
        // Animação suave para os links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
        
        // Efeito de hover nos cards
        document.querySelectorAll('.info-item').forEach(item => {
            item.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 4px 15px rgba(0,0,0,0.1)';
            });
            
            item.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0)';
                this.style.boxShadow = 'none';
            });
        });
        
        // Verificação de saúde da aplicação
        function checkApplicationHealth() {
            fetch('${pageContext.request.contextPath}/api/health')
                .then(response => response.json())
                .then(data => {
                    console.log('Application Status:', data);
                })
                .catch(error => {
                    console.warn('Health check failed:', error);
                });
        }
        
        // Executar verificação após carregamento
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(checkApplicationHealth, 1000);
        });
        
        // Easter egg - Konami Code
        let konamiCode = [];
        const konamiSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
        
        document.addEventListener('keydown', function(e) {
            konamiCode.push(e.keyCode);
            if (konamiCode.length > konamiSequence.length) {
                konamiCode.shift();
            }
            
            if (JSON.stringify(konamiCode) === JSON.stringify(konamiSequence)) {
                document.body.style.animation = 'rainbow 2s infinite';
                setTimeout(() => {
                    document.body.style.animation = '';
                }, 5000);
            }
        });
    </script>
    
    <style>
        @keyframes rainbow {
            0% { filter: hue-rotate(0deg); }
            100% { filter: hue-rotate(360deg); }
        }
    </style>
</body>
</html>