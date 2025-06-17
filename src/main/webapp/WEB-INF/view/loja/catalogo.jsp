<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/view/includes/header.jsp" %> <%-- CAMINHO CORRIGIDO --%>

<div class="container mt-4">
    <div class="row">
        <div class="col-md-3">
            <h4>Filtros</h4>
            <hr>
            <p>Filtros de categoria, preço, etc.</p>
        </div>
        <div class="col-md-9">
            <h2>Nosso Catálogo</h2>
            <hr>
            <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                <c:forEach var="livro" items="${livros}">
                    <div class="col">
                        <jsp:include page="/WEB-INF/view/loja/components/book-card.jsp" /> <%-- CAMINHO CORRIGIDO --%>
                    </div>
                </c:forEach>
            </div>
            
            <div class="mt-4">
                 <jsp:include page="/WEB-INF/view/includes/pagination.jsp" /> <%-- CAMINHO CORRIGIDO --%>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/view/includes/footer.jsp" %> <%-- CAMINHO CORRIGIDO --%>