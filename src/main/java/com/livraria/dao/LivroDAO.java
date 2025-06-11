package com.livraria.dao;

import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;

/**
 * DAO para operações com Livros
 */
public class LivroDAO extends BaseDAO<Livro> {
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    
    @Override
    protected String getTableName() {
        return "livros";
    }
    
    @Override
    public List<Livro> findAll() {
        String sql = "SELECT * FROM livros ORDER BY titulo ASC";
        return executeQuery(sql);
    }
    
    @Override
    public Livro findById(Long id) {
        String sql = "SELECT * FROM livros WHERE id = ?";
        return findOne(sql, id);
    }
    
    @Override
    public Livro save(Livro livro) {
        String sql = "INSERT INTO livros (titulo, autor, editora, isbn, ano_publicacao, " +
                    "paginas, preco, preco_promocional, estoque, estoque_minimo, sinopse, " +
                    "imagem, ativo, destaque, peso, categoria_id, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        Long id = executeInsertAndGetId(sql,
            livro.getTitulo(),
            livro.getAutor(),
            livro.getEditora(),
            livro.getIsbn(),
            livro.getAnoPublicacao(),
            livro.getPaginas(),
            livro.getPreco(),
            livro.getPrecoPromocional(),
            livro.getEstoque(),
            livro.getEstoqueMinimo(),
            livro.getSinopse(),
            livro.getImagem(),
            livro.getAtivo(),
            livro.getDestaque(),
            livro.getPeso(),
            livro.getCategoriaId()
        );
        
        if (id != null) {
            livro.setId(id);
            return livro;
        }
        
