<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Página não encontrada - Livraria Mil Páginas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Arial', sans-serif;
        }
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 60px 40px;
            text-align: center;
            max-width: 600px;
            margin: 0 auto;
        }
        .error-number {
            font-size: 8rem;
            font-weight: bold;
            color: #e74c3c;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .error-icon {
            font-size: 4rem;
            color: #f39c12;
            margin-bottom: 30px;
        }
        .btn-home {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 15px 30px;
            font-size: 1.1rem;
            border-radius: 50px;
            transition: transform 0.3s ease;
        }
        .btn-home:hover {
            transform: translateY(-2px);
            background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-book-open"></i>
            </div>
            
            <div class="error-number">404</div>
            
            <h2 class="mb-4">Oops! Página não encontrada</h2>
            
            <p class="text-muted mb-4">
                A página que você está procurando não existe ou foi movida. 
                Que tal explorar nosso catálogo de livros?
            </p>
            
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/" class="btn btn-primary btn-home me-3">
                    <i class="fas fa-home"></i> Página Inicial
                </a>
                <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-outline-primary">
                    <i class="fas fa-book"></i> Ver Catálogo
                </a>
            </div>
            
            <hr class="my-4">
            
            <p class="small text-muted">
                <strong>Código do Erro:</strong> <%= response.getStatus() %><br>
                <strong>URL Solicitada:</strong> <%= request.getRequestURL() %><br>
                <strong>Hora:</strong> <%= new java.util.Date() %>
            </p>
        </div>
    </div>
</body>
</html>