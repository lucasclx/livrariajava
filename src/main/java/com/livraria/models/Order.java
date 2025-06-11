package com.livraria.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.HashMap;

/**
 * Modelo de Pedido
 */
public class Order {
    
    // Status do pedido
    public static final String STATUS_PENDING_PAYMENT = "pending_payment";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_PAYMENT_FAILED = "payment_failed";
    public static final String STATUS_PROCESSING = "processing";
    public static final String STATUS_SHIPPED = "shipped";
    public static final String STATUS_DELIVERED = "delivered";
    public static final String STATUS_CANCELLED = "cancelled";
    public static final String STATUS_REFUNDED = "refunded";
    
    private Integer id;
    private String orderNumber;
    private Integer cartId;
    private Integer userId;
    private Integer cupomId;
    private BigDecimal subtotal;
    private BigDecimal desconto;
    private BigDecimal shippingCost;
    private BigDecimal total;
    private String paymentMethod;
    private String status;
    private String notes;
    private String observacoes;
    private String trackingCode;
    private LocalDateTime shippedAt;
    private LocalDateTime deliveredAt;
    
    // Dados do endereço de entrega
    private String shippingRecipientName;
    private String shippingStreet;
    private String shippingNumber;
    private String shippingComplement;
    private String shippingNeighborhood;
    private String shippingCity;
    private String shippingState;
    private String shippingPostalCode;
    private String shippingReference;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Relacionamentos
    private Cart cart;
    private User user;
    private Cupom cupom;
    
    // Construtores
    public Order() {
        this.status = STATUS_PENDING_PAYMENT;
        this.desconto = BigDecimal.ZERO;
    }
    
