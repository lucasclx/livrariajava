<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- 
    Arquivo de taglibs comum para todas as páginas JSP
    Este arquivo é incluído automaticamente em todas as páginas JSP conforme configurado no web.xml
--%>

<%-- JSTL Core Tags --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- JSTL Formatting Tags --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- JSTL Functions --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%-- JSTL SQL Tags (usar com moderação) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>

<%-- JSTL XML Tags --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>

<%-- Configurações de localização e formatação --%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" scope="application"/>

<%-- Configurar locale para português brasileiro --%>
<fmt:setLocale value="pt_BR" scope="session"/>

<%-- Configurar timezone para São Paulo --%>
<fmt:setTimeZone value="America/Sao_Paulo" scope="session"/>

<%-- Definir variáveis globais úteis --%>
<c:set var="currentDate" value="<%= new java.util.Date() %>" scope="request"/>
<c:set var="currentYear" scope="request">
    <fmt:formatDate value="${currentDate}" pattern="yyyy"/>
</c:set>

<%-- Funções customizadas (EL Functions) --%>
<%-- Estas podem ser expandidas conforme necessário --%>

<%-- Meta tags padrão para todas as páginas --%>
<c:set var="defaultMetaDescription" value="Livraria Mil Páginas - Sua livraria online de confiança com milhares de títulos" scope="application"/>
<c:set var="defaultMetaKeywords" value="livros, livraria, literatura, comprar livros online, educação, leitura" scope="application"/>
<c:set var="defaultMetaAuthor" value="Livraria Mil Páginas" scope="application"/>

<%-- Configurações da aplicação --%>
<c:set var="appName" value="${initParam['app.name']}" scope="application"/>
<c:set var="appVersion" value="${initParam['app.version']}" scope="application"/>
<c:set var="appEnvironment" value="${initParam['app.environment']}" scope="application"/>

<%-- URLs base para diferentes recursos --%>
<c:set var="assetsUrl" value="${contextPath}/assets" scope="application"/>
<c:set var="uploadsUrl" value="${contextPath}/uploads" scope="application"/>
<c:set var="apiUrl" value="${contextPath}/api" scope="application"/>

<%-- Configurações de paginação padrão --%>
<c:set var="defaultPageSize" value="12" scope="application"/>
<c:set var="maxPageSize" value="100" scope="application"/>

<%-- Status HTTP úteis --%>
<c:set var="HTTP_OK" value="200" scope="application"/>
<c:set var="HTTP_NOT_FOUND" value="404" scope="application"/>
<c:set var="HTTP_SERVER_ERROR" value="500" scope="application"/>

<%-- Configurações de formatação de moeda --%>
<fmt:setBundle basename="messages" scope="application"/>

<%-- Função para verificar se usuário está logado --%>
<c:set var="isLoggedIn" value="${not empty sessionScope.user}" scope="request"/>
<c:set var="isAdmin" value="${not empty sessionScope.user and sessionScope.user.admin}" scope="request"/>

<%-- Configurações de debug (apenas em desenvolvimento) --%>
<c:if test="${appEnvironment eq 'development'}">
    <c:set var="debugMode" value="true" scope="application"/>
</c:if>

<%-- 
    Macros e funções utilitárias que podem ser usadas em qualquer JSP
    Estas são definidas usando JSTL e podem ser referenciadas em outras páginas
--%>

<%-- Função para truncar texto --%>
<c:set var="truncateLength" value="100" scope="application"/>

<%-- Headers de segurança padrão --%>
<%
    // Headers de segurança básicos
    response.setHeader("X-Content-Type-Options", "nosniff");
    response.setHeader("X-Frame-Options", "DENY");
    response.setHeader("X-XSS-Protection", "1; mode=block");
    response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
    
    // Cache control para páginas dinâmicas
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<%-- Configurar encoding padrão --%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
%>

<%-- Verificar se a aplicação está em modo de manutenção --%>
<c:set var="maintenanceMode" value="false" scope="application"/>

<%-- Configurações de tema (futuro uso) --%>
<c:set var="defaultTheme" value="light" scope="application"/>
<c:set var="userTheme" value="${not empty sessionScope.userTheme ? sessionScope.userTheme : defaultTheme}" scope="request"/>

