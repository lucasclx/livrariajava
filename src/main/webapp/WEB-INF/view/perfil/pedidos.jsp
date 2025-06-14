<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Pedidos - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .order-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.2s;
        }
        .order-card:hover {
            transform: translateY(-2px);
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.5rem 1rem;
            border-radius: 20px;
        }
        .order-timeline {
            position: relative;
            padding-left: 2rem;
        }
        .order-timeline::before {
            content: '';
            position: absolute;
            left: 0.5rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
        }
        .timeline-item {
            position: relative;
            margin-bottom: 1rem;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -1.5rem;
            top: 0.2rem;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: #6c757d;
        }
        .timeline-item.active::before {
            background: #198754;
        }
    </style>
</head>
<body>
    <!-- Header com navegação aqui -->
    
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-2">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/perfil" class="text-white-50">
                                    <i class="fas fa-user"></i> Perfil
                                </a>
                            </li>
                            <li class="breadcrumb-item active text-white" aria-current="page">Pedidos</li>
                        </ol>
                    </nav>
                    <h1 class="h3 mb-0">
                        <i class="fas fa-shopping-bag me-2"></i>Meus Pedidos
                    </h1>
                    <p class="mb-0 opacity-75">Acompanhe seus pedidos e histórico de compras</p>
                </div>
            </div>
        </div>
    </div>

    <div class="container my-4">
        <!-- Filtros e Busca -->
        <div class="row mb-4">
            <div class="col-md-6">
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
        </div>

        <!-- Lista de Pedidos -->
        <c:choose>
            <c:when test="${empty pedidos}">
                <div class="text-center py-5">
                    <i class="fas fa-shopping-cart fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">Nenhum pedido encontrado</h4>
                    <p class="text-muted">Você ainda não fez nenhum pedido ou nenhum pedido corresponde aos filtros aplicados.</p>
                    <a href="${pageContext.request.contextPath}/loja" class="btn btn-primary">
                        <i class="fas fa-shopping-bag me-2"></i>Começar a Comprar
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="pedido" items="${pedidos}">
                        <div class="col-12">
                            <div class="order-card card">
                                <div class="card-header bg-transparent">
                                    <div class="row align-items-center">
                                        <div class="col-md-3">
                                            <h6 class="mb-1">Pedido #${pedido.orderNumber}</h6>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy 'às' HH:mm" />
                                            </small>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <c:choose>
                                                <c:when test="${pedido.status == 'pending_payment'}">
                                                    <span class="status-badge bg-warning text-dark">
                                                        <i class="fas fa-clock me-1"></i>Aguardando Pagamento
                                                    </span>
                                                </c:when>
                                                <c:when test="${pedido.status == 'confirmed'}">
                                                    <span class="status-badge bg-info text-white">
                                                        <i class="fas fa-check me-1"></i>Confirmado
                                                    </span>
                                                </c:when>
                                                <c:when test="${pedido.status == 'processing'}">
                                                    <span class="status-badge bg-primary text-white">
                                                        <i class="fas fa-cog me-1"></i>Processando
                                                    </span>
                                                </c:when>
                                                <c:when test="${pedido.status == 'shipped'}">
                                                    <span class="status-badge bg-secondary text-white">
                                                        <i class="fas fa-truck me-1"></i>Enviado
                                                    </span>
                                                </c:when>
                                                <c:when test="${pedido.status == 'delivered'}">
                                                    <span class="status-badge bg-success text-white">
                                                        <i class="fas fa-check-circle me-1"></i>Entregue
                                                    </span>
                                                </c:when>
                                                <c:when test="${pedido.status == 'cancelled'}">
                                                    <span class="status-badge bg-danger text-white">
                                                        <i class="fas fa-times me-1"></i>Cancelado
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge bg-light text-dark">${pedido.statusLabel}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <div class="fw-bold text-success fs-5">
                                                <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                                            </div>
                                        </div>
                                        <div class="col-md-2 text-center">
                                            <small class="text-muted d-block">Pagamento</small>
                                            <span class="badge bg-light text-dark">
                                                <c:choose>
                                                    <c:when test="${pedido.paymentMethod == 'credit_card'}">
                                                        <i class="fas fa-credit-card me-1"></i>Cartão
                                                    </c:when>
                                                    <c:when test="${pedido.paymentMethod == 'boleto'}">
                                                        <i class="fas fa-barcode me-1"></i>Boleto
                                                    </c:when>
                                                    <c:when test="${pedido.paymentMethod == 'pix'}">
                                                        <i class="fas fa-qrcode me-1"></i>PIX
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${pedido.paymentMethod}
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="col-md-3 text-end">
                                            <button class="btn btn-outline-primary btn-sm" type="button" 
                                                    data-bs-toggle="collapse" data-bs-target="#order-${pedido.id}" 
                                                    aria-expanded="false">
                                                <i class="fas fa-eye me-1"></i>Ver Detalhes
                                            </button>
                                            <c:if test="${pedido.canBeCancelled()}">
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
                                    <div class="card-body border-top">
                                        <div class="row">
                                            <!-- Timeline de Status -->
                                            <div class="col-md-4">
                                                <h6 class="mb-3">
                                                    <i class="fas fa-route me-2"></i>Acompanhamento
                                                </h6>
                                                <div class="order-timeline">
                                                    <div class="timeline-item ${pedido.status != 'cancelled' ? 'active' : ''}">
                                                        <small class="text-muted">Pedido Confirmado</small>
                                                        <c:if test="${pedido.createdAt != null}">
                                                            <div class="small">
                                                                <fmt:formatDate value="${pedido.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                            </div>
                                                        </c:if>
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
                                                        <c:if test="${pedido.trackingCode != null}">
                                                            <div class="small">
                                                                <i class="fas fa-barcode me-1"></i>
                                                                Código: ${pedido.trackingCode}
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
                                            
                                            <!-- Resumo do Pedido -->
                                            <div class="col-md-4">
                                                <h6 class="mb-3">
                                                    <i class="fas fa-receipt me-2"></i>Resumo do Pedido
                                                </h6>
                                                <table class="table table-sm">
                                                    <tr>
                                                        <td>Subtotal:</td>
                                                        <td class="text-end">
                                                            <fmt:formatNumber value="${pedido.subtotal}" type="currency" currencySymbol="R$ " />
                                                        </td>
                                                    </tr>
                                                    <c:if test="${pedido.desconto != null && pedido.desconto > 0}">
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
                                                                <c:when test="${pedido.shippingCost != null && pedido.shippingCost > 0}">
                                                                    <fmt:formatNumber value="${pedido.shippingCost}" type="currency" currencySymbol="R$ " />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-success">Grátis</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                    </tr>
                                                    <tr class="table-active fw-bold">
                                                        <td>Total:</td>
                                                        <td class="text-end text-success">
                                                            <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ " />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                            
                                            <!-- Endereço de Entrega -->
                                            <div class="col-md-4">
                                                <h6 class="mb-3">
                                                    <i class="fas fa-map-marker-alt me-2"></i>Endereço de Entrega
                                                </h6>
                                                <div class="small">
                                                    <c:if test="${pedido.shippingRecipientName != null}">
                                                        <div class="fw-bold">${pedido.shippingRecipientName}</div>
                                                    </c:if>
                                                    <div>${pedido.shippingStreet}, ${pedido.shippingNumber}</div>
                                                    <c:if test="${pedido.shippingComplement != null}">
                                                        <div>${pedido.shippingComplement}</div>
                                                    </c:if>
                                                    <div>${pedido.shippingNeighborhood}</div>
                                                    <div>${pedido.shippingCity}/${pedido.shippingState}</div>
                                                    <div>CEP: ${pedido.shippingPostalCode}</div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Observações -->
                                        <c:if test="${pedido.observacoes != null && !empty pedido.observacoes}">
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
                        </div>
                    </c:forEach>
                </div>

                <!-- Paginação -->
                <c:if test="${totalPages > 1}">
                    <nav aria-label="Navegação de pedidos">
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
    </div>

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

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
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
                fetch(`${pageContext.request.contextPath}/admin/pedidos/${orderToCancel}/status`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `status=cancelled&observacoes=Cancelado pelo cliente. Motivo: ${reason || 'Não informado'}`
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
        
        // Filtros em tempo real
        document.getElementById('searchOrder').addEventListener('input', filterOrders);
        document.getElementById('statusFilter').addEventListener('change', filterOrders);
        document.getElementById('periodFilter').addEventListener('change', filterOrders);
        
        function filterOrders() {
            const search = document.getElementById('searchOrder').value.toLowerCase();
            const status = document.getElementById('statusFilter').value;
            const period = document.getElementById('periodFilter').value;
            
            const orders = document.querySelectorAll('.order-card');
            
            orders.forEach(order => {
                const orderNumber = order.querySelector('h6').textContent.toLowerCase();
                const orderStatus = order.querySelector('.status-badge').textContent;
                
                let show = true;
                
                // Filtro de busca
                if (search && !orderNumber.includes(search)) {
                    show = false;
                }
                
                // Filtro de status
                if (status && !orderStatus.includes(status)) {
                    show = false;
                }
                
                // Mostrar/ocultar
                order.style.display = show ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>