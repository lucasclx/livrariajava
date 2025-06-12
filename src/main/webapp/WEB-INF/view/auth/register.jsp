<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="pageTitle" value="Criar Conta" />

<!DOCTYPE html>
<html lang="pt-BR" class="h-100">
<head>
    <jsp:include page="../common/head.jsp" />
</head>
<body class="d-flex flex-column h-100">
    <jsp:include page="../common/header.jsp" />

    <main class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-lg">
                    <div class="card-header text-center">
                        <h2 class="h3 mb-0">Criar Nova Conta</h2>
                        <p class="text-muted mt-2">Junte-se à nossa comunidade de leitores</p>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        
                        <c:if test="${!empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        
                        <form action="${pageContext.request.contextPath}/register" method="POST" id="registerForm">
                            <!-- Dados Básicos -->
                            <div class="mb-3">
                                <label for="name" class="form-label fw-bold">Nome Completo *</label>
                                <input type="text" class="form-control" id="name" name="name" 
                                       value="${name}" required maxlength="255"
                                       placeholder="Digite seu nome completo">
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label fw-bold">Email *</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${email}" required maxlength="255"
                                       placeholder="seu@email.com">
                                <div class="form-text">Será usado para login e comunicações</div>
                            </div>
                            
                            <!-- Senhas -->
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="password" class="form-label fw-bold">Senha *</label>
                                    <input type="password" class="form-control" id="password" name="password" 
                                           required minlength="6" maxlength="100"
                                           placeholder="Mínimo 6 caracteres">
                                    <div class="form-text">
                                        <span id="passwordStrength"></span>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label for="password_confirmation" class="form-label fw-bold">Confirme a Senha *</label>
                                    <input type="password" class="form-control" id="password_confirmation" 
                                           name="password_confirmation" required minlength="6" maxlength="100"
                                           placeholder="Digite a senha novamente">
                                    <div class="form-text">
                                        <span id="passwordMatch"></span>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Dados Pessoais Opcionais -->
                            <div class="border-top pt-4 mt-4">
                                <h5 class="mb-3">Dados Pessoais (Opcionais)</h5>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="telefone" class="form-label">Telefone</label>
                                        <input type="tel" class="form-control" id="telefone" name="telefone" 
                                               value="${telefone}" placeholder="(11) 99999-9999"
                                               pattern="^(\(?[0-9]{2}\)?)?[0-9]{4,5}-?[0-9]{4}$">
                                        <div class="form-text">Formato: (11) 99999-9999</div>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="cpf" class="form-label">CPF</label>
                                        <input type="text" class="form-control" id="cpf" name="cpf" 
                                               value="${cpf}" placeholder="000.000.000-00"
                                               pattern="^[0-9]{3}\.?[0-9]{3}\.?[0-9]{3}-?[0-9]{2}$">
                                        <div class="form-text">Formato: 000.000.000-00</div>
                                    </div>
                                </div>
                                
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="data_nascimento" class="form-label">Data de Nascimento</label>
                                        <input type="date" class="form-control" id="data_nascimento" 
                                               name="data_nascimento" value="${data_nascimento}"
                                               max="<%= java.time.LocalDate.now().minusYears(13) %>"
                                               min="<%= java.time.LocalDate.now().minusYears(120) %>">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="genero" class="form-label">Gênero</label>
                                        <select class="form-select" id="genero" name="genero">
                                            <option value="">Não informar</option>
                                            <option value="masculino" ${genero == 'masculino' ? 'selected' : ''}>Masculino</option>
                                            <option value="feminino" ${genero == 'feminino' ? 'selected' : ''}>Feminino</option>
                                            <option value="outro" ${genero == 'outro' ? 'selected' : ''}>Outro</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Termos e Condições -->
                            <div class="mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="terms" required>
                                    <label class="form-check-label" for="terms">
                                        Concordo com os <a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">Termos de Uso</a> 
                                        e <a href="#" data-bs-toggle="modal" data-bs-target="#privacyModal">Política de Privacidade</a> *
                                    </label>
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg" id="submitBtn">
                                    <i class="fas fa-user-plus me-2"></i>Criar Conta
                                </button>
                            </div>
                        </form>
                        
                        <hr class="my-4">
                        <div class="text-center">
                            <p class="mb-0">Já tem uma conta? <a href="${pageContext.request.contextPath}/login">Faça o login</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Modal Termos de Uso -->
    <div class="modal fade" id="termsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Termos de Uso</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>1. Aceitação dos Termos</h6>
                    <p>Ao criar uma conta na Livraria Mil Páginas, você concorda em cumprir estes termos de uso.</p>
                    
                    <h6>2. Uso da Conta</h6>
                    <p>Você é responsável por manter a confidencialidade de sua conta e senha.</p>
                    
                    <h6>3. Compras e Pagamentos</h6>
                    <p>Todos os preços estão sujeitos a alterações sem aviso prévio.</p>
                    
                    <h6>4. Propriedade Intelectual</h6>
                    <p>Todo o conteúdo do site é protegido por direitos autorais.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Modal Política de Privacidade -->
    <div class="modal fade" id="privacyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Política de Privacidade</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <h6>1. Coleta de Informações</h6>
                    <p>Coletamos apenas as informações necessárias para fornecer nossos serviços.</p>
                    
                    <h6>2. Uso das Informações</h6>
                    <p>Suas informações são usadas para processar pedidos e melhorar nossos serviços.</p>
                    
                    <h6>3. Compartilhamento de Dados</h6>
                    <p>Não compartilhamos suas informações pessoais com terceiros, exceto quando necessário para completar sua compra.</p>
                    
                    <h6>4. Segurança</h6>
                    <p>Implementamos medidas de segurança para proteger suas informações pessoais.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Máscaras para campos
            const telefoneInput = document.getElementById('telefone');
            const cpfInput = document.getElementById('cpf');
            
            // Máscara de telefone
            telefoneInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length <= 11) {
                    if (value.length <= 10) {
                        value = value.replace(/(\d{2})(\d{4})(\d{4})/, '($1) $2-$3');
                    } else {
                        value = value.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
                    }
                }
                e.target.value = value;
            });
            
            // Máscara de CPF
            cpfInput.addEventListener('input', function(e) {
                let value = e.target.value.replace(/\D/g, '');
                if (value.length <= 11) {
                    value = value.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
                }
                e.target.value = value;
            });
            
            // Validação de força da senha
            const passwordInput = document.getElementById('password');
            const passwordStrength = document.getElementById('passwordStrength');
            
            passwordInput.addEventListener('input', function() {
                const password = this.value;
                let strength = 0;
                let feedback = '';
                
                if (password.length >= 6) strength++;
                if (password.length >= 8) strength++;
                if (/[A-Z]/.test(password)) strength++;
                if (/[a-z]/.test(password)) strength++;
                if (/[0-9]/.test(password)) strength++;
                if (/[^A-Za-z0-9]/.test(password)) strength++;
                
                switch (strength) {
                    case 0:
                    case 1:
                        feedback = '<span class="text-danger">Muito fraca</span>';
                        break;
                    case 2:
                    case 3:
                        feedback = '<span class="text-warning">Fraca</span>';
                        break;
                    case 4:
                        feedback = '<span class="text-info">Média</span>';
                        break;
                    case 5:
                    case 6:
                        feedback = '<span class="text-success">Forte</span>';
                        break;
                }
                
                passwordStrength.innerHTML = feedback;
            });
            
            // Validação de confirmação de senha
            const passwordConfirmation = document.getElementById('password_confirmation');
            const passwordMatch = document.getElementById('passwordMatch');
            
            function checkPasswordMatch() {
                if (passwordConfirmation.value === '') {
                    passwordMatch.innerHTML = '';
                    return;
                }
                
                if (passwordInput.value === passwordConfirmation.value) {
                    passwordMatch.innerHTML = '<span class="text-success"><i class="fas fa-check"></i> Senhas coincidem</span>';
                } else {
                    passwordMatch.innerHTML = '<span class="text-danger"><i class="fas fa-times"></i> Senhas não coincidem</span>';
                }
            }
            
            passwordInput.addEventListener('input', checkPasswordMatch);
            passwordConfirmation.addEventListener('input', checkPasswordMatch);
            
            // Validação do formulário
            const form = document.getElementById('registerForm');
            const submitBtn = document.getElementById('submitBtn');
            
            form.addEventListener('submit', function(e) {
                // Verificar se as senhas coincidem
                if (passwordInput.value !== passwordConfirmation.value) {
                    e.preventDefault();
                    alert('As senhas não coincidem!');
                    passwordConfirmation.focus();
                    return;
                }
                
                // Verificar força mínima da senha
                if (passwordInput.value.length < 6) {
                    e.preventDefault();
                    alert('A senha deve ter pelo menos 6 caracteres!');
                    passwordInput.focus();
                    return;
                }
                
                // Mostrar loading
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Criando conta...';
                submitBtn.disabled = true;
            });
        });
    </script>
</body>
</html>