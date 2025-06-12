<%-- /WEB-INF/views/auth/login.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pageTitle" value="Login" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-lg">
                    <div class="card-header text-center">
                        <h2 class="h3 mb-0">Acessar sua Conta</h2>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        
                        <c:if test="${!empty param.error}">
                            <div class="alert alert-danger">${param.error}</div>
                        </c:if>
                        <c:if test="${!empty param.success}">
                            <div class="alert alert-success">${param.success}</div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/login" method="POST">
                            <div class="mb-3">
                                <label for="email" class="form-label fw-bold">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${email}" required>
                            </div>
                            <div class="mb-4">
                                <label for="password" class="form-label fw-bold">Senha</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg">Entrar</button>
                            </div>
                        </form>
                        <hr class="my-4">
                        <div class="text-center">
                            <p class="mb-0">Não tem uma conta? <a href="${pageContext.request.contextPath}/register">Cadastre-se aqui</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../common/footer.jsp" />
</body>
</html>