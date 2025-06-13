package com.livraria.dao;

import com.livraria.models.Avaliacao;
import com.livraria.models.Livro;
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
     * Conta o total de avaliações feitas por um usuário
     */
    public int contarPorUsuario(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM avaliacoes WHERE user_id = ?";
        return executeCountQuery(sql, userId);
    }

    /**
     * Busca avaliações de um usuário, com dados do livro, e com paginação
     */
    public List<Avaliacao> buscarPorUsuarioComLivro(int userId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        String sql = "SELECT a.*, l.titulo as livro_titulo, l.imagem as livro_imagem " +
                     "FROM avaliacoes a " +
                     "JOIN livros l ON a.livro_id = l.id " +
                     "WHERE a.user_id = ? " +
                     "ORDER BY a.created_at DESC" +
                     buildLimitClause(page, pageSize);
        
        return executeQuery(sql, this::mapRowToAvaliacaoComLivro, userId);
    }

    /**
     * Mapeia um registro do ResultSet para um objeto Avaliacao
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
     * Mapeia um registro do ResultSet para Avaliacao, incluindo dados básicos do Livro
     */
    private Avaliacao mapRowToAvaliacaoComLivro(ResultSet rs) throws SQLException {
        Avaliacao avaliacao = mapRowToAvaliacao(rs);
        
        Livro livro = new Livro();
        livro.setId(avaliacao.getLivroId());
        livro.setTitulo(rs.getString("livro_titulo"));
        livro.setImagem(rs.getString("livro_imagem"));
        avaliacao.setLivro(livro);
        
        return avaliacao;
    }
    
    // Métodos abstratos da BaseDAO (implementação mínima)
    @Override
    public List<Avaliacao> findAll() { throw new UnsupportedOperationException(); }
    @Override
    public Avaliacao findById(Long id) { throw new UnsupportedOperationException(); }
    @Override
    public Avaliacao save(Avaliacao entity) { throw new UnsupportedOperationException(); }
    @Override
    public Avaliacao update(Avaliacao entity) { throw new UnsupportedOperationException(); }
    @Override
    public boolean delete(Long id) { throw new UnsupportedOperationException(); }
}