package com.livraria.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Modelo de Carrinho
 */
public class Cart {
    
    private Integer id;
    private String sessionId;
    private Integer userId;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Relacionamentos
    private User user;
    private List<CartItem> items;
    
    // Construtores
    public Cart() {
        this.status = "active";
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public List<CartItem> getItems() { return items; }
    public void setItems(List<CartItem> items) { this.items = items; }
    
    // Métodos de negócio
    public BigDecimal getTotal() {
        if (items == null || items.isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        return items.stream()
                   .map(item -> item.getPrice().multiply(new BigDecimal(item.getQuantity())))
                   .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    
    public int getTotalItems() {
        if (items == null || items.isEmpty()) {
            return 0;
        }
        
        return items.stream()
                   .mapToInt(CartItem::getQuantity)
                   .sum();
    }
    
    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
    
    public boolean isActive() {
        return "active".equals(status);
    }
    
    @Override
    public String toString() {
        return "Cart{" +
                "id=" + id +
                ", sessionId='" + sessionId + '\'' +
                ", userId=" + userId +
                ", status='" + status + '\'' +
                ", itemCount=" + (items != null ? items.size() : 0) +
                '}';
    }
}