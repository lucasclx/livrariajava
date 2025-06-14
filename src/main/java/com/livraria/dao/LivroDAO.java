package com.livraria.dao;

import com.livraria.models.User;
import com.livraria.utils.PasswordUtil;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * DAO para operações com Usuários.
 * Corrigido para conter o código correto da classe UserDAO.
 */
public class UserDAO extends BaseDAO<User> {

    @Override
    protected String getTableName() {
        return "users";
    }

    @Override
    protected User mapResultSetToEntity(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setTelefone(rs.getString("telefone"));
        user.setCpf(rs.getString("cpf"));
        if (rs.getDate("data_nascimento") != null) {
            user.setDataNascimento(rs.getDate("data_nascimento").toLocalDate());
        }
        user.setGenero(rs.getString("genero"));
        user.setIsAdmin(rs.getBoolean("is_admin"));
        user.setAtivo(rs.getBoolean("ativo"));
        user.setEmailVerifiedAt(toLocalDateTime(rs.getTimestamp("email_verified_at")));
        user.setLastLoginAt(toLocalDateTime(rs.getTimestamp("last_login_at")));
        user.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        user.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        return user;
    }

    public User buscarPorEmail(String email) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ?";
        return executeSingleQuery(sql, this::mapResultSetToEntity, email);
    }

    public boolean emailJaExiste(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        return executeCountQuery(sql, email) > 0;
    }

    public boolean emailJaExisteParaOutroUsuario(String email, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND id != ?";
        return executeCountQuery(sql, email, userId) > 0;
    }

    public User criar(User user) throws SQLException {
        String sql = "INSERT INTO users (name, email, password, telefone, cpf, data_nascimento, genero, is_admin, ativo, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        int id = executeInsert(sql,
            user.getName(), user.getEmail(), user.getPassword(), user.getTelefone(),
            user.getCpf(), user.getDataNascimento(), user.getGenero(),
            user.getIsAdmin(), user.getAtivo());
        user.setId(id);
        return user;
    }

    public boolean atualizar(User user) throws SQLException {
        String sql = "UPDATE users SET name = ?, email = ?, telefone = ?, data_nascimento = ?, genero = ?, ativo = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, user.getName(), user.getEmail(), user.getTelefone(),
                        user.getDataNascimento(), user.getGenero(), user.getAtivo(), user.getId()) > 0;
    }

    public boolean atualizarUltimoLogin(int userId) throws SQLException {
        String sql = "UPDATE users SET last_login_at = NOW() WHERE id = ?";
        return executeUpdate(sql, userId) > 0;
    }

    public boolean atualizarSenha(int userId, String newPasswordHash) throws SQLException {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        return executeUpdate(sql, newPasswordHash, userId) > 0;
    }

    public int contar() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM " + getTableName());
    }

    public List<User> buscarComFiltros(String busca, String status, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        
        if (busca != null && !busca.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR email LIKE ? OR cpf LIKE ?) ");
            String searchTerm = "%" + escapeLike(busca) + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (status != null && !status.isEmpty()) {
            sql.append("AND ativo = ? ");
            params.add("ativo".equals(status));
        }
        
        sql.append("ORDER BY name ASC ").append(buildLimitClause(page, pageSize));
        
        return executeQuery(sql.toString(), this::mapResultSetToEntity, params.toArray());
    }

    public int contarComFiltros(String busca, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        
        if (busca != null && !busca.trim().isEmpty()) {
            sql.append("AND (name LIKE ? OR email LIKE ? OR cpf LIKE ?) ");
            String searchTerm = "%" + escapeLike(busca) + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (status != null && !status.isEmpty()) {
            sql.append("AND ativo = ? ");
            params.add("ativo".equals(status));
        }
        
        return executeCountQuery(sql.toString(), params.toArray());
    }
    
    // Métodos não utilizados da BaseDAO (implementação mínima)
    @Override public List<User> findAll() { throw new UnsupportedOperationException(); }
    @Override public User findById(Long id) { throw new UnsupportedOperationException(); }
    @Override public User save(User entity) { throw new UnsupportedOperationException(); }
    @Override public User update(User entity) { throw new UnsupportedOperationException(); }
    @Override public boolean delete(Long id) { throw new UnsupportedOperationException(); }
}