        return null;
    }
    
    @Override
    public Livro update(Livro livro) {
        String sql = "UPDATE livros SET titulo = ?, autor = ?, editora = ?, isbn = ?, " +
                    "ano_publicacao = ?, paginas = ?, preco = ?, preco_promocional = ?, " +
                    "estoque = ?, estoque_minimo = ?, sinopse = ?, imagem = ?, ativo = ?, " +
                    "destaque = ?, peso = ?, categoria_id = ?, updated_at = NOW() WHERE id = ?";
        
        int affectedRows = executeUpdate(sql,
            livro.getTitulo(),
            livro.getAutor(),
            livro.getEditora(),
            livro.getIsbn(),
            livro.getAnoPublicacao(),
            livro.getPaginas(),
            livro.getPreco(),
            livro.getPrecoPromocional(),
            livro.getEstoque(),
            livro.getEstoqueMinimo(),
            livro.getSinopse(),
            livro.getImagem(),
            livro.getAtivo(),
            livro.getDestaque(),
            livro.getPeso(),
            livro.getCategoriaId(),
            livro.getId()
        );
        
        return affectedRows > 0 ? livro : null;
    }
    
    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM livros WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }
    
    /**
     * Busca livros ativos
     */
    public List<Livro> findAtivos() {
        String sql = "SELECT * FROM livros WHERE ativo = true ORDER BY titulo ASC";
        return executeQuery(sql);
    }
    
    /**
     * Busca livros em estoque
     */
    public List<Livro> findEmEstoque() {
        String sql = "SELECT * FROM livros WHERE ativo = true AND estoque > 0 ORDER BY titulo ASC";
        return executeQuery(sql);
    }
    
    /**
     * Busca livros em destaque
     */
    public List<Livro> findDestaque(int limit) {
        String sql = "SELECT * FROM livros WHERE ativo = true AND destaque = true " +
                    "ORDER BY created_at DESC LIMIT ?";
        return executeQuery(sql, limit);
    }
    
    /**
     * Busca livros com promoção
     */
    public List<Livro> findComPromocao(int limit) {
        String sql = "SELECT * FROM livros WHERE ativo = true AND preco_promocional IS NOT NULL " +
                    "AND preco_promocional > 0 AND preco_promocional < preco " +
                    "ORDER BY (preco - preco_promocional) DESC LIMIT ?";
        return executeQuery(sql, limit);
    }
    
    /**
     * Busca livros por categoria
     */
    public List<Livro> findByCategoria(Long categoriaId) {
        String sql = "SELECT * FROM livros WHERE categoria_id = ? AND ativo = true ORDER BY titulo ASC";
        return executeQuery(sql, categoriaId);
    }
    
    /**
     * Busca livros com estoque baixo
     */
    public List<Livro> findEstoqueBaixo() {
        String sql = "SELECT * FROM livros WHERE ativo = true AND estoque <= estoque_minimo " +
                    "ORDER BY estoque ASC";
        return executeQuery(sql);
    }
    
    /**
     * Busca textual em livros
     */
    public List<Livro> search(String termo) {
        if (termo == null || termo.trim().isEmpty()) {
            return findAtivos();
        }
        
        String termoBusca = "%" + termo.toLowerCase() + "%";
        String sql = "SELECT * FROM livros WHERE ativo = true AND " +
                    "(LOWER(titulo) LIKE ? OR LOWER(autor) LIKE ? OR LOWER(isbn) LIKE ? OR LOWER(editora) LIKE ?) " +
                    "ORDER BY " +
                    "CASE " +
                    "  WHEN LOWER(titulo) LIKE ? THEN 1 " +
                    "  WHEN LOWER(autor) LIKE ? THEN 2 " +
                    "  WHEN LOWER(isbn) LIKE ? THEN 3 " +
                    "  ELSE 4 " +
                    "END, titulo ASC";
        
        return executeQuery(sql, termoBusca, termoBusca, termoBusca, termoBusca, 
                           termoBusca, termoBusca, termoBusca);
    }
    
    /**
     * Busca com filtros avançados
     */
    public PaginatedResult<Livro> searchWithFilters(String busca, Long categoriaId, 
                                                   BigDecimal precoMin, BigDecimal precoMax,
                                                   Boolean disponivel, Boolean promocao,
                                                   String ordem, String direcao,
                                                   int page, int size) {
        
        StringBuilder sql = new StringBuilder("SELECT l.* FROM livros l");
        List<Object> parameters = new ArrayList<>();
        List<String> conditions = new ArrayList<>();
        
        // Sempre filtrar apenas livros ativos
        conditions.add("l.ativo = true");
        
        // Busca textual
        if (busca != null && !busca.trim().isEmpty()) {
            String termoBusca = "%" + busca.toLowerCase() + "%";
            conditions.add("(LOWER(l.titulo) LIKE ? OR LOWER(l.autor) LIKE ? OR LOWER(l.isbn) LIKE ? OR LOWER(l.editora) LIKE ?)");
            parameters.add(termoBusca);
            parameters.add(termoBusca);
            parameters.add(termoBusca);
            parameters.add(termoBusca);
        }
        
        // Filtro por categoria
        if (categoriaId != null) {
            conditions.add("l.categoria_id = ?");
            parameters.add(categoriaId);
        }
        
        // Filtro por preço
        if (precoMin != null) {
            conditions.add("COALESCE(l.preco_promocional, l.preco) >= ?");
            parameters.add(precoMin);
        }
        
        if (precoMax != null) {
            conditions.add("COALESCE(l.preco_promocional, l.preco) <= ?");
            parameters.add(precoMax);
        }
        
        // Filtro por disponibilidade
        if (disponivel != null && disponivel) {
            conditions.add("l.estoque > 0");
        }
        
        // Filtro por promoção
        if (promocao != null && promocao) {
            conditions.add("l.preco_promocional IS NOT NULL AND l.preco_promocional > 0 AND l.preco_promocional < l.preco");
        }
        
        // Construir WHERE
        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        
        // Ordenação
        sql.append(" ORDER BY ");
        if (ordem != null) {
            switch (ordem) {
                case "preco":
                    sql.append("COALESCE(l.preco_promocional, l.preco)");
                    break;
                case "titulo":
                    sql.append("l.titulo");
                    break;
                case "autor":
                    sql.append("l.autor");
                    break;
                case "created_at":
                    sql.append("l.created_at");
                    break;
                default:
                    sql.append("l.titulo");
            }
            
            if ("desc".equalsIgnoreCase(direcao)) {
                sql.append(" DESC");
            } else {
                sql.append(" ASC");
            }
        } else {
            // Ordenação padrão - relevância se há busca, senão por título
            if (busca != null && !busca.trim().isEmpty()) {
                String termoBusca = "%" + busca.toLowerCase() + "%";
                sql.append("CASE ")
                   .append("WHEN LOWER(l.titulo) LIKE '").append(termoBusca).append("' THEN 1 ")
                   .append("WHEN LOWER(l.autor) LIKE '").append(termoBusca).append("' THEN 2 ")
                   .append("ELSE 3 END, l.titulo ASC");
            } else {
                sql.append("l.titulo ASC");
            }
        }
        
        // Paginação
        int offset = (page - 1) * size;
        sql.append(" LIMIT ? OFFSET ?");
        parameters.add(size);
        parameters.add(offset);
        
        // Executar busca
        List<Livro> items = executeQuery(sql.toString(), parameters.toArray());
        
        // Contar total
        StringBuilder countSql = new StringBuilder("SELECT COUNT(*) FROM livros l");
        if (!conditions.isEmpty()) {
            countSql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        
        List<Object> countParams = parameters.subList(0, parameters.size() - 2); // Remove LIMIT e OFFSET
        int totalItems = count(countSql.toString(), countParams.toArray());
        
        return new PaginatedResult<>(items, page, size, totalItems);
    }
    
    /**
     * Livros relacionados (mesma categoria)
     */
    public List<Livro> findRelacionados(Long livroId, Long categoriaId, int limit) {
        String sql = "SELECT * FROM livros WHERE id != ? AND categoria_id = ? AND ativo = true " +
                    "AND estoque > 0 ORDER BY RAND() LIMIT ?";
        return executeQuery(sql, livroId, categoriaId, limit);
    }
    
    /**
     * Atualizar estoque
     */
    public boolean updateEstoque(Long id, int novoEstoque) {
        String sql = "UPDATE livros SET estoque = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, novoEstoque, id) > 0;
    }
    
    /**
     * Diminuir estoque
     */
    public boolean diminuirEstoque(Long id, int quantidade) {
        String sql = "UPDATE livros SET estoque = estoque - ?, updated_at = NOW() " +
                    "WHERE id = ? AND estoque >= ?";
        return executeUpdate(sql, quantidade, id, quantidade) > 0;
    }
    
    /**
     * Estatísticas
     */
    public Map<String, Integer> getEstatisticas() {
        Map<String, Integer> stats = new HashMap<>();
        
        stats.put("total_livros", count("SELECT COUNT(*) FROM livros"));
        stats.put("livros_ativos", count("SELECT COUNT(*) FROM livros WHERE ativo = true"));
        stats.put("livros_estoque", count("SELECT COUNT(*) FROM livros WHERE ativo = true AND estoque > 0"));
        stats.put("livros_destaque", count("SELECT COUNT(*) FROM livros WHERE ativo = true AND destaque = true"));
        stats.put("estoque_baixo", count("SELECT COUNT(*) FROM livros WHERE ativo = true AND estoque <= estoque_minimo"));
        
        return stats;
    }
    
    @Override
    protected Livro mapResultSetToEntity(ResultSet rs) throws SQLException {
        Livro livro = new Livro();
        
        livro.setId(rs.getLong("id"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setEditora(rs.getString("editora"));
        livro.setIsbn(rs.getString("isbn"));
        livro.setAnoPublicacao(rs.getObject("ano_publicacao", Integer.class));
        livro.setPaginas(rs.getObject("paginas", Integer.class));
        livro.setPreco(rs.getBigDecimal("preco"));
        livro.setPrecoPromocional(rs.getBigDecimal("preco_promocional"));
        livro.setEstoque(rs.getInt("estoque"));
        livro.setEstoqueMinimo(rs.getObject("estoque_minimo", Integer.class));
        livro.setSinopse(rs.getString("sinopse"));
        livro.setImagem(rs.getString("imagem"));
        livro.setAtivo(rs.getBoolean("ativo"));
        livro.setDestaque(rs.getBoolean("destaque"));
        livro.setPeso(rs.getObject("peso", Double.class));
        livro.setCategoriaId(rs.getObject("categoria_id", Long.class));
        livro.setCreatedAt(rs.getTimestamp("created_at"));
        livro.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Carregar categoria se necessário
        if (livro.getCategoriaId() != null) {
            Categoria categoria = categoriaDAO.findById(livro.getCategoriaId());
            livro.setCategoria(categoria);
        }
        
        return livro;
    }
}