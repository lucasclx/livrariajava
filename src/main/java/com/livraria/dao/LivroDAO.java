package com.livraria.dao;

import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com Livros - Versão Completa
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

    @Override
    public List<Livro> findAll() {
        try {
            return listar();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Livro findById(Long id) {
        try {
            return buscarPorId(id.intValue());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Livro save(Livro entity) {
        try {
            return criar(entity);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Livro update(Livro entity) {
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

    // ========== MÉTODOS BÁSICOS ==========

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
        String sql = "SELECT l.*, c.nome as categoria_nome FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id WHERE l.id = ?";
        return executeSingleQuery(sql, this::mapRowToLivroComCategoria, id);
    }

    /**
     * Lista todos os livros
     */
    public List<Livro> listar() throws SQLException {
        String sql = "SELECT * FROM livros ORDER BY titulo";
        return executeQuery(sql, this::mapRowToLivro);
    }

    /**
     * Cria novo livro
     */
    public Livro criar(Livro livro) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, preco, " +
                    "preco_promocional, paginas, sinopse, categoria_id, estoque, estoque_minimo, " +
                    "peso, idioma, edicao, encadernacao, imagem, ativo, destaque, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            livro.getTitulo(),
            livro.getAutor(),
            livro.getIsbn(),
            livro.getEditora(),
            livro.getAnoPublicacao(),
            livro.getPreco(),
            livro.getPrecoPromocional(),
            livro.getPaginas(),
            livro.getSinopse(),
            livro.getCategoriaId(),
            livro.getEstoque(),
            livro.getEstoqueMinimo(),
            livro.getPeso(),
            livro.getIdioma(),
            livro.getEdicao(),
            livro.getEncadernacao(),
            livro.getImagem(),
            livro.isAtivo(),
            livro.isDestaque()
        );
        
        livro.setId(id);
        return livro;
    }

    /**
     * Atualiza livro
     */
    public boolean atualizar(Livro livro) throws SQLException {
        String sql = "UPDATE livros SET titulo = ?, autor = ?, isbn = ?, editora = ?, " +
                    "ano_publicacao = ?, preco = ?, preco_promocional = ?, paginas = ?, " +
                    "sinopse = ?, categoria_id = ?, estoque = ?, estoque_minimo = ?, " +
                    "peso = ?, idioma = ?, edicao = ?, encadernacao = ?, imagem = ?, " +
                    "ativo = ?, destaque = ?, updated_at = NOW() WHERE id = ?";
        
        int affectedRows = executeUpdate(sql,
            livro.getTitulo(),
            livro.getAutor(),
            livro.getIsbn(),
            livro.getEditora(),
            livro.getAnoPublicacao(),
            livro.getPreco(),
            livro.getPrecoPromocional(),
            livro.getPaginas(),
            livro.getSinopse(),
            livro.getCategoriaId(),
            livro.getEstoque(),
            livro.getEstoqueMinimo(),
            livro.getPeso(),
            livro.getIdioma(),
            livro.getEdicao(),
            livro.getEncadernacao(),
            livro.getImagem(),
            livro.isAtivo(),
            livro.isDestaque(),
            livro.getId()
        );
        
        return affectedRows > 0;
    }

    /**
     * Exclui livro
     */
    public boolean excluir(int id) throws SQLException {
        String sql = "DELETE FROM livros WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }

    // ========== MÉTODOS DE LISTAGEM ==========

    /**
     * Busca livros ativos com paginação
     */
    public List<Livro> listarAtivos(int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM livros WHERE ativo = true ORDER BY created_at DESC" + 
                    buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToLivro);
    }

    /**
     * Conta livros ativos
     */
    public int contarAtivos() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true");
    }

    /**
     * Busca livros ativos (para API)
     */
    public List<Livro> findAtivos() throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true ORDER BY created_at DESC";
        return executeQuery(sql, this::mapRowToLivro);
    }

    /**
     * Busca livros em destaque
     */
    public List<Livro> buscarDestaque(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true AND destaque = true " +
                    "ORDER BY vendas_total DESC, created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }

    /**
     * Busca livros mais vendidos
     */
    public List<Livro> buscarMaisVendidos(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "ORDER BY vendas_total DESC, created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }

    /**
     * Busca livros mais vendidos no mês
     */
    public List<Livro> buscarMaisVendidosMes(int limit) throws SQLException {
        String sql = "SELECT l.* FROM livros l " +
                    "JOIN order_items oi ON l.id = oi.livro_id " +
                    "JOIN orders o ON oi.order_id = o.id " +
                    "WHERE l.ativo = true AND o.created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH) " +
                    "GROUP BY l.id " +
                    "ORDER BY SUM(oi.quantity) DESC " +
                    "LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }

    // ========== MÉTODOS DE BUSCA E FILTRO ==========

    /**
     * Busca livros por categoria com paginação
     */
    public List<Livro> buscarPorCategoria(int categoriaId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM livros WHERE categoria_id = ? AND ativo = true " +
                    "ORDER BY created_at DESC" + buildLimitClause(page, pageSize);
        return executeQuery(sql, this::mapRowToLivro, categoriaId);
    }

    /**
     * Conta livros por categoria
     */
    public int contarPorCategoria(int categoriaId) throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE categoria_id = ? AND ativo = true", categoriaId);
    }

    /**
     * Busca livros relacionados (mesma categoria, exceto o próprio livro)
     */
    public List<Livro> buscarRelacionados(int categoriaId, int livroId, int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE categoria_id = ? AND id != ? AND ativo = true " +
                    "ORDER BY vendas_total DESC, RAND() LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, categoriaId, livroId, limit);
    }

    /**
     * Busca livros por termo de pesquisa
     */
    public List<Livro> buscarPorTermo(String termo, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String searchTerm = "%" + escapeLike(termo) + "%";
        String sql = "SELECT * FROM livros WHERE ativo = true AND " +
                    "(titulo LIKE ? OR autor LIKE ? OR isbn LIKE ? OR editora LIKE ?) " +
                    "ORDER BY " +
                    "CASE " +
                    "  WHEN titulo LIKE ? THEN 1 " +
                    "  WHEN autor LIKE ? THEN 2 " +
                    "  ELSE 3 " +
                    "END, vendas_total DESC" + buildLimitClause(page, pageSize);
        
        return executeQuery(sql, this::mapRowToLivro, 
            searchTerm, searchTerm, searchTerm, searchTerm, searchTerm, searchTerm);
    }

    /**
     * Conta livros por termo de pesquisa
     */
    public int contarPorTermo(String termo) throws SQLException {
        String searchTerm = "%" + escapeLike(termo) + "%";
        String sql = "SELECT COUNT(*) FROM livros WHERE ativo = true AND " +
                    "(titulo LIKE ? OR autor LIKE ? OR isbn LIKE ? OR editora LIKE ?)";
        return executeCountQuery(sql, searchTerm, searchTerm, searchTerm, searchTerm);
    }

    /**
     * Busca livros com filtros avançados
     */
    public List<Livro> buscarComFiltrosAvancados(String termo, String categoria, String precoMin, 
                                               String precoMax, String ordenacao, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        StringBuilder sql = new StringBuilder("SELECT l.*, c.nome as categoria_nome FROM livros l ");
        sql.append("LEFT JOIN categorias c ON l.categoria_id = c.id WHERE l.ativo = true ");
        
        List<Object> params = new ArrayList<>();
        
        if (termo != null && !termo.trim().isEmpty()) {
            String searchTerm = "%" + escapeLike(termo) + "%";
            sql.append("AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ?) ");
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (categoria != null && !categoria.isEmpty()) {
            sql.append("AND l.categoria_id = ? ");
            params.add(Integer.parseInt(categoria));
        }
        
        if (precoMin != null && !precoMin.isEmpty()) {
            sql.append("AND l.preco >= ? ");
            params.add(Double.parseDouble(precoMin));
        }
        
        if (precoMax != null && !precoMax.isEmpty()) {
            sql.append("AND l.preco <= ? ");
            params.add(Double.parseDouble(precoMax));
        }
        
        // Ordenação
        if ("preco_asc".equals(ordenacao)) {
            sql.append("ORDER BY l.preco ASC ");
        } else if ("preco_desc".equals(ordenacao)) {
            sql.append("ORDER BY l.preco DESC ");
        } else if ("titulo".equals(ordenacao)) {
            sql.append("ORDER BY l.titulo ASC ");
        } else if ("vendas".equals(ordenacao)) {
            sql.append("ORDER BY l.vendas_total DESC ");
        } else {
            sql.append("ORDER BY l.created_at DESC ");
        }
        
        sql.append(buildLimitClause(page, pageSize));
        
        return executeQuery(sql.toString(), this::mapRowToLivroComCategoria, params.toArray());
    }

    /**
     * Conta livros com filtros avançados
     */
    public int contarComFiltrosAvancados(String termo, String categoria, String precoMin, String precoMax) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM livros l WHERE l.ativo = true ");
        
        List<Object> params = new ArrayList<>();
        
        if (termo != null && !termo.trim().isEmpty()) {
            String searchTerm = "%" + escapeLike(termo) + "%";
            sql.append("AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ?) ");
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (categoria != null && !categoria.isEmpty()) {
            sql.append("AND l.categoria_id = ? ");
            params.add(Integer.parseInt(categoria));
        }
        
        if (precoMin != null && !precoMin.isEmpty()) {
            sql.append("AND l.preco >= ? ");
            params.add(Double.parseDouble(precoMin));
        }
        
        if (precoMax != null && !precoMax.isEmpty()) {
            sql.append("AND l.preco <= ? ");
            params.add(Double.parseDouble(precoMax));
        }
        
        return executeCountQuery(sql.toString(), params.toArray());
    }

    /**
     * Busca livros com filtros para admin
     */
    public List<Livro> buscarComFiltros(String busca, String categoriaId, String estoque, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        StringBuilder sql = new StringBuilder("SELECT l.*, c.nome as categoria_nome FROM livros l ");
        sql.append("LEFT JOIN categorias c ON l.categoria_id = c.id WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (busca != null && !busca.trim().isEmpty()) {
            String searchTerm = "%" + escapeLike(busca) + "%";
            sql.append("AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ?) ");
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (categoriaId != null && !categoriaId.isEmpty()) {
            sql.append("AND l.categoria_id = ? ");
            params.add(Integer.parseInt(categoriaId));
        }
        
        if (estoque != null && !estoque.isEmpty()) {
            switch (estoque) {
                case "sem_estoque":
                    sql.append("AND l.estoque = 0 ");
                    break;
                case "estoque_baixo":
                    sql.append("AND l.estoque > 0 AND l.estoque <= l.estoque_minimo ");
                    break;
                case "com_estoque":
                    sql.append("AND l.estoque > l.estoque_minimo ");
                    break;
            }
        }
        
        sql.append("ORDER BY l.titulo ASC ").append(buildLimitClause(page, pageSize));
        
        return executeQuery(sql.toString(), this::mapRowToLivroComCategoria, params.toArray());
    }

    /**
     * Conta livros com filtros para admin
     */
    public int contarComFiltros(String busca, String categoriaId, String estoque) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM livros l WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        if (busca != null && !busca.trim().isEmpty()) {
            String searchTerm = "%" + escapeLike(busca) + "%";
            sql.append("AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ?) ");
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        if (categoriaId != null && !categoriaId.isEmpty()) {
            sql.append("AND l.categoria_id = ? ");
            params.add(Integer.parseInt(categoriaId));
        }
        
        if (estoque != null && !estoque.isEmpty()) {
            switch (estoque) {
                case "sem_estoque":
                    sql.append("AND l.estoque = 0 ");
                    break;
                case "estoque_baixo":
                    sql.append("AND l.estoque > 0 AND l.estoque <= l.estoque_minimo ");
                    break;
                case "com_estoque":
                    sql.append("AND l.estoque > l.estoque_minimo ");
                    break;
            }
        }
        
        return executeCountQuery(sql.toString(), params.toArray());
    }

    // ========== MÉTODOS DE FAVORITOS ==========

    /**
     * Busca livros favoritos do usuário
     */
    public List<Livro> buscarFavoritos(int userId, int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        
        String sql = "SELECT l.*, c.nome as categoria_nome FROM livros l " +
                    "JOIN favoritos f ON l.id = f.livro_id " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE f.user_id = ? AND l.ativo = true " +
                    "ORDER BY f.created_at DESC" + buildLimitClause(page, pageSize);
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, userId);
    }

    /**
     * Conta livros favoritos do usuário
     */
    public int contarFavoritos(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos f " +
                    "JOIN livros l ON f.livro_id = l.id " +
                    "WHERE f.user_id = ? AND l.ativo = true";
        return executeCountQuery(sql, userId);
    }

    /**
     * Busca sugestões baseadas no carrinho
     */
    public List<Livro> buscarSugestoesPorCarrinho(List<com.livraria.models.CartItem> items, int limit) throws SQLException {
        if (items.isEmpty()) {
            return buscarMaisVendidos(limit);
        }
        
        StringBuilder sql = new StringBuilder("SELECT DISTINCT l.* FROM livros l WHERE l.ativo = true ");
        
        // Buscar livros da mesma categoria dos itens do carrinho
        sql.append("AND l.categoria_id IN (");
        sql.append("SELECT DISTINCT categoria_id FROM livros WHERE id IN (");
        
        List<Object> params = new ArrayList<>();
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
            params.add(items.get(i).getLivroId());
        }
        
        sql.append(")) AND l.id NOT IN (");
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) sql.append(",");
            sql.append("?");
            params.add(items.get(i).getLivroId());
        }
        
        sql.append(") ORDER BY l.vendas_total DESC LIMIT ?");
        params.add(limit);
        
        return executeQuery(sql.toString(), this::mapRowToLivro, params.toArray());
    }

    // ========== MÉTODOS DE ESTOQUE ==========

    /**
     * Conta livros no estoque
     */
    public int contar() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros");
    }

    /**
     * Conta livros com estoque
     */
    public int contarComEstoque() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE estoque > 0");
    }

    /**
     * Conta livros com estoque baixo
     */
    public int contarEstoqueBaixo() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE estoque > 0 AND estoque <= estoque_minimo");
    }

    /**
     * Busca livros com estoque baixo
     */
    public List<Livro> buscarEstoqueBaixo(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE estoque > 0 AND estoque <= estoque_minimo " +
                    "ORDER BY estoque ASC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }

    /**
     * Busca livros sem estoque
     */
    public List<Livro> buscarSemEstoque(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE estoque = 0 AND ativo = true " +
                    "ORDER BY updated_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }

    /**
     * Calcula valor total do estoque
     */
    public BigDecimal calcularValorTotalEstoque() throws SQLException {
        String sql = "SELECT SUM(preco * estoque) FROM livros WHERE ativo = true";
        List<BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1));
        return result.isEmpty() || result.get(0) == null ? BigDecimal.ZERO : result.get(0);
    }

    /**
     * Baixa estoque de um livro (para OrderService)
     */
    public void baixarEstoque(Connection conn, int livroId, int quantidade) throws SQLException {
        String sql = "UPDATE livros SET estoque = estoque - ? WHERE id = ? AND estoque >= ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, quantidade);
            stmt.setInt(2, livroId);
            stmt.setInt(3, quantidade);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Estoque insuficiente para o livro ID: " + livroId);
            }
        }
    }

    // ========== MÉTODOS DE VERIFICAÇÃO ==========

    /**
     * Verifica se livro tem pedidos vinculados
     */
    public boolean temPedidosVinculados(int livroId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM order_items WHERE livro_id = ?";
        return executeCountQuery(sql, livroId) > 0;
    }

    // ========== MÉTODOS DE MAPEAMENTO ==========

    /**
     * Mapeia ResultSet para Livro
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
        livro.setEstoqueMinimo(rs.getInt("estoque_minimo"));
        livro.setPeso(rs.getDouble("peso"));
        livro.setIdioma(rs.getString("idioma"));
        livro.setEdicao(rs.getString("edicao"));
        livro.setEncadernacao(rs.getString("encadernacao"));
        livro.setImagem(rs.getString("imagem"));
        livro.setAtivo(rs.getBoolean("ativo"));
        livro.setDestaque(rs.getBoolean("destaque"));
        livro.setAvaliacaoMedia(rs.getBigDecimal("avaliacao_media"));
        livro.setTotalAvaliacoes(rs.getInt("total_avaliacoes"));
        
        // Campos opcionais que podem não existir
        try {
            livro.setVendasTotal(rs.getInt("vendas_total"));
        } catch (SQLException e) {
            livro.setVendasTotal(0);
        }
        
        livro.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        livro.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return livro;
    }

    /**
     * Mapeia ResultSet para Livro com Categoria
     */
    private Livro mapRowToLivroComCategoria(ResultSet rs) throws SQLException {
        Livro livro = mapRowToLivro(rs);
        
        try {
            String categoriaNome = rs.getString("categoria_nome");
            if (categoriaNome != null) {
                Categoria categoria = new Categoria();
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