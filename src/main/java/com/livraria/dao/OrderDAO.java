package com.livraria.dao;

import com.livraria.models.Order;
import com.livraria.models.OrderItem;
import com.livraria.models.User;
import com.livraria.models.Livro;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com pedidos - Versão Completa
 */
public class OrderDAO extends BaseDAO<Order> {

    @Override
    protected String getTableName() {
        return "orders";
    }

    @Override
    protected Order mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToOrder(rs);
    }

    // ========== MÉTODOS BÁSICOS ==========

    /**
     * Busca pedido por ID
     */
    public Order buscarPorId(int orderId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToOrder, orderId);
    }

    /**
     * Busca pedido por número
     */
    public Order buscarPorNumero(String orderNumber) throws SQLException {
        String sql = "SELECT * FROM orders WHERE order_number = ?";
        return executeSingleQuery(sql, this::mapRowToOrder, orderNumber);
    }

    /**
     * Cria novo pedido (com conexão externa para transação)
     */
    public Order criar(Connection conn, Order order) throws SQLException {
        String sql = "INSERT INTO orders (order_number, user_id, cart_id, cupom_id, subtotal, desconto, " +
                     "shipping_cost, total, payment_method, status, shipping_recipient_name, shipping_street, " +
                     "shipping_number, shipping_complement, shipping_neighborhood, shipping_city, shipping_state, " +
                     "shipping_postal_code, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        stmt.setString(1, order.getOrderNumber());
        stmt.setInt(2, order.getUserId());
        stmt.setObject(3, order.getCartId());
        stmt.setObject(4, order.getCupomId());
        stmt.setBigDecimal(5, order.getSubtotal());
        stmt.setBigDecimal(6, order.getDesconto());
        stmt.setBigDecimal(7, order.getShippingCost());
        stmt.setBigDecimal(8, order.getTotal());
        stmt.setString(9, order.getPaymentMethod());
        stmt.setString(10, order.getStatus());
        stmt.setString(11, order.getShippingRecipientName());
        stmt.setString(12, order.getShippingStreet());
        stmt.setString(13, order.getShippingNumber());
        stmt.setString(14, order.getShippingComplement());
        stmt.setString(15, order.getShippingNeighborhood());
        stmt.setString(16, order.getShippingCity());
        stmt.setString(17, order.getShippingState());
        stmt.setString(18, order.getShippingPostalCode());
        
        stmt.executeUpdate();
        
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            order.setId(rs.getInt(1));
        }
        rs.close();
        stmt.close();
        
        return order;
    }

    /**
     * Atualiza pedido (com conexão externa para transação)
     */
    public boolean atualizar(Connection conn, Order order) throws SQLException {
        String sql = "UPDATE orders SET status = ?, updated_at = NOW() WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, order.getStatus());
            stmt.setInt(2, order.getId());
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Atualiza pedido (sem conexão externa)
     */
    public boolean atualizar(Order order) throws SQLException {
        String sql = "UPDATE orders SET status = ?, notes = ?, tracking_code = ?, " +
                    "shipped_at = ?, delivered_at = ?, updated_at = NOW() WHERE id = ?";
        
        return executeUpdate(sql, 
            order.getStatus(),
            order.getNotes(),
            order.getTrackingCode(),
            order.getShippedAt(),
            order.getDeliveredAt(),
            order.getId()
        ) > 0;
    }

    // ========== MÉTODOS DOS ITENS DO PEDIDO ==========

    /**
     * Cria item do pedido (com conexão externa para transação)
     */
    public OrderItem criarItem(Connection conn, OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, livro_id, quantity, unit_price, total_price, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, NOW())";
        
        PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        stmt.setInt(1, item.getOrderId());
        stmt.setInt(2, item.getLivroId());
        stmt.setInt(3, item.getQuantity());
        stmt.setBigDecimal(4, item.getUnitPrice());
        stmt.setBigDecimal(5, item.getUnitPrice().multiply(new BigDecimal(item.getQuantity())));

        stmt.executeUpdate();
        
        ResultSet rs = stmt.getGeneratedKeys();
        if (rs.next()) {
            item.setId(rs.getInt(1));
        }
        rs.close();
        stmt.close();

        return item;
    }

    /**
     * Lista itens de um pedido
     */
    public List<OrderItem> listarItensDoPedido(int orderId) throws SQLException {
        String sql = "SELECT oi.*, l.titulo, l.autor, l.imagem FROM order_items oi " +
                    "JOIN livros l ON oi.livro_id = l.id " +
                    "WHERE oi.order_id = ? ORDER BY oi.id";
        
        return executeQuery(sql, this::mapRowToOrderItemComLivro, orderId);
    }

    // ========== MÉTODOS DE BUSCA POR USUÁRIO ==========

    /**
     * Busca pedidos por usuário com paginação
     */
    public List<Order> buscarPorUsuario(int userId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC" + 
                    buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToOrder, userId);
    }

    /**
     * Busca últimos pedidos do usuário
     */
    public List<Order> buscarUltimosPorUsuario(int userId, int limit) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToOrder, userId, limit);
    }

    /**
     * Conta pedidos por usuário
     */
    public int contarPorUsuario(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        return executeCountQuery(sql, userId);
    }

    /**
     * Calcula total gasto por usuário
     */
    public double calcularTotalGastoPorUsuario(int userId) throws SQLException {
        String sql = "SELECT SUM(total) FROM orders WHERE user_id = ? AND status NOT IN ('payment_failed', 'cancelled')";
        List<Double> result = executeQuery(sql, rs -> {
            double value = rs.getDouble(1);
            return rs.wasNull() ? 0.0 : value;
        }, userId);
        return result.isEmpty() ? 0.0 : result.get(0);
    }

    // ========== MÉTODOS DE BUSCA GERAL ==========

    /**
     * Busca pedidos com filtros
     */
    public List<Order> buscarComFiltros(String status, String dataInicio, String dataFim, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        StringBuilder sql = new StringBuilder("SELECT o.*, u.name as user_name FROM orders o ");
        sql.append("JOIN users u ON o.user_id = u.id WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }
        
        if (dataInicio != null && !dataInicio.isEmpty()) {
            sql.append("AND o.created_at >= ? ");
            params.add(dataInicio + " 00:00:00");
        }
        
        if (dataFim != null && !dataFim.isEmpty()) {
            sql.append("AND o.created_at <= ? ");
            params.add(dataFim + " 23:59:59");
        }
        
        sql.append("ORDER BY o.created_at DESC ").append(buildLimitClause(page, pageSize));
        
        return executeQuery(sql.toString(), this::mapRowToOrderWithUser, params.toArray());
    }

    /**
     * Conta pedidos com filtros
     */
    public int contarComFiltros(String status, String dataInicio, String dataFim) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM orders o WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (status != null && !status.isEmpty()) {
            sql.append("AND o.status = ? ");
            params.add(status);
        }
        
        if (dataInicio != null && !dataInicio.isEmpty()) {
            sql.append("AND o.created_at >= ? ");
            params.add(dataInicio + " 00:00:00");
        }
        
        if (dataFim != null && !dataFim.isEmpty()) {
            sql.append("AND o.created_at <= ? ");
            params.add(dataFim + " 23:59:59");
        }
        
        return executeCountQuery(sql.toString(), params.toArray());
    }

    /**
     * Busca pedidos por status
     */
    public List<Order> buscarPorStatus(String status, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM orders WHERE status = ? ORDER BY created_at DESC" + 
                    buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToOrder, status);
    }

    /**
     * Busca últimos pedidos do sistema
     */
    public List<Order> buscarUltimos(int limit) throws SQLException {
        String sql = "SELECT o.*, u.name as user_name " +
                     "FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToOrderWithUser, limit);
    }

    // ========== MÉTODOS DE ESTATÍSTICAS ==========

    /**
     * Conta o total de pedidos no sistema
     */
    public int contar() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM orders");
    }

    /**
     * Calcula o faturamento do mês atual
     */
    public BigDecimal calcularFaturamentoMesAtual() throws SQLException {
        String sql = "SELECT SUM(total) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH) " +
                    "AND status NOT IN ('cancelled', 'payment_failed')";
        List<BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1));
        return result.isEmpty() || result.get(0) == null ? BigDecimal.ZERO : result.get(0);
    }

    /**
     * Calcula faturamento por período
     */
    public BigDecimal calcularFaturamentoPeriodo(int dias) throws SQLException {
        String sql = "SELECT SUM(total) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "AND status NOT IN ('cancelled', 'payment_failed')";
        List<BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1), dias);
        return result.isEmpty() || result.get(0) == null ? BigDecimal.ZERO : result.get(0);
    }

    /**
     * Conta pedidos por período
     */
    public int contarPedidosPeriodo(int dias) throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeCountQuery(sql, dias);
    }

    /**
     * Conta livros vendidos por período
     */
    public int contarLivrosVendidosPeriodo(int dias) throws SQLException {
        String sql = "SELECT SUM(oi.quantity) FROM order_items oi " +
                    "JOIN orders o ON oi.order_id = o.id " +
                    "WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "AND o.status NOT IN ('cancelled', 'payment_failed')";
        
        List<Integer> result = executeQuery(sql, rs -> {
            int value = rs.getInt(1);
            return rs.wasNull() ? 0 : value;
        }, dias);
        return result.isEmpty() ? 0 : result.get(0);
    }

    // ========== MÉTODOS DE ATUALIZAÇÃO DE STATUS ==========

    /**
     * Atualiza status do pedido
     */
    public boolean atualizarStatus(int orderId, String novoStatus, String observacoes) throws SQLException {
        String sql = "UPDATE orders SET status = ?, notes = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, novoStatus, observacoes, orderId) > 0;
    }

    /**
     * Marca pedido como enviado
     */
    public boolean marcarComoEnviado(int orderId, String trackingCode) throws SQLException {
        String sql = "UPDATE orders SET status = 'shipped', tracking_code = ?, shipped_at = NOW(), updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, trackingCode, orderId) > 0;
    }

    /**
     * Marca pedido como entregue
     */
    public boolean marcarComoEntregue(int orderId) throws SQLException {
        String sql = "UPDATE orders SET status = 'delivered', delivered_at = NOW(), updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, orderId) > 0;
    }

    /**
     * Cancela pedido
     */
    public boolean cancelarPedido(int orderId, String motivo) throws SQLException {
        String sql = "UPDATE orders SET status = 'cancelled', notes = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, motivo, orderId) > 0;
    }

    // ========== MÉTODOS DE RELATÓRIOS ==========

    /**
     * Calcula vendas por categoria em um período
     */
    public List<Object[]> calcularVendasPorCategoria(int dias) throws SQLException {
        String sql = "SELECT c.nome, SUM(oi.quantity) as quantidade, SUM(oi.total_price) as valor " +
                    "FROM order_items oi " +
                    "JOIN orders o ON oi.order_id = o.id " +
                    "JOIN livros l ON oi.livro_id = l.id " +
                    "JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "AND o.status NOT IN ('cancelled', 'payment_failed') " +
                    "GROUP BY c.id, c.nome " +
                    "ORDER BY valor DESC";
        
        return executeQuery(sql, rs -> new Object[]{
            rs.getString("nome"),
            rs.getInt("quantidade"),
            rs.getBigDecimal("valor")
        }, dias);
    }

    /**
     * Calcula vendas diárias em um período
     */
    public List<Object[]> calcularVendasDiarias(int dias) throws SQLException {
        String sql = "SELECT DATE(o.created_at) as data, COUNT(*) as pedidos, SUM(o.total) as valor " +
                    "FROM orders o " +
                    "WHERE o.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "AND o.status NOT IN ('cancelled', 'payment_failed') " +
                    "GROUP BY DATE(o.created_at) " +
                    "ORDER BY data DESC";
        
        return executeQuery(sql, rs -> new Object[]{
            rs.getDate("data"),
            rs.getInt("pedidos"),
            rs.getBigDecimal("valor")
        }, dias);
    }

    /**
     * Busca pedidos por método de pagamento
     */
    public List<Object[]> estatisticasPorMetodoPagamento(int dias) throws SQLException {
        String sql = "SELECT payment_method, COUNT(*) as quantidade, SUM(total) as valor " +
                    "FROM orders " +
                    "WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) " +
                    "AND status NOT IN ('cancelled', 'payment_failed') " +
                    "GROUP BY payment_method " +
                    "ORDER BY quantidade DESC";
        
        return executeQuery(sql, rs -> new Object[]{
            rs.getString("payment_method"),
            rs.getInt("quantidade"),
            rs.getBigDecimal("valor")
        }, dias);
    }

    // ========== MÉTODOS DE BUSCA COMPLETA ==========

    /**
     * Busca pedido completo com itens
     */
    public Order buscarPorIdCompleto(int orderId) throws SQLException {
        Order order = buscarPorId(orderId);
        if (order != null) {
            List<OrderItem> itens = listarItensDoPedido(orderId);
            // Nota: Order não tem setItems no modelo atual, mas poderia ser adicionado
        }
        return order;
    }

    // ========== MÉTODOS DE VALIDAÇÃO ==========

    /**
     * Verifica se pedido pode ser cancelado
     */
    public boolean podeCancelar(int orderId) throws SQLException {
        String sql = "SELECT status FROM orders WHERE id = ?";
        List<String> result = executeQuery(sql, rs -> rs.getString("status"), orderId);
        
        if (result.isEmpty()) return false;
        
        String status = result.get(0);
        return Order.STATUS_PENDING_PAYMENT.equals(status) ||
               Order.STATUS_CONFIRMED.equals(status) ||
               Order.STATUS_PROCESSING.equals(status);
    }

    /**
     * Verifica se pedido pode ser enviado
     */
    public boolean podeEnviar(int orderId) throws SQLException {
        String sql = "SELECT status FROM orders WHERE id = ?";
        List<String> result = executeQuery(sql, rs -> rs.getString("status"), orderId);
        
        if (result.isEmpty()) return false;
        
        String status = result.get(0);
        return Order.STATUS_CONFIRMED.equals(status) ||
               Order.STATUS_PROCESSING.equals(status);
    }

    // ========== MÉTODOS DE ESTOQUE ==========

    /**
     * Devolve estoque dos itens do pedido (para cancelamentos)
     */
    public void devolverEstoque(int orderId) throws SQLException {
        String sql = "UPDATE livros l " +
                    "JOIN order_items oi ON l.id = oi.livro_id " +
                    "SET l.estoque = l.estoque + oi.quantity " +
                    "WHERE oi.order_id = ?";
        
        executeUpdate(sql, orderId);
    }

    // ========== MÉTODOS DE MAPEAMENTO ==========

    /**
     * Mapeia ResultSet para Order
     */
    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setUserId(rs.getInt("user_id"));
        order.setCartId((Integer) rs.getObject("cart_id"));
        order.setCupomId((Integer) rs.getObject("cupom_id"));
        order.setSubtotal(rs.getBigDecimal("subtotal"));
        order.setDesconto(rs.getBigDecimal("desconto"));
        order.setShippingCost(rs.getBigDecimal("shipping_cost"));
        order.setTotal(rs.getBigDecimal("total"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setStatus(rs.getString("status"));
        order.setNotes(rs.getString("notes"));
        order.setObservacoes(rs.getString("observacoes"));
        order.setTrackingCode(rs.getString("tracking_code"));
        
        // Dados de endereço
        order.setShippingRecipientName(rs.getString("shipping_recipient_name"));
        order.setShippingStreet(rs.getString("shipping_street"));
        order.setShippingNumber(rs.getString("shipping_number"));
        order.setShippingComplement(rs.getString("shipping_complement"));
        order.setShippingNeighborhood(rs.getString("shipping_neighborhood"));
        order.setShippingCity(rs.getString("shipping_city"));
        order.setShippingState(rs.getString("shipping_state"));
        order.setShippingPostalCode(rs.getString("shipping_postal_code"));
        order.setShippingReference(rs.getString("shipping_reference"));
        
        // Datas
        order.setShippedAt(toLocalDateTime(rs.getTimestamp("shipped_at")));
        order.setDeliveredAt(toLocalDateTime(rs.getTimestamp("delivered_at")));
        order.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        order.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return order;
    }

    /**
     * Mapeia ResultSet para Order com dados do usuário
     */
    private Order mapRowToOrderWithUser(ResultSet rs) throws SQLException {
        Order order = mapRowToOrder(rs);
        
        // Adicionar dados do usuário se disponíveis
        try {
            if (hasColumn(rs, "user_name")) {
                User user = new User();
                user.setId(order.getUserId());
                user.setName(rs.getString("user_name"));
                order.setUser(user);
            }
        } catch (SQLException e) {
            // Dados do usuário podem não estar disponíveis
        }
        
        return order;
    }

    /**
     * Mapeia ResultSet para OrderItem
     */
    private OrderItem mapRowToOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setId(rs.getInt("id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setLivroId(rs.getInt("livro_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        item.setTotalPrice(rs.getBigDecimal("total_price"));
        item.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        
        return item;
    }

    /**
     * Mapeia ResultSet para OrderItem com dados do livro
     */
    private OrderItem mapRowToOrderItemComLivro(ResultSet rs) throws SQLException {
        OrderItem item = mapRowToOrderItem(rs);
        
        // Dados básicos do livro
        try {
            if (hasColumn(rs, "titulo")) {
                Livro livro = new Livro();
                livro.setId(item.getLivroId());
                livro.setTitulo(rs.getString("titulo"));
                livro.setAutor(rs.getString("autor"));
                livro.setImagem(rs.getString("imagem"));
                item.setLivro(livro);
            }
        } catch (SQLException e) {
            // Dados do livro podem não estar disponíveis
        }
        
        return item;
    }

    // ========== MÉTODOS ABSTRATOS DA BASEDAO ==========

    @Override
    public List<Order> findAll() {
        try {
            String sql = "SELECT * FROM orders ORDER BY created_at DESC";
            return executeQuery(sql, this::mapRowToOrder);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Order findById(Long id) {
        try {
            return buscarPorId(id.intValue());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Order save(Order entity) {
        throw new UnsupportedOperationException("Use criar(Connection, Order) para transações");
    }

    @Override
    public Order update(Order entity) {
        try {
            atualizar(entity);
            return entity;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean delete(Long id) {
        try {
            String sql = "DELETE FROM orders WHERE id = ?";
            return executeUpdate(sql, id) > 0;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}