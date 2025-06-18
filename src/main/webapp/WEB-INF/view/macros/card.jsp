<!-- /WEB-INF/view/macros/card.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="${cardClass}">
    <c:if test="${not empty cardHeader}">
        <div class="card-header">
            <h5 class="mb-0">${cardHeader}</h5>
        </div>
    </c:if>
    <div class="card-body">
        ${cardContent}
    </div>
    <c:if test="${not empty cardFooter}">
        <div class="card-footer">
            ${cardFooter}
        </div>
    </c:if>
</div>