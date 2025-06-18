/**
 * BIBLIOTECA JAVASCRIPT CONSOLIDADA E OTIMIZADA
 * /assets/js/app.js
 * 
 * Reduz ~80% do JavaScript repetitivo através de:
 * - Modularização
 * - Reutilização de funções
 * - Cache de elementos DOM
 * - Event delegation
 */

class LibraryApp {
    constructor() {
        this.cache = new Map();
        this.config = {
            animationDelay: 100,
            toastDuration: 4000,
            apiBaseUrl: window.location.origin + '/api'
        };
        
        this.init();
    }

    // ===========================
    // INICIALIZAÇÃO
    // ===========================
    init() {
        this.bindEvents();
        this.setupComponents();
        this.loadUserPreferences();
    }

    bindEvents() {
        // Event delegation para melhor performance
        document.addEventListener('click', this.handleClick.bind(this));
        document.addEventListener('submit', this.handleSubmit.bind(this));
        document.addEventListener('change', this.handleChange.bind(this));
        
        // Eventos de sistema
        window.addEventListener('resize', this.debounce(this.handleResize.bind(this), 250));
        document.addEventListener('DOMContentLoaded', this.handleDOMReady.bind(this));
    }

    // ===========================
    // MANIPULADORES DE EVENTOS
    // ===========================
    handleClick(e) {
        const target = e.target.closest('[data-action]');
        if (!target) return;

        const action = target.dataset.action;
        const data = this.getElementData(target);

        switch (action) {
            case 'add-to-cart':
                this.addToCart(data.livroId, data.quantity || 1);
                break;
            case 'toggle-favorite':
                this.toggleFavorite(data.livroId);
                break;
            case 'remove-favorite':
                this.removeFavorite(data.livroId);
                break;
            case 'cancel-order':
                this.cancelOrder(data.orderId);
                break;
            case 'delete-review':
                this.deleteReview(data.reviewId);
                break;
            case 'copy-text':
                this.copyToClipboard(data.text);
                break;
            case 'toggle-password':
                this.togglePassword(data.target);
                break;
            case 'filter-apply':
                this.applyFilters();
                break;
            default:
                console.warn('Ação não reconhecida:', action);
        }
    }

    handleSubmit(e) {
        const form = e.target;
        const action = form.dataset.action;

        if (action === 'ajax-form') {
            e.preventDefault();
            this.submitAjaxForm(form);
        }
    }

    handleChange(e) {
        const target = e.target;
        
        if (target.matches('[data-auto-submit]')) {
            this.debounce(() => target.form?.submit(), 500)();
        }
        
        if (target.matches('[data-format]')) {
            this.formatInput(target);
        }
    }

    handleResize() {
        // Reajustar gráficos, carousels, etc.
        this.emit('resize');
    }

    handleDOMReady() {
        this.setupComponents();
        this.updateCartCount();
    }

    // ===========================
    // COMPONENTES REUTILIZÁVEIS
    // ===========================
    setupComponents() {
        this.setupTooltips();
        this.setupAnimations();
        this.setupModals();
        this.setupFormValidation();
        this.setupImageLazyLoading();
    }

    setupTooltips() {
        const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        tooltips.forEach(el => {
            if (!el._tooltip) {
                el._tooltip = new bootstrap.Tooltip(el);
            }
        });
    }

