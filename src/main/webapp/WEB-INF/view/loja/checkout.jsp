<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Pedido Confirmado" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .success-hero {
            background: linear-gradient(135deg, var(--forest-green) 0%, #1a6e1a 100%);
            color: white;
            padding: 4rem 0;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        
        .success-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: rotate 30s linear infinite;
        }
        
        @keyframes rotate {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .success-icon {
            width: 120px;
            height: 120px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            animation: pulse 2s infinite;
            position: relative;
            z-index: 1;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.7); }
            70% { transform: scale(1.05); box-shadow: 0 0 0 10px rgba(255, 255, 255, 0); }
            100% { transform: scale(1); box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
        }
        
        .order-card {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(139, 69, 19, 0.1);
            margin-bottom: 2rem;
            overflow: hidden;
        }
        
        .order-header {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.1) 0%, rgba(139, 69, 19, 0.1) 100%);
            padding: 2rem;
            text-align: center;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .order-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--forest-green);
            margin-bottom: 0.5rem;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }
        
        .info-item {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            border-left: 4px solid var(--gold);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .info-item h6 {
            color: var(--dark-brown);
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .timeline {
            position: relative;
            padding-left: 2rem;
            margin: 2rem 0;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 1rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--light-brown);
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
            padding-left: 2rem;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -1.5rem;
            top: 0.5rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--forest-green);
            border: 2px solid white;
            box-shadow: 0 0 0 4px rgba(34, 139, 34, 0.2);
        }
        
        .timeline-item.pending::before {
            background: var(--light-brown);
            box-shadow: 0 0 0 4px rgba(210, 180, 140, 0.2);
        }
        
        .payment-info {
            background: linear-gradient(135deg, rgba(34, 139, 34, 0.05) 0%, rgba(34, 139, 34, 0.02) 100%);
            border: 1px solid rgba(34, 139, 34, 0.2);
            border-radius: 15px;
            padding: 2rem;
            margin: 2rem 0;
        }
        
        .qr-code {
            width: 200px;
            height: 200px;
            background: white;
            border: 2px solid var(--light-brown);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            font-size: 3rem;
            color: var(--dark-brown);
        }
        
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            justify-content: center;
            margin: 2rem 0;
        }
        
        .products-summary {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        
        .product-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .product-item:last-child {
            border-bottom: none;
        }
        
        .product-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
            background: var(--aged-paper);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1rem;
        }
        
        .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
        }
        
        .breadcrumb-item.active {
            color: white;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <!-- Hero Success -->
    <section class="success-hero text-center">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb justify-content-center">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Início</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/cart">Carrinho</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/checkout">Checkout</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Confirmação</li>
                </ol>
            </nav>
            
            <div class="success-icon">
                <i class="fas fa-check fa-4x"></i>
            </div>
            
            <h1 class="display-4 mb-3">Pedido Confirmado!</h1>
            <p class="lead mb-0">Obrigado por escolher a Livraria Mil Páginas</p>
        </div>
    </section>

    <main class="container my-4 flex-grow-1">
        <!-- Informações do Pedido -->
        <div class="order-card">
            <div class="order-header">
                <div class="order-number">Pedido #${pedido.orderNumber}</div>
                <p class="mb-0 text-muted">
                    Realizado em <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy 'às' HH:mm" />
                </p>
            </div>
            
            <div class="card-body p-4">
                <!-- Informações Gerais -->
                <div class="info-grid">
                    <div class="info-item">
                        <h6>
                            <i class="fas fa-credit-card text-primary"></i>
                            Pagamento
                        </h6>
                        <c:choose>
                            <c:when test="${pedido.paymentMethod == 'credit_card'}">
                                <p class="mb-1"><strong>Cartão de Crédito</strong></p>
                                <p class="mb-0 text-muted small">Será processado em até 2 dias úteis</p>
                            </c:when>
                            <c:when test="${pedido.paymentMethod == 'pix'}">
                                <p class="mb-1"><strong>PIX</strong></p>
                                <p class="mb-0 text-success small">
                                    <i class="fas fa-check-circle me-1"></i>Pagamento instantâneo
                                </p>
                            </c:when>
                            <c:when test="${pedido.paymentMethod == 'boleto'}">
                                <p class="mb-1"><strong>Boleto Bancário</strong></p>
                                <p class="mb-0 text-warning small">
                                    <i class="fas fa-clock me-1"></i>Vencimento em 3 dias úteis
                                </p>
                            </c:when>
                        </c:choose>
                    </div>
                    
                    <div class="info-item">
                        <h6>
                            <i class="fas fa-truck text-info"></i>
                            Entrega
                        </h6>
                        <p class="mb-1"><strong>Entrega Padrão</strong></p>
                        <p class="mb-0 text-muted small">
                            Previsão: <fmt:formatDate value="${pedido.estimatedDelivery}" pattern="dd/MM/yyyy" />
                        </p>
                    </div>
                    
                    <div class="info-item">
                        <h6>
                            <i class="fas fa-calculator text-success"></i>
                            Total Pago
                        </h6>
                        <p class="mb-1 h4 text-success">
                            <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                        </p>
                        <c:if test="${pedido.desconto > 0}">
                            <p class="mb-0 text-muted small">
                                Economia de <fmt:formatNumber value="${pedido.desconto}" type="currency" currencySymbol="R$ " />
                            </p>
                        </c:if>
                    </div>
                    
                    <div class="info-item">
                        <h6>
                            <i class="fas fa-map-marker-alt text-warning"></i>
                            Endereço
                        </h6>
                        <p class="mb-1">${pedido.shippingStreet}, ${pedido.shippingNumber}</p>
                        <p class="mb-0 text-muted small">
                            ${pedido.shippingNeighborhood}, ${pedido.shippingCity}/${pedido.shippingState}
                        </p>
                    </div>
                </div>

                <!-- Timeline de Entrega -->
                <div class="mt-4">
                    <h5 class="mb-3">
                        <i class="fas fa-route me-2"></i>Acompanhe seu Pedido
                    </h5>
                    <div class="timeline">
                        <div class="timeline-item">
                            <h6>Pedido Confirmado</h6>
                            <p class="text-muted mb-0">
                                <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                            </p>
                        </div>
                        <div class="timeline-item pending">
                            <h6>Preparando para Envio</h6>
                            <p class="text-muted mb-0">Aguardando processamento</p>
                        </div>
                        <div class="timeline-item pending">
                            <h6>Produto Enviado</h6>
                            <p class="text-muted mb-0">Você receberá o código de rastreamento</p>
                        </div>
                        <div class="timeline-item pending">
                            <h6>Produto Entregue</h6>
                            <p class="text-muted mb-0">
                                Previsão: <fmt:formatDate value="${pedido.estimatedDelivery}" pattern="dd/MM/yyyy" />
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Informações de Pagamento Específicas -->
                <c:if test="${pedido.paymentMethod == 'pix' && pedido.status == 'pending_payment'}">
                    <div class="payment-info text-center">
                        <h5 class="mb-3">
                            <i class="fas fa-qrcode me-2"></i>Pagamento via PIX
                        </h5>
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <div class="qr-code">
                                    <i class="fas fa-qrcode"></i>
                                </div>
                                <p class="mt-2 small text-muted">Escaneie o QR Code com seu banco</p>
                            </div>
                            <div class="col-md-6">
                                <h6>Chave PIX (Copia e Cola):</h6>
                                <div class="input-group mb-3">
                                    <input type="text" class="form-control" value="${pedido.pixKey}" readonly id="pixKey">
                                    <button class="btn btn-outline-secondary" onclick="copyPix()">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <strong>Importante:</strong> O pagamento deve ser feito em até 30 minutos.
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <c:if test="${pedido.paymentMethod == 'boleto' && pedido.status == 'pending_payment'}">
                    <div class="payment-info text-center">
                        <h5 class="mb-3">
                            <i class="fas fa-barcode me-2"></i>Boleto Bancário
                        </h5>
                        <p class="mb-3">Seu boleto foi gerado e enviado por email.</p>
                        <div class="action-buttons">
                            <a href="${pageContext.request.contextPath}/pedidos/${pedido.id}/boleto" 
                               class="btn btn-warning" target="_blank">
                                <i class="fas fa-download me-2"></i>Baixar Boleto
                            </a>
                            <button type="button" class="btn btn-outline-warning" onclick="sendBoletoEmail()">
                                <i class="fas fa-envelope me-2"></i>Reenviar por Email
                            </button>
                        </div>
                        <div class="alert alert-warning mt-3">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Atenção:</strong> Vencimento em 3 dias úteis.
                        </div>
                    </div>
                </c:if>

                <!-- Produtos do Pedido -->
                <div class="mt-4">
                    <h5 class="mb-3">
                        <i class="fas fa-book me-2"></i>Produtos do Pedido
                    </h5>
                    <div class="products-summary">
                        <c:forEach var="item" items="${pedido.items}">
                            <div class="product-item">
                                <c:choose>
                                    <c:when test="${not empty item.livro.imagem}">
                                        <img src="${pageContext.request.contextPath}/uploads/livros/${item.livro.imagem}" 
                                             alt="${item.livro.titulo}" class="product-image">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-image">
                                            <i class="fas fa-book text-muted"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                                
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${item.livro.titulo}</h6>
                                    <p class="text-muted mb-0 small">
                                        ${item.livro.autor} • Qtd: ${item.quantity}
                                    </p>
                                </div>
                                
                                <div class="text-end">
                                    <div class="fw-bold">${item.subtotalFormatado}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
        </div>

        <!-- Ações -->
        <div class="action-buttons">
            <a href="${pageContext.request.contextPath}/perfil/pedidos" class="btn btn-primary btn-lg">
                <i class="fas fa-list me-2"></i>Ver Meus Pedidos
            </a>
            
            <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-outline-elegant btn-lg">
                <i class="fas fa-shopping-bag me-2"></i>Continuar Comprando
            </a>
            
            <button type="button" class="btn btn-outline-info btn-lg" onclick="shareOrder()">
                <i class="fas fa-share me-2"></i>Compartilhar
            </button>
            
            <a href="${pageContext.request.contextPath}/pedidos/${pedido.id}/print" 
               class="btn btn-outline-secondary btn-lg" target="_blank">
                <i class="fas fa-print me-2"></i>Imprimir
            </a>
        </div>

        <!-- Próximos Passos -->
        <div class="order-card">
            <div class="card-body p-4">
                <h5 class="mb-3">
                    <i class="fas fa-lightbulb me-2"></i>Próximos Passos
                </h5>
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="info-item">
                            <h6>
                                <i class="fas fa-envelope text-info"></i>
                                Confirmação por Email
                            </h6>
                            <p class="mb-0">
                                Enviamos um email com todos os detalhes do seu pedido para 
                                <strong>${sessionScope.user.email}</strong>
                            </p>
                        </div>
                    </div>
                    
                    <div class="col-md-6">
                        <div class="info-item">
                            <h6>
                                <i class="fas fa-bell text-warning"></i>
                                Acompanhamento
                            </h6>
                            <p class="mb-0">
                                Você receberá notificações por email sobre o status 
                                do seu pedido e código de rastreamento.
                            </p>
                        </div>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <div class="alert alert-success">
                        <i class="fas fa-heart me-2"></i>
                        <strong>Obrigado pela sua confiança!</strong> 
                        Esperamos que você tenha uma excelente experiência de leitura.
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
        // Copiar chave PIX
        function copyPix() {
            const pixKey = document.getElementById('pixKey');
            pixKey.select();
            pixKey.setSelectionRange(0, 99999);
            
            navigator.clipboard.writeText(pixKey.value).then(() => {
                const btn = event.target.closest('button');
                const originalContent = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-check"></i>';
                btn.classList.add('btn-success');
                btn.classList.remove('btn-outline-secondary');
                
                setTimeout(() => {
                    btn.innerHTML = originalContent;
                    btn.classList.remove('btn-success');
                    btn.classList.add('btn-outline-secondary');
                }, 2000);
            });
        }
        
        // Reenviar boleto por email
        function sendBoletoEmail() {
            fetch(`${pageContext.request.contextPath}/api/pedidos/${pedido.id}/reenviar-boleto`, {
                method: 'POST'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Boleto reenviado com sucesso!');
                } else {
                    alert('Erro ao reenviar boleto: ' + data.message);
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                alert('Erro ao reenviar boleto');
            });
        }
        
        // Compartilhar pedido
        function shareOrder() {
            if (navigator.share) {
                navigator.share({
                    title: 'Meu Pedido - Livraria Mil Páginas',
                    text: `Acabei de fazer um pedido na Livraria Mil Páginas! Pedido #${pedido.orderNumber}`,
                    url: window.location.href
                });
            } else {
                // Fallback para copiar link
                navigator.clipboard.writeText(window.location.href).then(() => {
                    alert('Link copiado para a área de transferência!');
                });
            }
        }
        
        // Verificar status do pagamento PIX (se aplicável)
        <c:if test="${pedido.paymentMethod == 'pix' && pedido.status == 'pending_payment'}">
            let checkPaymentInterval = setInterval(() => {
                fetch(`${pageContext.request.contextPath}/api/pedidos/${pedido.id}/status`)
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'paid') {
                        clearInterval(checkPaymentInterval);
                        location.reload();
                    }
                })
                .catch(error => console.error('Erro ao verificar pagamento:', error));
            }, 5000); // Verificar a cada 5 segundos
            
            // Parar verificação após 30 minutos
            setTimeout(() => {
                clearInterval(checkPaymentInterval);
            }, 1800000);
        </c:if>
        
        // Animação de entrada
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.order-card, .info-item');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>