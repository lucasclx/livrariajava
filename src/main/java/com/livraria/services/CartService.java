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
 * Serviço para gerenciar operações do carrinho de compras.
 */
public class CartService {
    
    private CartDAO cartDAO;
    private LivroDAO livroDAO;
    
    public CartService() {
        this.cartDAO = new CartDAO();
        this.livroDAO = new LivroDAO();
    }
    
    /**
     * Obtém o carrinho da sessão atual, ou cria um novo se não existir.
     */
    public Cart obterOuCriarCarrinho(HttpServletRequest request) throws SQLException {
        HttpSession session = request.getSession(true);
        Integer cartId = (Integer) session.getAttribute("cart_id");
        
        Cart cart = null;
        if (cartId != null) {
            cart = cartDAO.buscarPorId(cartId);
        }

        // Se o carrinho não existe ou já foi finalizado, cria um novo
        if (cart == null || !"active".equals(cart.getStatus())) {
            cart = new Cart();
            cart.setSessionId(session.getId());
            
            User user = (User) session.getAttribute("user");
            if (user != null) {
                cart.setUserId(user.getId());
            }
            
            cart = cartDAO.criar(cart);
            session.setAttribute("cart_id", cart.getId());
        }
        
        return cart;
    }
    
    /**
     * Adiciona um item ao carrinho, validando estoque e regras de negócio.
     */
    public void adicionarItem(HttpServletRequest request, int livroId, int quantidade) 
            throws SQLException, IllegalArgumentException {
        
        if (quantidade <= 0) {
            throw new IllegalArgumentException("A quantidade deve ser positiva.");
        }

        Livro livro = livroDAO.buscarPorId(livroId);
        if (livro == null || !livro.isAtivo()) {
            throw new IllegalArgumentException("Livro não encontrado ou indisponível.");
        }

        if (livro.getEstoque() < quantidade) {
            throw new IllegalArgumentException("Estoque insuficiente. Disponível: " + livro.getEstoque());
        }

        Cart cart = obterOuCriarCarrinho(request);
        CartItem itemExistente = cartDAO.buscarItemPorLivro(cart.getId(), livroId);

        if (itemExistente != null) {
            int novaQuantidade = itemExistente.getQuantity() + quantidade;
            if (novaQuantidade > livro.getEstoque()) {
                throw new IllegalArgumentException("A quantidade total no carrinho excede o estoque disponível.");
            }
            itemExistente.setQuantity(novaQuantidade);
            cartDAO.atualizarItem(itemExistente);
        } else {
            CartItem novoItem = new CartItem(cart, livro, quantidade);
            cartDAO.adicionarItem(novoItem);
        }
        
        atualizarContadorCarrinho(request);
    }

    /**
     * Atualiza o contador de itens do carrinho na sessão.
     */
    public void atualizarContadorCarrinho(HttpServletRequest request) {
        try {
            Cart cart = obterOuCriarCarrinho(request);
            int count = cartDAO.contarItensCarrinho(cart.getId());
            request.getSession().setAttribute("cart_count", count);
        } catch (SQLException e) {
            System.err.println("Erro ao atualizar contador do carrinho: " + e.getMessage());
        }
    }
    
    // ... outros métodos do serviço (remover, atualizar, etc.)
}