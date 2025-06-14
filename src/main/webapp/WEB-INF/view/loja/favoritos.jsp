<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.livraria.models.Livro" %>
<%@ page import="com.livraria.models.User" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Favoritos - Livraria Mil Páginas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-heart text-danger me-2"></i>Meus Favoritos</h2>
                    <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-outline-primary">
                        <i class="fas fa-arrow-left me-1"></i>Ver Catálogo
                    </a>
                </div>

                <%
                    @SuppressWarnings("unchecked")
                    List<Livro> favoritos = (List<Livro>) request.getAttribute("favoritos");
                    Integer totalFavoritos = (Integer) request.getAttribute("totalFavoritos");
                    
                    if (favoritos == null || favoritos.isEmpty()) {
                %>
                    <!-- Nenhum Favorito -->
                    <div class="text-center py-5">
                        <i class="fas fa-heart-broken fa-5x text-muted mb-3"></i>
                        <h3 class="text-muted">Você ainda não tem favoritos</h3>
                        <p class="text-muted mb-4">Marque os livros que mais gostar para encontrá-los facilmente depois</p>
                        <a href="${pageContext.request.contextPath}/loja/catalogo" class="btn btn-primary btn-lg">
                            <i class="fas fa-book me-2"></i>Explorar Livros
                        </a>
                    </div>

                    <%
                        @SuppressWarnings("unchecked")
                        List<Livro> sugestoes = (List<Livro>) request.getAttribute("sugestoes");
                        if (sugestoes != null && !sugestoes.isEmpty()) {
                    %>
                        <!-- Sugestões para usuário sem favoritos -->
                        <div class="mt-5">
                            <h4><i class="fas fa-star me-2"></i>Livros em Destaque</h4>
                            <div class="row">
                                <%
                                    for (Livro livro : sugestoes) {
                                %>
                                    <div class="col-md-3 mb-4">
                                        <div class="card h-100">
                                            <img src="<%=livro.getImagemUrl()%>" class="card-img-top" alt="<%=livro.getTitulo()%>" style="height: 250px; object-fit: cover;">
                                            <div class="card-body d-flex flex-column">
                                                <h6 class="card-title"><%=livro.getTitulo()%></h6>
                                                <p class="card-text text-muted small"><%=livro.getAutor()%></p>
                                                <div class="mt-auto">
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <strong class="text-primary"><%=livro.getPrecoFormatado()%></strong>
                                                        <button class="btn btn-sm btn-outline-danger" 
                                                                onclick="toggleFavorite(<%=livro.getId()%>)">
                                                            <i class="far fa-heart"></i>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    <%
                        }
                    %>
                <%
                    } else {
                %>
                    <!-- Lista de Favoritos -->
                    <div class="mb-3">
                        <span class="text-muted"><%=totalFavoritos%> livro<%=totalFavoritos > 1 ? "s" : ""%> favorito<%=totalFavoritos > 1 ? "s" : ""%></span>
                        <button class="btn btn-sm btn-outline-warning ms-3" onclick="clearFavorites()">
                            <i class="fas fa-broom me-1"></i>Limpar Favoritos
                        </button>
                    </div>

                    <div class="row">
                        <%
                            for (Livro livro : favoritos) {
                        %>
                            <div class="col-lg-4 col-md-6 mb-4" id="favorite-<%=livro.getId()%>">
                                <div class="card h-100">
                                    <div class="position-relative">
                                        <img src="<%=livro.getImagemUrl()%>" class="card-img-top" alt="<%=livro.getTitulo()%>" style="height: 250px; object-fit: cover;">
                                        <button class="btn btn-sm btn-danger position-absolute top-0 end-0 m-2" 
                                                onclick="toggleFavorite(<%=livro.getId()%>)"
                                                title="Remover dos favoritos">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                        <%
                                            if (livro.isTemPromocao()) {
                                        %>
                                            <span class="badge bg-danger position-absolute top-0 start-0 m-2">
                                                -<%=livro.getDesconto()%>%
                                            </span>
                                        <%
                                            }
                                        %>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <h6 class="card-title"><%=livro.getTitulo()%></h6>
                                        <p class="card-text text-muted small"><%=livro.getAutor()%></p>
                                        
                                        <%
                                            if (livro.getSinopse() != null && !livro.getSinopse().trim().isEmpty()) {
                                        %>
                                            <p class="card-text small">
                                                <%=livro.getSinopse().length() > 100 ? livro.getSinopse().substring(0, 100) + "..." : livro.getSinopse()%>
                                            </p>
                                        <%
                                            }
                                        %>
                                        
                                        <!-- Status do Estoque -->
                                        <div class="mb-2">
                                            <%
                                                if (livro.isEmEstoque()) {
                                                    if (livro.isEstoqueBaixo()) {
                                            %>
                                                        <small class="text-warning">
                                                            <i class="fas fa-exclamation-triangle me-1"></i>Últimas unidades
                                                        </small>
                                            <%
                                                    } else {
                                            %>
                                                        <small class="text-success">
                                                            <i class="fas fa-check me-1"></i>Disponível
                                                        </small>
                                            <%
                                                    }
                                                } else {
                                            %>
                                                    <small class="text-danger">
                                                        <i class="fas fa-times me-1"></i>Esgotado
                                                    </small>
                                            <%
                                                }
                                            %>
                                        </div>
                                        
                                        <div class="mt-auto">
                                            <!-- Preço -->
                                            <div class="mb-2">
                                                <%
                                                    if (livro.isTemPromocao()) {
                                                %>
                                                        <div>
                                                            <small class="text-muted text-decoration-line-through"><%=String.format("R$ %.2f", livro.getPreco().doubleValue()).replace(".", ",")%></small>
                                                            <br>
                                                            <strong class="text-danger h6"><%=livro.getPrecoFormatado()%></strong>
                                                        </div>
                                                <%
                                                    } else {
                                                %>
                                                        <strong class="text-primary h6"><%=livro.getPrecoFormatado()%></strong>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            
                                            <!-- Botões de Ação -->
                                            <div class="d-grid gap-2">
                                                <%
                                                    if (livro.isEmEstoque()) {
                                                %>
                                                        <button class="btn btn-primary btn-sm" 
                                                                onclick="addToCart(<%=livro.getId()%>, 1)">
                                                            <i class="fas fa-shopping-cart me-1"></i>Adicionar ao Carrinho
                                                        </button>
                                                <%
                                                    } else {
                                                %>
                                                        <button class="btn btn-secondary btn-sm" disabled>
                                                            <i class="fas fa-ban me-1"></i>Indisponível
                                                        </button>
                                                <%
                                                    }
                                                %>
                                                <a href="${pageContext.request.contextPath}/loja/livro/<%=livro.getId()%>" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    <i class="fas fa-eye me-1"></i>Ver Detalhes
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <%
                            }
                        %>
                    </div>

                    <!-- Paginação -->
                    <%
                        Integer currentPage = (Integer) request.getAttribute("currentPage");
                        Integer totalPages = (Integer) request.getAttribute("totalPages");
                        
                        if (totalPages != null && totalPages > 1) {
                    %>
                        <nav aria-label="Navegação de favoritos">
                            <ul class="pagination justify-content-center">
                                <%
                                    if (currentPage > 1) {
                                %>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=<%=currentPage - 1%>">Anterior</a>
                                        </li>
                                <%
                                    }
                                    
                                    for (int i = 1; i <= totalPages; i++) {
                                        if (i == currentPage) {
                                %>
                                            <li class="page-item active">
                                                <span class="page-link"><%=i%></span>
                                            </li>
                                <%
                                        } else {
                                %>
                                            <li class="page-item">
                                                <a class="page-link" href="?page=<%=i%>"><%=i%></a>
                                            </li>
                                <%
                                        }
                                    }
                                    
                                    if (currentPage < totalPages) {
                                %>
                                        <li class="page-item">
                                            <a class="page-link" href="?page=<%=currentPage + 1%>">Próximo</a>
                                        </li>
                                <%
                                    }
                                %>
                            </ul>
                        </nav>
                    <%
                        }
                    %>
                <%
                    }
                %>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Toggle favorito
        function toggleFavorite(livroId) {
            fetch('${pageContext.request.contextPath}/favorites/toggle/' + livroId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Se removeu dos favoritos, recarregar a página
                    if (!data.data.favorited) {
                        location.reload();
                    } else {
                        // Se adicionou, apenas mostrar mensagem
                        showMessage(data.data.message, 'success');
                    }
                } else {
                    showMessage(data.message || 'Erro ao atualizar favoritos', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao atualizar favoritos', 'error');
            });
        }
        
        // Adicionar ao carrinho
        function addToCart(livroId, quantity) {
            fetch('${pageContext.request.contextPath}/cart/add/' + livroId, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'quantity=' + quantity
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    showMessage('Livro adicionado ao carrinho!', 'success');
                } else {
                    showMessage(data.message || 'Erro ao adicionar ao carrinho', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao adicionar ao carrinho', 'error');
            });
        }
        
        // Limpar todos os favoritos
        function clearFavorites() {
            if (!confirm('Deseja remover todos os livros dos seus favoritos?')) {
                return;
            }
            
            fetch('${pageContext.request.contextPath}/favorites/clear', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.reload();
                } else {
                    showMessage(data.message || 'Erro ao limpar favoritos', 'error');
                }
            })
            .catch(error => {
                console.error('Erro:', error);
                showMessage('Erro ao limpar favoritos', 'error');
            });
        }
        
        // Mostrar mensagem
        function showMessage(message, type) {
            // Criar um toast ou alert simples
            const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
            const alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                     style="top: 20px; right: 20px; z-index: 1050;" role="alert">
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            document.body.insertAdjacentHTML('beforeend', alertHtml);
            
            // Auto-remover após 3 segundos
            setTimeout(() => {
                const alert = document.querySelector('.alert');
                if (alert) {
                    alert.remove();
                }
            }, 3000);
        }
    </script>
</body>
</html>