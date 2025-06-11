package com.livraria.dao;

import com.livraria.models.Avaliacao;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO para operações com avaliações
 */
public class AvaliacaoDAO extends BaseDAO<Avaliacao> {

    @Override
    protected String getTableName() {
        return "avaliacoes";
    }

    @Override
    public List<Avaliacao> findAll() {
        String sql = "SELECT * FROM avaliacoes ORDER BY created_at DESC";
        return executeQuery(sql, this::mapRowToAvaliacao);
    }

    @Override
    public Avaliacao findById(Long id) {
        try {
            return buscarPorId(id.intValue());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Avaliacao save(Avaliacao entity) {
        try {
            return criar(entity);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Avaliacao update(Avaliacao entity) {
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
            return excluir(id.intValue());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected Avaliacao mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToAvaliacao(rs);
    }
    
    /**
     * Busca avaliação por ID
     */
    public Avaliacao buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM avaliacoes WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToAvaliacao, id);
    }
    
    /**
     * Cria nova avaliação
     */
    public Avaliacao criar(Avaliacao avaliacao) throws SQLException {
        String sql = "INSERT INTO avaliacoes (livro_id, user_id, rating, titulo, comentario, " +
                    "aprovado, recomenda, vantagens, desvantagens, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            avaliacao.getLivroId(),
            avaliacao.getUserId(),
            avaliacao.getRating(),
            avaliacao.getTitulo(),
            avaliacao.getComentario(),
            avaliacao.isAprovado(),
            avaliacao.isRecomenda(),
            avaliacao.getVantagens(),
            avaliacao.getDesvantagens()
        );
        
        avaliacao.setId(id);
        return avaliacao;
    }
    
    /**
     * Atualiza avaliação
     */
    public boolean atualizar(Avaliacao avaliacao) throws SQLException {
        String sql = "UPDATE avaliacoes SET rating = ?, titulo = ?, comentario = ?, " +
                    "aprovado = ?, recomenda = ?, vantagens = ?, desvantagens = ?, " +
                    "updated_at = NOW() WHERE id = ?";
        
        return executeUpdate(sql,
            avaliacao.getRating(),
            avaliacao.getTitulo(),
            avaliacao.getComentario(),
            avaliacao.isAprovado(),
            avaliacao.isRecomenda(),
            avaliacao.getVantagens(),
            avaliacao.getDesvantagens(),
            avaliacao.getId()
        ) > 0;
    }
    
    /**
     * Exclui avaliação
     */
    public boolean excluir(int id) throws SQLException {
        String sql = "DELETE FROM avaliacoes WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }
    
    /**
     * Conta avaliações por usuário
     */
    public int contarPorUsuario(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM avaliacoes WHERE user_id = ?";
        return executeCountQuery(sql, userId);
    }
    
    /**
     * Busca avaliações por livro
     */
    public List<Avaliacao> buscarPorLivro(int livroId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        String sql = "SELECT a.*, u.name as user_name FROM avaliacoes a " +
                    "JOIN users u ON a.user_id = u.id " +
                    "WHERE a.livro_id = ? AND a.aprovado = true " +
                    "ORDER BY a.created_at DESC" +
                    buildLimitClause(page, pageSize);
        
        return executeQuery(sql, this::mapRowToAvaliacaoComUser, livroId);
    }
    
    /**
     * Busca avaliações pendentes de aprovação
     */
    public List<Avaliacao> buscarPendentes(int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        String sql = "SELECT a.*, l.titulo as livro_titulo, u.name as user_name " +
                    "FROM avaliacoes a " +
                    "JOIN livros l ON a.livro_id = l.id " +
                    "JOIN users u ON a.user_id = u.id " +
                    "WHERE a.aprovado = false " +
                    "ORDER BY a.created_at DESC" +
                    buildLimitClause(page, pageSize);
        
        return executeQuery(sql, this::mapRowToAvaliacaoCompleta);
    }
    
    /**
     * Aprova avaliação
     */
    public boolean aprovar(int id) throws SQLException {
        String sql = "UPDATE avaliacoes SET aprovado = true, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }
    
    /**
     * Calcula média de avaliações de um livro
     */
    public double calcularMediaPorLivro(int livroId) throws SQLException {
        String sql = "SELECT AVG(rating) FROM avaliacoes WHERE livro_id = ? AND aprovado = true";
        
        List<Double> result = executeQuery(sql, rs -> rs.getDouble(1), livroId);
        return result.isEmpty() ? 0.0 : result.get(0);
    }
    
    /**
     * Mapeia ResultSet para Avaliacao
     */
    private Avaliacao mapRowToAvaliacao(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = new Avaliacao();
        avaliacao.setId(rs.getInt("id"));
        avaliacao.setLivroId(rs.getInt("livro_id"));
        avaliacao.setUserId(rs.getInt("user_id"));
        avaliacao.setRating(rs.getObject("rating", Integer.class));
        avaliacao.setTitulo(rs.getString("titulo"));
        avaliacao.setComentario(rs.getString("comentario"));
        avaliacao.setAprovado(rs.getBoolean("aprovado"));
        avaliacao.setRecomenda(rs.getBoolean("recomenda"));
        avaliacao.setVantagens(rs.getString("vantagens"));
        avaliacao.setDesvantagens(rs.getString("desvantagens"));
        avaliacao.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        avaliacao.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return avaliacao;
    }
    
    /**
     * Mapeia ResultSet para Avaliacao com dados do usuário
     */
    private Avaliacao mapRowToAvaliacaoComUser(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = mapRowToAvaliacao(rs);
        
        // Se precisar adicionar dados do usuário, fazer aqui
        // User user = new User();
        // user.setName(rs.getString("user_name"));
        // avaliacao.setUser(user);
        
        return avaliacao;
    }
    
    /**
     * Mapeia ResultSet para Avaliacao com dados completos
     */
    private Avaliacao mapRowToAvaliacaoCompleta(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = mapRowToAvaliacao(rs);
        
        // Adicionar dados extras se necessário
        // String livroTitulo = rs.getString("livro_titulo");
        // String userName = rs.getString("user_name");
        
        return avaliacao;
    }
}