<%-- URLs de CDN para bibliotecas externas --%>
<c:set var="bootstrapCssUrl" value="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" scope="application"/>
<c:set var="bootstrapJsUrl" value="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" scope="application"/>
<c:set var="fontAwesomeUrl" value="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" scope="application"/>
<c:set var="jqueryUrl" value="https://code.jquery.com/jquery-3.7.0.min.js" scope="application"/>

<%-- Configurações de upload --%>
<c:set var="maxFileSize" value="2097152" scope="application"/><%-- 2MB --%>
<c:set var="allowedImageTypes" value="image/jpeg,image/jpg,image/png,image/gif,image/webp" scope="application"/>

<%-- Padrões de validação --%>
<c:set var="emailPattern" value="^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$" scope="application"/>
<c:set var="phonePattern" value="^\(?[0-9]{2}\)?[0-9]{4,5}-?[0-9]{4}$" scope="application"/>
<c:set var="cepPattern" value="^[0-9]{5}-?[0-9]{3}$" scope="application"/>

<%-- Mensagens padrão do sistema --%>
<c:set var="defaultSuccessMessage" value="Operação realizada com sucesso!" scope="application"/>
<c:set var="defaultErrorMessage" value="Ocorreu um erro. Tente novamente." scope="application"/>
<c:set var="defaultWarningMessage" value="Atenção: verifique os dados informados." scope="application"/>
<c:set var="defaultInfoMessage" value="Informação importante." scope="application"/>

<%-- Configurações de pesquisa --%>
<c:set var="minSearchLength" value="3" scope="application"/>
<c:set var="maxSearchResults" value="50" scope="application"/>

<%-- Estados brasileiros para formulários --%>
<c:set var="estadosBrasil" value="AC,AL,AP,AM,BA,CE,DF,ES,GO,MA,MT,MS,MG,PA,PB,PR,PE,PI,RJ,RN,RS,RO,RR,SC,SP,SE,TO" scope="application"/>

<%-- Configurações de e-commerce --%>
<c:set var="moedaPadrao" value="BRL" scope="application"/>
<c:set var="simboloMoeda" value="R$" scope="application"/>
<c:set var="taxaFreteGratis" value="99.00" scope="application"/>

<%-- Configurações de sessão --%>
<c:set var="sessionTimeout" value="30" scope="application"/><%-- minutos --%>

<%-- Links úteis para footer --%>
<c:set var="linkTermosUso" value="${contextPath}/termos-uso" scope="application"/>
<c:set var="linkPoliticaPrivacidade" value="${contextPath}/politica-privacidade" scope="application"/>
<c:set var="linkContato" value="${contextPath}/contato" scope="application"/>
<c:set var="linkAjuda" value="${contextPath}/ajuda" scope="application"/>

<%-- Redes sociais (configurar conforme necessário) --%>
<c:set var="facebookUrl" value="#" scope="application"/>
<c:set var="instagramUrl" value="#" scope="application"/>
<c:set var="twitterUrl" value="#" scope="application"/>
<c:set var="linkedinUrl" value="#" scope="application"/>

<%-- Google Analytics / Tag Manager (configurar em produção) --%>
<c:set var="googleAnalyticsId" value="" scope="application"/>
<c:set var="googleTagManagerId" value="" scope="application"/>

<%-- Configurações de SEO --%>
<c:set var="defaultPageTitle" value="Livraria Mil Páginas" scope="application"/>
<c:set var="titleSeparator" value=" - " scope="application"/>

<%-- Tipos MIME permitidos para upload --%>
<c:set var="allowedMimeTypes" value="image/jpeg,image/png,image/gif,image/webp,application/pdf" scope="application"/>

<%-- Configurações de cache (em segundos) --%>
<c:set var="staticResourcesCache" value="3600" scope="application"/><%-- 1 hora --%>
<c:set var="dynamicContentCache" value="300" scope="application"/><%-- 5 minutos --%>

<%-- Configurações de log --%>
<c:set var="logLevel" value="${appEnvironment eq 'development' ? 'DEBUG' : 'INFO'}" scope="application"/>

<%-- Versão dos assets (para cache busting) --%>
<c:set var="assetsVersion" value="${appVersion}" scope="application"/>

