<%-- /WEB-INF/views/common/head.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Livraria Mil Páginas - Sua livraria online de confiança.">
<title>${!empty pageTitle ? pageTitle : 'Livraria Mil Páginas'}</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Lora:ital,wght@0,400;0,600;1,400&family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/book-card.css">

<style>
    :root {
        --primary-brown: #8B4513;
        --dark-brown: #654321;
        --light-brown: #D2B48C;
        --cream: #F5F5DC;
        --gold: #DAA520;
        --dark-gold: #B8860B;
        --paper: #FDF6E3;
        --ink: #2C1810;
        --aged-paper: #F4F1E8;
        --burgundy: #800020;
        --forest-green: #228B22;
    }

    body {
        font-family: 'Lora', serif;
        background: linear-gradient(135deg, var(--aged-paper) 0%, var(--cream) 100%);
        color: var(--ink);
        min-height: 100vh;
        position: relative;
    }

    body::before {
        content: '';
        position: fixed;
        top: 0; left: 0;
        width: 100%; height: 100%;
        background-image: 
            radial-gradient(circle at 20% 50%, rgba(218, 165, 32, 0.05) 0%, transparent 20%),
            radial-gradient(circle at 80% 20%, rgba(139, 69, 19, 0.05) 0%, transparent 20%),
            radial-gradient(circle at 40% 80%, rgba(218, 165, 32, 0.03) 0%, transparent 20%);
        pointer-events: none;
        z-index: -1;
    }

    .navbar {
        background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
        box-shadow: 0 4px 20px rgba(139, 69, 19, 0.3);
        padding: 1rem 0;
    }

    .navbar-brand {
        font-family: 'Playfair Display', serif;
        font-weight: 700;
        font-size: 1.8rem;
        color: var(--gold) !important;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .navbar-brand::before {
        content: '📚';
        font-size: 1.5em;
        filter: drop-shadow(2px 2px 4px rgba(0,0,0,0.3));
    }

    .nav-link {
        color: var(--cream) !important;
        font-weight: 500;
        transition: all 0.3s ease;
        position: relative;
        padding: 0.5rem 1rem !important;
        border-radius: 25px;
    }

    .nav-link:hover, .nav-link.active {
        color: var(--gold) !important;
        background: rgba(218, 165, 32, 0.1);
        transform: translateY(-2px);
    }

    .card {
        background: rgba(253, 246, 227, 0.7); /* var(--paper) com alpha */
        border: 1px solid rgba(139, 69, 19, 0.2);
        border-radius: 15px;
        box-shadow: 0 8px 32px rgba(139, 69, 19, 0.1);
        backdrop-filter: blur(5px);
        overflow: hidden;
        transition: all 0.3s ease;
        height: 100%;
    }

    .card:hover {
        transform: translateY(-8px);
        box-shadow: 0 20px 40px rgba(139, 69, 19, 0.2);
    }

    .card-header {
        background: linear-gradient(135deg, var(--light-brown) 0%, var(--primary-brown) 100%);
        color: white;
        font-family: 'Playfair Display', serif;
        font-weight: 600;
        border-bottom: 1px solid var(--dark-brown);
        text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
    }

    .book-card:hover {
        transform: translateY(-12px) scale(1.02);
        box-shadow: 0 25px 50px rgba(139, 69, 19, 0.25);
    }
    
    .book-cover img {
        aspect-ratio: 2 / 3;
        object-fit: cover;
        background-color: var(--aged-paper);
    }

    .btn-primary {
        background: linear-gradient(135deg, var(--primary-brown) 0%, var(--dark-brown) 100%);
        border: none;
        border-radius: 25px;
        padding: 0.75rem 1.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(139, 69, 19, 0.3);
        color: white;
    }
    .btn-primary:hover {
        background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(139, 69, 19, 0.4);
        color: white;
    }
    .btn-gold {
        background: linear-gradient(135deg, var(--gold) 0%, var(--dark-gold) 100%);
        border: none;
        color: white;
        border-radius: 25px;
        padding: 0.75rem 1.5rem;
        font-weight: 500;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(218, 165, 32, 0.3);
    }
    .btn-gold:hover {
        background: linear-gradient(135deg, var(--dark-gold) 0%, var(--gold) 100%);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(218, 165, 32, 0.4);
    }

    h1, h2, h3, h4, h5, h6 {
        font-family: 'Playfair Display', serif;
        color: var(--dark-brown);
        font-weight: 700;
    }

    .page-title {
        font-size: 2.8rem;
        text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        position: relative;
        display: inline-block;
        margin-bottom: 2rem;
    }
    .page-title::after {
        content: '';
        position: absolute;
        bottom: -10px;
        left: 50%;
        transform: translateX(-50%);
        width: 70%;
        height: 3px;
        background: linear-gradient(90deg, var(--gold) 0%, var(--dark-gold) 100%);
        border-radius: 2px;
    }
    .price {
        font-family: 'Inter', sans-serif;
        font-weight: 600;
        font-size: 1.4rem;
        color: var(--forest-green);
    }
    
    .footer {
        background: linear-gradient(135deg, var(--dark-brown) 0%, var(--ink) 100%);
        color: var(--cream);
        padding: 2rem 0;
        margin-top: 4rem;
        border-top: 5px solid var(--gold);
    }

    main {
        min-height: calc(100vh - 160px); /* Ajustar valor conforme altura do header/footer */
    }
</style>