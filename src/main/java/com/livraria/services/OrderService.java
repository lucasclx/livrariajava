package com.livraria.services;

import com.livraria.dao.CartDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.dao.OrderDAO;
import com.livraria.models.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.math.BigDecimal;
import java.util.UUID;
import com.livraria.utils.ConnectionFactory;

/**
 * Serviço para gerenciar a criação de pedidos.
 */
public class OrderService {

    private final OrderDAO orderDAO;
    private final CartDAO cartDAO;
    private final LivroDAO livroDAO;
    private final PaymentService paymentService;

    public OrderService() {
        this.orderDAO = new OrderDAO();
        this.cartDAO = new CartDAO();
        this.livroDAO = new LivroDAO();
        this.paymentService = new PaymentService();
    }

    /**
     * Cria um novo pedido a partir do carrinho do usuário.
     * Este método deve ser transacional.
     *
     * @param user O usuário que está fazendo o pedido.
     * @param cart O carrinho de compras.
     * @param address O endereço de entrega.
     * @param paymentMethod O método de pagamento.
     * @return O pedido criado.
     * @throws SQLException Se ocorrer um erro no banco de dados.
     * @throws IllegalStateException Se o carrinho estiver vazio ou se houver problemas de estoque.
     */
    public Order createOrder(User user, Cart cart, UserAddress address, String paymentMethod) throws SQLException, IllegalStateException {
        List<CartItem> items = cartDAO.listarItensDoCarrinho(cart.getId());
        if (items.isEmpty()) {
            throw new IllegalStateException("O carrinho está vazio.");
        }

        // 1. Validar estoque antes de iniciar a transação
        List<String> stockErrors = cartDAO.validarEstoqueCarrinho(cart.getId());
        if (!stockErrors.isEmpty()) {
            throw new IllegalStateException("Erro de estoque: " + String.join(", ", stockErrors));
        }

        Connection conn = null;
        Order createdOrder = null;

        try {
            conn = ConnectionFactory.getConnection();
            conn.setAutoCommit(false); // Inicia a transação

            // 2. Criar o objeto Order
            Order order = new Order();
            order.setOrderNumber(UUID.randomUUID().toString().substring(0, 18).toUpperCase());
            order.setUserId(user.getId());
            order.setCartId(cart.getId());
            order.setPaymentMethod(paymentMethod);
            order.setStatus(Order.STATUS_PENDING_PAYMENT);

            // 3. Copiar dados do endereço
            order.setShippingRecipientName(address.getRecipientName());
            order.setShippingStreet(address.getStreet());
            order.setShippingNumber(address.getNumber());
            order.setShippingComplement(address.getComplement());
            order.setShippingNeighborhood(address.getNeighborhood());
            order.setShippingCity(address.getCity());
            order.setShippingState(address.getState());
            order.setShippingPostalCode(address.getPostalCode());

            // 4. Calcular totais
            CartService cartService = new CartService();
            // Esta chamada precisa de um request, o que é um problema de design.
            // Vamos recriar o cálculo aqui para evitar dependência do HttpServletRequest.
            CarrinhoTotais totals = calcularTotais(items);
            order.setSubtotal(totals.getSubtotal());
            order.setShippingCost(totals.getFrete());
            order.setDesconto(BigDecimal.ZERO); // Lógica de cupom não implementada no checkout
            order.setTotal(totals.getTotal());

            // 5. Salvar o pedido principal para obter o ID
            createdOrder = orderDAO.criar(conn, order);

            // 6. Salvar os itens do pedido e baixar o estoque
            for (CartItem item : items) {
                OrderItem orderItem = new OrderItem();
                orderItem.setOrderId(createdOrder.getId());
                orderItem.setLivroId(item.getLivroId());
                orderItem.setQuantity(item.getQuantity());
                orderItem.setUnitPrice(item.getPrice());
                
                orderDAO.criarItem(conn, orderItem);
                livroDAO.baixarEstoque(conn, item.getLivroId(), item.getQuantity());
            }

            // 7. Processar pagamento (simulado)
            boolean paymentSuccess = paymentService.processPayment(createdOrder);
            if (paymentSuccess) {
                createdOrder.setStatus(Order.STATUS_CONFIRMED);
            } else {
                createdOrder.setStatus(Order.STATUS_PAYMENT_FAILED);
            }
            orderDAO.atualizar(conn, createdOrder); // Atualiza o status do pedido

            // 8. Se o pagamento falhou, reverter a transação
            if (!paymentSuccess) {
                throw new SQLException("Falha no processamento do pagamento.");
            }
            
            // 9. Marcar o carrinho como concluído
            cartDAO.marcarComoConcluido(conn, cart.getId());

            conn.commit(); // Finaliza a transação com sucesso

        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback(); // Desfaz tudo em caso de erro
            }
            // Lançar a exceção para que o controller possa tratá-la
            throw new SQLException("Erro ao criar o pedido. A operação foi cancelada.", e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }

        return createdOrder;
    }
    
    // Método auxiliar para evitar dependência do HttpServletRequest
    private CarrinhoTotais calcularTotais(List<CartItem> items) throws SQLException {
        BigDecimal subtotal = BigDecimal.ZERO;
        int totalItens = 0;
        double pesoTotal = 0.0;

        for (CartItem item : items) {
            BigDecimal itemTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
            subtotal = subtotal.add(itemTotal);
            totalItens += item.getQuantity();

            Livro livro = livroDAO.buscarPorId(item.getLivroId());
            if (livro != null && livro.getPeso() != null) {
                pesoTotal += livro.getPeso() * item.getQuantity();
            } else {
                pesoTotal += 0.5 * item.getQuantity(); // Peso padrão
            }
        }

        // Lógica de frete simplificada
        BigDecimal frete = new BigDecimal("15.00");
        if (subtotal.compareTo(new BigDecimal("99.00")) >= 0) {
            frete = BigDecimal.ZERO; // Frete grátis
        } else if (pesoTotal <= 1.0) {
            frete = new BigDecimal("12.50");
        } else if (pesoTotal <= 3.0) {
            frete = new BigDecimal("18.90");
        }

        BigDecimal total = subtotal.add(frete);
        return new CarrinhoTotais(subtotal, frete, total, totalItens);
    }

    // Classe interna para evitar dependência do CartService
    public static class CarrinhoTotais {
        private final BigDecimal subtotal;
        private final BigDecimal frete;
        private final BigDecimal total;
        private final int totalItens;

        public CarrinhoTotais(BigDecimal subtotal, BigDecimal frete, BigDecimal total, int totalItens) {
            this.subtotal = subtotal;
            this.frete = frete;
            this.total = total;
            this.totalItens = totalItens;
        }

        public BigDecimal getSubtotal() { return subtotal; }
        public BigDecimal getFrete() { return frete; }
        public BigDecimal getTotal() { return total; }
        public int getTotalItens() { return totalItens; }
    }
}