<%-- Configurações de API externa (se necessário) --%>
<c:set var="apiTimeout" value="30000" scope="application"/><%-- 30 segundos --%>
<c:set var="apiRetries" value="3" scope="application"/>

<%-- Configurações de backup --%>
<c:set var="backupEnabled" value="${appEnvironment eq 'production'}" scope="application"/>

<%-- Formatadores personalizados --%>
<%-- Estes podem ser usados em qualquer página JSP --%>

<%-- 
    Configurações específicas por ambiente
--%>
<c:choose>
    <c:when test="${appEnvironment eq 'development'}">
        <c:set var="minifyResources" value="false" scope="application"/>
        <c:set var="showDebugInfo" value="true" scope="application"/>
        <c:set var="enableHotReload" value="true" scope="application"/>
    </c:when>
    <c:when test="${appEnvironment eq 'staging'}">
        <c:set var="minifyResources" value="true" scope="application"/>
        <c:set var="showDebugInfo" value="false" scope="application"/>
        <c:set var="enableHotReload" value="false" scope="application"/>
    </c:when>
    <c:when test="${appEnvironment eq 'production'}">
        <c:set var="minifyResources" value="true" scope="application"/>
        <c:set var="showDebugInfo" value="false" scope="application"/>
        <c:set var="enableHotReload" value="false" scope="application"/>
        <%-- Configurações específicas de produção --%>
        <c:set var="enableGoogleAnalytics" value="true" scope="application"/>
        <c:set var="enableErrorReporting" value="true" scope="application"/>
    </c:when>
    <c:otherwise>
        <c:set var="minifyResources" value="false" scope="application"/>
        <c:set var="showDebugInfo" value="true" scope="application"/>
        <c:set var="enableHotReload" value="false" scope="application"/>
    </c:otherwise>
</c:choose>

<%-- Informações do servidor (apenas em desenvolvimento) --%>
<c:if test="${showDebugInfo}">
    <c:set var="serverInfo" value="<%= application.getServerInfo() %>" scope="request"/>
    <c:set var="javaVersion" value="<%= System.getProperty(\"java.version\") %>" scope="request"/>
    <c:set var="osName" value="<%= System.getProperty(\"os.name\") %>" scope="request"/>
</c:if>

<%-- Meta viewport padrão para responsividade --%>
<c:set var="defaultViewport" value="width=device-width, initial-scale=1.0" scope="application"/>

<%-- Configurações de PWA (Progressive Web App) - futuro uso --%>
<c:set var="pwaEnabled" value="false" scope="application"/>
<c:set var="manifestUrl" value="${contextPath}/manifest.json" scope="application"/>
<c:set var="serviceWorkerUrl" value="${contextPath}/sw.js" scope="application"/>

<%-- 
    Funções utilitárias que podem ser chamadas de qualquer JSP
    Estas são implementadas usando EL e JSTL
--%>

<%-- Verificar se string não está vazia --%>
<%-- Uso: ${not empty variavel} --%>

<%-- Verificar se usuário tem permissão específica --%>
<%-- Uso: ${isAdmin or (isLoggedIn and user.id eq targetUserId)} --%>

<%-- Formatar data para exibição --%>
<%-- Uso: <fmt:formatDate value="${data}" pattern="dd/MM/yyyy HH:mm"/> --%>

<%-- Formatar moeda --%>
<%-- Uso: <fmt:formatNumber value="${preco}" type="currency" currencySymbol="R$ "/> --%>

<%-- Truncar texto --%>
<%-- Uso: ${fn:substring(texto, 0, 100)}${fn:length(texto) > 100 ? '...' : ''} --%>

<%-- 
    Incluir arquivos CSS e JS de forma condicional
    baseado no ambiente e configurações
--%>

<%-- Flag para indicar que taglibs foram carregadas --%>
<c:set var="taglibsLoaded" value="true" scope="request"/>

<%-- Log de inicialização (apenas em desenvolvimento) --%>
<c:if test="${showDebugInfo}">
    <%-- 
        System.out.println("Taglibs carregadas para: " + request.getRequestURI());
        System.out.println("Ambiente: " + application.getInitParameter("app.environment"));
        System.out.println("Usuário logado: " + (session.getAttribute("user") != null));
    --%>
</c:if>