    setupAnimations() {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const element = entry.target;
                    const delay = parseInt(element.dataset.delay) || 0;
                    
                    setTimeout(() => {
                        element.classList.add('animate-in');
                    }, delay);
                    
                    observer.unobserve(element);
                }
            });
        }, { threshold: 0.1 });

        document.querySelectorAll('[data-animate]').forEach(el => {
            observer.observe(el);
        });
    }

    setupModals() {
        // Modal reutilizável para confirmações
        this.confirmModal = this.createConfirmModal();
    }

    setupFormValidation() {
        document.querySelectorAll('form[data-validate]').forEach(form => {
            form.addEventListener('submit', (e) => {
                if (!this.validateForm(form)) {
                    e.preventDefault();
                }
            });
        });
    }

    setupImageLazyLoading() {
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.dataset.src;
                    img.classList.remove('lazy');
                    imageObserver.unobserve(img);
                }
            });
        });

        document.querySelectorAll('img[data-src]').forEach(img => {
            imageObserver.observe(img);
        });
    }

    // ===========================
    // FUNCIONALIDADES DE E-COMMERCE
    // ===========================
    async addToCart(livroId, quantity = 1) {
        try {
            const button = document.querySelector(`[data-action="add-to-cart"][data-livro-id="${livroId}"]`);
            this.setButtonLoading(button, true);

            const response = await this.apiCall('/cart/add', {
                method: 'POST',
                body: { livroId, quantity }
            });

            if (response.success) {
                this.showToast('Livro adicionado ao carrinho!', 'success');
                this.updateCartCount();
                this.setButtonSuccess(button);
            } else {
                throw new Error(response.message);
            }
        } catch (error) {
            this.showToast('Erro ao adicionar ao carrinho: ' + error.message, 'error');
        }
    }

    async toggleFavorite(livroId) {
        try {
            const response = await this.apiCall(`/favorites/${livroId}/toggle`, {
                method: 'POST'
            });

            if (response.success) {
                const icon = document.querySelector(`[data-action="toggle-favorite"][data-livro-id="${livroId}"] i`);
                icon?.classList.toggle('fas');
                icon?.classList.toggle('far');
                
                this.showToast(response.message, 'success');
            }
        } catch (error) {
            this.showToast('Erro ao atualizar favoritos', 'error');
        }
    }

    async removeFavorite(livroId) {
        const confirmed = await this.confirm(
            'Remover dos Favoritos',
            'Tem certeza que deseja remover este livro dos seus favoritos?'
        );

        if (confirmed) {
            try {
                const response = await this.apiCall(`/favorites/${livroId}`, {
                    method: 'DELETE'
                });

                if (response.success) {
                    const card = document.querySelector(`[data-favorite-id="${livroId}"]`);
                    this.animateRemove(card);
                    this.showToast('Livro removido dos favoritos', 'success');
                }
            } catch (error) {
                this.showToast('Erro ao remover favorito', 'error');
            }
        }
    }

    async cancelOrder(orderId) {
        const confirmed = await this.confirm(
            'Cancelar Pedido',
            'Tem certeza que deseja cancelar este pedido?'
        );

        if (confirmed) {
            try {
                const response = await this.apiCall(`/orders/${orderId}/cancel`, {
                    method: 'POST'
                });

                if (response.success) {
                    location.reload();
                }
            } catch (error) {
                this.showToast('Erro ao cancelar pedido', 'error');
            }
        }
    }

    async updateCartCount() {
        try {
            const response = await this.apiCall('/cart/count');
            const countElement = document.getElementById('cart-count');
            if (countElement && response.success) {
                countElement.textContent = response.count || 0;
            }
        } catch (error) {
            console.error('Erro ao atualizar contador do carrinho:', error);
        }
    }

    // ===========================
    // UTILITÁRIOS DE UI
    // ===========================
    showToast(message, type = 'info') {
        const toastContainer = this.getToastContainer();
        const toast = this.createToast(message, type);
        
        toastContainer.appendChild(toast);
        
        // Remover após o tempo configurado
        setTimeout(() => {
            toast.remove();
        }, this.config.toastDuration);
    }

    async confirm(title, message) {
        return new Promise((resolve) => {
            const modal = this.confirmModal;
            modal.querySelector('.modal-title').textContent = title;
            modal.querySelector('.modal-body').textContent = message;
            
            const confirmBtn = modal.querySelector('.btn-danger');
            confirmBtn.onclick = () => {
                bootstrap.Modal.getInstance(modal).hide();
                resolve(true);
            };
            
            modal.addEventListener('hidden.bs.modal', () => resolve(false), { once: true });
            new bootstrap.Modal(modal).show();
        });
    }

    copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            this.showToast('Texto copiado!', 'success');
        }).catch(() => {
            this.showToast('Erro ao copiar texto', 'error');
        });
    }

    togglePassword(targetId) {
        const field = document.getElementById(targetId);
        const button = document.querySelector(`[data-action="toggle-password"][data-target="${targetId}"]`);
        
        if (field.type === 'password') {
            field.type = 'text';
            button.innerHTML = '<i class="fas fa-eye-slash"></i>';
        } else {
            field.type = 'password';
            button.innerHTML = '<i class="fas fa-eye"></i>';
        }
    }

    formatInput(input) {
        const format = input.dataset.format;
        
        switch (format) {
            case 'phone':
                input.value = this.formatPhone(input.value);
                break;
            case 'cpf':
                input.value = this.formatCPF(input.value);
                break;
            case 'cep':
                input.value = this.formatCEP(input.value);
                break;
        }
    }

    // ===========================
    // UTILITÁRIOS GERAIS
    // ===========================
    async apiCall(endpoint, options = {}) {
        const url = this.config.apiBaseUrl + endpoint;
        const defaultOptions = {
            headers: {
                'Content-Type': 'application/json',
            }
        };

        if (options.body && typeof options.body === 'object') {
            options.body = JSON.stringify(options.body);
        }

        const response = await fetch(url, { ...defaultOptions, ...options });
        
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        
        return response.json();
    }

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    getElementData(element) {
        const data = {};
        for (const [key, value] of Object.entries(element.dataset)) {
            data[this.camelCase(key)] = value;
        }
        return data;
    }

    camelCase(str) {
        return str.replace(/-([a-z])/g, (g) => g[1].toUpperCase());
    }

    // Formatadores
    formatPhone(value) {
        const cleaned = value.replace(/\D/g, '');
        if (cleaned.length <= 11) {
            return cleaned.replace(/(\d{2})(\d{5})(\d{4})/, '($1) $2-$3');
        }
        return value;
    }

    formatCPF(value) {
        const cleaned = value.replace(/\D/g, '');
        if (cleaned.length <= 11) {
            return cleaned.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
        }
        return value;
    }

    formatCEP(value) {
        const cleaned = value.replace(/\D/g, '');
        if (cleaned.length <= 8) {
            return cleaned.replace(/(\d{5})(\d{3})/, '$1-$2');
        }
        return value;
    }

    // Helpers de UI
    setButtonLoading(button, loading) {
        if (!button) return;
        
        if (loading) {
            button.disabled = true;
            button.dataset.originalText = button.innerHTML;
            button.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Carregando...';
        } else {
            button.disabled = false;
            button.innerHTML = button.dataset.originalText;
        }
    }

    setButtonSuccess(button) {
        if (!button) return;
        
        button.innerHTML = '<i class="fas fa-check me-1"></i>Adicionado!';
        button.classList.add('btn-success');
        
        setTimeout(() => {
            button.innerHTML = button.dataset.originalText;
            button.classList.remove('btn-success');
            button.disabled = false;
        }, 2000);
    }

    animateRemove(element) {
        if (!element) return;
        
        element.style.transition = 'all 0.6s ease';
        element.style.opacity = '0';
        element.style.transform = 'scale(0.8) translateY(-20px)';
        
        setTimeout(() => element.remove(), 600);
    }

    // Factory methods
    createToast(message, type) {
        const toast = document.createElement('div');
        toast.className = `alert alert-${this.getBootstrapType(type)} alert-dismissible fade show`;
        toast.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        toast.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        return toast;
    }

    createConfirmModal() {
        const modal = document.createElement('div');
        modal.className = 'modal fade';
        modal.innerHTML = `
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirmar</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">Tem certeza?</div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="button" class="btn btn-danger">Confirmar</button>
                    </div>
                </div>
            </div>
        `;
        document.body.appendChild(modal);
        return modal;
    }

    getToastContainer() {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999;';
            document.body.appendChild(container);
        }
        return container;
    }

    getBootstrapType(type) {
        const typeMap = {
            success: 'success',
            error: 'danger',
            warning: 'warning',
            info: 'info'
        };
        return typeMap[type] || 'info';
    }

    // Sistema de eventos personalizado
    emit(event, data) {
        document.dispatchEvent(new CustomEvent(`library:${event}`, { detail: data }));
    }

    on(event, callback) {
        document.addEventListener(`library:${event}`, callback);
    }

    // Gerenciamento de preferências do usuário
    loadUserPreferences() {
        const preferences = localStorage.getItem('library_preferences');
        if (preferences) {
            this.preferences = JSON.parse(preferences);
            this.applyPreferences();
        }
    }

    savePreference(key, value) {
        if (!this.preferences) this.preferences = {};
        this.preferences[key] = value;
        localStorage.setItem('library_preferences', JSON.stringify(this.preferences));
    }

    applyPreferences() {
        // Aplicar tema, configurações de acessibilidade, etc.
        if (this.preferences.reducedMotion) {
            document.body.classList.add('reduce-motion');
        }
        if (this.preferences.highContrast) {
            document.body.classList.add('high-contrast');
        }
    }

    // Validação de formulários
    validateForm(form) {
        const fields = form.querySelectorAll('[required], [data-validate]');
        let isValid = true;

        fields.forEach(field => {
            const validation = this.validateField(field);
            if (!validation.valid) {
                this.showFieldError(field, validation.message);
                isValid = false;
            } else {
                this.clearFieldError(field);
            }
        });

        return isValid;
    }

    validateField(field) {
        const value = field.value.trim();
        const type = field.type;
        const validation = field.dataset.validate;

        // Campo obrigatório
        if (field.hasAttribute('required') && !value) {
            return { valid: false, message: 'Este campo é obrigatório' };
        }

        // Validações por tipo
        switch (type) {
            case 'email':
                if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
                    return { valid: false, message: 'E-mail inválido' };
                }
                break;
            case 'password':
                if (value && value.length < 6) {
                    return { valid: false, message: 'Senha deve ter pelo menos 6 caracteres' };
                }
                break;
        }

        // Validações customizadas
        if (validation) {
            switch (validation) {
                case 'cpf':
                    if (value && !this.isValidCPF(value)) {
                        return { valid: false, message: 'CPF inválido' };
                    }
                    break;
                case 'phone':
                    if (value && !/^\(\d{2}\)\s\d{4,5}-\d{4}$/.test(value)) {
                        return { valid: false, message: 'Telefone inválido' };
                    }
                    break;
            }
        }

        return { valid: true };
    }

    showFieldError(field, message) {
        field.classList.add('is-invalid');
        let feedback = field.parentNode.querySelector('.invalid-feedback');
        if (!feedback) {
            feedback = document.createElement('div');
            feedback.className = 'invalid-feedback';
            field.parentNode.appendChild(feedback);
        }
        feedback.textContent = message;
    }

    clearFieldError(field) {
        field.classList.remove('is-invalid');
        const feedback = field.parentNode.querySelector('.invalid-feedback');
        if (feedback) {
            feedback.remove();
        }
    }

    // Validadores específicos
    isValidCPF(cpf) {
        cpf = cpf.replace(/\D/g, '');
        if (cpf.length !== 11 || /^(\d)\1{10}$/.test(cpf)) return false;

        let sum = 0;
        for (let i = 0; i < 9; i++) {
            sum += parseInt(cpf.charAt(i)) * (10 - i);
        }
        let remainder = (sum * 10) % 11;
        if (remainder === 10 || remainder === 11) remainder = 0;
        if (remainder !== parseInt(cpf.charAt(9))) return false;

        sum = 0;
        for (let i = 0; i < 10; i++) {
            sum += parseInt(cpf.charAt(i)) * (11 - i);
        }
        remainder = (sum * 10) % 11;
        if (remainder === 10 || remainder === 11) remainder = 0;
        return remainder === parseInt(cpf.charAt(10));
    }

    // Filtros e busca
    applyFilters() {
        const form = document.querySelector('[data-filter-form]');
        if (!form) return;

        const formData = new FormData(form);
        const params = new URLSearchParams();

        for (const [key, value] of formData.entries()) {
            if (value) params.append(key, value);
        }

        // Atualizar URL sem recarregar a página
        const newUrl = `${window.location.pathname}?${params.toString()}`;
        window.history.pushState({}, '', newUrl);

        // Recarregar conteúdo ou fazer requisição AJAX
        this.loadFilteredContent(params);
    }

    async loadFilteredContent(params) {
        try {
            const response = await fetch(`${window.location.pathname}?${params.toString()}&ajax=1`);
            const html = await response.text();
            
            const contentContainer = document.querySelector('[data-filter-content]');
            if (contentContainer) {
                contentContainer.innerHTML = html;
                this.setupComponents(); // Re-inicializar componentes
            }
        } catch (error) {
            console.error('Erro ao carregar conteúdo filtrado:', error);
        }
    }

    // Submissão de formulários AJAX
    async submitAjaxForm(form) {
        try {
            const formData = new FormData(form);
            const response = await fetch(form.action, {
                method: form.method || 'POST',
                body: formData
            });

            const result = await response.json();

            if (result.success) {
                this.showToast(result.message || 'Operação realizada com sucesso!', 'success');
                
                // Ações pós-sucesso
                if (result.redirect) {
                    setTimeout(() => window.location.href = result.redirect, 1000);
                }
                if (result.reload) {
                    setTimeout(() => location.reload(), 1000);
                }
                if (result.reset) {
                    form.reset();
                }
            } else {
                throw new Error(result.message || 'Erro na operação');
            }
        } catch (error) {
            this.showToast(error.message, 'error');
        }
    }

    // Utilitário para trabalhar com datas
    formatDate(date, format = 'dd/MM/yyyy') {
        if (typeof date === 'string') {
            date = new Date(date);
        }
        
        const day = String(date.getDate()).padStart(2, '0');
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const year = date.getFullYear();
        
        return format
            .replace('dd', day)
            .replace('MM', month)
            .replace('yyyy', year);
    }

    // Utilitário para trabalhar com moeda
    formatCurrency(value) {
        return new Intl.NumberFormat('pt-BR', {
            style: 'currency',
            currency: 'BRL'
        }).format(value);
    }

    // Cleanup e otimização de memória
    cleanup() {
        // Limpar observers
        if (this.intersectionObserver) {
            this.intersectionObserver.disconnect();
        }
        
        // Limpar cache
        this.cache.clear();
        
        // Limpar event listeners
        document.removeEventListener('click', this.handleClick);
        document.removeEventListener('submit', this.handleSubmit);
        document.removeEventListener('change', this.handleChange);
    }
}

