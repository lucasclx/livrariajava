package com.livraria.dao;

import com.livraria.models.Livro;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

/**
 * DAO completo para favoritos
 */
public class FavoriteDAO extends BaseDAO<Livro> {
    
    @Override
    protected String getTableName() {
        return "favoritos";
    }

    @Override
    public List<Livro> findAll() {
        throw new UnsupportedOperationException("Use buscarFavoritos com userId");
    }

    @Override
    public Livro findById(Long id) {
        throw new UnsupportedOperationException("Use verificarFavorito");
    }

    @Override
    public Livro save(Livro entity) {
        throw new UnsupportedOperationException("Use adicionar");
    }

    @Override
    public Livro update(Livro entity) {
        throw new UnsupportedOperationException("Favoritos não são atualizados");
    }

    @Override
    public boolean delete(Long id) {
        throw new UnsupportedOperationException("Use remover");
    }

    @Override
    protected Livro mapResultSetToEntity(java.sql.ResultSet rs) throws SQLException {
        return mapRowToLivro(rs);
    }
    
    /**
     * Verifica se o livro está nos favoritos do usuário
     */
    public boolean verificarFavorito(int userId, int livroId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos WHERE user_id = ? AND livro_id = ?";
        return executeCountQuery(sql, userId, livroId) > 0;
    }
    
    /**
     * Adiciona livro aos favoritos
     */
    public boolean adicionar(int userId, int livroId) throws SQLException {
        // Verificar se já não está nos favoritos
        if (verificarFavorito(userId, livroId)) {
            return false; // Já está nos favoritos
        }
        
        String sql = "INSERT INTO favoritos (user_id, livro_id, created_at) VALUES (?, ?, NOW())";
        return executeUpdate(sql, userId, livroId) > 0;
    }
    
    /**
     * Remove livro dos favoritos
     */
    public boolean remover(int userId, int livroId) throws SQLException {
        String sql = "DELETE FROM favoritos WHERE user_id = ? AND livro_id = ?";
        return executeUpdate(sql, userId, livroId) > 0;
    }
    
    /**
     * Lista favoritos do usuário com paginação
     */
    public List<Livro> listarFavoritos(int userId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE f.user_id = ? AND l.ativo = true " +
                    "ORDER BY f.created_at DESC " +
                    buildLimitClause(page, pageSize);
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, userId);
    }
    
    /**
     * Busca sugestões baseadas nos favoritos do usuário
     */
    public List<Livro> buscarSugestoesPorFavoritos(int userId, int limit) throws SQLException {
        String sql = "SELECT DISTINCT l2.*, c.nome as categoria_nome " +
                    "FROM favoritos f1 " +
                    "JOIN livros l1 ON f1.livro_id = l1.id " +
                    "JOIN livros l2 ON l1.categoria_id = l2.categoria_id " +
                    "LEFT JOIN categorias c ON l2.categoria_id = c.id " +
                    "WHERE f1.user_id = ? " +
                    "AND l2.id NOT IN (SELECT livro_id FROM favoritos WHERE user_id = ?) " +
                    "AND l2.ativo = true " +
                    "ORDER BY l2.vendas_total DESC, RAND() " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, userId, userId, limit);
    }
    
    /**
     * Remove favoritos de livros inativos
     */
    public int limparFavoritosInativos() throws SQLException {
        String sql = "DELETE f FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "WHERE l.ativo = false";
        return executeUpdate(sql);
    }
    
    /**
     * Lista todos os favoritos do usuário (sem paginação)
     */
    public List<Livro> listarTodosFavoritos(int userId) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE f.user_id = ? AND l.ativo = true " +
                    "ORDER BY f.created_at DESC";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, userId);
    }
    
    /**
     * Conta favoritos do usuário
     */
    public int contarFavoritos(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "WHERE f.user_id = ? AND l.ativo = true";
        return executeCountQuery(sql, userId);
    }
    
    /**
     * Remove todos os favoritos do usuário
     */
    public boolean limparFavoritos(int userId) throws SQLException {
        String sql = "DELETE FROM favoritos WHERE user_id = ?";
        return executeUpdate(sql, userId) > 0;
    }
    
    /**
     * Lista livros mais favoritados (estatística)
     */
    public List<Object[]> listarMaisFavoritados(int limit) throws SQLException {
        String sql = "SELECT l.id, l.titulo, l.autor, COUNT(f.id) as total_favoritos " +
                    "FROM livros l " +
                    "JOIN favoritos f ON l.id = f.livro_id " +
                    "WHERE l.ativo = true " +
                    "GROUP BY l.id, l.titulo, l.autor " +
                    "ORDER BY total_favoritos DESC " +
                    "LIMIT ?";
        
        return executeQuery(sql, rs -> new Object[]{
            rs.getInt("id"),
            rs.getString("titulo"), 
            rs.getString("autor"),
            rs.getInt("total_favoritos")
        }, limit);
    }
    
    /**
     * Conta quantos usuários favoritaram um livro
     */
    public int contarFavoritosPorLivro(int livroId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos WHERE livro_id = ?";
        return executeCountQuery(sql, livroId);
    }
    
    /**
     * Lista usuários que favoritaram um livro específico
     */
    public List<Integer> listarUsuariosFavoritos(int livroId) throws SQLException {
        String sql = "SELECT user_id FROM favoritos WHERE livro_id = ? ORDER BY created_at DESC";
        return executeQuery(sql, rs -> rs.getInt("user_id"), livroId);
    }
    
    /**
     * Busca favoritos por categoria
     */
    public List<Livro> buscarFavoritosPorCategoria(int userId, int categoriaId, int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE f.user_id = ? AND l.categoria_id = ? AND l.ativo = true " +
                    "ORDER BY f.created_at DESC " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, userId, categoriaId, limit);
    }
    
    /**
     * Verifica se usuário tem favoritos
     */
    public boolean temFavoritos(int userId) throws SQLException {
        return contarFavoritos(userId) > 0;
    }
    
    /**
     * Lista favoritos recentes do usuário
     */
    public List<Livro> listarFavoritosRecentes(int userId, int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE f.user_id = ? AND l.ativo = true " +
                    "AND f.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) " +
                    "ORDER BY f.created_at DESC " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, userId, limit);
    }
    
    /**
     * Mapeia ResultSet para Livro
     */
    private Livro mapRowToLivro(java.sql.ResultSet rs) throws SQLException {
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
        livro.setVendasTotal((Integer) rs.getObject("vendas_total"));
        livro.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        livro.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return livro;
    }
    
    /**
     * Mapeia ResultSet para Livro com categoria
     */
    private Livro mapRowToLivroComCategoria(java.sql.ResultSet rs) throws SQLException {
        Livro livro = mapRowToLivro(rs);
        
        try {
            String categoriaNome = rs.getString("categoria_nome");
            if (categoriaNome != null) {
                com.livraria.models.Categoria categoria = new com.livraria.models.Categoria();
                categoria.setId(livro.getCategoriaId());
                categoria.setNome(categoriaNome);
                livro.setCategoria(categoria);
            }
        } catch (SQLException e) {
            // Campo categoria pode não estar disponível
        }
        
        return livro;
    }
}