package com.livraria.services;

import com.livraria.dao.CartDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.models.Cart;
import com.livraria.models.CartItem;
import com.livraria.models.Livro;
import com.livraria.models.User;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Serviço para gerenciar operações do carrinho
 */
public class CartService {
    
    private CartDAO cartDAO;
    private LivroDAO livroDAO;
    
    public CartService() {
        this.cartDAO = new CartDAO();
        this.livroDAO = new LivroDAO();
    }
    
    /**
     * Obtém o carrinho atual da sessão
     */
    public Cart obterCarrinho(HttpServletRequest request) throws SQLException {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        Integer cartId = (Integer) session.getAttribute("cart_id");
        if (cartId == null) return null;
        
        return cartDAO.buscarPorId(cartId);
    }
    
    /**
     * Obtém ou cria um carrinho para a sessão
     */
    public Cart obterOuCriarCarrinho(HttpServletRequest request) throws SQLException {
        Cart cart = obterCarrinho(request);
        
        if (cart != null && "active".equals(cart.getStatus())) {
            return cart;
        }
        
        // Criar novo carrinho
        HttpSession session = request.getSession(true);
        
        cart = new Cart();
        cart.setSessionId(session.getId());
        cart.setStatus("active");
        
        // Se usuário está logado, associar ao carrinho
        User user = (User) session.getAttribute("user");
        if (user != null) {
            cart.setUserId(user.getId());
        }
        
        cart = cartDAO.criar(cart);
        session.setAttribute("cart_id", cart.getId());
        
        return cart;
    }
    
    /**
     * Adiciona item ao carrinho
     */
    public void adicionarItem(HttpServletRequest request, int livroId, int quantidade) 
            throws SQLException, IllegalArgumentException {
        
        // Validar quantidade
        if (quantidade <= 0 || quantidade > 10) {
            throw new IllegalArgumentException("Quantidade deve estar entre 1 e 10");
        }
        
        // Buscar livro
        Livro livro = livroDAO.buscarPorId(livroId);
        if (livro == null) {
            throw new IllegalArgumentException("Livro não encontrado");
        }
        
        if (!livro.isAtivo()) {
            throw new IllegalArgumentException("Livro não está disponível");
        }
        
        if (livro.getEstoque() < quantidade) {
            throw new IllegalArgumentException("Estoque insuficiente. Disponível: " + livro.getEstoque());
        }
        
        // Obter carrinho
        Cart cart = obterOuCriarCarrinho(request);
        
        // Verificar se item já existe
        CartItem itemExistente = cartDAO.buscarItemPorLivro(cart.getId(), livroId);
        
        if (itemExistente != null) {
            int novaQuantidade = itemExistente.getQuantity() + quantidade;
            
            if (novaQuantidade > livro.getEstoque()) {
                throw new IllegalArgumentException("Quantidade total excede o estoque disponível");
            }
            
            if (novaQuantidade > 10) {
                throw new IllegalArgumentException("Quantidade máxima por item é 10");
            }
            
            itemExistente.setQuantity(novaQuantidade);
            cartDAO.atualizarItem(itemExistente);
        } else {
            CartItem novoItem = new CartItem();
            novoItem.setCartId(cart.getId());
            novoItem.setLivroId(livroId);
            novoItem.setQuantity(quantidade);
            novoItem.setPrice(livro.getPrecoFinal());
            
            cartDAO.adicionarItem(novoItem);
        }
        
        // Atualizar contador na sessão
        atualizarContadorCarrinho(request);
    }
    
    /**
     * Atualiza quantidade de um item
     */
    public void atualizarQuantidade(HttpServletRequest request, int itemId, int novaQuantidade) 
            throws SQLException, IllegalArgumentException {
        
        if (novaQuantidade <= 0 || novaQuantidade > 10) {
            throw new IllegalArgumentException("Quantidade deve estar entre 1 e 10");
        }
        
        CartItem item = cartDAO.buscarItemPorId(itemId);
        if (item == null) {
            throw new IllegalArgumentException("Item não encontrado no carrinho");
        }
        
        // Verificar se item pertence ao carrinho da sessão
        Cart cart = obterCarrinho(request);
        if (cart == null || !cart.getId().equals(item.getCartId())) {
            throw new IllegalArgumentException("Item não encontrado no seu carrinho");
        }
        
        // Verificar estoque
        Livro livro = livroDAO.buscarPorId(item.getLivroId());
        if (livro.getEstoque() < novaQuantidade) {
            throw new IllegalArgumentException("Estoque insuficiente. Disponível: " + livro.getEstoque());
        }
        
        item.setQuantity(novaQuantidade);
        cartDAO.atualizarItem(item);
        
        atualizarContadorCarrinho(request);
    }
    
    /**
     * Remove item do carrinho
     */
    public void removerItem(HttpServletRequest request, int itemId) 
            throws SQLException, IllegalArgumentException {
        
        CartItem item = cartDAO.buscarItemPorId(itemId);
        if (item == null) {
            throw new IllegalArgumentException("Item não encontrado no carrinho");
        }
        
        // Verificar se item pertence ao carrinho da sessão
        Cart cart = obterCarrinho(request);
        if (cart == null || !cart.getId().equals(item.getCartId())) {
            throw new IllegalArgumentException("Item não encontrado no seu carrinho");
        }
        
        cartDAO.removerItem(itemId);
        atualizarContadorCarrinho(request);
    }
    
