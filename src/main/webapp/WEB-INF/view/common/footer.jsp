<%-- /WEB-INF/views/common/footer.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<footer class="footer mt-auto">
    <div class="container">
        <!-- Main Footer Content -->
        <div class="row py-5">
            <!-- Company Info -->
            <div class="col-lg-4 mb-4">
                <h5 class="mb-3">
                    <i class="fas fa-book-open me-2"></i>
                    Livraria Mil Páginas
                </h5>
                <p class="mb-3">
                    Sua livraria online de confiança, onde cada página é uma nova jornada. 
                    Oferecemos os melhores livros com qualidade e preços acessíveis.
                </p>
                <div class="social-links">
                    <a href="#" class="me-3 hover-gold" data-bs-toggle="tooltip" title="Facebook">
                        <i class="fab fa-facebook-f fs-5"></i>
                    </a>
                    <a href="#" class="me-3 hover-gold" data-bs-toggle="tooltip" title="Instagram">
                        <i class="fab fa-instagram fs-5"></i>
                    </a>
                    <a href="#" class="me-3 hover-gold" data-bs-toggle="tooltip" title="Twitter">
                        <i class="fab fa-twitter fs-5"></i>
                    </a>
                    <a href="#" class="me-3 hover-gold" data-bs-toggle="tooltip" title="YouTube">
                        <i class="fab fa-youtube fs-5"></i>
                    </a>
                    <a href="#" class="hover-gold" data-bs-toggle="tooltip" title="LinkedIn">
                        <i class="fab fa-linkedin-in fs-5"></i>
                    </a>
                </div>
            </div>
            
            <!-- Quick Links -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Navegação</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/" class="hover-gold">
                            <i class="fas fa-home me-2"></i>Início
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/loja/catalogo" class="hover-gold">
                            <i class="fas fa-book me-2"></i>Catálogo
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/search" class="hover-gold">
                            <i class="fas fa-search me-2"></i>Buscar
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/loja/favoritos" class="hover-gold">
                            <i class="fas fa-heart me-2"></i>Favoritos
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Categories -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Categorias</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/search?categoria=ficcao" class="hover-gold">
                            Ficção
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/search?categoria=nao-ficcao" class="hover-gold">
                            Não Ficção
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/search?categoria=infantil" class="hover-gold">
                            Infantil
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/search?categoria=tecnico" class="hover-gold">
                            Técnico
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/search?categoria=autoajuda" class="hover-gold">
                            Autoajuda
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Customer Service -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Atendimento</h6>
                <ul class="list-unstyled">
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/contato" class="hover-gold">
                            <i class="fas fa-envelope me-2"></i>Contato
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/ajuda" class="hover-gold">
                            <i class="fas fa-question-circle me-2"></i>Ajuda
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/faq" class="hover-gold">
                            <i class="fas fa-info-circle me-2"></i>FAQ
                        </a>
                    </li>
                    <li class="mb-2">
                        <a href="${pageContext.request.contextPath}/trocas-devolucoes" class="hover-gold">
                            <i class="fas fa-exchange-alt me-2"></i>Trocas
                        </a>
                    </li>
                </ul>
            </div>
            
            <!-- Contact Info -->
            <div class="col-lg-2 col-md-6 mb-4">
                <h6 class="mb-3">Contato</h6>
                <div class="contact-info">
                    <div class="mb-2">
                        <i class="fas fa-phone me-2"></i>
                        <small>(11) 9999-9999</small>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-envelope me-2"></i>
                        <small>contato@milpaginas.com.br</small>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-map-marker-alt me-2"></i>
                        <small>São Paulo - SP</small>
                    </div>
                    <div class="mb-2">
                        <i class="fas fa-clock me-2"></i>
                        <small>Seg-Sex: 8h às 18h</small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Payment Methods -->
        <div class="border-top border-gold py-4">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start mb-3 mb-md-0">
                    <h6 class="mb-2">Formas de Pagamento</h6>
                    <div class="payment-methods">
                        <i class="fab fa-cc-visa fs-4 me-2" data-bs-toggle="tooltip" title="Visa"></i>
                        <i class="fab fa-cc-mastercard fs-4 me-2" data-bs-toggle="tooltip" title="Mastercard"></i>
                        <i class="fab fa-cc-amex fs-4 me-2" data-bs-toggle="tooltip" title="American Express"></i>
                        <i class="fab fa-pix fs-4 me-2" data-bs-toggle="tooltip" title="PIX"></i>
                        <i class="fas fa-barcode fs-4 me-2" data-bs-toggle="tooltip" title="Boleto"></i>
                    </div>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <h6 class="mb-2">Segurança</h6>
                    <div class="security-badges">
                        <span class="badge bg-success me-2">
                            <i class="fas fa-shield-alt me-1"></i>Site Seguro
                        </span>
                        <span class="badge bg-primary me-2">
                            <i class="fas fa-lock me-1"></i>SSL
                        </span>
                        <span class="badge bg-warning text-dark">
                            <i class="fas fa-medal me-1"></i>Verificado
                        </span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Bottom Footer -->
        <div class="border-top py-3">
            <div class="row align-items-center">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-0 small">
                        &copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" /> 
                        Livraria Mil Páginas. Todos os direitos reservados.
                    </p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/termos-uso" class="small hover-gold me-3">
                            Termos de Uso
                        </a>
                        <a href="${pageContext.request.contextPath}/politica-privacidade" class="small hover-gold me-3">
                            Privacidade
                        </a>
                        <a href="${pageContext.request.contextPath}/cookies" class="small hover-gold">
                            Cookies
                        </a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Developer Credit -->
        <div class="text-center py-2 border-top">
            <p class="mb-0 small opacity-75">
                Desenvolvido com 
                <i class="fas fa-heart text-danger"></i> 
                usando Java Servlets, JSP e Bootstrap
                <span class="mx-2">|</span>
                <i class="fas fa-code me-1"></i>
                <a href="https://github.com" class="hover-gold small">
                    Ver no GitHub
                </a>
            </p>
        </div>
    </div>
