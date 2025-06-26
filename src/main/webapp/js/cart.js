document.addEventListener('DOMContentLoaded', function() {
    const addToCartButtons = document.querySelectorAll('.js-add-to-cart');
    const cartCountSpan = document.getElementById('cart-count');

    addToCartButtons.forEach(button => {
        button.addEventListener('click', function() {
            const livroId = this.dataset.livroId;
            const quantity = 1; // Por enquanto, sempre adiciona 1 unidade

            fetch(`${contextPath}/api/cart/add/${livroId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ quantity: quantity })
            })
            .then(response => {
                if (!response.ok) {
                    // Tenta ler a mensagem de erro do corpo da resposta
                    return response.json().then(err => { throw new Error(err.message || 'Erro desconhecido'); });
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    if (cartCountSpan) {
                        cartCountSpan.textContent = data.data.count;
                    }
                    alert(data.data.message); // Exibe a mensagem de sucesso
                } else {
                    alert('Erro: ' + data.message); // Exibe a mensagem de erro da API
                }
            })
            .catch(error => {
                console.error('Erro ao adicionar ao carrinho:', error);
                alert('Erro ao adicionar ao carrinho: ' + error.message);
            });
        });
    });
});
