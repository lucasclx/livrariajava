package com.livraria.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.livraria.dao.CartDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.models.Cart;
import com.livraria.models.CartItem;
import com.livraria.models.Livro;
import com.livraria.models.User;

@WebServlet("/cart/*")
public class CartController extends BaseController {
    
    private CartDAO cartDAO;
    private LivroDAO livroDAO;
    
    @Override
    public void init() throws ServletException {
        cartDAO = new CartDAO();
        livroDAO = new LivroDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
            mostrarCarrinho(request, response);
        } else if (pathInfo.equals("/count")) {
            obterContadorCarrinho(request, response);
        } else if (pathInfo.equals("/checkout")) {
            mostrarCheckout(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/add/")) {
            String idStr = pathInfo.substring("/add/".length());
            adicionarAoCarrinho(request, response, Integer.parseInt(idStr));
        } else if (pathInfo != null && pathInfo.startsWith("/update/")) {
            String idStr = pathInfo.substring("/update/".length());
            atualizarQuantidade(request, response, Integer.parseInt(idStr));
        } else if (pathInfo != null && pathInfo.equals("/clear")) {
            limparCarrinho(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        if (pathInfo != null && pathInfo.startsWith("/remove/")) {
            String idStr = pathInfo.substring("/remove/".length());
            removerDoCarrinho(request, response, Integer.parseInt(idStr));
        }
    }
    
    private void mostrarCarrinho(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Cart cart = obterOuCriarCarrinho(request);
            List<CartItem> items = cartDAO.listarItensDoCarrinho(cart.getId());
            
            // Calcular totais
            BigDecimal subtotal = BigDecimal.ZERO;
            int totalItens = 0;
            
            for (CartItem item : items) {
                BigDecimal itemTotal = item.getPrice().multiply(new BigDecimal(item.getQuantity()));
                subtotal = subtotal.add(itemTotal);
                totalItens += item.getQuantity();
            }
            
            // Buscar sugestões baseadas no carrinho
            List<Livro> sugestoes = livroDAO.buscarSugestoesPorCarrinho(items, 4);
            
            request.setAttribute("items", items);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("totalItens", totalItens);
            request.setAttribute("sugestoes", sugestoes);
            
            request.getRequestDispatcher("/cart/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar carrinho", e);
        }
    }
    
    private void adicionarAoCarrinho(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException {
        
        try {
            // Buscar livro
            Livro livro = livroDAO.buscarPorId(livroId);
            if (livro == null || !livro.isAtivo()) {
                sendJsonError(response, "Livro não encontrado ou não disponível");
                return;
            }
            
            int quantidade = getIntParameter(request, "quantity", 1);
            quantidade = Math.max(1, Math.min(quantidade, 10)); // Entre 1 e 10
            
            // Verificar estoque
            if (livro.getEstoque() < quantidade) {
                sendJsonError(response, "Quantidade solicitada não disponível em estoque");
                return;
            }
            
            Cart cart = obterOuCriarCarrinho(request);
            
            // Verificar se o item já existe no carrinho
            CartItem itemExistente = cartDAO.buscarItemPorLivro(cart.getId(), livroId);
            
            if (itemExistente != null) {
                // Verificar se a nova quantidade não excede o estoque
                int novaQuantidade = itemExistente.getQuantity() + quantidade;
                if (novaQuantidade > livro.getEstoque()) {
                    sendJsonError(response, "Quantidade total excede o estoque disponível");
                    return;
                }
                
                // Atualizar quantidade
                itemExistente.setQuantity(novaQuantidade);
                cartDAO.atualizarItem(itemExistente);
            } else {
                // Criar novo item
                CartItem novoItem = new CartItem();
                novoItem.setCartId(cart.getId());
                novoItem.setLivroId(livroId);
                novoItem.setQuantity(quantidade);
                novoItem.setPrice(livro.getPrecoFinal());
                
                cartDAO.adicionarItem(novoItem);
            }
            
            // Atualizar contador na sessão
            atualizarContadorCarrinho(request);
            
            sendJsonSuccess(response, "Livro adicionado ao carrinho!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao adicionar ao carrinho: " + e.getMessage());
        }
    }
    
    private void atualizarQuantidade(HttpServletRequest request, HttpServletResponse response, int itemId)
            throws ServletException, IOException {
        
        try {
            CartItem item = cartDAO.buscarItemPorId(itemId);
            if (item == null) {
                sendJsonError(response, "Item não encontrado no carrinho");
                return;
            }
            
            // Verificar se o item pertence ao carrinho da sessão
            Cart cart = obterCarrinho(request);
            if (cart == null || !cart.getId().equals(item.getCartId())) {
                sendJsonError(response, "Item não encontrado no seu carrinho");
                return;
            }
            
            int novaQuantidade = getIntParameter(request, "quantity", 1);
            novaQuantidade = Math.max(1, Math.min(novaQuantidade, 10));
            
            // Verificar estoque
            Livro livro = livroDAO.buscarPorId(item.getLivroId());
            if (livro.getEstoque() < novaQuantidade) {
                sendJsonError(response, "Quantidade solicitada não disponível em estoque");
                return;
            }
            
            // Atualizar
            item.setQuantity(novaQuantidade);
            cartDAO.atualizarItem(item);
            
            // Atualizar contador na sessão
            atualizarContadorCarrinho(request);
            
            sendJsonSuccess(response, "Quantidade atualizada!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao atualizar quantidade: " + e.getMessage());
        }
    }
    
    private void removerDoCarrinho(HttpServletRequest request, HttpServletResponse response, int itemId)
            throws ServletException, IOException {
        
        try {
            CartItem item = cartDAO.buscarItemPorId(itemId);
            if (item == null) {
                sendJsonError(response, "Item não encontrado no carrinho");
                return;
            }
            
            // Verificar se o item pertence ao carrinho da sessão
            Cart cart = obterCarrinho(request);
            if (cart == null || !cart.getId().equals(item.getCartId())) {
                sendJsonError(response, "Item não encontrado no seu carrinho");
                return;
            }
            
            // Remover
            cartDAO.removerItem(itemId);
            
            // Atualizar contador na sessão
            atualizarContadorCarrinho(request);
            
            sendJsonSuccess(response, "Item removido do carrinho!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao remover item: " + e.getMessage());
        }
    }
    
    private void limparCarrinho(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Cart cart = obterCarrinho(request);
            if (cart != null) {
                cartDAO.limparCarrinho(cart.getId());
                
                // Atualizar contador na sessão
                atualizarContadorCarrinho(request);
            }
            
            sendJsonSuccess(response, "Carrinho limpo!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao limpar carrinho: " + e.getMessage());
        }
    }
    
    private void mostrarCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar autenticação
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=" + 
                java.net.URLEncoder.encode(request.getRequestURI(), "UTF-8"));
            return;
        }
        
        try {
            Cart cart = obterCarrinho(request);
            if (cart == null) {
                redirectWithError(response, request.getContextPath() + "/cart", 
                    "Seu carrinho está vazio");
                return;
            }
            
            List<CartItem> items = cartDAO.listarItensDoCarrinho(cart.getId());
            if (items.isEmpty()) {
                redirectWithError(response, request.getContextPath() + "/cart", 
                    "Seu carrinho está vazio");
                return;
            }
            
            // Validar estoque de todos os itens
            List<String> errosEstoque = cartDAO.validarEstoqueCarrinho(cart.getId());
            if (!errosEstoque.isEmpty()) {
                String mensagem = "Alguns itens não estão mais disponíveis: " + 
                    String.join(", ", errosEstoque);
                redirectWithError(response, request.getContextPath() + "/cart", mensagem);
                return;
            }
            
            // Calcular totais
            BigDecimal subtotal = cartDAO.calcularTotalCarrinho(cart.getId());
            BigDecimal frete = calcularFrete(items);
            BigDecimal total = subtotal.add(frete);
            
            request.setAttribute("items", items);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("frete", frete);
            request.setAttribute("total", total);
            
            request.getRequestDispatcher("/cart/checkout.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar checkout", e);
        }
    }
    
    private void obterContadorCarrinho(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Cart cart = obterCarrinho(request);
            int count = 0;
            
            if (cart != null) {
                count = cartDAO.contarItensCarrinho(cart.getId());
            }
            
            sendJsonSuccess(response, count);
            
        } catch (Exception e) {
        	sendJsonError(response, "Erro ao obter contador do carrinho", 500);
        }
    }
    
    private Cart obterCarrinho(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        Integer cartId = (Integer) session.getAttribute("cart_id");
        if (cartId == null) return null;
        
        try {
            return cartDAO.buscarPorId(cartId);
        } catch (Exception e) {
            return null;
        }
    }
    
    private Cart obterOuCriarCarrinho(HttpServletRequest request) {
        Cart cart = obterCarrinho(request);
        
        if (cart != null) {
            return cart;
        }
        
        // Criar novo carrinho
        try {
            HttpSession session = request.getSession(true);
            
            cart = new Cart();
            cart.setSessionId(session.getId());
            cart.setStatus("active");
            
            User user = getAuthenticatedUser(request);
            if (user != null) {
                cart.setUserId(user.getId());
            }
            
            cart = cartDAO.criar(cart);
            session.setAttribute("cart_id", cart.getId());
            
            return cart;
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao criar carrinho", e);
        }
    }
    
    private void atualizarContadorCarrinho(HttpServletRequest request) {
        try {
            Cart cart = obterCarrinho(request);
            if (cart != null) {
                int count = cartDAO.contarItensCarrinho(cart.getId());
                request.getSession().setAttribute("cart_count", count);
            }
        } catch (Exception e) {
            // Log do erro, mas não interrompe o fluxo
        }
    }
    
    private BigDecimal calcularFrete(List<CartItem> items) {
        // Lógica simplificada de cálculo de frete
        double pesoTotal = 0.0;
        
        for (CartItem item : items) {
            try {
                Livro livro = livroDAO.buscarPorId(item.getLivroId());
                double peso = livro.getPeso() != null ? livro.getPeso() : 0.5;
                pesoTotal += peso * item.getQuantity();
            } catch (Exception e) {
                pesoTotal += 0.5 * item.getQuantity(); // peso padrão
            }
        }
        
        if (pesoTotal <= 1.0) {
            return new BigDecimal("12.50"); // PAC
        } else if (pesoTotal <= 3.0) {
            return new BigDecimal("18.90"); // SEDEX
        } else {
            return new BigDecimal("25.00"); // Frete especial
        }
    }
}