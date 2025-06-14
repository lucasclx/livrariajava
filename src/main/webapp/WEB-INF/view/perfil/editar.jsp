<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.livraria.models.User" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Perfil - Livraria Mil Páginas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <%
        User user = (User) request.getAttribute("user");
        String dataFormatada = (String) request.getAttribute("dataFormatada");
        
        // Mensagens de sucesso/erro
        String successMessage = (String) session.getAttribute("success");
        String errorMessage = (String) session.getAttribute("error");
        session.removeAttribute("success");
        session.removeAttribute("error");
    %>

    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2><i class="fas fa-user-edit me-2"></i>Editar Perfil</h2>
                    <a href="${pageContext.request.contextPath}/perfil" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Voltar ao Perfil
                    </a>
                </div>

                <!-- Mensagens -->
                <% if (successMessage != null) { %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i><%=successMessage%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <% if (errorMessage != null) { %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i><%=errorMessage%>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Tabs -->
                <ul class="nav nav-tabs" id="profileTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="dados-tab" data-bs-toggle="tab" data-bs-target="#dados" type="button" role="tab">
                            <i class="fas fa-user me-1"></i>Dados Pessoais
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="senha-tab" data-bs-toggle="tab" data-bs-target="#senha" type="button" role="tab">
                            <i class="fas fa-lock me-1"></i>Alterar Senha
                        </button>
                    </li>
                </ul>

                <div class="tab-content" id="profileTabsContent">
                    <!-- Tab Dados Pessoais -->
                    <div class="tab-pane fade show active" id="dados" role="tabpanel">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/perfil/atualizar" method="post" id="formDados">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="name" class="form-label">Nome Completo *</label>
                                                <input type="text" class="form-control" id="name" name="name" 
                                                       value="<%=user.getName() != null ? user.getName() : ""%>" 
                                                       required maxlength="255">
                                                <div class="form-text">Mínimo 2 caracteres</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="email" class="form-label">E-mail *</label>
                                                <input type="email" class="form-control" id="email" name="email" 
                                                       value="<%=user.getEmail() != null ? user.getEmail() : ""%>" 
                                                       required maxlength="255">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="telefone" class="form-label">Telefone</label>
                                                <input type="tel" class="form-control" id="telefone" name="telefone" 
                                                       value="<%=user.getTelefone() != null ? user.getTelefone() : ""%>" 
                                                       placeholder="(11) 99999-9999">
                                                <div class="form-text">Formato: (XX) XXXXX-XXXX</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="data_nascimento" class="form-label">Data de Nascimento</label>
                                                <input type="date" class="form-control" id="data_nascimento" name="data_nascimento" 
                                                       value="<%=dataFormatada != null ? dataFormatada : ""%>">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="genero" class="form-label">Gênero</label>
                                                <select class="form-select" id="genero" name="genero">
                                                    <option value="">Selecione...</option>
                                                    <option value="M" <%="M".equals(user.getGenero()) ? "selected" : ""%>>Masculino</option>
                                                    <option value="F" <%="F".equals(user.getGenero()) ? "selected" : ""%>>Feminino</option>
                                                    <option value="O" <%="O".equals(user.getGenero()) ? "selected" : ""%>>Outro</option>
                                                    <option value="N" <%="N".equals(user.getGenero()) ? "selected" : ""%>>Prefiro não informar</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="button" class="btn btn-outline-secondary me-md-2" onclick="resetForm()">
                                            <i class="fas fa-undo me-1"></i>Cancelar
                                        </button>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>Salvar Alterações
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- Tab Alterar Senha -->
                    <div class="tab-pane fade" id="senha" role="tabpanel">
                        <div class="card">
                            <div class="card-body">
                                <form action="${pageContext.request.contextPath}/perfil/alterar-senha" method="post" id="formSenha">
                                    <div class="mb-3">
                                        <label for="senha_atual" class="form-label">Senha Atual *</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="senha_atual" name="senha_atual" required>
                                            <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('senha_atual')">
                                                <i class="fas fa-eye" id="senha_atual_icon"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="nova_senha" class="form-label">Nova Senha *</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="nova_senha" name="nova_senha" 
                                                   required minlength="8" onkeyup="checkPasswordStrength()">
                                            <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('nova_senha')">
                                                <i class="fas fa-eye" id="nova_senha_icon"></i>
                                            </button>
                                        </div>
                                        <div class="form-text">Mínimo 8 caracteres</div>
                                        <div id="password_strength" class="mt-2"></div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="nova_senha_confirmation" class="form-label">Confirmar Nova Senha *</label>
                                        <div class="input-group">
                                            <input type="password" class="form-control" id="nova_senha_confirmation" 
                                                   name="nova_senha_confirmation" required minlength="8" onkeyup="checkPasswordMatch()">
                                            <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('nova_senha_confirmation')">
                                                <i class="fas fa-eye" id="nova_senha_confirmation_icon"></i>
                                            </button>
                                        </div>
                                        <div id="password_match" class="mt-2"></div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="button" class="btn btn-outline-secondary me-md-2" onclick="resetPasswordForm()">
                                            <i class="fas fa-undo me-1"></i>Cancelar
                                        </button>
                                        <button type="submit" class="btn btn-warning" id="btnAlterarSenha" disabled>
                                            <i class="fas fa-key me-1"></i>Alterar Senha
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Toggle mostrar/ocultar senha
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = document.getElementById(fieldId + '_icon');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                field.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Verificar força da senha
        function checkPasswordStrength() {
            const password = document.getElementById('nova_senha').value;
            const strengthDiv = document.getElementById('password_strength');
            
            if (password.length === 0) {
                strengthDiv.innerHTML = '';
                return;
            }
            
            let score = 0;
            let feedback = [];
            
            // Critérios de força
            if (password.length >= 8) score++;
            else feedback.push('Pelo menos 8 caracteres');
            
            if (/[a-z]/.test(password)) score++;
            else feedback.push('Letras minúsculas');
            
            if (/[A-Z]/.test(password)) score++;
            else feedback.push('Letras maiúsculas');
            
            if (/[0-9]/.test(password)) score++;
            else feedback.push('Números');
            
            if (/[^A-Za-z0-9]/.test(password)) score++;
            else feedback.push('Caracteres especiais');
            
            // Determinar nível
            let level, color, message;
            if (score <= 2) {
                level = 'Fraca';
                color = 'danger';
                message = 'Adicione: ' + feedback.slice(0, 2).join(', ');
            } else if (score <= 3) {
                level = 'Média';
                color = 'warning';
                message = 'Adicione: ' + feedback.slice(0, 1).join(', ');
            } else if (score <= 4) {
                level = 'Boa';
                color = 'info';
                message = 'Quase lá!';
            } else {
                level = 'Forte';
                color = 'success';
                message = 'Senha segura';
            }
            
            strengthDiv.innerHTML = `
                <div class="text-${color}">
                    <small><strong>Força: ${level}</strong> - ${message}</small>
                </div>
            `;
            
            checkPasswordMatch();
        }

        // Verificar se senhas coincidem
        function checkPasswordMatch() {
            const password = document.getElementById('nova_senha').value;
            const confirm = document.getElementById('nova_senha_confirmation').value;
            const matchDiv = document.getElementById('password_match');
            const btnSubmit = document.getElementById('btnAlterarSenha');
            
            if (confirm.length === 0) {
                matchDiv.innerHTML = '';
                btnSubmit.disabled = true;
                return;
            }
            
            if (password === confirm && password.length >= 8) {
                matchDiv.innerHTML = '<small class="text-success"><i class="fas fa-check me-1"></i>Senhas coincidem</small>';
                btnSubmit.disabled = false;
            } else {
                matchDiv.innerHTML = '<small class="text-danger"><i class="fas fa-times me-1"></i>Senhas não coincidem</small>';
                btnSubmit.disabled = true;
            }
        }

        // Reset form dados
        function resetForm() {
            document.getElementById('formDados').reset();
        }

        // Reset form senha
        function resetPasswordForm() {
            document.getElementById('formSenha').reset();
            document.getElementById('password_strength').innerHTML = '';
            document.getElementById('password_match').innerHTML = '';
            document.getElementById('btnAlterarSenha').disabled = true;
        }

        // Máscara de telefone
        document.getElementById('telefone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            
            if (value.length >= 11) {
                value = value.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
            } else if (value.length >= 7) {
                value = value.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
            } else if (value.length >= 3) {
                value = value.replace(/(\d{2})(\d{0,5})/, '($1) $2');
            }
            
            e.target.value = value;
        });

        // Validação do formulário principal
        document.getElementById('formDados').addEventListener('submit', function(e) {
            const name = document.getElementById('name').value;
            const email = document.getElementById('email').value;
            
            if (name.length < 2) {
                e.preventDefault();
                alert('Nome deve ter pelo menos 2 caracteres');
                return;
            }
            
            if (!email.includes('@')) {
                e.preventDefault();
                alert('E-mail inválido');
                return;
            }
        });

        // Validação do formulário de senha
        document.getElementById('formSenha').addEventListener('submit', function(e) {
            const senhaAtual = document.getElementById('senha_atual').value;
            const novaSenha = document.getElementById('nova_senha').value;
            const confirmacao = document.getElementById('nova_senha_confirmation').value;
            
            if (senhaAtual.length === 0) {
                e.preventDefault();
                alert('Informe a senha atual');
                return;
            }
            
            if (novaSenha.length < 8) {
                e.preventDefault();
                alert('Nova senha deve ter pelo menos 8 caracteres');
                return;
            }
            
            if (novaSenha !== confirmacao) {
                e.preventDefault();
                alert('Confirmação de senha não confere');
                return;
            }
        });
    </script>
</body>
</html>