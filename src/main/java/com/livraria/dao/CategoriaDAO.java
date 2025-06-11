package com.livraria.dao;

import com.livraria.models.Categoria;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO para operações com categorias
 */
public class CategoriaDAO extends BaseDAO<Categoria> {

    @Override
    protected String getTableName() {
        return "categorias";
    }

    @Override
    public List<Categoria> findAll() {
        try {
            return listar();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Categoria findById(Long id) {
        try {
            return buscarPorId(id.intValue());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Categoria save(Categoria entity) {
        try {
            return criar(entity);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Categoria update(Categoria entity) {
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
    protected Categoria mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToCategoria(rs);
    }
    
    /**
     * Busca categoria por ID
     */
    public Categoria buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM categorias WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToCategoria, id);
    }
    
    /**
     * Busca categoria por slug ou nome
     */
    public Categoria buscarPorSlugOuNome(String slugOuNome) throws SQLException {
        String sql = "SELECT * FROM categorias WHERE (slug = ? OR nome = ?) AND ativo = true";
        return executeSingleQuery(sql, this::mapRowToCategoria, slugOuNome, slugOuNome);
    }
    
    /**
     * Busca categoria por ID com livros
     */
    public Categoria buscarPorIdComLivros(int id) throws SQLException {
        Categoria categoria = buscarPorId(id);
        if (categoria != null) {
            int countLivros = contarLivrosVinculados(id);
            categoria.setLivrosCount(countLivros);
        }
        return categoria;
    }
    
    /**
     * Lista todas as categorias
     */
    public List<Categoria> listar() throws SQLException {
        String sql = "SELECT * FROM categorias ORDER BY nome";
        return executeQuery(sql, this::mapRowToCategoria);
    }
    
    /**
     * Lista categorias ativas
     */
    public List<Categoria> listarAtivas() throws SQLException {
        String sql = "SELECT * FROM categorias WHERE ativo = true ORDER BY nome";
        return executeQuery(sql, this::mapRowToCategoria);
    }
    
    /**
     * Lista categorias ativas com contagem de livros
     */
    public List<Categoria> listarAtivasComContagem(int limit) throws SQLException {
        String sql = "SELECT c.*, COUNT(l.id) as livros_count " +
                    "FROM categorias c " +
                    "LEFT JOIN livros l ON c.id = l.categoria_id AND l.ativo = true " +
                    "WHERE c.ativo = true " +
                    "GROUP BY c.id, c.nome, c.descricao, c.slug, c.imagem, c.ativo, c.created_at, c.updated_at " +
                    "HAVING livros_count > 0 " +
                    "ORDER BY livros_count DESC";
        
        if (limit > 0) {
            sql += " LIMIT " + limit;
        }
        
        return executeQuery(sql, this::mapRowToCategoriaComCount);
    }
    
    /**
     * Lista categorias ativas com contagem (sem limite)
     */
    public List<Categoria> listarAtivasComContagem() throws SQLException {
        return listarAtivasComContagem(0);
    }
    
    /**
     * Lista com paginação
     */
    public List<Categoria> listarComPaginacao(int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM categorias ORDER BY nome" + buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToCategoria);
    }
    
    /**
     * Verifica se nome já existe
     */
    public boolean existeNome(String nome, Integer excludeId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM categorias WHERE nome = ?";
        Object[] params;
        
        if (excludeId != null) {
            sql += " AND id != ?";
            params = new Object[]{nome, excludeId};
        } else {
            params = new Object[]{nome};
        }
        
        return executeCountQuery(sql, params) > 0;
    }
    
    /**
     * Cria nova categoria
     */
    public Categoria criar(Categoria categoria) throws SQLException {
        String sql = "INSERT INTO categorias (nome, descricao, slug, imagem, ativo, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            categoria.getNome(),
            categoria.getDescricao(),
            categoria.getSlug(),
            categoria.getImagem(),
            categoria.isAtivo()
        );
        
        categoria.setId(id);
        return categoria;
    }
    
    /**
     * Atualiza categoria
     */
    public boolean atualizar(Categoria categoria) throws SQLException {
        String sql = "UPDATE categorias SET nome = ?, descricao = ?, slug = ?, " +
                    "imagem = ?, ativo = ?, updated_at = NOW() WHERE id = ?";
        
        int affectedRows = executeUpdate(sql,
            categoria.getNome(),
            categoria.getDescricao(),
            categoria.getSlug(),
            categoria.getImagem(),
            categoria.isAtivo(),
            categoria.getId()
        );
        
        return affectedRows > 0;
    }
    
    /**
     * Exclui categoria
     */
    public boolean excluir(int id) throws SQLException {
        String sql = "DELETE FROM categorias WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }
    
    /**
     * Conta total de categorias
     */
    public int contar() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM categorias");
    }
    
    /**
     * Conta categorias ativas
     */
    public int contarAtivas() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM categorias WHERE ativo = true");
    }
    
    /**
     * Conta categorias ativas com livros
     */
    public int contarAtivasComLivros() throws SQLException {
        String sql = "SELECT COUNT(DISTINCT c.id) FROM categorias c " +
                    "JOIN livros l ON c.id = l.categoria_id " +
                    "WHERE c.ativo = true AND l.ativo = true";
        return executeCountQuery(sql);
    }
    
    /**
     * Conta livros vinculados à categoria
     */
    public int contarLivrosVinculados(int categoriaId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM livros WHERE categoria_id = ?";
        return executeCountQuery(sql, categoriaId);
    }
    
    /**
     * Altera status da categoria
     */
    public boolean alterarStatus(int id, boolean ativo) throws SQLException {
        String sql = "UPDATE categorias SET ativo = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, ativo, id) > 0;
    }
    
    /**
     * Busca categorias por termo
     */
    public List<Categoria> buscarPorTermo(String termo) throws SQLException {
        String sql = "SELECT * FROM categorias WHERE ativo = true " +
                    "AND (nome LIKE ? OR descricao LIKE ?) ORDER BY nome";
        String searchTerm = "%" + escapeLike(termo) + "%";
        return executeQuery(sql, this::mapRowToCategoria, searchTerm, searchTerm);
    }
    
    /**
     * Obtém categorias mais populares (com mais livros)
     */
    public List<Categoria> obterMaisPopulares(int limit) throws SQLException {
        String sql = "SELECT c.*, COUNT(l.id) as livros_count " +
                    "FROM categorias c " +
                    "JOIN livros l ON c.id = l.categoria_id " +
                    "WHERE c.ativo = true AND l.ativo = true " +
                    "GROUP BY c.id " +
                    "ORDER BY livros_count DESC, c.nome " +
                    "LIMIT ?";
        return executeQuery(sql, this::mapRowToCategoriaComCount, limit);
    }
    
    /**
     * Mapeia ResultSet para Categoria
     */
    private Categoria mapRowToCategoria(ResultSet rs) throws SQLException {
        Categoria categoria = new Categoria();
        categoria.setId(rs.getInt("id"));
        categoria.setNome(rs.getString("nome"));
        categoria.setDescricao(rs.getString("descricao"));
        categoria.setSlug(rs.getString("slug"));
        categoria.setImagem(rs.getString("imagem"));
        categoria.setAtivo(rs.getBoolean("ativo"));
        categoria.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        categoria.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return categoria;
    }
    
    /**
     * Mapeia ResultSet para Categoria com contagem de livros
     */
    private Categoria mapRowToCategoriaComCount(ResultSet rs) throws SQLException {
        Categoria categoria = mapRowToCategoria(rs);
        
        try {
            categoria.setLivrosCount(rs.getInt("livros_count"));
        } catch (SQLException e) {
            // Campo pode não estar disponível em todas as queries
            categoria.setLivrosCount(0);
        }
        
        return categoria;
    }
}