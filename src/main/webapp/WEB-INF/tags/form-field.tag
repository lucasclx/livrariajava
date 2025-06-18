<!-- /WEB-INF/tags/form-field.tag -->
<%@ tag body-content="empty" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="value" required="false" %>
<%@ attribute name="required" required="false" %>
<%@ attribute name="placeholder" required="false" %>

<c:set var="fieldType" value="${empty type ? 'text' : type}" />

<div class="mb-3">
    <label for="${name}" class="form-label">
        ${label} ${required ? '*' : ''}
    </label>
    <input type="${fieldType}" class="form-control" id="${name}" name="${name}" 
           value="${value}" ${required ? 'required' : ''} 
           placeholder="${placeholder}">
</div>