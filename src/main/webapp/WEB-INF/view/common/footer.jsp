<%-- /WEB-INF/views/common/footer.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<footer class="footer mt-auto">
    <div class="container text-center py-3">
        <p class="mb-1">&copy; <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy" /> Livraria Mil Páginas. Todos os direitos reservados.</p>
        <p class="mb-0 small">Desenvolvido com Java Servlets, JSP e muito &#x2764;&#xfe0f;.</p>
    </div>
</footer>

<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/js/cart.js"></script>
<script>
    // Atualiza a contagem de itens no carrinho no header
    function updateCartCount() {
        fetch(`${contextPath}/cart/count`)
            .then(response => {
                if (!response.ok) throw new Error('Network response was not ok');
                return response.json();
            })
            .then(data => {
                const cartCountEl = document.getElementById('cart-count');
                if (cartCountEl && data.success) {
                    cartCountEl.innerText = data.data || 0;
                }
            })
            .catch(error => console.error('Falha ao buscar contagem do carrinho:', error));
    }

    document.addEventListener('DOMContentLoaded', function () {
        updateCartCount();
    });
</script>