    /**
     * Limpa todo o carrinho
     */
    public void limparCarrinho(HttpServletRequest request) throws SQLException {
        Cart cart = obterCarrinho(request);
        if (cart != null) {
            cartDAO.limparCarrinho(cart.getId());
            atualizarContadorCarrinho(request);
        }
    }
    
    /**
     * Lista itens do carrinho
     */
    public List<CartItem> listarItens(HttpServletRequest request) throws SQLException {
        Cart cart = obterCarrinho(request);
        if (cart == null) {
            return List.of();
        }
        
        return cartDAO.listarItensDoCarrinho(cart.getId());
    }
    
    /**
     * Calcula totais do carrinho
     */
    public CarrinhoTotais calcularTotais(HttpServletRequest request) throws SQLException {
        Cart cart = obterCarrinho(request);
        if (cart == null) {
            return new CarrinhoTotais();
        }
        
        List<CartItem> items = cartDAO.listarItensDoCarrinho(cart.getId());
        
        BigDecimal subtotal = BigDecimal.ZERO;
        int totalItens = 0;
        
        for (CartItem item : items) {
            BigDecimal itemTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
            subtotal = subtotal.add(itemTotal);
            totalItens += item.getQuantity();
        }
        
        BigDecimal frete = calcularFrete(items);
        BigDecimal total = subtotal.add(frete);
        
        return new CarrinhoTotais(subtotal, frete, total, totalItens);
    }
    
    /**
     * Conta itens no carrinho
     */
    public int contarItens(HttpServletRequest request) throws SQLException {
        Cart cart = obterCarrinho(request);
        if (cart == null) {
            return 0;
        }
        
        return cartDAO.contarItensCarrinho(cart.getId());
    }
    
    /**
     * Valida estoque de todos os itens do carrinho
     */
    public List<String> validarEstoque(HttpServletRequest request) throws SQLException {
        Cart cart = obterCarrinho(request);
        if (cart == null) {
            return List.of();
        }
        
        return cartDAO.validarEstoqueCarrinho(cart.getId());
    }
    
    /**
     * Migra carrinho de sessão para usuário logado
     */
    public void migrarCarrinhoParaUsuario(String sessionId, int userId) throws SQLException {
        cartDAO.migrarCarrinhoParaUsuario(sessionId, userId);
    }
    
    /**
     * Atualiza contador de itens na sessão
     */
    private void atualizarContadorCarrinho(HttpServletRequest request) {
        try {
            int count = contarItens(request);
            request.getSession().setAttribute("cart_count", count);
        } catch (SQLException e) {
            // Log do erro, mas não interrompe o fluxo
            System.err.println("Erro ao atualizar contador do carrinho: " + e.getMessage());
        }
    }
    
    /**
     * Calcula frete baseado nos itens
     */
    private BigDecimal calcularFrete(List<CartItem> items) {
        if (items.isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        double pesoTotal = 0.0;
        BigDecimal valorTotal = BigDecimal.ZERO;
        
        for (CartItem item : items) {
            try {
                Livro livro = livroDAO.buscarPorId(item.getLivroId());
                double peso = livro.getPeso() != null ? livro.getPeso() : 0.5;
                pesoTotal += peso * item.getQuantity();
                
                BigDecimal itemTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
                valorTotal = valorTotal.add(itemTotal);
            } catch (SQLException e) {
                pesoTotal += 0.5 * item.getQuantity(); // peso padrão
            }
        }
        
        // Frete grátis acima de R$ 99
        if (valorTotal.compareTo(new BigDecimal("99.00")) >= 0) {
            return BigDecimal.ZERO;
        }
        
        // Cálculo simplificado de frete
        if (pesoTotal <= 1.0) {
            return new BigDecimal("12.50"); // PAC
        } else if (pesoTotal <= 3.0) {
            return new BigDecimal("18.90"); // SEDEX
        } else {
            return new BigDecimal("25.00"); // Frete especial
        }
    }
    
    /**
     * Classe para totais do carrinho
     */
    public static class CarrinhoTotais {
        private BigDecimal subtotal;
        private BigDecimal frete;
        private BigDecimal total;
        private int totalItens;
        
        public CarrinhoTotais() {
            this(BigDecimal.ZERO, BigDecimal.ZERO, BigDecimal.ZERO, 0);
        }
        
        public CarrinhoTotais(BigDecimal subtotal, BigDecimal frete, BigDecimal total, int totalItens) {
            this.subtotal = subtotal;
            this.frete = frete;
            this.total = total;
            this.totalItens = totalItens;
        }
        
        // Getters
        public BigDecimal getSubtotal() { return subtotal; }
        public BigDecimal getFrete() { return frete; }
        public BigDecimal getTotal() { return total; }
        public int getTotalItens() { return totalItens; }
        
        public boolean isEmpty() { return totalItens == 0; }
        
        public boolean temFreteGratis() { 
            return frete.compareTo(BigDecimal.ZERO) == 0 && !isEmpty(); 
        }
        
        public String getSubtotalFormatado() {
            return String.format("R$ %.2f", subtotal.doubleValue()).replace(".", ",");
        }
        
        public String getFreteFormatado() {
            if (temFreteGratis()) {
                return "Grátis";
            }
            return String.format("R$ %.2f", frete.doubleValue()).replace(".", ",");
        }
        
        public String getTotalFormatado() {
            return String.format("R$ %.2f", total.doubleValue()).replace(".", ",");
        }
    }
}