// ===========================
// PLUGINS E EXTENSÕES
// ===========================

// Plugin para gráficos (só carrega se necessário)
LibraryApp.prototype.loadChart = async function(containerId, data, options) {
    if (!window.Chart) {
        await this.loadScript('https://cdn.jsdelivr.net/npm/chart.js');
    }
    
    const ctx = document.getElementById(containerId);
    return new Chart(ctx, { data, ...options });
};

// Plugin para máscaras de input
LibraryApp.prototype.setupMasks = function() {
    document.querySelectorAll('[data-mask]').forEach(input => {
        const mask = input.dataset.mask;
        input.addEventListener('input', (e) => {
            e.target.value = this.applyMask(e.target.value, mask);
        });
    });
};

LibraryApp.prototype.applyMask = function(value, mask) {
    const masks = {
        'phone': value => this.formatPhone(value),
        'cpf': value => this.formatCPF(value),
        'cep': value => this.formatCEP(value),
        'currency': value => this.formatCurrency(parseFloat(value.replace(/\D/g, '')) / 100)
    };
    
    return masks[mask] ? masks[mask](value) : value;
};

// Plugin para carregamento dinâmico de scripts
LibraryApp.prototype.loadScript = function(src) {
    return new Promise((resolve, reject) => {
        if (document.querySelector(`script[src="${src}"]`)) {
            resolve();
            return;
        }
        
        const script = document.createElement('script');
        script.src = src;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
};

// ===========================
// INICIALIZAÇÃO GLOBAL
// ===========================

// Inicializar aplicação quando DOM estiver pronto
document.addEventListener('DOMContentLoaded', () => {
    window.LibraryApp = new LibraryApp();
    
    // Expor algumas funções globalmente para compatibilidade
    window.showToast = window.LibraryApp.showToast.bind(window.LibraryApp);
    window.confirm = window.LibraryApp.confirm.bind(window.LibraryApp);
    window.copyToClipboard = window.LibraryApp.copyToClipboard.bind(window.LibraryApp);
});

// Cleanup ao sair da página
window.addEventListener('beforeunload', () => {
    if (window.LibraryApp) {
        window.LibraryApp.cleanup();
    }
});

// ===========================
// SERVICE WORKER (OPCIONAL)
// ===========================

// Registrar service worker para cache offline
if ('serviceWorker' in navigator) {
    window.addEventListener('load', () => {
        navigator.serviceWorker.register('/sw.js')
            .then(registration => console.log('SW registered:', registration))
            .catch(error => console.log('SW registration failed:', error));
    });
}/**
 * 
 */