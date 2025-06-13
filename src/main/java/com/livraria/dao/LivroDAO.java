package com.livraria.dao;

import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import java.math.BigDecimal;

/**
 * DAO para operações com Livros
 */
public class LivroDAO extends BaseDAO<Livro> {
    
    @Override
    protected String getTableName() {
        return "livros";
    }

    @Override
    protected Livro mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToLivro(rs);
    }
    
    /**
     * Busca livro por ID
     */
    public Livro buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM livros WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToLivro, id);
    }
    
    /**
     * Busca livro por ID com categoria
     */
    public Livro buscarPorIdComCategoria(int id) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE l.id = ?";
        return executeSingleQuery(sql, this::mapRowToLivroComCategoria, id);
    }
    
    /**
     * Lista livros ativos com paginação
     */
    public List<Livro> listarAtivos(int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM livros WHERE ativo = true ORDER BY titulo" + 
                    buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToLivro);
    }
    
    /**
     * Conta o total de livros ativos
     */
    public int contarAtivos() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true");
    }
    
    /**
     * Busca livros em destaque
     */
    public List<Livro> buscarDestaque(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true AND destaque = true " +
                    "ORDER BY created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }
    
    /**
     * Busca livros mais vendidos
     */
    public List<Livro> buscarMaisVendidos(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "ORDER BY vendas_total DESC, titulo LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }

    /**
     * Busca livros por categoria com paginação
     */
    public List<Livro> buscarPorCategoria(int categoriaId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM livros WHERE ativo = true AND categoria_id = ? " +
                    "ORDER BY titulo" + buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToLivro, categoriaId);
    }
    
    /**
     * Conta livros por categoria
     */
    public int contarPorCategoria(int categoriaId) throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true AND categoria_id = ?", 
                                categoriaId);
    }
    
    /**
     * Busca livros relacionados (mesma categoria, exceto o próprio livro)
     */
    public List<Livro> buscarRelacionados(int categoriaId, int excludeLivroId, int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "AND categoria_id = ? AND id != ? " +
                    "ORDER BY RAND() LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, categoriaId, excludeLivroId, limit);
    }
    
    /**
     * Busca livros por termo de pesquisa com paginação
     */
    public List<Livro> buscarPorTermo(String termo, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String searchTerm = "%" + escapeLike(termo) + "%";
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "AND (titulo LIKE ? OR autor LIKE ? OR isbn LIKE ?) " +
                    "ORDER BY titulo" + buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToLivro, searchTerm, searchTerm, searchTerm);
    }
    
    /**
     * Conta livros por termo de pesquisa
     */
    public int contarPorTermo(String termo) throws SQLException {
        String searchTerm = "%" + escapeLike(termo) + "%";
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true " +
                                "AND (titulo LIKE ? OR autor LIKE ? OR isbn LIKE ?)", 
                                searchTerm, searchTerm, searchTerm);
    }

    /**
     * Busca favoritos de um usuário com paginação
     */
    public List<Livro> buscarFavoritos(int userId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT l.* FROM livros l " +
                    "JOIN favoritos f ON l.id = f.livro_id " +
                    "WHERE f.user_id = ? AND l.ativo = true " +
                    "ORDER BY f.created_at DESC" + buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToLivro, userId);
    }
    
    /**
     * Conta total de favoritos de um usuário
     */
    public int contarFavoritos(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "WHERE f.user_id = ? AND l.ativo = true";
        return executeCountQuery(sql, userId);
    }

    /**
     * Baixa o estoque de um livro (usado em transações)
     */
    public boolean baixarEstoque(Connection conn, int livroId, int quantidade) throws SQLException {
        String sql = "UPDATE livros SET estoque = estoque - ?, vendas_total = vendas_total + ? WHERE id = ? AND estoque >= ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantidade);
            stmt.setInt(2, quantidade);
            stmt.setInt(3, livroId);
            stmt.setInt(4, quantidade);
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Estoque insuficiente ou livro não encontrado para baixar estoque. Livro ID: " + livroId);
            }
            return true;
        }
    }

    /**
     * Mapeia um registro do ResultSet para um objeto Livro
     */
    private Livro mapRowToLivro(ResultSet rs) throws SQLException {
        Livro livro = new Livro();
        livro.setId(rs.getInt("id"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setIsbn(rs.getString("isbn"));
        livro.setEditora(rs.getString("editora"));
        livro.setAnoPublicacao((Integer) rs.getObject("ano_publicacao"));
        livro.setPreco(rs.getBigDecimal("preco"));
        livro.setPrecoPromocional(rs.getBigDecimal("preco_promocional"));
        livro.setPaginas((Integer) rs.getObject("paginas"));
        livro.setSinopse(rs.getString("sinopse"));
        livro.setCategoriaId((Integer) rs.getObject("categoria_id"));
        livro.setEstoque(rs.getInt("estoque"));
        livro.setImagem(rs.getString("imagem"));
        livro.setAtivo(rs.getBoolean("ativo"));
        livro.setDestaque(rs.getBoolean("destaque"));
        livro.setVendasTotal(rs.getInt("vendas_total"));
        livro.setPeso(rs.getDouble("peso"));
        livro.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        livro.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return livro;
    }
    
    /**
     * Mapeia um registro do ResultSet para um objeto Livro com dados da Categoria
     */
    private Livro mapRowToLivroComCategoria(ResultSet rs) throws SQLException {
        Livro livro = mapRowToLivro(rs);
        
        if (livro.getCategoriaId() != null) {
            Categoria categoria = new Categoria();
            categoria.setId(livro.getCategoriaId());
            // O alias 'categoria_nome' deve estar presente no SELECT
            if (hasColumn(rs, "categoria_nome")) {
                categoria.setNome(rs.getString("categoria_nome"));
            }
            livro.setCategoria(categoria);
        }
        return livro;
    }

    // Métodos abstratos da BaseDAO (implementação mínima)
    @Override
    public List<Livro> findAll() { throw new UnsupportedOperationException(); }
    @Override
    public Livro findById(Long id) { throw new UnsupportedOperationException(); }
    @Override
    public Livro save(Livro entity) { throw new UnsupportedOperationException(); }
    @Override
    public Livro update(Livro entity) { throw new UnsupportedOperationException(); }
    @Override
    public boolean delete(Long id) { throw new UnsupportedOperationException(); }
}