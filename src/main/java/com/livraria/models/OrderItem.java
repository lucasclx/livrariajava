package com.livraria.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Modelo que representa um Item do Pedido
 */
public class OrderItem {
    
    private Integer id;
    private Integer orderId;
    private Integer livroId;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal totalPrice;
    private LocalDateTime createdAt;
    
    // Relacionamentos
    private Order order;
    private Livro livro;
    
    // Construtores
    public OrderItem() {
    }
    
    public OrderItem(Integer orderId, Integer livroId, Integer quantity, BigDecimal unitPrice) {
        this.orderId = orderId;
        this.livroId = livroId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = unitPrice.multiply(new BigDecimal(quantity));
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }
    
    public Integer getLivroId() { return livroId; }
    public void setLivroId(Integer livroId) { this.livroId = livroId; }
    
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { 
        this.quantity = quantity;
        if (this.unitPrice != null) {
            this.totalPrice = this.unitPrice.multiply(new BigDecimal(quantity));
        }
    }
    
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { 
        this.unitPrice = unitPrice;
        if (this.quantity != null) {
            this.totalPrice = unitPrice.multiply(new BigDecimal(quantity));
        }
    }
    
    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }
    
    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { this.livro = livro; }
    
    // Métodos auxiliares
    public String getFormattedUnitPrice() {
        return String.format("R$ %.2f", unitPrice.doubleValue()).replace(".", ",");
    }
    
    public String getFormattedTotalPrice() {
        return String.format("R$ %.2f", totalPrice.doubleValue()).replace(".", ",");
    }
    
    @Override
    public String toString() {
        return "OrderItem{" +
                "id=" + id +
                ", orderId=" + orderId +
                ", livroId=" + livroId +
                ", quantity=" + quantity +
                ", unitPrice=" + unitPrice +
                ", totalPrice=" + totalPrice +
                '}';
    }
}