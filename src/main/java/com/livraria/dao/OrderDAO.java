package com.livraria.dao;

import com.livraria.models.Order;
import com.livraria.utils.ConnectionFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int contar() throws SQLException {
        String sql = "SELECT COUNT(*) FROM pedidos";
        try (Connection conn = ConnectionFactory.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    public Order buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM pedidos WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return parseOrder(rs);
            }
        }
        return null;
    }

    public List<Order> buscarUltimos(int limite) throws SQLException {
        String sql = "SELECT * FROM pedidos ORDER BY data_criacao DESC LIMIT ?";
        List<Order> lista = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, limite);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) lista.add(parseOrder(rs));
            }
        }
        return lista;
    }

    public void atualizarStatus(int pedidoId, String status, String observacoes) throws SQLException {
        String sql = "UPDATE pedidos SET status = ?, observacoes = ? WHERE id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, observacoes);
            stmt.setInt(3, pedidoId);
            stmt.executeUpdate();
        }
    }

    public void devolverEstoque(int pedidoId) throws SQLException {
        // Exemplo simples. Adapte para seu sistema.
        String sql = "UPDATE livros l " +
                "JOIN itens_pedido i ON l.id = i.livro_id " +
                "SET l.estoque = l.estoque + i.quantidade " +
                "WHERE i.pedido_id = ?";
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pedidoId);
            stmt.executeUpdate();
        }
    }

    // Métodos fictícios para exemplos avançados - personalize conforme seu banco:
    public int contarComFiltros(String status, String dataInicio, String dataFim) throws SQLException {
        String sql = "SELECT COUNT(*) FROM pedidos WHERE 1=1";
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
            params.add(status);
        }
        if (dataInicio != null && !dataInicio.isEmpty()) {
            sql += " AND data_criacao >= ?";
            params.add(Date.valueOf(dataInicio));
        }
        if (dataFim != null && !dataFim.isEmpty()) {
            sql += " AND data_criacao <= ?";
            params.add(Date.valueOf(dataFim));
        }
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Order> buscarComFiltros(String status, String dataInicio, String dataFim, int page, int pageSize) throws SQLException {
        String sql = "SELECT * FROM pedidos WHERE 1=1";
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            sql += " AND status = ?";
            params.add(status);
        }
        if (dataInicio != null && !dataInicio.isEmpty()) {
            sql += " AND data_criacao >= ?";
            params.add(Date.valueOf(dataInicio));
        }
        if (dataFim != null && !dataFim.isEmpty()) {
            sql += " AND data_criacao <= ?";
            params.add(Date.valueOf(dataFim));
        }
        sql += " ORDER BY data_criacao DESC LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        List<Order> lista = new ArrayList<>();
        try (Connection conn = ConnectionFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) lista.add(parseOrder(rs));
            }
        }
        return lista;
    }

    // Exemplo de parse para montar o objeto Order (personalize para seu modelo!)
    private Order parseOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setStatus(rs.getString("status"));
        order.setDataCriacao(rs.getTimestamp("data_criacao").toLocalDateTime());
        order.setObservacoes(rs.getString("observacoes"));
        // Preencha os campos conforme sua tabela
        return order;
    }

    // Outros métodos conforme necessidade...
}
