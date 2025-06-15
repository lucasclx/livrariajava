<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Perfil - Livraria Mil Páginas</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .form-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-section {
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 2rem;
            margin-bottom: 2rem;
        }
        .form-section:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        .password-strength {
            height: 5px;
            border-radius: 3px;
            transition: all 0.3s;
        }
        .strength-weak { background: #dc3545; }
        .strength-medium { background: #ffc107; }
        .strength-strong { background: #198754; }
    </style>
</head>
<body>
    <!-- Header com navegação aqui -->
    
    <div class="page-header">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-2">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/perfil" class="text-white-50">
                            <i class="fas fa-user"></i> Perfil
                        </a>
                    </li>
                    <li class="breadcrumb-item active text-white" aria-current="page">Editar</li>
                </ol>
            </nav>
            <h1 class="h3 mb-0">
                <i class="fas fa-user-edit me-2"></i>Editar Perfil
            </h1>
            <p class="mb-0 opacity-75">Atualize suas informações pessoais e configurações</p>
        </div>
    </div>

    <div class="container my-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="form-card card">
                    <div class="card-body p-4">
                        <!-- Mensagens de Feedback -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Formulário de Dados Pessoais -->
                        <form action="${pageContext.request.contextPath}/perfil/atualizar" method="post" id="profileForm">
                            <div class="form-section">
                                <h5 class="mb-3">
                                    <i class="fas fa-user me-2 text-primary"></i>Informações Pessoais
                                </h5>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="name" class="form-label">Nome Completo *</label>
                                        <input type="text" class="form-control" id="name" name="name" 
                                               value="${user.name}" required maxlength="255">
                                        <div class="invalid-feedback">
                                            Nome é obrigatório e deve ter entre 2 e 255 caracteres.
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="email" class="form-label">E-mail *</label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="${user.email}" required maxlength="255">
                                        <div class="invalid-feedback">
                                            E-mail deve ter um formato válido.
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="telefone" class="form-label">Telefone</label>
                                        <input type="tel" class="form-control" id="telefone" name="telefone" 
                                               value="${user.telefone}" placeholder="(11) 99999-9999">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Formato: (11) 99999-9999
                                        </div>
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="cpf" class="form-label">CPF</label>
                                        <input type="text" class="form-control" id="cpf" name="cpf" 
                                               value="${user.cpf}" placeholder="000.000.000-00">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>
                                            Apenas números ou formato 000.000.000-00
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="data_nascimento" class="form-label">Data de Nascimento</label>
                                       <input type="date" class="form-control" id="data_nascimento" name="data_nascimento" 
       										value="${user.dataNascimento}">
                                    </div>
                                    
                                    <div class="col-md-6 mb-3">
                                        <label for="genero" class="form-label">Gênero</label>
                                        <select class="form-select" id="genero" name="genero">
                                            <option value="">Prefiro não informar</option>
                                            <option value="masculino" ${user.genero == 'masculino' ? 'selected' : ''}>Masculino</option>
                                            <option value="feminino" ${user.genero == 'feminino' ? 'selected' : ''}>Feminino</option>
                                            <option value="outro" ${user.genero == 'outro' ? 'selected' : ''}>Outro</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/perfil" class="btn btn-light">
                                    <i class="fas fa-arrow-left me-2"></i>Voltar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Salvar Alterações
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Formulário de Alteração de Senha -->
                <div class="form-card card mt-4">
                    <div class="card-body p-4">
                        <h5 class="mb-3">
                            <i class="fas fa-lock me-2 text-warning"></i>Alterar Senha
                        </h5>
                        
                        <form action="${pageContext.request.contextPath}/perfil/alterar-senha" method="post" id="passwordForm">
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="senha_atual" class="form-label">Senha Atual *</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="senha_atual" name="senha_atual" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('senha_atual')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nova_senha" class="form-label">Nova Senha *</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="nova_senha" name="nova_senha" required minlength="8">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('nova_senha')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="mt-2">
                                        <div class="password-strength" id="passwordStrength"></div>
                                        <small class="form-text text-muted" id="passwordFeedback">
                                            Mínimo 8 caracteres
                                        </small>
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="nova_senha_confirmation" class="form-label">Confirmar Nova Senha *</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="nova_senha_confirmation" 
                                               name="nova_senha_confirmation" required minlength="8">
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword('nova_senha_confirmation')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">
                                        As senhas não coincidem.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Dicas para uma senha segura:</strong>
                                <ul class="mb-0 mt-2">
                                    <li>Use pelo menos 8 caracteres</li>
                                    <li>Combine letras maiúsculas e minúsculas</li>
                                    <li>Inclua números e caracteres especiais</li>
                                    <li>Evite informações pessoais óbvias</li>
                                </ul>
                            </div>
                            
                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-warning">
                                    <i class="fas fa-key me-2"></i>Alterar Senha
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Configurações de Privacidade -->
                <div class="form-card card mt-4">
                    <div class="card-body p-4">
                        <h5 class="mb-3">
                            <i class="fas fa-shield-alt me-2 text-success"></i>Privacidade e Segurança
                        </h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="d-flex justify-content-between align-items-center py-2">
                                    <div>
                                        <div class="fw-bold">E-mail verificado</div>
                                        <small class="text-muted">Seu e-mail foi verificado</small>
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${user.emailVerified}">
                                                <span class="badge bg-success">
                                                    <i class="fas fa-check me-1"></i>Verificado
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="btn btn-sm btn-outline-warning">
                                                    <i class="fas fa-envelope me-1"></i>Verificar
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <div class="d-flex justify-content-between align-items-center py-2">
                                    <div>
                                        <div class="fw-bold">Último login</div>
                                        <small class="text-muted">
                                            <c:choose>
                                                <c:when test="${user.lastLoginAt != null}">
                                                    <fmt:formatDate value="${user.lastLoginAt}" pattern="dd/MM/yyyy 'às' HH:mm" />
                                                </c:when>
                                                <c:otherwise>
                                                    Primeiro acesso
                                                </c:otherwise>
                                            </c:choose>
                                        </small>
                                    </div>
                                    <div>
                                        <i class="fas fa-clock text-muted"></i>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="d-flex justify-content-between align-items-center py-2">
                                    <div>
                                        <div class="fw-bold">Conta criada em</div>
                                        <small class="text-muted">
                                            <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                        </small>
                                    </div>
                                    <div>
                                        <i class="fas fa-user-plus text-muted"></i>
                                    </div>
                                </div>
                                
                                <hr>
                                
                                <div class="d-flex justify-content-between align-items-center py-2">
                                    <div>
                                        <div class="fw-bold text-danger">Excluir conta</div>
                                        <small class="text-muted">Ação irreversível</small>
                                    </div>
                                    <div>
                                        <button class="btn btn-sm btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
                                            <i class="fas fa-trash me-1"></i>Excluir
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal de Confirmação de Exclusão -->
    <div class="modal fade" id="deleteAccountModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Excluir Conta
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="alert alert-danger">
                        <i class="fas fa-warning me-2"></i>
                        <strong>Atenção!</strong> Esta ação é irreversível.
                    </div>
                    
                    <p>Ao excluir sua conta:</p>
                    <ul>
                        <li>Todos os seus dados pessoais serão removidos</li>
                        <li>Seu histórico de pedidos será anonimizado</li>
                        <li>Você perderá acesso a favoritos e avaliações</li>
                        <li>Não será possível recuperar a conta</li>
                    </ul>
                    
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Digite sua senha para confirmar:</label>
                        <input type="password" class="form-control" id="confirmPassword" required>
                    </div>
                    
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="confirmDelete">
                        <label class="form-check-label" for="confirmDelete">
                            Entendo que esta ação é irreversível
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cancelar
                    </button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn" disabled>
                        <i class="fas fa-trash me-2"></i>Excluir Conta
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Validação do formulário
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();

        // Toggle password visibility
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const button = field.nextElementSibling.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                button.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                field.type = 'password';
                button.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        // Validação de senha em tempo real
        document.getElementById('nova_senha').addEventListener('input', function() {
            const password = this.value;
            const strengthBar = document.getElementById('passwordStrength');
            const feedback = document.getElementById('passwordFeedback');
            
            let strength = 0;
            let messages = [];
            
            if (password.length >= 8) strength++;
            else messages.push('Mínimo 8 caracteres');
            
            if (/[a-z]/.test(password)) strength++;
            else messages.push('Letras minúsculas');
            
            if (/[A-Z]/.test(password)) strength++;
            else messages.push('Letras maiúsculas');
            
            if (/[0-9]/.test(password)) strength++;
            else messages.push('Números');
            
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            else messages.push('Caracteres especiais');
            
            // Atualizar barra de força
            strengthBar.style.width = (strength * 20) + '%';
            
            if (strength < 3) {
                strengthBar.className = 'password-strength strength-weak';
                feedback.textContent = 'Fraca: ' + messages.join(', ');
                feedback.className = 'form-text text-danger';
            } else if (strength < 5) {
                strengthBar.className = 'password-strength strength-medium';
                feedback.textContent = 'Média: ' + (messages.length > 0 ? messages.join(', ') : 'Boa senha');
                feedback.className = 'form-text text-warning';
            } else {
                strengthBar.className = 'password-strength strength-strong';
                feedback.textContent = 'Forte: Senha segura';
                feedback.className = 'form-text text-success';
            }
        });

        // Validação de confirmação de senha
        document.getElementById('nova_senha_confirmation').addEventListener('input', function() {
            const password = document.getElementById('nova_senha').value;
            const confirmation = this.value;
            
            if (password !== confirmation) {
                this.setCustomValidity('As senhas não coincidem');
                this.classList.add('is-invalid');
            } else {
                this.setCustomValidity('');
                this.classList.remove('is-invalid');
                this.classList.add('is-valid');
            }
        });

        // Formatação de telefone
        document.getElementById('telefone').addEventListener('input', function() {
            let value = this.value.replace(/\D/g, '');
            
            if (value.length <= 11) {
                if (value.length <= 2) {
                    value = value.replace(/(\d{0,2})/, '($1');
                } else if (value.length <= 6) {
                    value = value.replace(/(\d{2})(\d{0,4})/, '($1) $2');
                } else if (value.length <= 10) {
                    value = value.replace(/(\d{2})(\d{4})(\d{0,4})/, '($1) $2-$3');
                } else {
                    value = value.replace(/(\d{2})(\d{5})(\d{0,4})/, '($1) $2-$3');
                }
            }
            
            this.value = value;
        });

        // Formatação de CPF
        document.getElementById('cpf').addEventListener('input', function() {
            let value = this.value.replace(/\D/g, '');
            
            if (value.length <= 11) {
                value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
            }
            
            this.value = value;
        });

        // Validação de e-mail em tempo real
        document.getElementById('email').addEventListener('blur', function() {
            const email = this.value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (email && !emailRegex.test(email)) {
                this.setCustomValidity('E-mail deve ter um formato válido');
                this.classList.add('is-invalid');
            } else {
                this.setCustomValidity('');
                this.classList.remove('is-invalid');
                if (email) this.classList.add('is-valid');
            }
        });

        // Modal de exclusão de conta
        const confirmPassword = document.getElementById('confirmPassword');
        const confirmDelete = document.getElementById('confirmDelete');
        const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

        function checkDeleteConfirmation() {
            confirmDeleteBtn.disabled = !(confirmPassword.value && confirmDelete.checked);
        }

        confirmPassword.addEventListener('input', checkDeleteConfirmation);
        confirmDelete.addEventListener('change', checkDeleteConfirmation);

        confirmDeleteBtn.addEventListener('click', function() {
            if (confirm('Tem certeza absoluta que deseja excluir sua conta? Esta ação não pode ser desfeita.')) {
                // Aqui faria a requisição para excluir a conta
                alert('Funcionalidade de exclusão será implementada em breve.');
            }
        });

        // Auto-save em caso de mudanças não salvas
        let formChanged = false;
        const profileForm = document.getElementById('profileForm');
        const originalFormData = new FormData(profileForm);

        profileForm.addEventListener('input', function() {
            formChanged = true;
        });

        window.addEventListener('beforeunload', function(e) {
            if (formChanged) {
                e.preventDefault();
                e.returnValue = 'Você tem alterações não salvas. Deseja realmente sair?';
                return e.returnValue;
            }
        });

        profileForm.addEventListener('submit', function() {
            formChanged = false;
        });

        // Mensagens de feedback automático
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const closeBtn = alert.querySelector('.btn-close');
                if (closeBtn) {
                    setTimeout(function() {
                        closeBtn.click();
                    }, 5000);
                }
            });
        }, 100);
    </script>
</body>
</html>