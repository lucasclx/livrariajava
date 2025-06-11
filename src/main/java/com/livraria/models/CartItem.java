package com.livraria.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Modelo que representa um Item do Carrinho
 */
public class CartItem {
    
    private Integer id;
    private Integer cartId;
    private Integer livroId;
    private Integer quantity;
    private BigDecimal price;
    private boolean stockReserved;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Relacionamentos
    private Cart cart;
    private Livro livro;
    
    // Construtores
    public CartItem() {
        this.stockReserved = false;
        this.quantity = 1;
    }
    
    public CartItem(Integer cartId, Integer livroId, Integer quantity, BigDecimal price) {
        this();
        this.cartId = cartId;
        this.livroId = livroId;
        this.quantity = quantity;
        this.price = price;
    }
    
    public CartItem(Cart cart, Livro livro, Integer quantity) {
        this();
        this.cart = cart;
        this.cartId = cart != null ? cart.getId() : null;
        this.livro = livro;
        this.livroId = livro != null ? livro.getId() : null;
        this.quantity = quantity;
        this.price = livro != null ? livro.getPrecoFinal() : BigDecimal.ZERO;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getCartId() { return cartId; }
    public void setCartId(Integer cartId) { this.cartId = cartId; }
    
    public Integer getLivroId() { return livroId; }
    public void setLivroId(Integer livroId) { this.livroId = livroId; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { 
        if (quantity != null && quantity < 1) {
            throw new IllegalArgumentException("Quantidade deve ser maior que zero");
        }
        this.quantity = quantity; 
    }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public boolean isStockReserved() { return stockReserved; }
    public void setStockReserved(boolean stockReserved) { this.stockReserved = stockReserved; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public Cart getCart() { return cart; }
    public void setCart(Cart cart) { 
        this.cart = cart;
        this.cartId = cart != null ? cart.getId() : null;
    }
    
    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { 
        this.livro = livro;
        this.livroId = livro != null ? livro.getId() : null;
        if (livro != null && this.price == null) {
            this.price = livro.getPrecoFinal();
        }
    }
    
    // Métodos de negócio
    public BigDecimal getSubtotal() {
        if (price == null || quantity == null) {
            return BigDecimal.ZERO;
        }
        return price.multiply(new BigDecimal(quantity));
    }
    
    public String getSubtotalFormatado() {
        return formatarMoeda(getSubtotal());
    }
    
    public String getPriceFormatado() {
        return formatarMoeda(price != null ? price