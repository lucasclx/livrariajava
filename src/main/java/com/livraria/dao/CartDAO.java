package com.livraria.dao;

import com.livraria.models.Cart;
import com.livraria.models.CartItem;
import com.livraria.models.Livro;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com carrinho
 */
public class CartDAO extends BaseDAO<Cart> {

    @Override
    protected String getTableName() {
        return "carts";
    }

    @Override
    public List<Cart> findAll() {
        throw new UnsupportedOperationException();
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
        throw new UnsupportedOperationException();
    }

    @Override
    protected Cart mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToCart(rs);
    }
    
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
        String sql = "UPDATE carts SET session_id = ?, user_id = ?, status = ?, " +
                    "updated_at = NOW() WHERE id = ?";
        
        return executeUpdate(sql,
            cart.getSessionId(),
            cart.getUserId(),
            cart.getStatus(),
            cart.getId()
        ) > 0;
    }
    
    /**
     * Marca carrinho como concluído
     */
    public boolean marcarComoConcluido(int cartId) throws SQLException {
        String sql = "UPDATE carts SET status = 'completed', updated_at = NOW() WHERE id = ?";
        return executeUpdate(sql, cartId) > 0;
    }
    
    /**
     * Lista itens do carrinho
     */
    public List<CartItem> listarItensDoCarrinho(int cartId) throws SQLException {
        String sql = "SELECT ci.*, l.titulo, l.autor, l.preco, l.imagem, l.estoque, " +
                    "c.nome as categoria_nome " +
                    "FROM cart_items ci " +
                    "JOIN livros l ON ci.livro_id = l.id " +
                    "LEFT JOIN categorias c ON l.categoria_id = c.id " +
                    "WHERE ci.cart_id = ? " +
                    "ORDER BY ci.created_at";
        
        return executeQuery(sql, this::mapRowToCartItemComLivro, cartId);
    }
    
    /**
     * Busca item específico do carrinho
     */
    public CartItem buscarItemPorId(int itemId) throws SQLException {
        String sql = "SELECT * FROM cart_items WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToCartItem, itemId);
    }
    
    /**
     * Busca item por livro no carrinho
     */
    public CartItem buscarItemPorLivro(int cartId, int livroId) throws SQLException {
        String sql = "SELECT * FROM cart_items WHERE cart_id = ? AND livro_id = ?";
        return executeSingleQuery(sql, this::mapRowToCartItem, cartId, livroId);
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
    
    /**
     * Conta itens no carrinho
     */
    public int contarItensCarrinho(int cartId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM cart_items WHERE cart_id = ?";
        return executeCountQuery(sql, cartId);
    }
    
    /**
     * Calcula total do carrinho
     */
    public BigDecimal calcularTotalCarrinho(int cartId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity * price), 0) FROM cart_items WHERE cart_id = ?";
        
        List<BigDecimal> result = executeQuery(sql, rs -> rs.getBigDecimal(1), cartId);
        return result.isEmpty() ? BigDecimal.ZERO : result.get(0);
    }
    
    /**
     * Valida estoque dos itens do carrinho
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
                erros.add("O livro '" + titulo + "' não está mais disponível");
            } else if (estoque < quantity) {
                erros.add("Estoque insuficiente para '" + titulo + "'. Disponível: " + estoque);
            }
        }
        
        return erros;
    }
    
    /**
     * Reserva estoque dos itens do carrinho
     */
    public boolean reservarEstoque(int cartId) throws SQLException {
        String sql = "UPDATE livros l " +
                    "JOIN cart_items ci ON l.id = ci.livro_id " +
                    "SET l.estoque = l.estoque - ci.quantity, " +
                    "ci.stock_reserved = true " +
                    "WHERE ci.cart_id = ? AND l.estoque >= ci.quantity";
        
        int affectedRows = executeUpdate(sql, cartId);
        return affectedRows > 0;
    }
    
    /**
     * Libera estoque reservado
     */
    public boolean liberarEstoque(int cartId) throws SQLException {
        String sql = "UPDATE livros l " +
                    "JOIN cart_items ci ON l.id = ci.livro_id " +
                    "SET l.estoque = l.estoque + ci.quantity, " +
                    "ci.stock_reserved = false " +
                    "WHERE ci.cart_id = ? AND ci.stock_reserved = true";
        
        return executeUpdate(sql, cartId) > 0;
    }
    
    /**
     * Busca carrinhos abandonados (para limpeza)
     */
    public List<Cart> buscarCarrinhosAbandonados(int diasAbandonado) throws SQLException {
        String sql = "SELECT * FROM carts " +
                    "WHERE status = 'active' " +
                    "AND updated_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        
        return executeQuery(sql, this::mapRowToCart, diasAbandonado);
    }
    
    /**
     * Remove carrinhos abandonados
     */
    public int removerCarrinhosAbandonados(int diasAbandonado) throws SQLException {
        // Primeiro remove os itens
        String deleteItemsSql = "DELETE ci FROM cart_items ci " +
                               "JOIN carts c ON ci.cart_id = c.id " +
                               "WHERE c.status = 'active' " +
                               "AND c.updated_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        
        executeUpdate(deleteItemsSql, diasAbandonado);
        
        // Depois remove os carrinhos
        String deleteCartsSql = "DELETE FROM carts " +
                               "WHERE status = 'active' " +
                               "AND updated_at < DATE_SUB(NOW(), INTERVAL ? DAY)";
        
        return executeUpdate(deleteCartsSql, diasAbandonado);
    }
    
    /**
     * Migra carrinho de sessão para usuário logado
     */
    public boolean migrarCarrinhoParaUsuario(String sessionId, int userId) throws SQLException {
        String sql = "UPDATE carts SET user_id = ?, updated_at = NOW() " +
                    "WHERE session_id = ? AND user_id IS NULL AND status = 'active'";
        
        return executeUpdate(sql, userId, sessionId) > 0;
    }
    
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
        
        try {
            item.setStockReserved(rs.getBoolean("stock_reserved"));
        } catch (SQLException e) {
            // Campo pode não existir em todas as queries
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
        
        // Criar objeto Livro com dados básicos
        Livro livro = new Livro();
        livro.setId(item.getLivroId());
        livro.setTitulo(rs.getString("titulo"));
        livro.setAutor(rs.getString("autor"));
        livro.setPreco(rs.getBigDecimal("preco"));
        livro.setImagem(rs.getString("imagem"));
        livro.setEstoque(rs.getInt("estoque"));
        
        item.setLivro(livro);
        
        return item;
    }
}