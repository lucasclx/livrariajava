package com.livraria.models;

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
    }
    
    public CartItem(Integer cartId, Integer livroId, Integer quantity, BigDecimal price) {
        this();
        this.cartId = cartId;
        this.livroId = livroId;
        this.quantity = quantity;
        this.price = price;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getCartId() { return cartId; }
    public void setCartId(Integer cartId) { this.cartId = cartId; }
    
    public Integer getLivroId() { return livroId; }
    public void setLivroId(Integer livroId) { this.livroId = livroId; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    
    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }
    
    public boolean isStockReserved() { return stockReserved; }
    public void setStockReserved(boolean stockReserved) { this.stockReserved = stockReserved; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public Cart getCart() { return cart; }
    public void setCart(Cart cart) { this.cart = cart; }
    
    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { this.livro = livro; }
    
    // Métodos de negócio
    public BigDecimal getSubtotal() {
        return price.multiply(new BigDecimal(quantity));
    }
    
    public String getSubtotalFormatado() {
        return String.format("R$ %.2f", getSubtotal().doubleValue()).replace(".", ",");
    }
    
    public boolean isAvailable() {
        return livro != null && livro.isAtivo() && livro.getEstoque() >= quantity;
    }
    
    @Override
    public String toString() {
        return "CartItem{" +
                "id=" + id +
                ", cartId=" + cartId +
                ", livroId=" + livroId +
                ", quantity=" + quantity +
                ", price=" + price +
                ", subtotal=" + getSubtotal() +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        CartItem cartItem = (CartItem) o;
        return id != null && id.equals(cartItem.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}