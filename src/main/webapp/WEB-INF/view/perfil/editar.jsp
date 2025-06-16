<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="pageTitle" value="Editar Perfil" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
    <style>
        .profile-hero {
            background: linear-gradient(135deg, var(--dark-brown) 0%, var(--primary-brown) 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .form-card {
            background: rgba(253, 246, 227, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(139, 69, 19, 0.2);
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(139, 69, 19, 0.1);
            overflow: hidden;
        }
        
        .form-section {
            background: white;
            padding: 2rem;
            margin: -1px;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        
        .section-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.75rem;
            font-size: 1.2rem;
        }
        
        .form-label {
            color: var(--dark-brown);
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .form-control, .form-select {
            border: 2px solid rgba(139, 69, 19, 0.2);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--gold);
            box-shadow: 0 0 0 0.2rem rgba(218, 165, 32, 0.25);
        }
        
        .input-group-text {
            background: var(--aged-paper);
            border: 2px solid rgba(139, 69, 19, 0.2);
            border-right: none;
            color: var(--dark-brown);
        }
        
        .input-group .form-control {
            border-left: none;
        }
        
        .password-strength {
            height: 6px;
            border-radius: 3px;
            transition: all 0.3s ease;
            margin-top: 0.5rem;
        }
        
        .strength-weak { background: linear-gradient(90deg, #dc3545 0%, #dc3545 33%, #e9ecef 33%); }
        .strength-medium { background: linear-gradient(90deg, #ffc107 0%, #ffc107 66%, #e9ecef 66%); }
        .strength-strong { background: linear-gradient(90deg, #198754 0%, #198754 100%); }
        
        .alert-custom {
            border-radius: 15px;
            border: none;
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .alert-success {
            background: linear-gradient(135deg, rgba(34, 139, 34, 0.1) 0%, rgba(34, 139, 34, 0.05) 100%);
            color: var(--forest-green);
            border-left: 4px solid var(--forest-green);
        }
        
        .alert-danger {
            background: linear-gradient(135deg, rgba(128, 0, 32, 0.1) 0%, rgba(128, 0, 32, 0.05) 100%);
            color: var(--burgundy);
            border-left: 4px solid var(--burgundy);
        }
        
        .privacy-card {
            background: rgba(245, 245, 220, 0.5);
            border: 1px solid rgba(139, 69, 19, 0.1);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }
        
        .privacy-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(139, 69, 19, 0.1);
        }
        
        .privacy-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid rgba(139, 69, 19, 0.1);
        }
        
        .privacy-item:last-child {
            border-bottom: none;
        }
        
        .btn-delete {
            background: linear-gradient(135deg, var(--burgundy) 0%, #a00025 100%);
            color: white;
            border: none;
        }
        
        .btn-delete:hover {
            background: linear-gradient(135deg, #a00025 0%, var(--burgundy) 100%);
            color: white;
            transform: translateY(-2px);
        }
        
        .breadcrumb {
            background: transparent;
            padding: 0;
            margin-bottom: 1rem;
        }
        
        .breadcrumb-item a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
        }
        
        .breadcrumb-item.active {
            color: white;
        }
    </style>
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <!-- Hero Section -->
    <section class="profile-hero">
        <div class="container">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/"><i class="fas fa-home"></i> Início</a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/perfil">Meu Perfil</a>
                    </li>
                    <li class="breadcrumb-item active" aria-current="page">Editar</li>
                </ol>
            </nav>
            
            <div class="row align-items-center">
                <div class="col">
                    <h1 class="h3 mb-0">
                        <i class="fas fa-user-edit me-2"></i>Editar Perfil
                    </h1>
                    <p class="mb-0 opacity-75">Atualize suas informações pessoais e configurações</p>
                </div>
            </div>
        </div>
    </section>

    <main class="container my-4 flex-grow-1">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Mensagens de Feedback -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-custom alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Formulário de Dados Pessoais -->
                <div class="form-card mb-4">
                    <form action="${pageContext.request.contextPath}/perfil/atualizar" method="post" id="profileForm">
                        <div class="form-section">
                            <h5 class="mb-4">
                                <span class="section-icon bg-primary text-white">
                                    <i class="fas fa-user"></i>
                                </span>
                                Informações Pessoais
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="name" class="form-label">Nome Completo *</label>
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="${user.name}" required maxlength="255">
                                    <div class="invalid-feedback">
                                        Nome é obrigatório
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="email" class="form-label">E-mail *</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${user.email}" required maxlength="255">
                                    <div class="invalid-feedback">
                                        E-mail inválido
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="telefone" class="form-label">Telefone</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-phone"></i>
                                        </span>
                                        <input type="tel" class="form-control" id="telefone" name="telefone" 
                                               value="${user.telefone}" placeholder="(11) 99999-9999">
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="cpf" class="form-label">CPF</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-id-card"></i>
                                        </span>
                                        <input type="text" class="form-control" id="cpf" name="cpf" 
                                               value="${user.cpf}" placeholder="000.000.000-00">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="data_nascimento" class="form-label">Data de Nascimento</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-calendar"></i>
                                        </span>
                                        <input type="date" class="form-control" id="data_nascimento" 
                                               name="data_nascimento" value="${user.dataNascimento}">
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="genero" class="form-label">Gênero</label>
                                    <select class="form-select" id="genero" name="genero">
                                        <option value="">Prefiro não informar</option>
                                        <option value="M" ${user.genero == 'M' ? 'selected' : ''}>Masculino</option>
                                        <option value="F" ${user.genero == 'F' ? 'selected' : ''}>Feminino</option>
                                        <option value="Outro" ${user.genero == 'Outro' ? 'selected' : ''}>Outro</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-footer bg-transparent border-0 p-4">
                            <div class="d-flex justify-content-between">
                                <a href="${pageContext.request.contextPath}/perfil" class="btn btn-outline-elegant">
                                    <i class="fas fa-arrow-left me-2"></i>Voltar
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-2"></i>Salvar Alterações
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Formulário de Alteração de Senha -->
                <div class="form-card mb-4">
                    <form action="${pageContext.request.contextPath}/perfil/alterar-senha" method="post" id="passwordForm">
                        <div class="form-section">
                            <h5 class="mb-4">
                                <span class="section-icon bg-warning text-white">
                                    <i class="fas fa-lock"></i>
                                </span>
                                Alterar Senha
                            </h5>
                            
                            <div class="row">
                                <div class="col-md-12 mb-3">
                                    <label for="senha_atual" class="form-label">Senha Atual *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-key"></i>
                                        </span>
                                        <input type="password" class="form-control" id="senha_atual" 
                                               name="senha_atual" required>
                                        <button class="btn btn-outline-secondary" type="button" 
                                                onclick="togglePassword('senha_atual')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="nova_senha" class="form-label">Nova Senha *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="nova_senha" 
                                               name="nova_senha" required minlength="6">
                                        <button class="btn btn-outline-secondary" type="button" 
                                                onclick="togglePassword('nova_senha')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="password-strength" id="passwordStrength"></div>
                                    <small class="form-text text-muted" id="passwordFeedback">
                                        Mínimo 6 caracteres
                                    </small>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <label for="nova_senha_confirmation" class="form-label">Confirmar Nova Senha *</label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock"></i>
                                        </span>
                                        <input type="password" class="form-control" id="nova_senha_confirmation" 
                                               name="nova_senha_confirmation" required minlength="6">
                                        <button class="btn btn-outline-secondary" type="button" 
                                                onclick="togglePassword('nova_senha_confirmation')">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">
                                        As senhas não coincidem
                                    </div>
                                </div>
                            </div>
                            
                            <div class="alert alert-info alert-custom">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Dicas para uma senha segura:</strong>
                                <ul class="mb-0 mt-2 ps-4">
                                    <li>Use pelo menos 6 caracteres</li>
                                    <li>Combine letras maiúsculas e minúsculas</li>
                                    <li>Inclua números e caracteres especiais</li>
                                </ul>
                            </div>
                        </div>
                        
                        <div class="card-footer bg-transparent border-0 p-4">
                            <div class="d-flex justify-content-end">
                                <button type="submit" class="btn btn-gold">
                                    <i class="fas fa-key me-2"></i>Alterar Senha
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Configurações de Privacidade -->
                <div class="form-card">
                    <div class="form-section">
                        <h5 class="mb-4">
                            <span class="section-icon bg-success text-white">
                                <i class="fas fa-shield-alt"></i>
                            </span>
                            Privacidade e Segurança
                        </h5>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="privacy-card">
                                    <div class="privacy-item">
                                        <div>
                                            <div class="fw-bold">E-mail verificado</div>
                                            <small class="text-muted">Status da verificação</small>
                                        </div>
                                        <div>
                                            <c:choose>
                                                <c:when test="${user.emailVerifiedAt != null}">
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
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="privacy-card">
                                    <div class="privacy-item">
                                        <div>
                                            <div class="fw-bold">Último acesso</div>
                                            <small class="text-muted">
                                                <c:choose>
                                                    <c:when test="${user.lastLoginAt != null}">
                                                        <fmt:formatDate value="${user.lastLoginAt}" 
                                                                       pattern="dd/MM/yyyy 'às' HH:mm" />
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
                            </div>
                        </div>
                        
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <div class="privacy-card">
                                    <div class="privacy-item">
                                        <div>
                                            <div class="fw-bold">Membro desde</div>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy" />
                                            </small>
                                        </div>
                                        <div>
                                            <i class="fas fa-user-plus text-muted"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="privacy-card bg-danger bg-opacity-10">
                                    <div class="privacy-item">
                                        <div>
                                            <div class="fw-bold text-danger">Excluir conta</div>
                                            <small class="text-muted">Ação irreversível</small>
                                        </div>
                                        <div>
                                            <button class="btn btn-sm btn-outline-danger" 
                                                    data-bs-toggle="modal" data-bs-target="#deleteAccountModal">
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
    </main>

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
                        <li>Seu histórico de pedidos será mantido anonimizado</li>
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
                    <button type="button" class="btn btn-delete" id="confirmDeleteBtn" disabled>
                        <i class="fas fa-trash me-2"></i>Excluir Conta
                    </button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
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
            
            if (password.length >= 6) strength++;
            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;
            
            strengthBar.style.width = '100%';
            
            if (strength < 2) {
                strengthBar.className = 'password-strength strength-weak';
                feedback.textContent = 'Senha fraca';
                feedback.className = 'form-text text-danger';
            } else if (strength < 4) {
                strengthBar.className = 'password-strength strength-medium';
                feedback.textContent = 'Senha média';
                feedback.className = 'form-text text-warning';
            } else {
                strengthBar.className = 'password-strength strength-strong';
                feedback.textContent = 'Senha forte';
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

        // Modal de exclusão de conta
        const confirmPassword = document.getElementById('confirmPassword');
        const confirmDelete = document.getElementById('confirmDelete');
        const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

        function checkDeleteConfirmation() {
            confirmDeleteBtn.disabled = !(confirmPassword.value && confirmDelete.checked);
        }

        confirmPassword.addEventListener('input', checkDeleteConfirmation);
        confirmDelete.addEventListener('change', checkDeleteConfirmation);

        // Animação ao carregar
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.form-card');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    card.style.transition = 'all 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>