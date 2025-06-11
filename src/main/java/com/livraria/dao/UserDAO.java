package com.livraria.dao;

import com.livraria.models.User;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com usuários
 */
public class UserDAO extends BaseDAO {
    
    /**
     * Busca usuário por ID
     */
    public User buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToUser, id);
    }
    
    /**
     * Busca usuário por email
     */
    public User buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        return executeSingleQuery(sql, this::mapRowToUser, email);
    }
    
    /**
     * Verifica se email já existe
     */
    public boolean emailJaExiste(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        return executeCountQuery(sql, email) > 0;
    }
    
    /**
     * Verifica se email já existe para outro usuário
     */
    public boolean emailJaExisteParaOutroUsuario(String email, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND id != ?";
        return executeCountQuery(sql, email, userId) > 0;
    }
    
    /**
     * Cria novo usuário
     */
    public User criar(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, is_admin, ativo, telefone, " +
                    "data_nascimento, genero, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql, 
            user.getName(),
            user.getEmail(),
            user.getPassword(),
            user.isAdmin(),
            user.isAtivo(),
            user.getTelefone(),
            user.getDataNascimento(),
            user.getGenero()
        );
        
        user.setId(id);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        return user;
    }
    
    /**
     * Atualiza usuário
     */
    public boolean atualizar(User user) throws SQLException {
        String sql = "UPDATE users SET name = ?, email = ?, telefone = ?, " +
                    "data_nascimento = ?, genero = ?, updated_at = NOW() WHERE id = ?";
        
        int affectedRows = executeUpdate(sql,
            user.getName(),
            user.getEmail(),
            user.getTelefone(),
            user.getDataNascimento(),
            user.getGenero(),
            user.getId()
        );
        
        return affectedRows > 0;
    }
    
    /**
     * Atualiza senha do usuário
     */
    public boolean atualizarSenha(int userId, String novaSenhaHash) throws SQLException {
        String sql = "UPDATE users SET password = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, novaSenhaHash, userId) > 0;
    }
    
    /**
     * Atualiza último login
     */
    public boolean atualizarUltimoLogin(int userId) throws SQLException {
        String sql = "UPDATE users SET last_login_at = NOW(), updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, userId) > 0;
    }
    
    /**
     * Lista usuários com filtros
     */
    public List<User> buscarComFiltros(String busca, String status, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        StringBuilder sql = new StringBuilder("SELECT * FROM users");
        List<Object> params = new ArrayList<>();
        
        // Construir WHERE
        List<String> conditions = new ArrayList<>();
        
        if (busca != null && !busca.trim().isEmpty()) {
            conditions.add("(name LIKE ? OR email LIKE ?)");
            String searchTerm = "%" + escapeLike(busca.trim()) + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            if ("ativo".equals(status)) {
                conditions.add("ativo = true");
            } else if ("inativo".equals(status)) {
                conditions.add("ativo = false");
            } else if ("admin".equals(status)) {
                conditions.add("is_admin = true");
            }
        }
        
        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        
        sql.append(" ORDER BY name").append(buildLimitClause(page, pageSize));
        
        return executeQuery(sql.toString(), this::mapRowToUser, params.toArray());
    }
    
    /**
     * Conta usuários com filtros
     */
    public int contarComFiltros(String busca, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users");
        List<Object> params = new ArrayList<>();
        
        // Construir WHERE (mesmo lógica do buscarComFiltros)
        List<String> conditions = new ArrayList<>();
        
        if (busca != null && !busca.trim().isEmpty()) {
            conditions.add("(name LIKE ? OR email LIKE ?)");
            String searchTerm = "%" + escapeLike(busca.trim()) + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (status != null && !status.trim().isEmpty()) {
            if ("ativo".equals(status)) {
                conditions.add("ativo = true");
            } else if ("inativo".equals(status)) {
                conditions.add("ativo = false");
            } else if ("admin".equals(status)) {
                conditions.add("is_admin = true");
            }
        }
        
        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        
        return executeCountQuery(sql.toString(), params.toArray());
    }
    
    /**
     * Conta total de usuários
     */
    public int contar() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM users");
    }
    
    /**
     * Conta novos usuários em um período
     */
    public int contarNovosPeriodo(int dias) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeCountQuery(sql, dias);
    }
    
    /**
     * Lista administradores
     */
    public List<User> listarAdministradores() throws SQLException {
        String sql = "SELECT * FROM users WHERE is_admin = true ORDER BY name";
        return executeQuery(sql, this::mapRowToUser);
    }
    
    /**
     * Ativa/desativa usuário
     */
    public boolean alterarStatus(int userId, boolean ativo) throws SQLException {
        String sql = "UPDATE users SET ativo = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, ativo, userId) > 0;
    }
    
    /**
     * Promove/rebaixa usuário a admin
     */
    public boolean alterarTipoAdmin(int userId, boolean isAdmin) throws SQLException {
        String sql = "UPDATE users SET is_admin = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, isAdmin, userId) > 0;
    }
    
    /**
     * Exclui usuário (soft delete ou hard delete dependendo da regra de negócio)
     */
    public boolean excluir(int userId) throws SQLException {
        // Por segurança, primeiro verificar se o usuário tem pedidos
        String checkSql = "SELECT COUNT(*) FROM orders WHERE user_id = ?";
        int orderCount = executeCountQuery(checkSql, userId);
        
        if (orderCount > 0) {
            // Se tem pedidos, apenas desativar
            return alterarStatus(userId, false);
        } else {
            // Se não tem pedidos, pode excluir fisicamente
            String sql = "DELETE FROM users WHERE id = ?";
            return executeUpdate(sql, userId) > 0;
        }
    }
    
    /**
     * Mapeia ResultSet para User
     */
    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setAdmin(rs.getBoolean("is_admin"));
        user.setAtivo(rs.getBoolean("ativo"));
        user.setTelefone(rs.getString("telefone"));
        
        // Tratar campos de data que podem ser null
        if (rs.getDate("data_nascimento") != null) {
            user.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());
        }
        
        user.setGenero(rs.getString("genero"));
        user.setEmailVerifiedAt(toLocalDateTime(rs.getTimestamp("email_verified_at")));
        user.setLastLoginAt(toLocalDateTime(rs.getTimestamp("last_login_at")));
        user.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        user.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return user;
    }
}