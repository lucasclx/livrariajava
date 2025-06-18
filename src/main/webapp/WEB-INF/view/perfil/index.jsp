<%-- Página de Perfil Otimizada - Redução de ~70% do código --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%-- Configuração da página --%>
<c:set var="pageTitle" value="Meu Perfil" />
<c:set var="showHero" value="true" />
<c:set var="heroIcon" value="fas fa-user" />
<c:set var="heroTitle" value="Olá, ${fn:split(sessionScope.user.name, ' ')[0]}!" />
<c:set var="heroSubtitle" value="Cliente desde ${fmt:formatDate(sessionScope.user.createdAt, 'MMMM de yyyy')}" />
<c:set var="heroAction"><a href="${pageContext.request.contextPath}/perfil/editar" class="btn btn-elegant">
    <i class="fas fa-edit me-2"></i>Editar Perfil</a></c:set>
<c:set var="contentPage" value="perfil-content.jsp" />

<%-- Usar layout base --%>
<jsp:include page="../layouts/base.jsp" />

<%-- Conteúdo específico da página (perfil-content.jsp) --%>
<%-- /WEB-INF/view/perfil/perfil-content.jsp --%>

<!-- Estatísticas usando fragment -->
<div class="row g-4 mb-5">
    <app:stat-card icon="fas fa-shopping-bag" value="${totalPedidos}" 
                   label="Pedidos Realizados" color="primary" />
    <app:stat-card icon="fas fa-book" value="${totalLivrosComprados}" 
                   label="Livros Comprados" color="success" />
    <app:stat-card icon="fas fa-heart" value="${livrosFavoritos}" 
                   label="Livros Favoritos" color="danger" />
    <app:stat-card icon="fas fa-star" value="${avaliacoesFeitas}" 
                   label="Avaliações" color="warning" />
</div>

<div class="row g-4">
    <!-- Últimos Pedidos -->
    <div class="col-lg-6">
        <app:data-section title="Últimos Pedidos" icon="fas fa-clock" 
                         items="${ultimosPedidos}" template="order-item.jsp"
                         emptyIcon="fas fa-shopping-cart" emptyTitle="Nenhum pedido ainda"
                         emptyMessage="Que tal começar explorando nosso catálogo?"
                         emptyAction='<a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary btn-sm">Ver Livros</a>'
                         seeAllUrl="${pageContext.request.contextPath}/perfil/pedidos" />
    </div>

    <!-- Livros Favoritos -->
    <div class="col-lg-6">
        <app:data-section title="Favoritos" icon="fas fa-heart" 
                         items="${favoritos}" template="book-mini.jsp"
                         itemClass="col-6 col-md-4" gridLayout="true"
                         emptyIcon="fas fa-heart" emptyTitle="Lista vazia"
                         seeAllUrl="${pageContext.request.contextPath}/perfil/favoritos" />
    </div>
</div>

<!-- Ações Rápidas -->
<app:quick-actions>
    <app:action-item title="Editar Perfil" icon="fas fa-user-edit" color="primary"
                     url="${pageContext.request.contextPath}/perfil/editar" 
                     description="Atualize suas informações" />
    <app:action-item title="Meus Pedidos" icon="fas fa-shopping-bag" color="success"
                     url="${pageContext.request.contextPath}/perfil/pedidos" 
                     description="Acompanhe suas compras" />
    <app:action-item title="Endereços" icon="fas fa-map-marker-alt" color="info"
                     url="${pageContext.request.contextPath}/perfil/enderecos" 
                     description="Gerencie endereços de entrega" />
    <app:action-item title="Avaliações" icon="fas fa-star" color="warning"
                     url="${pageContext.request.contextPath}/perfil/avaliacoes" 
                     description="Suas opiniões sobre livros" />
</app:quick-actions>

<%-- Tags customizadas para reduzir repetição --%>

<%-- /WEB-INF/tags/stat-card.tag --%>
<%@ tag body-content="empty" %>
<%@ attribute name="icon" required="true" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="color" required="true" %>

