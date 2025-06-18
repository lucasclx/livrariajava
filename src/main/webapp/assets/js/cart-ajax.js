/**
 * Aguarda o carregamento completo do DOM para registrar os eventos.
 */
document.addEventListener('DOMContentLoaded', function() {
    
    /**
     * Usa a técnica de "delegação de eventos" para observar todos os cliques no corpo do documento.
     * Isso é mais eficiente do que adicionar um listener para cada botão, especialmente para
     * conteúdo carregado dinamicamente.
     */
    document.body.addEventListener('submit', function(event) {
        // Verifica se o evento de submit veio de um formulário com a nossa classe alvo
        if (event.target.matches('.add-to-cart-form')) {
            event.preventDefault(); // Impede o envio tradicional do formulário
            handleAddToCart(event.target);
        }
    });
});

/**
 * Função assíncrona para lidar com a adição de um item ao carrinho.
 * @param {HTMLFormElement} form - O formulário que foi submetido.
 */
async function handleAddToCart(form) {
    const submitButton = form.querySelector('button[type="submit"]');
    if (!submitButton) return;
    
    const originalButtonHTML = submitButton.innerHTML;
    
    // Fornece feedback visual de que algo está acontecendo
    submitButton.disabled = true;
    submitButton.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adicionando...';

    const url = form.action;
    const quantityInput = form.querySelector('input[name="quantity"]');
    const quantity = quantityInput ? quantityInput.value : '1';

    try {
        // Usa a API Fetch para fazer a requisição POST
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest' // Padrão para identificar requisições AJAX
            },
            body: new URLSearchParams({ 'quantity': quantity })
        });

        // Converte a resposta do servidor de string JSON para objeto JavaScript
        const result = await response.json();

        // Verifica se a resposta do servidor indica sucesso
        if (result.success) {
            updateCartCounter(result.data.cartCount);
            showToast(result.data.message, 'success');
            
            // Feedback de sucesso no botão
            submitButton.innerHTML = '<i class="fas fa-check"></i> Adicionado!';
            setTimeout(() => {
                submitButton.disabled = false;
                submitButton.innerHTML = originalButtonHTML;
            }, 2000); // Restaura o botão após 2 segundos

        } else {
            // Se o backend retornou um erro de negócio, lança uma exceção para o bloco catch
            throw new Error(result.message);
        }

    } catch (error) {
        console.error('Erro ao adicionar ao carrinho:', error);
        showToast(error.message || 'Não foi possível adicionar o item ao carrinho.', 'error');
        
        // Restaura o botão em caso de erro
        submitButton.disabled = false;
        submitButton.innerHTML = originalButtonHTML;
    }
}

/**
 * Atualiza o contador de itens do carrinho no cabeçalho.
 * @param {number} count - O número total de itens no carrinho.
 */
function updateCartCounter(count) {
    const counterElement = document.getElementById('cart-item-count');
    if (counterElement) {
        counterElement.textContent = count;
        if (count > 0) {
            counterElement.style.display = 'inline-block';
        } else {
            counterElement.style.display = 'none';
        }
    }
}

/**
 * Exibe uma notificação flutuante (toast).
 * @param {string} message - A mensagem a ser exibida.
 * @param {string} type - O tipo de notificação ('success', 'error', 'info').
 */
function showToast(message, type = 'info') {
    const existingToast = document.querySelector('.toast-notification');
    if (existingToast) {
        existingToast.remove();
    }
    
    const toast = document.createElement('div');
    toast.className = `toast-notification ${type}`;
    toast.textContent = message;
    
    document.body.appendChild(toast);
    
    // Força a animação de entrada
    setTimeout(() => {
        toast.classList.add('show');
    }, 10);
    
    // Remove o toast após alguns segundos
    setTimeout(() => {
        toast.classList.remove('show');
        setTimeout(() => toast.remove(), 500);
    }, 3500);
}