package com.livraria.dao;

import com.livraria.models.Cart;
import com.livraria.models.CartItem;
import com.livraria.models.Livro;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com carrinho - Versão Completa
 */
public class CartDAO extends BaseDAO<Cart> {

    @Override
    protected String getTableName() {
        return "carts";
    }

    @Override
    protected Cart mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToCart(rs);
    }

    // ========== MÉTODOS BÁSICOS DO CART ==========

    /**
     * Busca carrinho por ID
     */
    public Cart buscarPorId(int id) throws SQLException {
        String sql = "SELECT * FROM carts WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToCart, id);
    }

    /**
     * Cria novo carrinho
     */
    public Cart criar(Cart cart) throws SQLException {
        String sql = "INSERT INTO carts (session_id, user_id, status, created_at, updated_at) " +
                    "VALUES (?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            cart.getSessionId(),
            cart.getUserId(),
            cart.getStatus()
        );
        
        cart.setId(id);
        return cart;
    }

    /**
     * Atualiza carrinho
     */
    public boolean atualizar(Cart cart) throws SQLException {
        String sql = "UPDATE carts SET user_id = ?, status = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, cart.getUserId(), cart.getStatus(), cart.getId()) > 0;
    }

    /**
     * Exclui carrinho
     */
    public boolean excluir(int id) throws SQLException {
        String sql = "DELETE FROM carts WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }

    // ========== MÉTODOS DOS ITENS DO CARRINHO ==========

    /**
     * Lista itens do carrinho
     */
    public List<CartItem> listarItensDoCarrinho(int cartId) throws SQLException {
        String sql = "SELECT ci.*, l.titulo, l.autor, l.preco, l.imagem, l.estoque, l.ativo " +
                    "FROM cart_items ci " +
                    "JOIN livros l ON ci.livro_id = l.id " +
                    "WHERE ci.cart_id = ? " +
                    "ORDER BY ci.created_at";
        
        return executeQuery(sql, this::mapRowToCartItemComLivro, cartId);
    }

    /**
     * Busca item por livro no carrinho
     */
    public CartItem buscarItemPorLivro(int cartId, int livroId) throws SQLException {
        String sql = "SELECT * FROM cart_items WHERE cart_id = ? AND livro_id = ?";
        return executeSingleQuery(sql, this::mapRowToCartItem, cartId, livroId);
    }

    /**
     * Busca item por ID
     */
    public CartItem buscarItemPorId(int itemId) throws SQLException {
        String sql = "SELECT * FROM cart_items WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToCartItem, itemId);
    }

    /**
     * Adiciona item ao carrinho
     */
    public CartItem adicionarItem(CartItem item) throws SQLException {
        String sql = "INSERT INTO cart_items (cart_id, livro_id, quantity, price, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            item.getCartId(),
            item.getLivroId(),
            item.getQuantity(),
            item.getPrice()
        );
        
        item.setId(id);
        return item;
    }

    /**
     * Atualiza item do carrinho
     */
    public boolean atualizarItem(CartItem item) throws SQLException {
        String sql = "UPDATE cart_items SET quantity = ?, price = ?, updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, item.getQuantity(), item.getPrice(), item.getId()) > 0;
    }

    /**
     * Remove item do carrinho
     */
    public boolean removerItem(int itemId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE id = ?";
        return executeUpdate(sql, itemId) > 0;
    }

    /**
     * Limpa todos os itens do carrinho
     */
    public boolean limparCarrinho(int cartId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        return executeUpdate(sql, cartId) > 0;
    }

    // ========== MÉTODOS DE CÁLCULO E CONTAGEM ==========

    /**
     * Conta a quantidade total de itens no carrinho
     */
    public int contarItensCarrinho(int cartId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE cart_id = ?";
        return executeCountQuery(sql, cartId);
    }

    /**
     * Calcula total do carrinho
     */
    public BigDecimal calcularTotalCarrinho(int cartId) throws SQLException {
        String sql = "SELECT SUM(price * quantity) FROM cart_items WHERE cart_id = ?";
        List<BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1), cartId);
        return result.isEmpty() || result.get(0) == null ? BigDecimal.ZERO : result.get(0);
    }

    /**
     * Calcula subtotal dos itens
     */
    public BigDecimal calcularSubtotal(int cartId) throws SQLException {
        return calcularTotalCarrinho(cartId);
    }

    // ========== MÉTODOS DE VALIDAÇÃO ==========

    /**
     * Valida o estoque de todos os itens do carrinho
     */
    public List<String> validarEstoqueCarrinho(int cartId) throws SQLException {
        String sql = "SELECT ci.quantity, l.titulo, l.estoque, l.ativo " +
                    "FROM cart_items ci " +
                    "JOIN livros l ON ci.livro_id = l.id " +
                    "WHERE ci.cart_id = ?";
        
        List<String> erros = new ArrayList<>();
        
        List<Object[]> items = executeQuery(sql, rs -> new Object[]{
            rs.getInt("quantity"),
            rs.getString("titulo"),
            rs.getInt("estoque"),
            rs.getBoolean("ativo")
        }, cartId);
        
        for (Object[] item : items) {
            int quantity = (Integer) item[0];
            String titulo = (String) item[1];
            int estoque = (Integer) item[2];
            boolean ativo = (Boolean) item[3];
            
            if (!ativo) {
                erros.add("O livro '" + titulo + "' não está mais disponível.");
            } else if (estoque < quantity) {
                erros.add("Estoque insuficiente para '" + titulo + "'. Disponível: " + estoque + ", solicitado: " + quantity + ".");
            }
        }
        
        return erros;
    }

    /**
     * Verifica se carrinho está vazio
     */
    public boolean isCarrinhoVazio(int cartId) throws SQLException {
        return contarItensCarrinho(cartId) == 0;
    }

    // ========== MÉTODOS DE MIGRAÇÃO E GERENCIAMENTO ==========

    /**
     * Migra carrinho de sessão para usuário
     */
    public void migrarCarrinhoParaUsuario(String sessionId, int userId) throws SQLException {
        String sql = "UPDATE carts SET user_id = ? WHERE session_id = ? AND user_id IS NULL";
        executeUpdate(sql, userId, sessionId);
    }

    /**
     * Busca carrinho por sessão
     */
    public Cart buscarPorSessao(String sessionId) throws SQLException {
        String sql = "SELECT * FROM carts WHERE session_id = ? AND status = 'active'";
        return executeSingleQuery(sql, this::mapRowToCart, sessionId);
    }

    /**
     * Busca carrinho ativo do usuário
     */
    public Cart buscarAtivoDoUsuario(int userId) throws SQLException {
        String sql = "SELECT * FROM carts WHERE user_id = ? AND status = 'active' ORDER BY updated_at DESC LIMIT 1";
        return executeSingleQuery(sql, this::mapRowToCart, userId);
    }

    /**
     * Marca carrinho como concluído dentro de uma transação
     */
    public boolean marcarComoConcluido(Connection conn, int cartId) throws SQLException {
        String sql = "UPDATE carts SET status = 'completed', updated_at = NOW() WHERE id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    /**
     * Marca carrinho como cancelado
     */
    public boolean marcarComoCancelado(int cartId) throws SQLException {
        String sql = "UPDATE carts SET status = 'cancelled', updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, cartId) > 0;
    }

    // ========== MÉTODOS DE LIMPEZA E MANUTENÇÃO ==========

    /**
     * Remove carrinhos antigos e inativos
     */
    public int limparCarrinhosAntigos(int diasAntigos) throws SQLException {
        String sql = "DELETE FROM carts WHERE status = 'active' AND created_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        return executeUpdate(sql, diasAntigos);
    }

    /**
     * Lista carrinhos abandonados
     */
    public List<Cart> buscarCarrinhosAbandonados(int horasInativo) throws SQLException {
        String sql = "SELECT c.* FROM carts c " +
                    "WHERE c.status = 'active' " +
                    "AND c.updated_at < DATE_SUB(NOW(), INTERVAL ? HOUR) " +
                    "AND EXISTS (SELECT 1 FROM cart_items ci WHERE ci.cart_id = c.id) " +
                    "ORDER BY c.updated_at DESC";
        
        return executeQuery(sql, this::mapRowToCart, horasInativo);
    }

    // ========== MÉTODOS DE ESTATÍSTICAS ==========

    /**
     * Conta carrinhos ativos
     */
    public int contarCarrinhosAtivos() throws SQLException {
        return executeCountQuery("SELECT COUNT(*) FROM carts WHERE status = 'active'");
    }

    /**
     * Calcula valor médio dos carrinhos
     */
    public BigDecimal calcularValorMedioCarrinhos() throws SQLException {
        String sql = "SELECT AVG(total.valor) FROM (" +
                    "SELECT SUM(ci.price * ci.quantity) as valor " +
                    "FROM carts c " +
                    "JOIN cart_items ci ON c.id = ci.cart_id " +
                    "WHERE c.status = 'active' " +
                    "GROUP BY c.id" +
                    ") total";
        
        List<BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1));
        return result.isEmpty() || result.get(0) == null ? BigDecimal.ZERO : result.get(0);
    }

    // ========== MÉTODOS DE BUSCA AVANÇADA ==========

    /**
     * Busca itens específicos em carrinhos
     */
    public List<CartItem> buscarItensPorLivro(int livroId) throws SQLException {
        String sql = "SELECT ci.*, c.session_id, c.user_id FROM cart_items ci " +
                    "JOIN carts c ON ci.cart_id = c.id " +
                    "WHERE ci.livro_id = ? AND c.status = 'active'";
        
        return executeQuery(sql, this::mapRowToCartItem, livroId);
    }

    /**
     * Lista carrinhos com itens
     */
    public List<Cart> listarCarrinhosComItens() throws SQLException {
        String sql = "SELECT DISTINCT c.* FROM carts c " +
                    "JOIN cart_items ci ON c.id = ci.cart_id " +
                    "WHERE c.status = 'active' " +
                    "ORDER BY c.updated_at DESC";
        
        return executeQuery(sql, this::mapRowToCart);
    }

    // ========== MÉTODOS DE SINCRONIZAÇÃO ==========

    /**
     * Sincroniza preços dos itens do carrinho com preços atuais dos livros
     */
    public int sincronizarPrecos(int cartId) throws SQLException {
        String sql = "UPDATE cart_items ci " +
                    "JOIN livros l ON ci.livro_id = l.id " +
                    "SET ci.price = COALESCE(l.preco_promocional, l.preco), " +
                    "ci.updated_at = NOW() " +
                    "WHERE ci.cart_id = ? " +
                    "AND ci.price != COALESCE(l.preco_promocional, l.preco)";
        
        return executeUpdate(sql, cartId);
    }

    /**
     * Remove itens de livros inativos do carrinho
     */
    public int removerItensInativos(int cartId) throws SQLException {
        String sql = "DELETE ci FROM cart_items ci " +
                    "JOIN livros l ON ci.livro_id = l.id " +
                    "WHERE ci.cart_id = ? AND l.ativo = false";
        
        return executeUpdate(sql, cartId);
    }

    // ========== MÉTODOS DE MAPEAMENTO ==========

    /**
     * Mapeia ResultSet para Cart
     */
    private Cart mapRowToCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setId(rs.getInt("id"));
        cart.setSessionId(rs.getString("session_id"));
        cart.setUserId((Integer) rs.getObject("user_id"));
        cart.setStatus(rs.getString("status"));
        cart.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        cart.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return cart;
    }

    /**
     * Mapeia ResultSet para CartItem
     */
    private CartItem mapRowToCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setId(rs.getInt("id"));
        item.setCartId(rs.getInt("cart_id"));
        item.setLivroId(rs.getInt("livro_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getBigDecimal("price"));
        
        // Campos opcionais
        try {
            item.setStockReserved(rs.getBoolean("stock_reserved"));
        } catch (SQLException e) {
            item.setStockReserved(false);
        }
        
        item.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        item.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        
        return item;
    }

    /**
     * Mapeia ResultSet para CartItem com dados do Livro
     */
    private CartItem mapRowToCartItemComLivro(ResultSet rs) throws SQLException {
        CartItem item = mapRowToCartItem(rs);
        
        // Dados básicos do livro
        Livro livro = new Livro();
        livro.setId(item.getLivroId());
        
        try {
            livro.setTitulo(rs.getString("titulo"));
            livro.setAutor(rs.getString("autor"));
            livro.setPreco(rs.getBigDecimal("preco"));
            livro.setImagem(rs.getString("imagem"));
            livro.setEstoque(rs.getInt("estoque"));
            livro.setAtivo(rs.getBoolean("ativo"));
        } catch (SQLException e) {
            // Alguns campos podem não estar disponíveis dependendo da query
        }
        
        item.setLivro(livro);
        
        return item;
    }

    // ========== MÉTODOS ABSTRATOS DA BASEDAO ==========

    @Override
    public List<Cart> findAll() {
        try {
            String sql = "SELECT * FROM carts ORDER BY created_at DESC";
            return executeQuery(sql, this::mapRowToCart);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Cart findById(Long id) {
        try {
            return buscarPorId(id.intValue());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Cart save(Cart entity) {
        try {
            return criar(entity);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Cart update(Cart entity) {
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
}