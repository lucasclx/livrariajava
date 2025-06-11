package com.livraria.dao;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * Classe base para operações de banco de dados
 */
public abstract class BaseDAO<T> {
    protected DataSource dataSource;
    
    // Construtor que obtém o DataSource configurado
    public BaseDAO() {
        try {
            Context ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/livraria");
        } catch (Exception e) {
            throw new RuntimeException("Erro ao configurar DataSource", e);
        }
    }
    
    /**
     * Obtém uma conexão com o banco de dados
     */
    protected Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    /**
     * Fecha recursos de banco de dados
     */
    protected void closeResources(Connection conn, PreparedStatement stmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        try {
            if (stmt != null) stmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    protected void closeResources(Connection conn, PreparedStatement stmt) {
        closeResources(conn, stmt, null);
    }
    
    /**
     * Métodos abstratos que devem ser implementados pelas classes filhas
     */
    public abstract List<T> findAll();
    public abstract T findById(Long id);
    public abstract T save(T entity);
    public abstract T update(T entity);
    public abstract boolean delete(Long id);
    protected abstract T mapResultSetToEntity(ResultSet rs) throws SQLException;
    
    /**
     * Busca paginada
     */
    public PaginatedResult<T> findWithPagination(int page, int size) {
        return findWithPagination(page, size, null, null);
    }
    
    public PaginatedResult<T> findWithPagination(int page, int size, String orderBy, String direction) {
        List<T> items = new ArrayList<>();
        int totalItems = 0;
        
        String countSql = "SELECT COUNT(*) FROM " + getTableName();
        String selectSql = buildSelectSql(orderBy, direction, page, size);
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // Contar total de registros
            stmt = conn.prepareStatement(countSql);
            rs = stmt.executeQuery();
            if (rs.next()) {
                totalItems = rs.getInt(1);
            }
            rs.close();
            stmt.close();
            
            // Buscar registros da página
            stmt = conn.prepareStatement(selectSql);
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                items.add(mapResultSetToEntity(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return new PaginatedResult<>(items, page, size, totalItems);
    }
    
    /**
     * Busca com filtros
     */
    public List<T> findWithFilters(Map<String, Object> filters) {
        List<T> items = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT * FROM " + getTableName());
        List<Object> parameters = new ArrayList<>();
        
        if (filters != null && !filters.isEmpty()) {
            sql.append(" WHERE ");
            boolean first = true;
            
            for (Map.Entry<String, Object> entry : filters.entrySet()) {
                if (!first) {
                    sql.append(" AND ");
                }
                
                String key = entry.getKey();
                Object value = entry.getValue();
                
                if (value instanceof String && ((String) value).contains("%")) {
                    sql.append(key).append(" LIKE ?");
                } else {
                    sql.append(key).append(" = ?");
                }
                
                parameters.add(value);
                first = false;
            }
        }
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql.toString());
            
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            rs = stmt.executeQuery();
            
            while (rs.next()) {
                items.add(mapResultSetToEntity(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }
        
        return items;
    }
    
    /**
     * Executa uma query customizada
     */
    protected List<T> executeQuery(String sql, Object... parameters) {
        List<T> items = new ArrayList<>();
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);
            
            for (int i = 0; i < parameters.length; i++) {
                stmt.setObject(i + 1, parameters[i]);
            }
            
            rs = stmt.executeQuery();
            while (rs.next()) {
                items.add(mapResultSetToEntity(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return items;
    }
}