</footer>

<!-- JavaScript Global -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" 
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" 
        crossorigin="anonymous"></script>

<script>
    // Funcionalidades globais do footer
    document.addEventListener('DOMContentLoaded', function() {
        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
        
        // Atualizar contagem do carrinho no header
        updateCartCount();
        
        // Newsletter subscription
        const newsletterForms = document.querySelectorAll('form[action*="newsletter"]');
        newsletterForms.forEach(form => {
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                const email = this.querySelector('input[name="email"]').value;
                
                // Simular subscribe (implementar backend depois)
                showToast('Obrigado! Você será notificado sobre nossas novidades.', 'success');
                this.reset();
            });
        });
        
        // Analytics tracking para links do footer
        document.querySelectorAll('footer a').forEach(link => {
            link.addEventListener('click', function() {
                // Implementar tracking analytics aqui
                console.log('Footer link clicked:', this.href);
            });
        });
    });
    
    // Função global para atualizar contagem do carrinho
    function updateCartCount() {
        fetch('${pageContext.request.contextPath}/cart/count')
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                const cartCountEl = document.getElementById('cart-count');
                if (cartCountEl && data.success) {
                    cartCountEl.textContent = data.count || 0;
                    
                    // Animar contador se houver mudança
                    if (data.count > 0) {
                        cartCountEl.classList.add('pulse');
                        setTimeout(() => cartCountEl.classList.remove('pulse'), 1000);
                    }
                }
            })
            .catch(error => {
                console.error('Erro ao buscar contagem do carrinho:', error);
            });
    }
    
    // Função global para toast notifications
    function showToast(message, type = 'info', duration = 5000) {
        // Verificar se já existe um container de toasts
        let toastContainer = document.getElementById('toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.id = 'toast-container';
            toastContainer.className = 'position-fixed top-0 end-0 p-3';
            toastContainer.style.zIndex = '9999';
            document.body.appendChild(toastContainer);
        }
        
        // Criar toast
        const toastId = 'toast-' + Date.now();
        const toast = document.createElement('div');
        toast.id = toastId;
        toast.className = `toast align-items-center text-white bg-${type} border-0`;
        toast.setAttribute('role', 'alert');
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-${getToastIcon(type)} me-2"></i>
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" 
                        data-bs-dismiss="toast"></button>
            </div>
        `;
        
        toastContainer.appendChild(toast);
        
        // Inicializar e mostrar toast
        const bsToast = new bootstrap.Toast(toast, {
            autohide: true,
            delay: duration
        });
        bsToast.show();
        
        // Remover elemento após ocultar
        toast.addEventListener('hidden.bs.toast', function() {
            this.remove();
        });
    }
    
    // Ícones para diferentes tipos de toast
    function getToastIcon(type) {
        const icons = {
            'success': 'check-circle',
            'danger': 'exclamation-triangle',
            'warning': 'exclamation-triangle',
            'info': 'info-circle',
            'primary': 'info-circle',
            'secondary': 'info-circle'
        };
        return icons[type] || 'info-circle';
    }
    
    // Cookie consent (implementar se necessário)
    function checkCookieConsent() {
        if (!localStorage.getItem('cookieConsent')) {
            // Mostrar banner de cookies
            const cookieBanner = document.createElement('div');
            cookieBanner.className = 'position-fixed bottom-0 start-0 end-0 bg-dark text-white p-3';
            cookieBanner.style.zIndex = '9998';
            cookieBanner.innerHTML = `
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <small>
                                <i class="fas fa-cookie-bite me-2"></i>
                                Este site usa cookies para melhorar sua experiência. 
                                <a href="${pageContext.request.contextPath}/cookies" class="text-warning">
                                    Saiba mais
                                </a>
                            </small>
                        </div>
                        <div class="col-md-4 text-end">
                            <button class="btn btn-gold btn-sm" onclick="acceptCookies()">
                                Aceitar
                            </button>
                        </div>
                    </div>
                </div>
            `;
            document.body.appendChild(cookieBanner);
        }
    }
    
    function acceptCookies() {
        localStorage.setItem('cookieConsent', 'true');
        document.querySelector('.position-fixed.bottom-0').remove();
    }
    
    // Verificar consentimento de cookies após carregar página
    // setTimeout(checkCookieConsent, 2000);
</script>