    // Mapa de status
    public static Map<String, String> getStatusMap() {
        Map<String, String> statusMap = new HashMap<>();
        statusMap.put(STATUS_PENDING_PAYMENT, "Aguardando Pagamento");
        statusMap.put(STATUS_CONFIRMED, "Confirmado");
        statusMap.put(STATUS_PAYMENT_FAILED, "Falha no Pagamento");
        statusMap.put(STATUS_PROCESSING, "Processando");
        statusMap.put(STATUS_SHIPPED, "Enviado");
        statusMap.put(STATUS_DELIVERED, "Entregue");
        statusMap.put(STATUS_CANCELLED, "Cancelado");
        statusMap.put(STATUS_REFUNDED, "Estornado");
        return statusMap;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getOrderNumber() { return orderNumber; }
    public void setOrderNumber(String orderNumber) { this.orderNumber = orderNumber; }
    
    public Integer getCartId() { return cartId; }
    public void setCartId(Integer cartId) { this.cartId = cartId; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Integer getCupomId() { return cupomId; }
    public void setCupomId(Integer cupomId) { this.cupomId = cupomId; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public BigDecimal getDesconto() { return desconto; }
    public void setDesconto(BigDecimal desconto) { this.desconto = desconto; }
    
    public BigDecimal getShippingCost() { return shippingCost; }
    public void setShippingCost(BigDecimal shippingCost) { this.shippingCost = shippingCost; }
    
    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }
    
    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
    
    public String getObservacoes() { return observacoes; }
    public void setObservacoes(String observacoes) { this.observacoes = observacoes; }
    
    public String getTrackingCode() { return trackingCode; }
    public void setTrackingCode(String trackingCode) { this.trackingCode = trackingCode; }
    
    public LocalDateTime getShippedAt() { return shippedAt; }
    public void setShippedAt(LocalDateTime shippedAt) { this.shippedAt = shippedAt; }
    
    public LocalDateTime getDeliveredAt() { return deliveredAt; }
    public void setDeliveredAt(LocalDateTime deliveredAt) { this.deliveredAt = deliveredAt; }
    
    // Getters e Setters do endereço
    public String getShippingRecipientName() { return shippingRecipientName; }
    public void setShippingRecipientName(String shippingRecipientName) { this.shippingRecipientName = shippingRecipientName; }
    
    public String getShippingStreet() { return shippingStreet; }
    public void setShippingStreet(String shippingStreet) { this.shippingStreet = shippingStreet; }
    
    public String getShippingNumber() { return shippingNumber; }
    public void setShippingNumber(String shippingNumber) { this.shippingNumber = shippingNumber; }
    
    public String getShippingComplement() { return shippingComplement; }
    public void setShippingComplement(String shippingComplement) { this.shippingComplement = shippingComplement; }
    
    public String getShippingNeighborhood() { return shippingNeighborhood; }
    public void setShippingNeighborhood(String shippingNeighborhood) { this.shippingNeighborhood = shippingNeighborhood; }
    
    public String getShippingCity() { return shippingCity; }
    public void setShippingCity(String shippingCity) { this.shippingCity = shippingCity; }
    
    public String getShippingState() { return shippingState; }
    public void setShippingState(String shippingState) { this.shippingState = shippingState; }
    
    public String getShippingPostalCode() { return shippingPostalCode; }
    public void setShippingPostalCode(String shippingPostalCode) { this.shippingPostalCode = shippingPostalCode; }
    
    public String getShippingReference() { return shippingReference; }
    public void setShippingReference(String shippingReference) { this.shippingReference = shippingReference; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    // Relacionamentos
    public Cart getCart() { return cart; }
    public void setCart(Cart cart) { this.cart = cart; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public Cupom getCupom() { return cupom; }
    public void setCupom(Cupom cupom) { this.cupom = cupom; }
    
    // Métodos de negócio
    public String getStatusLabel() {
        return getStatusMap().getOrDefault(status, "Status Desconhecido");
    }
    
    public String getFormattedTotal() {
        return String.format("R$ %.2f", total.doubleValue()).replace(".", ",");
    }
    
    public String getFormattedShippingAddress() {
        StringBuilder address = new StringBuilder();
        
        if (shippingStreet != null) address.append(shippingStreet);
        if (shippingNumber != null) address.append(", ").append(shippingNumber);
        if (shippingNeighborhood != null) address.append(" - ").append(shippingNeighborhood);
        if (shippingCity != null) address.append(" - ").append(shippingCity);
        if (shippingState != null) address.append("/").append(shippingState);
        if (shippingPostalCode != null) address.append(" - CEP: ").append(shippingPostalCode);
        
        return address.toString();
    }
    
    public boolean canBeCancelled() {
        return STATUS_PENDING_PAYMENT.equals(status) || 
               STATUS_CONFIRMED.equals(status) || 
               STATUS_PROCESSING.equals(status);
    }
    
    public boolean canBeShipped() {
        return STATUS_CONFIRMED.equals(status) || STATUS_PROCESSING.equals(status);
    }
    
    public boolean canBeDelivered() {
        return STATUS_SHIPPED.equals(status);
    }
    
    public boolean isPaid() {
        return !STATUS_PENDING_PAYMENT.equals(status) && 
               !STATUS_PAYMENT_FAILED.equals(status) && 
               !STATUS_CANCELLED.equals(status);
    }
    
    public boolean isCompleted() {
        return STATUS_DELIVERED.equals(status);
    }
    
    public boolean isCancelled() {
        return STATUS_CANCELLED.equals(status);
    }
    
    // Métodos para validação de transição de status
    public boolean isValidStatusTransition(String newStatus) {
        switch (status) {
            case STATUS_PENDING_PAYMENT:
                return STATUS_CONFIRMED.equals(newStatus) || 
                       STATUS_PAYMENT_FAILED.equals(newStatus) || 
                       STATUS_CANCELLED.equals(newStatus);
            case STATUS_CONFIRMED:
                return STATUS_PROCESSING.equals(newStatus) || 
                       STATUS_CANCELLED.equals(newStatus);
            case STATUS_PROCESSING:
                return STATUS_SHIPPED.equals(newStatus) || 
                       STATUS_CANCELLED.equals(newStatus);
            case STATUS_SHIPPED:
                return STATUS_DELIVERED.equals(newStatus);
            case STATUS_PAYMENT_FAILED:
                return STATUS_PENDING_PAYMENT.equals(newStatus) || 
                       STATUS_CANCELLED.equals(newStatus);
            case STATUS_DELIVERED:
                return STATUS_REFUNDED.equals(newStatus);
            default:
                return false;
        }
    }
    
    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", orderNumber='" + orderNumber + '\'' +
                ", userId=" + userId +
                ", total=" + total +
                ", status='" + status + '\'' +
                ", paymentMethod='" + paymentMethod + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Order order = (Order) o;
        return id != null && id.equals(order.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}