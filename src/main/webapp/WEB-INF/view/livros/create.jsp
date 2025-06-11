<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cadastrar Novo Livro - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <!-- Include Header/Navigation -->
        <jsp:include page="/WEB-INF/views/layouts/admin-header.jsp" />
        
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header">
                        <h4><i class="fas fa-plus"></i> Cadastrar Novo Livro</h4>
                    </div>
                    <div class="card-body">
                        <!-- Exibir erros de validação -->
                        <c:if test="${not empty errors}">
                            <div class="alert alert-danger">
                                <h6><i class="fas fa-exclamation-triangle"></i> Corrija os seguintes erros:</h6>
                                <ul class="mb-0">
                                    <c:forEach var="error" items="${errors}">
                                        <li>${error}</li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/livros/store" method="POST" 
                              enctype="multipart/form-data" id="livroForm">
                            
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label class="form-label">Título *</label>
                                    <input type="text" name="titulo" class="form-control ${not empty errors ? 'is-invalid' : ''}" 
                                           value="${param.titulo}" required maxlength="500"
                                           placeholder="Digite o título do livro">
                                    <div class="form-text">Máximo 500 caracteres</div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Categoria</label>
                                    <select name="categoria_id" class="form-select">
                                        <option value="">Selecionar categoria</option>
                                        <c:forEach var="categoria" items="${categorias}">
                                            <option value="${categoria.id}" 
                                                    ${param.categoria_id == categoria.id ? 'selected' : ''}>
                                                ${categoria.nome}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="form-text">
                                        <a href="${pageContext.request.contextPath}/categorias/create" target="_blank">
                                            <i class="fas fa-plus"></i> Criar nova categoria
                                        </a>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Autor *</label>
                                    <input type="text" name="autor" class="form-control" 
                                           value="${param.autor}" required maxlength="255"
                                           placeholder="Nome do autor"
                                           list="autores-list">
                                    <datalist id="autores-list">
                                        <c:forEach var="autor" items="${autores}">
                                            <option value="${autor}">
                                        </c:forEach>
                                    </datalist>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Editora</label>
                                    <input type="text" name="editora" class="form-control" 
                                           value="${param.editora}" maxlength="255"
                                           placeholder="Nome da editora"
                                           list="editoras-list">
                                    <datalist id="editoras-list">
                                        <c:forEach var="editora" items="${editoras}">
                                            <option value="${editora}">
                                        </c:forEach>
                                    </datalist>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">ISBN</label>
                                    <input type="text" name="isbn" class="form-control" 
                                           value="${param.isbn}" maxlength="20"
                                           placeholder="978-XX-XXXX-XXX-X"
                                           pattern="[0-9\-X]*">
                                    <div class="form-text">Formato: 978-XX-XXXX-XXX-X</div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Ano de Publicação</label>
                                    <input type="number" name="ano_publicacao" class="form-control" 
                                           value="${param.ano_publicacao}" 
                                           min="1900" max="${currentYear + 1}"
                                           placeholder="2024">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Páginas</label>
                                    <input type="number" name="paginas" class="form-control" 
                                           value="${param.paginas}" min="1"
                                           placeholder="300">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Preço *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">R$</span>
                                        <input type="number" step="0.01" name="preco" class="form-control" 
                                               value="${param.preco}" required min="0" max="9999.99"
                                               placeholder="29.90">
                                    </div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Preço Promocional</label>
                                    <div class="input-group">
                                        <span class="input-group-text">R$</span>
                                        <input type="number" step="0.01" name="preco_promocional" class="form-control" 
                                               value="${param.preco_promocional}" min="0" max="9999.99"
                                               placeholder="24.90">
                                    </div>
                                    <div class="form-text">Deixe vazio se não houver promoção</div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Estoque *</label>
                                    <input type="number" name="estoque" class="form-control" 
                                           value="${param.estoque != null ? param.estoque : '0'}" 
                                           required min="0" placeholder="10">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Estoque Mínimo</label>
                                    <input type="number" name="estoque_minimo" class="form-control" 
                                           value="${param.estoque_minimo != null ? param.estoque_minimo : '5'}" 
                                           min="0" placeholder="5">
                                    <div class="form-text">Alerta quando estoque atingir este valor</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Peso (kg)</label>
                                    <input type="number" step="0.001" name="peso" class="form-control" 
                                           value="${param.peso != null ? param.peso : '0.5'}" 
                                           min="0" placeholder="0.5">
                                    <div class="form-text">Para cálculo de frete</div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Sinopse</label>
                                <textarea name="sinopse" class="form-control" rows="4" maxlength="5000"
                                          placeholder="Breve descrição do livro...">${param.sinopse}</textarea>
                                <div class="form-text">
                                    <span id="sinopseCount">0</span>/5000 caracteres
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Imagem do Livro</label>
                                <input type="file" name="imagem" class="form-control" 
                                       accept="image/*" onchange="previewImage(this, 'preview-image')">
                                <div class="form-text">
                                    Formatos aceitos: JPG, PNG, GIF, WEBP. Tamanho máximo: 5MB
                                </div>
                                
                                <div class="mt-2">
                                    <img id="preview-image" src="#" alt="Preview" 
                                         style="display: none; max-width: 200px; max-height: 200px; border-radius: 5px; border: 1px solid #ddd;">
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" name="ativo" id="ativo" class="form-check-input" 
                                               ${param.ativo != 'false' ? 'checked' : ''}>
                                        <label for="ativo" class="form-check-label">
                                            <strong>Livro Ativo</strong>
                                        </label>
                                        <div class="form-text">Livro aparecerá na loja se ativo</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="form-check">
                                        <input type="checkbox" name="destaque" id="destaque" class="form-check-input" 
                                               ${param.destaque == 'true' ? 'checked' : ''}>
                                        <label for="destaque" class="form-check-label">
                                            <strong>Livro em Destaque</strong>
                                        </label>
                                        <div class="form-text">Aparecerá na seção de destaques</div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end gap-2">
                                <a href="${pageContext.request.contextPath}/livros" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left"></i> Voltar
                                </a>
                                <button type="button" class="btn btn-outline-primary" onclick="previewLivro()">
                                    <i class="fas fa-eye"></i> Visualizar
                                </button>
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save"></i> Cadastrar Livro
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de Preview -->
    <div class="modal fade" id="previewModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Preview do Livro</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="previewContent">
                    <!-- Conteúdo será preenchido via JavaScript -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                    <button type="button" class="btn btn-success" onclick="submitForm()">
                        <i class="fas fa-save"></i> Confirmar e Salvar
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Preview da imagem
        function previewImage(input, previewId) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById(previewId).src = e.target.result;
                    document.getElementById(previewId).style.display = 'block';
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        // Contador de caracteres da sinopse
        document.addEventListener('DOMContentLoaded', function() {
            const sinopseTextarea = document.querySelector('textarea[name="sinopse"]');
            const counter = document.getElementById('sinopseCount');
            
            function updateCounter() {
                const count = sinopseTextarea.value.length;
                counter.textContent = count;
                
                if (count > 4500) {
                    counter.style.color = 'red';
                } else if (count > 4000) {
                    counter.style.color = 'orange';
                } else {
                    counter.style.color = 'inherit';
                }
            }
            
            sinopseTextarea.addEventListener('input', updateCounter);
            updateCounter(); // Inicializar contador
        });

        // Validação de preços
        document.querySelector('input[name="preco_promocional"]').addEventListener('input', function() {
            const precoNormal = parseFloat(document.querySelector('input[name="preco"]').value) || 0;
            const precoPromocional = parseFloat(this.value) || 0;
            
            if (precoPromocional > 0 && precoPromocional >= precoNormal) {
                this.setCustomValidity('Preço promocional deve ser menor que o preço normal');
            } else {
                this.setCustomValidity('');
            }
        });

        // Preview do livro
        function previewLivro() {
            const form = document.getElementById('livroForm');
            const formData = new FormData(form);
            
            // Criar HTML do preview
            let previewHtml = `
                <div class="row">
                    <div class="col-md-4">
                        <div class="text-center">
            `;
            
            const imageFile = document.querySelector('input[name="imagem"]').files[0];
            if (imageFile) {
                const imageUrl = URL.createObjectURL(imageFile);
                previewHtml += `<img src="${imageUrl}" class="img-fluid rounded" style="max-height: 300px;">`;
            } else {
                previewHtml += `<div class="bg-light p-5 rounded"><i class="fas fa-book fa-4x text-muted"></i><p class="mt-2 text-muted">Sem imagem</p></div>`;
            }
            
            previewHtml += `
                        </div>
                    </div>
                    <div class="col-md-8">
                        <h4>${formData.get('titulo') || 'Título não informado'}</h4>
                        <p><strong>Autor:</strong> ${formData.get('autor') || 'Não informado'}</p>
                        <p><strong>Editora:</strong> ${formData.get('editora') || 'Não informado'}</p>
                        <p><strong>ISBN:</strong> ${formData.get('isbn') || 'Não informado'}</p>
                        <p><strong>Ano:</strong> ${formData.get('ano_publicacao') || 'Não informado'}</p>
                        <p><strong>Páginas:</strong> ${formData.get('paginas') || 'Não informado'}</p>
                        
                        <div class="mb-3">
                            <strong>Preço:</strong>
            `;
            
            const preco = parseFloat(formData.get('preco')) || 0;
            const precoPromocional = parseFloat(formData.get('preco_promocional')) || 0;
            
            if (precoPromocional > 0 && precoPromocional < preco) {
                previewHtml += `
                    <span class="text-decoration-line-through text-muted">R$ ${preco.toFixed(2).replace('.', ',')}</span>
                    <span class="text-danger h5 ms-2">R$ ${precoPromocional.toFixed(2).replace('.', ',')}</span>
                    <span class="badge bg-danger ms-2">Promoção</span>
                `;
            } else {
                previewHtml += `<span class="h5 text-success">R$ ${preco.toFixed(2).replace('.', ',')}</span>`;
            }
            
            previewHtml += `
                        </div>
                        
                        <p><strong>Estoque:</strong> ${formData.get('estoque')} unidades</p>
                        <p><strong>Peso:</strong> ${formData.get('peso')} kg</p>
                        
                        <div class="mb-3">
            `;
            
            if (formData.get('ativo') === 'on') {
                previewHtml += `<span class="badge bg-success me-2">Ativo</span>`;
            } else {
                previewHtml += `<span class="badge bg-danger me-2">Inativo</span>`;
            }
            
            if (formData.get('destaque') === 'on') {
                previewHtml += `<span class="badge bg-warning">Destaque</span>`;
            }
            
            previewHtml += `
                        </div>
                    </div>
                </div>
            `;
            
            const sinopse = formData.get('sinopse');
            if (sinopse) {
                previewHtml += `
                    <hr>
                    <h5>Sinopse</h5>
                    <p>${sinopse}</p>
                `;
            }
            
            document.getElementById('previewContent').innerHTML = previewHtml;
            
            const modal = new bootstrap.Modal(document.getElementById('previewModal'));
            modal.show();
        }

        // Submeter formulário
        function submitForm() {
            document.getElementById('livroForm').submit();
        }

        // Validação do formulário
        document.getElementById('livroForm').addEventListener('submit', function(e) {
            const titulo = document.querySelector('input[name="titulo"]').value.trim();
            const autor = document.querySelector('input[name="autor"]').value.trim();
            const preco = parseFloat(document.querySelector('input[name="preco"]').value) || 0;
            
            if (!titulo) {
                e.preventDefault();
                alert('Título é obrigatório');
                document.querySelector('input[name="titulo"]').focus();
                return;
            }
            
            if (!autor) {
                e.preventDefault();
                alert('Autor é obrigatório');
                document.querySelector('input[name="autor"]').focus();
                return;
            }
            
            if (preco <= 0) {
                e.preventDefault();
                alert('Preço deve ser maior que zero');
                document.querySelector('input[name="preco"]').focus();
                return;
            }
            
            // Mostrar loading
            const submitBtn = document.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Salvando...';
            submitBtn.disabled = true;
            
            // Se chegou até aqui, o formulário é válido
            // O loading será removido quando a página recarregar
        });

        // Auto-complete do ISBN
        document.querySelector('input[name="isbn"]').addEventListener('input', function() {
            let isbn = this.value.replace(/[^0-9X]/g, '');
            
            // Formatar ISBN automaticamente
            if (isbn.length >= 3) {
                if (isbn.length <= 12) {
                    // ISBN-10 format
                    isbn = isbn.replace(/(\d{3})(\d{0,7})(\d{0,3})(\d{0,1})/, '$1-$2-$3-$4');
                } else {
                    // ISBN-13 format
                    isbn = isbn.replace(/(\d{3})(\d{0,1})(\d{0,5})(\d{0,7})(\d{0,1})/, '$1-$2-$3-$4-$5');
                }
                isbn = isbn.replace(/-+$/, ''); // Remove trailing dashes
                this.value = isbn;
            }
        });

        // Sugestões de categoria baseadas no título
        document.querySelector('input[name="titulo"]').addEventListener('input', function() {
            const titulo = this.value.toLowerCase();
            const categoriaSelect = document.querySelector('select[name="categoria_id"]');
            
            // Sugestões baseadas em palavras-chave
            const sugestoes = {
                'programação': 'Técnico',
                'java': 'Técnico',
                'javascript': 'Técnico',
                'python': 'Técnico',
                'romance': 'Ficção',
                'amor': 'Ficção',
                'história': 'História',
                'infantil': 'Infantil',
                'criança': 'Infantil',
                'autoajuda': 'Autoajuda',
                'motivação': 'Autoajuda',
                'arte': 'Arte',
                'música': 'Arte',
                'ciência': 'Ciência',
                'física': 'Ciência',
                'matemática': 'Ciência'
            };
            
            for (const [palavra, categoria] of Object.entries(sugestoes)) {
                if (titulo.includes(palavra)) {
                    // Selecionar categoria se encontrada
                    for (const option of categoriaSelect.options) {
                        if (option.text === categoria) {
                            categoriaSelect.value = option.value;
                            categoriaSelect.style.backgroundColor = '#e7f3ff';
                            setTimeout(() => {
                                categoriaSelect.style.backgroundColor = '';
                            }, 2000);
                            break;
                        }
                    }
                    break;
                }
            }
        });

        // Validação de arquivo de imagem
        document.querySelector('input[name="imagem"]').addEventListener('change', function() {
            const file = this.files[0];
            if (file) {
                // Verificar tamanho (5MB = 5242880 bytes)
                if (file.size > 5242880) {
                    alert('Arquivo muito grande. Tamanho máximo: 5MB');
                    this.value = '';
                    document.getElementById('preview-image').style.display = 'none';
                    return;
                }
                
                // Verificar tipo
                const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
                if (!allowedTypes.includes(file.type)) {
                    alert('Tipo de arquivo não permitido. Use: JPG, PNG, GIF ou WEBP');
                    this.value = '';
                    document.getElementById('preview-image').style.display = 'none';
                    return;
                }
            }
        });

        // Salvar rascunho no localStorage
        function salvarRascunho() {
            const form = document.getElementById('livroForm');
            const formData = new FormData(form);
            const rascunho = {};
            
            for (const [key, value] of formData.entries()) {
                if (key !== 'imagem') { // Não salvar arquivo
                    rascunho[key] = value;
                }
            }
            
            localStorage.setItem('livroRascunho', JSON.stringify(rascunho));
        }

        // Carregar rascunho do localStorage
        function carregarRascunho() {
            const rascunho = localStorage.getItem('livroRascunho');
            if (rascunho) {
                const dados = JSON.parse(rascunho);
                
                for (const [key, value] of Object.entries(dados)) {
                    const field = document.querySelector(`[name="${key}"]`);
                    if (field) {
                        if (field.type === 'checkbox') {
                            field.checked = value === 'on';
                        } else {
                            field.value = value;
                        }
                    }
                }
                
                // Perguntar se quer usar o rascunho
                if (confirm('Encontramos um rascunho salvo. Deseja carregá-lo?')) {
                    // Rascunho já foi carregado
                } else {
                    localStorage.removeItem('livroRascunho');
                    location.reload();
                }
            }
        }

        // Salvar rascunho automaticamente
        document.addEventListener('DOMContentLoaded', function() {
            carregarRascunho();
            
            // Salvar a cada 30 segundos
            setInterval(salvarRascunho, 30000);
            
            // Salvar quando sair da página
            window.addEventListener('beforeunload', salvarRascunho);
            
            // Limpar rascunho quando enviar formulário
            document.getElementById('livroForm').addEventListener('submit', function() {
                localStorage.removeItem('livroRascunho');
            });
        });
    </script>
    
    <style>
        .preview-image {
            transition: all 0.3s ease;
        }
        
        .preview-image:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        
        .form-control:focus {
            border-color: #8B4513;
            box-shadow: 0 0 0 0.2rem rgba(139, 69, 19, 0.25);
        }
        
        .btn-success {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
        }
        
        .btn-success:hover {
            background: linear-gradient(135deg, #20c997 0%, #28a745 100%);
            transform: translateY(-1px);
        }
        
        .card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border: none;
            border-radius: 15px;
        }
        
        .form-text {
            font-size: 0.8rem;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
        }
        
        .modal-content {
            border-radius: 15px;
        }
        
        @media (max-width: 768px) {
            .container-fluid {
                padding: 1rem;
            }
            
            .card-body {
                padding: 1rem;
            }
        }
    </style>
</body>
</html>