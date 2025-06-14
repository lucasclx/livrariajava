<%-- /WEB-INF/views/common/head.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Livraria Mil Páginas - Sua livraria online de confiança.">
<title>${!empty pageTitle ? pageTitle : 'Livraria Mil Páginas'}</title>

<!-- Preconnect para fontes -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:ital,wght@0,400;0,600;1,400&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />

<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">

<!-- CSS Principal do Projeto -->
<link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">

<!-- Meta tags para SEO -->
<meta name="author" content="Livraria Mil Páginas">
<meta name="keywords" content="livros, livraria, literatura, comprar livros online, educação, leitura">
<meta name="robots" content="index, follow">

<!-- Open Graph / Facebook -->
<meta property="og:type" content="website">
<meta property="og:url" content="${pageContext.request.requestURL}">
<meta property="og:title" content="${!empty pageTitle ? pageTitle : 'Livraria Mil Páginas'}">
<meta property="og:description" content="Discover worlds in every page at Livraria Mil Páginas">
<meta property="og:image" content="${pageContext.request.contextPath}/assets/images/og-image.jpg">

<!-- Twitter -->
<meta property="twitter:card" content="summary_large_image">
<meta property="twitter:url" content="${pageContext.request.requestURL}">
<meta property="twitter:title" content="${!empty pageTitle ? pageTitle : 'Livraria Mil Páginas'}">
<meta property="twitter:description" content="Discover worlds in every page at Livraria Mil Páginas">
<meta property="twitter:image" content="${pageContext.request.contextPath}/assets/images/og-image.jpg">

<!-- Favicon -->
<link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico">
<link rel="apple-touch-icon" sizes="180x180" href="${pageContext.request.contextPath}/assets/images/apple-touch-icon.png">

<!-- Preload crítico -->
<link rel="preload" href="${pageContext.request.contextPath}/assets/css/style.css" as="style">

<!-- Theme Color -->
<meta name="theme-color" content="#8B4513">