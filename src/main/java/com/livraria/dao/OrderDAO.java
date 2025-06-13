package com.livraria.dao;

import com.livraria.models.Order;
import com.livraria.models.OrderItem;
import com.livraria.models.User;
import com.livraria.models.Livro;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO extends BaseDAO<Order> {

    @Override
    protected String getTableName() {
        return "orders";
    }

    public Order criar(Connection conn, Order order) throws SQLException {
        String sql = "INSERT INTO orders (order_number, user_id, cart_id, cupom_id, subtotal, desconto, shipping_cost, total, payment_method, status, shipping_recipient_name, shipping_street, shipping_number, shipping_complement, shipping_neighborhood, shipping_city, shipping_state, shipping_postal_code, created_at, updated_at) " +
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

    public OrderItem criarItem(Connection conn, OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, livro_id, quantity, unit_price, total_price, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
        
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

    public int contarPorUsuario(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        return executeCountQuery(sql, userId);
    }
    
    public double calcularTotalGastoPorUsuario(int userId) throws SQLException {
        String sql = "SELECT SUM(total) FROM orders WHERE user_id = ? AND status NOT IN ('payment_failed', 'cancelled')";
        List<Double> result = executeQuery(sql, rs -> rs.getDouble(1), userId);
        return result.isEmpty() || result.get(0) == null ? 0.0 : result.get(0);
    }

    public List<Order> buscarPorUsuario(int userId, int page, int pageSize) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC" + buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToOrder, userId);
    }
    
    public List<Order> buscarUltimosPorUsuario(int userId, int limit) throws SQLException {
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToOrder, userId, limit);
    }

    private Order mapRowToOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setOrderNumber(rs.getString("order_number"));
        order.setUserId(rs.getInt("user_id"));
        order.setTotal(rs.getBigDecimal("total"));
        order.setStatus(rs.getString("status"));
        order.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        order.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        // Mapear outros campos se necessário
        return order;
    }

    // Outros métodos da classe abstrata
    @Override
    public List<Order> findAll() { throw new UnsupportedOperationException(); }
    @Override
    public Order findById(Long id) { throw new UnsupportedOperationException(); }
    @Override
    public Order save(Order entity) { throw new UnsupportedOperationException(); }
    @Override
    public Order update(Order entity) { throw new UnsupportedOperationException(); }
    @Override
    public boolean delete(Long id) { throw new UnsupportedOperationException(); }
    @Override
    protected Order mapResultSetToEntity(ResultSet rs) throws SQLException { return mapRowToOrder(rs); }
}