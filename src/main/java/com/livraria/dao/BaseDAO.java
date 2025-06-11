package com.livraria.dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.function.Function;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import com.livraria.utils.ConnectionFactory;


/**
 * Classe base para operações de banco de dados
 */
public abstract class BaseDAO<T> {

    // Construtor padrão
    public BaseDAO() {
    }

    /**
     * Obtém uma conexão com o banco de dados
     */
    protected Connection getConnection() throws SQLException {
        return ConnectionFactory.getConnection();
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

    @FunctionalInterface
    protected interface RowMapper<R> {
        R map(ResultSet rs) throws SQLException;
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
    protected abstract String getTableName();
    
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

    /**
     * Executa uma query customizada usando mapeamento de resultado
     */
    protected <R> List<R> executeQuery(String sql, RowMapper<R> mapper, Object... parameters) {
        List<R> items = new ArrayList<>();

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
                items.add(mapper.map(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return items;
    }

    /** Executa uma query que retorna um único registro */
    protected <R> R executeSingleQuery(String sql, RowMapper<R> mapper, Object... parameters) {
        List<R> results = executeQuery(sql, mapper, parameters);
        return results.isEmpty() ? null : results.get(0);
    }

    /** Executa um INSERT retornando o id gerado (int) */
    protected int executeInsert(String sql, Object... parameters) {
        int id = 0;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            for (int i = 0; i < parameters.length; i++) {
                stmt.setObject(i + 1, parameters[i]);
            }

            stmt.executeUpdate();
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                id = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return id;
    }

    /** Executa um INSERT retornando o id gerado (Long) */
    protected Long executeInsertAndGetId(String sql, Object... parameters) {
        Long id = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            for (int i = 0; i < parameters.length; i++) {
                stmt.setObject(i + 1, parameters[i]);
            }

            stmt.executeUpdate();
            rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                id = rs.getLong(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return id;
    }

    /** Executa UPDATE/DELETE */
    protected int executeUpdate(String sql, Object... parameters) {
        int affected = 0;
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = getConnection();
            stmt = conn.prepareStatement(sql);

            for (int i = 0; i < parameters.length; i++) {
                stmt.setObject(i + 1, parameters[i]);
            }

            affected = stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt);
        }

        return affected;
    }

    /** Executa consulta COUNT */
    protected int executeCountQuery(String sql, Object... parameters) {
        int count = 0;
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
            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, stmt, rs);
        }

        return count;
    }

    /** Escapa caracteres para uso em LIKE */
    protected String escapeLike(String value) {
        if (value == null) return null;
        return value
            .replace("\\", "\\\\")
            .replace("%", "\\%")
            .replace("_", "\\_");
    }

    /** Constrói cláusula LIMIT/OFFSET */
    protected String buildLimitClause(int page, int size) {
        int offset = (page - 1) * size;
        return " LIMIT " + size + " OFFSET " + offset;
    }

    /** Valida parâmetros de paginação */
    protected void validatePagination(int page, int size) {
        if (page < 1) {
            throw new IllegalArgumentException("Página deve ser maior que zero");
        }
        if (size < 1 || size > 100) {
            throw new IllegalArgumentException("Itens por página deve estar entre 1 e 100");
        }
    }

    /** Converte Timestamp para LocalDateTime de forma segura */
    protected LocalDateTime toLocalDateTime(Timestamp ts) {
        return ts != null ? ts.toLocalDateTime() : null;
    }

    /** Monta SQL de seleção com ordenação e paginação */
    protected String buildSelectSql(String orderBy, String direction, int page, int size) {
        StringBuilder sb = new StringBuilder("SELECT * FROM ").append(getTableName());
        if (orderBy != null && !orderBy.trim().isEmpty()) {
            sb.append(" ORDER BY ").append(orderBy);
            if ("desc".equalsIgnoreCase(direction)) {
                sb.append(" DESC");
            } else {
                sb.append(" ASC");
            }
        }
        sb.append(buildLimitClause(page, size));
        return sb.toString();
    }

    /** Encontra apenas um registro */
    protected T findOne(String sql, Object... parameters) {
        List<T> results = executeQuery(sql, parameters);
        return results.isEmpty() ? null : results.get(0);
    }

    /** Executa contagem simples */
    protected int count(String sql, Object... parameters) {
        return executeCountQuery(sql, parameters);
    }
}
