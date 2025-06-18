<!-- /WEB-INF/view/fragments/stat-card.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Parâmetros esperados: icon, value, label, color --%>
<div class="col-md-3">
    <div class="stats-card">
        <div class="stats-icon ${color}">
            <i class="${icon}"></i>
        </div>
        <h4 class="mb-1">${value}</h4>
        <p class="text-muted mb-0 small">${label}</p>
    </div>
</div>