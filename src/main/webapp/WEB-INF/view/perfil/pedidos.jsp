<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Meus Pedidos" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .page-hero {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .order-card {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 20px;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(139, 69, 19, 0.15);
        }
        
        .order-header {
            background: linear-gradient(135deg, rgba(218, 165, 32, 0.1) 0%, rgba(139, 69, 19, 0.1) 100%);
            padding: 1.5rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .status-badge {
            font-size: 0.875rem;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-weight: 500;
        }
        
        .status-pending { background: linear-gradient(135deg, #ffc107 0%, #ff9800 100%); color: white; }
        .status-confirmed { background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); color: white; }
        .status-processing { background: linear-gradient(135deg, #007bff 0%, #0056b3 100%); color: white; }
        .status-shipped { background: linear-gradient(135deg, #6c757d 0%, #495057 100%); color: white; }
        .status-delivered { background: linear-gradient(135deg, #28a745 0%, #1e7e34 100%); color: white; }
        .status-cancelled { background: linear-gradient(135deg, #dc3545 0%, #bd2130 100%); color: white; }
        
        .order-timeline {
            position: relative;
            padding-left: 2rem;
        }
        
        .order-timeline::before {
            content: '';
            position: absolute;
            left: 0.75rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--light-brown);
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
            padding-left: 1rem;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -1.25rem;
            top: 0.25rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--light-brown);
            border: 2px solid white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .timeline-item.active::before {
            background: var(--forest-green);
            box-shadow: 0 0 0 4px rgba(34, 139, 34, 0.2);
        }
        
        .filter-card {
            background: rgba(245, 245, 220, 0.8);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.1);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.08);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--ink);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--light-brown);
            margin-bottom: 1rem;
        }
        
        .payment-method {
            background: rgba(255, 255, 255, 0.8);
            border-radius: 10px;
            padding: 0.5rem 1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .address-box {
            background: rgba(255, 255, 255, 0.5);
            border-radius: 10px;
            padding: 1rem;
            border: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .summary-table {
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .summary-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid rgba(139, 69, 19, 0.05);
        }
        
        .summary-table tr:last-child td {
            border-bottom: none;
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

    <!-- Hero Section -->
    <section class="page-hero">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Início</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/perfil">Meu Perfil</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Pedidos</li>
                </ol>
            </nav>
            
            <div class="row align-items-center">
                <div class="col">
                    <h1 class="h3 mb-0">
                        <i class="fas fa-shopping-bag me-2"></i>Meus Pedidos
                    </h1>
                    <p class="mb-0 opacity-75">Acompanhe seus pedidos e histórico de compras</p>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4 flex-grow-1">
        <!-- Filtros -->
        <div class="filter-card">
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="input-group">
                        <span class="input-group-text">
                            <i class="fas fa-search"></i>
                        </span>
                        <input type="text" class="form-control" placeholder="Buscar por número do pedido..." 
                               id="searchOrder">
                    </div>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="statusFilter">
                        <option value="">Todos os Status</option>
                        <option value="pending_payment">Aguardando Pagamento</option>
                        <option value="confirmed">Confirmado</option>
                        <option value="processing">Processando</option>
                        <option value="shipped">Enviado</option>
                        <option value="delivered">Entregue</option>
                        <option value="cancelled">Cancelado</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select class="form-select" id="periodFilter">
                        <option value="">Todos os Períodos</option>
                        <option value="7">Últimos 7 dias</option>
                        <option value="30">Últimos 30 dias</option>
                        <option value="90">Últimos 3 meses</option>
                        <option value="365">Último ano</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn btn-primary w-100" onclick="applyFilters()">
                        <i class="fas fa-filter me-2"></i>Filtrar
                    </button>
                </div>
            </div>
        </div>

        <!-- Lista de Pedidos -->
        <c:choose>
            <c:when test="${empty pedidos}">
                <div class="empty-state">
                    <i class="fas fa-shopping-cart"></i>
                    <h4>Nenhum pedido encontrado</h4>
                    <p class="text-muted">Você ainda não fez nenhum pedido ou nenhum pedido corresponde aos filtros aplicados.</p>
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary">
                        <i class="fas fa-shopping-bag me-2"></i>Começar a Comprar
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="pedido" items="${pedidos}">
                    <div class="order-card">
                        <div class="order-header">
                            <div class="row align-items-center">
                                <div class="col-md-3">
                                    <h6 class="mb-1">Pedido #${pedido.orderNumber}</h6>
                                    <small class="text-muted">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy 'às' HH:mm" />
                                    </small>
                                </div>
                                <div class="col-md-2 text-center">
                                    <c:choose>
                                        <c:when test="${pedido.status == 'pending_payment'}">
                                            <span class="status-badge status-pending">
                                                <i class="fas fa-clock me-1"></i>Aguardando Pagamento
                                            </span>
                                        </c:when>
                                        <c:when test="${pedido.status == 'confirmed'}">
                                            <span class="status-badge status-confirmed">
                                                <i class="fas fa-check me-1"></i>Confirmado
                                            </span>
                                        </c:when>
                                        <c:when test="${pedido.status == 'processing'}">
                                            <span class="status-badge status-processing">
                                                <i class="fas fa-cog me-1"></i>Processando
                                            </span>
                                        </c:when>
                                        <c:when test="${pedido.status == 'shipped'}">
                                            <span class="status-badge status-shipped">
                                                <i class="fas fa-truck me-1"></i>Enviado
                                            </span>
                                        </c:when>
                                        <c:when test="${pedido.status == 'delivered'}">
                                            <span class="status-badge status-delivered">
                                                <i class="fas fa-check-circle me-1"></i>Entregue
                                            </span>
                                        </c:when>
                                        <c:when test="${pedido.status == 'cancelled'}">
                                            <span class="status-badge status-cancelled">
                                                <i class="fas fa-times me-1"></i>Cancelado
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <div class="col-md-2 text-center">
                                    <div class="fw-bold text-success fs-5">
                                        <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                                    </div>
                                </div>
                                <div class="col-md-2 text-center">
                                    <div class="payment-method">
                                        <c:choose>
                                            <c:when test="${pedido.paymentMethod == 'credit_card'}">
                                                <i class="fas fa-credit-card text-primary"></i>
                                                <span>Cartão</span>
                                            </c:when>
                                            <c:when test="${pedido.paymentMethod == 'boleto'}">
                                                <i class="fas fa-barcode text-warning"></i>
                                                <span>Boleto</span>
                                            </c:when>
                                            <c:when test="${pedido.paymentMethod == 'pix'}">
                                                <i class="fas fa-qrcode text-success"></i>
                                                <span>PIX</span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="col-md-3 text-end">
                                    <button class="btn btn-outline-elegant btn-sm" type="button" 
                                            data-bs-toggle="collapse" data-bs-target="#order-${pedido.id}">
                                        <i class="fas fa-eye me-1"></i>Ver Detalhes
                                    </button>
                                    <c:if test="${pedido.status == 'pending_payment' || pedido.status == 'confirmed'}">
                                        <button class="btn btn-outline-danger btn-sm ms-2" 
                                                onclick="cancelarPedido(${pedido.id})">
                                            <i class="fas fa-times me-1"></i>Cancelar
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Detalhes do Pedido (Colapsável) -->
                        <div class="collapse" id="order-${pedido.id}">
                            <div class="card-body">
                                <div class="row">
                                    <!-- Timeline -->
                                    <div class="col-md-4">
                                        <h6 class="mb-3">
                                            <i class="fas fa-route me-2"></i>Acompanhamento
                                        </h6>
                                        <div class="order-timeline">
                                            <div class="timeline-item ${pedido.status != 'cancelled' ? 'active' : ''}">
                                                <small class="text-muted">Pedido Realizado</small>
                                                <div class="small">
                                                    <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </div>
                                            </div>
                                            <div class="timeline-item ${pedido.status == 'processing' || pedido.status == 'shipped' || pedido.status == 'delivered' ? 'active' : ''}">
                                                <small class="text-muted">Em Preparação</small>
                                            </div>
                                            <div class="timeline-item ${pedido.status == 'shipped' || pedido.status == 'delivered' ? 'active' : ''}">
                                                <small class="text-muted">Enviado</small>
                                                <c:if test="${pedido.shippedAt != null}">
                                                    <div class="small">
                                                        <fmt:formatDate value="${pedido.shippedAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </c:if>
                                                <c:if test="${not empty pedido.trackingCode}">
                                                    <div class="small">
                                                        <i class="fas fa-barcode me-1"></i>
                                                        ${pedido.trackingCode}
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="timeline-item ${pedido.status == 'delivered' ? 'active' : ''}">
                                                <small class="text-muted">Entregue</small>
                                                <c:if test="${pedido.deliveredAt != null}">
                                                    <div class="small">
                                                        <fmt:formatDate value="${pedido.deliveredAt}" pattern="dd/MM/yyyy HH:mm" />
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Resumo -->
                                    <div class="col-md-4">
                                        <h6 class="mb-3">
                                            <i class="fas fa-receipt me-2"></i>Resumo do Pedido
                                        </h6>
                                        <table class="summary-table w-100">
                                            <tr>
                                                <td>Subtotal:</td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${pedido.subtotal}" type="currency" currencySymbol="R$ " />
                                                </td>
                                            </tr>
                                            <c:if test="${pedido.desconto > 0}">
                                                <tr class="text-success">
                                                    <td>Desconto:</td>
                                                    <td class="text-end">
                                                        -<fmt:formatNumber value="${pedido.desconto}" type="currency" currencySymbol="R$ " />
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <tr>
                                                <td>Frete:</td>
                                                <td class="text-end">
                                                    <c:choose>
                                                        <c:when test="${pedido.shippingCost > 0}">
                                                            <fmt:formatNumber value="${pedido.shippingCost}" type="currency" currencySymbol="R$ " />
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-success">Grátis</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                            <tr class="fw-bold">
                                                <td>Total:</td>
                                                <td class="text-end text-success">
                                                    <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                    
                                    <!-- Endereço -->
                                    <div class="col-md-4">
                                        <h6 class="mb-3">
                                            <i class="fas fa-map-marker-alt me-2"></i>Endereço de Entrega
                                        </h6>
                                        <div class="address-box">
                                            <c:if test="${not empty pedido.shippingRecipientName}">
                                                <div class="fw-bold">${pedido.shippingRecipientName}</div>
                                            </c:if>
                                            <div>${pedido.shippingStreet}, ${pedido.shippingNumber}</div>
                                            <c:if test="${not empty pedido.shippingComplement}">
                                                <div>${pedido.shippingComplement}</div>
                                            </c:if>
                                            <div>${pedido.shippingNeighborhood}</div>
                                            <div>${pedido.shippingCity}/${pedido.shippingState}</div>
                                            <div>CEP: ${pedido.shippingPostalCode}</div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Observações -->
                                <c:if test="${not empty pedido.observacoes}">
                                    <div class="row mt-3">
                                        <div class="col-12">
                                            <h6>
                                                <i class="fas fa-sticky-note me-2"></i>Observações
                                            </h6>
                                            <div class="alert alert-light">
                                                ${pedido.observacoes}
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Paginação -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Navegação de pedidos" class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage - 1}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="page">
                                <c:choose>
                                    <c:when test="${page == currentPage}">
                                        <li class="page-item active">
                                            <span class="page-link">${page}</span>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${page}">${page}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="?page=${currentPage + 1}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- Modal de Cancelamento -->
    <div class="modal fade" id="cancelModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                        Cancelar Pedido
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Tem certeza que deseja cancelar este pedido?</p>
                    <p class="text-muted small">
                        <i class="fas fa-info-circle me-1"></i>
                        Esta ação não pode ser desfeita. Se o pedido já foi enviado, 
                        entre em contato com nosso suporte.
                    </p>
                    
                    <div class="mb-3">
                        <label for="cancelReason" class="form-label">Motivo do cancelamento (opcional):</label>
                        <select class="form-select" id="cancelReason">
                            <option value="">Selecione um motivo</option>
                            <option value="changed_mind">Mudei de ideia</option>
                            <option value="found_better_price">Encontrei melhor preço</option>
                            <option value="payment_issues">Problemas com pagamento</option>
                            <option value="delivery_delay">Demora na entrega</option>
                            <option value="other">Outro motivo</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Manter Pedido
                    </button>
                    <button type="button" class="btn btn-danger" id="confirmCancel">
                        <i class="fas fa-times me-2"></i>Cancelar Pedido
                    </button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
        let orderToCancel = null;
        
        function cancelarPedido(orderId) {
            orderToCancel = orderId;
            new bootstrap.Modal(document.getElementById('cancelModal')).show();
        }
        
        document.getElementById('confirmCancel').addEventListener('click', function() {
            if (orderToCancel) {
                const reason = document.getElementById('cancelReason').value;
                
                // Enviar requisição de cancelamento
                fetch(`${pageContext.request.contextPath}/api/pedidos/${orderToCancel}/cancelar`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ motivo: reason })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        location.reload();
                    } else {
                        alert('Erro ao cancelar pedido: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Erro:', error);
                    alert('Erro ao cancelar pedido');
                });
                
                bootstrap.Modal.getInstance(document.getElementById('cancelModal')).hide();
            }
        });
        
        // Filtros
        function applyFilters() {
            const search = document.getElementById('searchOrder').value;
            const status = document.getElementById('statusFilter').value;
            const period = document.getElementById('periodFilter').value;
            
            let url = new URL(window.location.href);
            
            if (search) url.searchParams.set('search', search);
            else url.searchParams.delete('search');
            
            if (status) url.searchParams.set('status', status);
            else url.searchParams.delete('status');
            
            if (period) url.searchParams.set('period', period);
            else url.searchParams.delete('period');
            
            window.location.href = url.toString();
        }
        
        // Animação ao carregar
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.order-card');
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