<div class="col-md-3">
    <div class="stats-card">
        <div class="stats-icon ${color}">
            <i class="${icon}"></i>
        </div>
        <h3 class="mb-1">${value != null ? value : 0}</h3>
        <p class="text-muted mb-0">${label}</p>
    </div>
</div>

<%-- /WEB-INF/tags/data-section.tag --%>
<%@ tag body-content="empty" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="icon" required="true" %>
<%@ attribute name="items" required="true" type="java.util.Collection" %>
<%@ attribute name="template" required="true" %>
<%@ attribute name="itemClass" required="false" %>
<%@ attribute name="gridLayout" required="false" %>
<%@ attribute name="emptyIcon" required="false" %>
<%@ attribute name="emptyTitle" required="false" %>
<%@ attribute name="emptyMessage" required="false" %>
<%@ attribute name="emptyAction" required="false" %>
<%@ attribute name="seeAllUrl" required="false" %>

<div class="section-card h-100">
    <div class="section-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">
            <i class="${icon} me-2"></i>${title}
        </h5>
        <c:if test="${not empty seeAllUrl}">
            <a href="${seeAllUrl}" class="btn btn-sm btn-outline-elegant">
                Ver Todos <i class="fas fa-arrow-right ms-1"></i>
            </a>
        </c:if>
    </div>
    <div class="card-body">
        <c:choose>
            <c:when test="${empty items}">
                <div class="empty-state">
                    <c:if test="${not empty emptyIcon}">
                        <i class="${emptyIcon}"></i>
                    </c:if>
                    <c:if test="${not empty emptyTitle}">
                        <h6>${emptyTitle}</h6>
                    </c:if>
                    <c:if test="${not empty emptyMessage}">
                        <p class="text-muted small">${emptyMessage}</p>
                    </c:if>
                    <c:if test="${not empty emptyAction}">
                        ${emptyAction}
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${gridLayout}">
                        <div class="row g-2">
                            <c:forEach var="item" items="${items}" varStatus="status">
                                <c:if test="${status.index < 6}">
                                    <div class="${itemClass}">
                                        <jsp:include page="../fragments/${template}">
                                            <jsp:param name="item" value="${item}" />
                                        </jsp:include>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="item" items="${items}" varStatus="status">
                            <c:if test="${status.index < 5}">
                                <jsp:include page="../fragments/${template}">
                                    <jsp:param name="item" value="${item}" />
                                </jsp:include>
                            </c:if>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- /WEB-INF/tags/quick-actions.tag --%>
<%@ tag body-content="scriptless" %>

<div class="section-card mt-5">
    <div class="section-header">
        <h5 class="mb-0">
            <i class="fas fa-lightning me-2"></i>Ações Rápidas
        </h5>
    </div>
    <div class="card-body">
        <div class="row g-4">
            <jsp:doBody/>
        </div>
    </div>
</div>

<%-- /WEB-INF/tags/action-item.tag --%>
<%@ tag body-content="empty" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="icon" required="true" %>
<%@ attribute name="color" required="true" %>
<%@ attribute name="url" required="true" %>
<%@ attribute name="description" required="true" %>

<div class="col-md-3">
    <a href="${url}" class="text-decoration-none">
        <div class="action-card">
            <div class="icon bg-${color} text-white">
                <i class="${icon}"></i>
            </div>
            <h6>${title}</h6>
            <p class="text-muted small mb-0">${description}</p>
        </div>
    </a>
</div>

<%-- CSS Mínimo Necessário (apenas o específico desta página) --%>
<style>
.profile-avatar {
    width: 120px;
    height: 120px;
    background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
    border: 5px solid rgba(255, 255, 255, 0.3);
}

.action-card .icon {
    width: 60px;
    height: 60px;
    margin: 0 auto 1rem;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
}
</style>

<%-- JavaScript mínimo usando classe global --%>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Usar funcionalidades da classe global LibraryApp
    window.app?.setupAnimations?.();
});
</script>