package com.livraria.dao;

import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import com.livraria.models.CartItem;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * DAO para operações com Livros
 */
public class LivroDAO extends BaseDAO<Livro> {
    
    @Override
    protected String getTableName() {
        return "livros";
    }
    
    @Override
    public List<Livro> findAll() {
        String sql = "SELECT * FROM livros ORDER BY titulo ASC";
        return executeQuery(sql, this::mapRowToLivro);
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
    public Livro save(Livro livro) {
        try {
            return criar(livro);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    
    @Override
    public Livro update(Livro livro) {
        try {
            atualizar(livro);
            return livro;
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
     * Lista livros ativos
     */
    public List<Livro> listarAtivos(int page, int pageSize) throws SQLException {
        validatePagination(page, pageSize);
        String sql = "SELECT * FROM livros WHERE ativo = true ORDER BY titulo" + 
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
     * Busca livros em destaque
     */
    public List<Livro> buscarDestaque(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true AND destaque = true " +
                    "ORDER BY created_at DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }
    
    /**
     * Busca livros mais recentes
     */
    public List<Livro> buscarMaisRecentes(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
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
     * Busca livros aleatórios
     */
    public List<Livro> buscarAleatorios(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "ORDER BY RAND() LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }
    
    /**
     * Busca livros em promoção
     */
    public List<Livro> buscarPromocoes(int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "AND preco_promocional IS NOT NULL " +
                    "AND preco_promocional > 0 " +
                    "AND preco_promocional < preco " +
                    "ORDER BY (preco - preco_promocional) DESC LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, limit);
    }
    
    /**
     * Busca livros por preço máximo
     */
    public List<Livro> buscarPorPrecoMaximo(double precoMax, int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "AND COALESCE(preco_promocional, preco) <= ? " +
                    "ORDER BY COALESCE(preco_promocional, preco) LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, precoMax, limit);
    }
    
    /**
     * Busca livros por categoria
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
     * Busca livros relacionados
     */
    public List<Livro> buscarRelacionados(int categoriaId, int excludeLivroId, int limit) throws SQLException {
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "AND categoria_id = ? AND id != ? " +
                    "ORDER BY RAND() LIMIT ?";
        return executeQuery(sql, this::mapRowToLivro, categoriaId, excludeLivroId, limit);
    }
    
    /**
     * Busca livros por termo
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
     * Conta livros por termo
     */
    public int contarPorTermo(String termo) throws SQLException {
        String searchTerm = "%" + escapeLike(termo) + "%";
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true " +
                                "AND (titulo LIKE ? OR autor LIKE ? OR isbn LIKE ?)", 
                                searchTerm, searchTerm, searchTerm);
    }
    
    /**
     * Busca livros para autocomplete
     */
    public List<Livro> buscarParaAutocomplete(String termo, int limit) throws SQLException {
        String searchTerm = "%" + escapeLike(termo) + "%";
        String sql = "SELECT id, titulo, autor, preco, preco_promocional, imagem " +
                    "FROM livros WHERE ativo = true " +
                    "AND (titulo LIKE ? OR autor LIKE ?) " +
                    "ORDER BY titulo LIMIT ?";
        return executeQuery(sql, this::mapRowToLivroSimples, searchTerm, searchTerm, limit);
    }
    
    /**
     * Verifica se está nos favoritos
     */
    public boolean estaNosfavoritos(int livroId, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM favoritos WHERE livro_id = ? AND user_id = ?";
        return executeCountQuery(sql, livroId, userId) > 0;
    }
    
    /**
     * Busca favoritos do usuário
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
     * Conta favoritos do usuário
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
    public List<Livro> buscarSugestoesPorCarrinho(List<CartItem> items, int limit) throws SQLException {
        if (items == null || items.isEmpty()) {
            return buscarMaisVendidos(limit);
        }
        
        // Pegar categorias dos livros no carrinho
        List<Integer> categorias = new ArrayList<>();
        for (CartItem item : items) {
            if (item.getLivro() != null && item.getLivro().getCategoriaId() != null) {
                categorias.add(item.getLivro().getCategoriaId());
            }
        }
        
        if (categorias.isEmpty()) {
            return buscarMaisVendidos(limit);
        }
        
        // Criar placeholders para IN clause
        String placeholders = String.join(",", categorias.stream().map(c -> "?").toArray(String[]::new));
        
        String sql = "SELECT * FROM livros WHERE ativo = true " +
                    "AND categoria_id IN (" + placeholders + ") " +
                    "ORDER BY vendas_total DESC, RAND() LIMIT ?";
        
        List<Object> params = new ArrayList<>(categorias);
        params.add(limit);
        
        return executeQuery(sql, this::mapRowToLivro, params.toArray());
    }
    
    /**
     * Conta autores ativos
     */
    public int contarAutoresAtivos() throws SQLException {
        return executeCountQuery("SELECT COUNT(DISTINCT autor) FROM livros WHERE ativo = true");
    }
    
    /**
     * Soma estoque total
     */
    public int somarEstoque() throws SQLException {
        String sql = "SELECT COALESCE(SUM(estoque), 0) FROM livros WHERE ativo = true";
        return executeCountQuery(sql);
    }
    
    /**
     * Cria novo livro
     */
    public Livro criar(Livro livro) throws SQLException {
        String sql = "INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, " +
                    "preco, preco_promocional, paginas, sinopse, categoria_id, estoque, " +
                    "estoque_minimo, peso, idioma, edicao, encadernacao, imagem, ativo, " +
                    "destaque, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            livro.getTitulo(), livro.getAutor(), livro.getIsbn(), livro.getEditora(),
            livro.getAnoPublicacao(), livro.getPreco(), livro.getPrecoPromocional(),
            livro.getPaginas(), livro.getSinopse(), livro.getCategoriaId(),
            livro.getEstoque(), livro.getEstoqueMinimo(), livro.getPeso(),
            livro.getIdioma(), livro.getEdicao(), livro.getEncadernacao(),
            livro.getImagem(), livro.isAtivo(), livro.isDestaque()
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
        
        return executeUpdate(sql,
            livro.getTitulo(), livro.getAutor(), livro.getIsbn(), livro.getEditora(),
            livro.getAnoPublicacao(), livro.getPreco(), livro.getPrecoPromocional(),
            livro.getPaginas(), livro.getSinopse(), livro.getCategoriaId(),
            livro.getEstoque(), livro.getEstoqueMinimo(), livro.getPeso(),
            livro.getIdioma(), livro.getEdicao(), livro.getEncadernacao(),
            livro.getImagem(), livro.isAtivo(), livro.isDestaque(), livro.getId()
        ) > 0;
    }
    
    /**
     * Exclui livro
     */
    public boolean excluir(int id) throws SQLException {
        String sql = "DELETE FROM livros WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }
    
    /**
     * Verifica se tem pedidos vinculados
     */
    public boolean temPedidosVinculados(int livroId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM order_items WHERE livro_id = ?";
        return executeCountQuery(sql, livroId) > 0;
    }
    
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
        livro.setEstoqueMinimo((Integer) rs.getObject("estoque_minimo"));
        livro.setPeso((Double) rs.getObject("peso"));
        livro.setIdioma(rs.getString("idioma"));
        livro.setEdicao(rs.getString("edicao"));
        livro.setEncadernacao(rs.getString("encadernacao"));
        livro.setImagem(rs.getString("imagem"));
        livro.setAtivo(rs.getBoolean("ativo"));
        livro.setDestaque(rs.getBoolean("destaque"));
        livro.setVendasTotal((Integer) rs.getObject("vendas_total"));
        livro.setAvaliacaoMedia(rs.getBigDecimal("avaliacao_media"));
        livro.setTotalAvaliacoes((Integer) rs.getObject("total_avaliacoes"));
        livro.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        livro.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return livro;
    }
    
    /**
     * Mapeia ResultSet para Livro com categoria
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
    
    /**
     * Mapeia ResultSet para Livro simples (autocomplete)
     */
    private Livro mapRowToLivroSimples(ResultSet rs) throws SQLException {
        Livro livro = new Livro();
        livro.setId(rs.getInt("id"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setPreco(rs.getBigDecimal("preco"));
        livro.setPrecoPromocional(rs.getBigDecimal("preco_promocional"));
        livro.setImagem(rs.getString("imagem"));
        
        return livro;
    }
    /**
     * Busca livros com filtros avançados
     */
    public List<Livro> buscarComFiltrosAvancados(String busca, String categoriaId, String precoMin, 
                                               String precoMax, String ordenacao, int page, int pageSize) 
            throws SQLException {
        validatePagination(page, pageSize);
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT l.*, c.nome as categoria_nome FROM livros l ");
        sql.append("LEFT JOIN categorias c ON l.categoria_id = c.id ");
        sql.append("WHERE l.ativo = true ");
        
        List<Object> params = new ArrayList<>();
        
        // Filtro de busca por texto
        if (busca != null && !busca.trim().isEmpty()) {
            sql.append("AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ? OR l.editora LIKE ? OR l.sinopse LIKE ?) ");
            String searchTerm = "%" + escapeLike(busca.trim()) + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        // Filtro de categoria
        if (categoriaId != null && !categoriaId.trim().isEmpty() && !categoriaId.equals("0")) {
            sql.append("AND l.categoria_id = ? ");
            params.add(Integer.parseInt(categoriaId));
        }
        
        // Filtro de preço mínimo
        if (precoMin != null && !precoMin.trim().isEmpty()) {
            sql.append("AND COALESCE(l.preco_promocional, l.preco) >= ? ");
            params.add(Double.parseDouble(precoMin));
        }
        
        // Filtro de preço máximo
        if (precoMax != null && !precoMax.trim().isEmpty()) {
            sql.append("AND COALESCE(l.preco_promocional, l.preco) <= ? ");
            params.add(Double.parseDouble(precoMax));
        }
        
        // Ordenação
        sql.append("ORDER BY ");
        if (ordenacao != null) {
            switch (ordenacao) {
                case "preco_asc":
                    sql.append("COALESCE(l.preco_promocional, l.preco) ASC, l.titulo ASC");
                    break;
                case "preco_desc":
                    sql.append("COALESCE(l.preco_promocional, l.preco) DESC, l.titulo ASC");
                    break;
                case "titulo":
                    sql.append("l.titulo ASC");
                    break;
                case "autor":
                    sql.append("l.autor ASC, l.titulo ASC");
                    break;
                case "mais_vendidos":
                    sql.append("l.vendas_total DESC, l.titulo ASC");
                    break;
                case "mais_recentes":
                    sql.append("l.created_at DESC");
                    break;
                case "avaliacao":
                    sql.append("l.avaliacao_media DESC, l.total_avaliacoes DESC, l.titulo ASC");
                    break;
                default:
                    sql.append("l.titulo ASC");
            }
        } else {
            sql.append("l.titulo ASC");
        }
        
        sql.append(buildLimitClause(page, pageSize));
        
        return executeQuery(sql.toString(), this::mapRowToLivroComCategoria, params.toArray());
    }

    /**
     * Conta livros com filtros avançados
     */
    public int contarComFiltrosAvancados(String busca, String categoriaId, String precoMin, String precoMax) 
            throws SQLException {
        
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM livros l WHERE l.ativo = true ");
        
        List<Object> params = new ArrayList<>();
        
        // Filtro de busca por texto
        if (busca != null && !busca.trim().isEmpty()) {
            sql.append("AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.isbn LIKE ? OR l.editora LIKE ? OR l.sinopse LIKE ?) ");
            String searchTerm = "%" + escapeLike(busca.trim()) + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        
        // Filtro de categoria
        if (categoriaId != null && !categoriaId.trim().isEmpty() && !categoriaId.equals("0")) {
            sql.append("AND l.categoria_id = ? ");
            params.add(Integer.parseInt(categoriaId));
        }
        
        // Filtro de preço mínimo
        if (precoMin != null && !precoMin.trim().isEmpty()) {
            sql.append("AND COALESCE(l.preco_promocional, l.preco) >= ? ");
            params.add(Double.parseDouble(precoMin));
        }
        
        // Filtro de preço máximo
        if (precoMax != null && !precoMax.trim().isEmpty()) {
            sql.append("AND COALESCE(l.preco_promocional, l.preco) <= ? ");
            params.add(Double.parseDouble(precoMax));
        }
        
        return executeCountQuery(sql.toString(), params.toArray());
    }

    /**
     * Busca por autocomplete
     */
    public List<String> buscarSugestoes(String termo, int limit) throws SQLException {
        String sql = "SELECT DISTINCT " +
                    "CASE " +
                    "  WHEN l.titulo LIKE ? THEN l.titulo " +
                    "  WHEN l.autor LIKE ? THEN l.autor " +
                    "  WHEN l.editora LIKE ? THEN l.editora " +
                    "  ELSE l.titulo " +
                    "END as sugestao " +
                    "FROM livros l " +
                    "WHERE l.ativo = true " +
                    "AND (l.titulo LIKE ? OR l.autor LIKE ? OR l.editora LIKE ?) " +
                    "ORDER BY " +
                    "CASE " +
                    "  WHEN l.titulo LIKE ? THEN 1 " +
                    "  WHEN l.autor LIKE ? THEN 2 " +
                    "  ELSE 3 " +
                    "END, sugestao " +
                    "LIMIT ?";
        
        String searchTerm = "%" + escapeLike(termo) + "%";
        String startTerm = escapeLike(termo) + "%";
        
        return executeQuery(sql, rs -> rs.getString("sugestao"), 
                           startTerm, startTerm, startTerm, 
                           searchTerm, searchTerm, searchTerm,
                           startTerm, startTerm, limit);
    }

    /**
     * Busca livros mais vendidos por período
     */
    public List<Livro> buscarMaisVendidosPeriodo(int dias, int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome, " +
                    "COALESCE(SUM(oi.quantity), 0) as vendas_periodo " +
                    "FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "LEFT JOIN order_items oi ON l.id = oi.livro_id " +
                    "LEFT JOIN orders o ON oi.order_id = o.id " +
                    "WHERE l.ativo = true " +
                    "AND (o.created_at >= DATE_SUB(NOW(), INTERVAL ? DAY) OR o.created_at IS NULL) " +
                    "GROUP BY l.id " +
                    "ORDER BY vendas_periodo DESC, l.vendas_total DESC, l.titulo " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, dias, limit);
    }

    /**
     * Busca livros por faixa de preço
     */
    public List<Livro> buscarPorFaixaPreco(double precoMin, double precoMax, int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE l.ativo = true " +
                    "AND COALESCE(l.preco_promocional, l.preco) BETWEEN ? AND ? " +
                    "ORDER BY COALESCE(l.preco_promocional, l.preco), l.titulo " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, precoMin, precoMax, limit);
    }

    /**
     * Busca livros com estoque baixo
     */
    public List<Livro> buscarEstoqueBaixo(int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE l.ativo = true " +
                    "AND l.estoque > 0 " +
                    "AND l.estoque <= l.estoque_minimo " +
                    "ORDER BY l.estoque, l.titulo " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, limit);
    }

    /**
     * Busca livros sem estoque
     */
    public List<Livro> buscarSemEstoque(int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome " +
                    "FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE l.ativo = true " +
                    "AND l.estoque = 0 " +
                    "ORDER BY l.titulo " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, limit);
    }

    /**
     * Conta livros com estoque
     */
    public int contarComEstoque() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true AND estoque > 0");
    }

    /**
     * Conta livros com estoque baixo
     */
    public int contarEstoqueBaixo() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true AND estoque > 0 AND estoque <= estoque_minimo");
    }

    /**
     * Calcula valor total do estoque
     */
    public java.math.BigDecimal calcularValorTotalEstoque() throws SQLException {
        String sql = "SELECT COALESCE(SUM(l.estoque * COALESCE(l.preco_promocional, l.preco)), 0) " +
                    "FROM livros l WHERE l.ativo = true";
        
        List<java.math.BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1));
        return result.isEmpty() ? java.math.BigDecimal.ZERO : result.get(0);
    }

    /**
     * Busca livros mais vendidos no mês atual
     */
    public List<Livro> buscarMaisVendidosMes(int limit) throws SQLException {
        String sql = "SELECT l.*, c.nome as categoria_nome, " +
                    "COALESCE(SUM(oi.quantity), 0) as vendas_mes " +
                    "FROM livros l " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "LEFT JOIN order_items oi ON l.id = oi.livro_id " +
                    "LEFT JOIN orders o ON oi.order_id = o.id " +
                    "WHERE l.ativo = true " +
                    "AND (MONTH(o.created_at) = MONTH(NOW()) AND YEAR(o.created_at) = YEAR(NOW()) OR o.created_at IS NULL) " +
                    "GROUP BY l.id " +
                    "ORDER BY vendas_mes DESC, l.titulo " +
                    "LIMIT ?";
        
        return executeQuery(sql, this::mapRowToLivroComCategoria, limit);
    }

    /**
     * Contar total de livros
     */
    public int contar() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM livros WHERE ativo = true");
    }
}