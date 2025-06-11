package com.livraria.models;

import java.time.LocalDateTime;

/**
 * Modelo que representa um Endereço do Usuário
 */
public class UserAddress {
    
    private Integer id;
    private Integer userId;
    private String label;
    private String recipientName;
    private String street;
    private String number;
    private String complement;
    private String neighborhood;
    private String city;
    private String state;
    private String postalCode;
    private String reference;
    private boolean isDefault;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Relacionamento
    private User user;
    
    // Construtores
    public UserAddress() {
        this.isDefault = false;
    }
    
    public UserAddress(String street, String number, String neighborhood, String city, String state, String postalCode) {
        this();
        this.street = street;
        this.number = number;
        this.neighborhood = neighborhood;
        this.city = city;
        this.state = state;
        this.postalCode = postalCode;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public String getLabel() { return label; }
    public void setLabel(String label) { this.label = label; }
    
    public String getRecipientName() { return recipientName; }
    public void setRecipientName(String recipientName) { this.recipientName = recipientName; }
    
    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }
    
    public String getNumber() { return number; }
    public void setNumber(String number) { this.number = number; }
    
    public String getComplement() { return complement; }
    public void setComplement(String complement) { this.complement = complement; }
    
    public String getNeighborhood() { return neighborhood; }
    public void setNeighborhood(String neighborhood) { this.neighborhood = neighborhood; }
    
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    
    public String getState() { return state; }
    public void setState(String state) { this.state = state; }
    
    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }
    
    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }
    
    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    // Métodos auxiliares
    public String getFullAddress() {
        StringBuilder address = new StringBuilder();
        
        if (street != null) address.append(street);
        if (number != null) address.append(", ").append(number);
        if (complement != null && !complement.trim().isEmpty()) {
            address.append(" - ").append(complement);
        }
        if (neighborhood != null) address.append(" - ").append(neighborhood);
        if (city != null) address.append(" - ").append(city);
        if (state != null) address.append("/").append(state);
        if (postalCode != null) address.append(" - CEP: ").append(getFormattedPostalCode());
        
        return address.toString();
    }
    
    public String getFormattedPostalCode() {
        if (postalCode == null || postalCode.length() != 8) {
            return postalCode;
        }
        return postalCode.substring(0, 5) + "-" + postalCode.substring(5);
    }
    
    public String getShortAddress() {
        StringBuilder address = new StringBuilder();
        
        if (street != null) {
            address.append(street);
            if (street.length() > 30) {
                address.setLength(30);
                address.append("...");
            }
        }
        if (number != null) address.append(", ").append(number);
        if (neighborhood != null) address.append(" - ").append(neighborhood);
        
        return address.toString();
    }
    
    public String getCityState() {
        StringBuilder cityState = new StringBuilder();
        if (city != null) cityState.append(city);
        if (state != null) {
            if (cityState.length() > 0) cityState.append("/");
            cityState.append(state);
        }
        return cityState.toString();
    }
    
    public boolean isComplete() {
        return street != null && !street.trim().isEmpty() &&
               number != null && !number.trim().isEmpty() &&
               neighborhood != null && !neighborhood.trim().isEmpty() &&
               city != null && !city.trim().isEmpty() &&
               state != null && !state.trim().isEmpty() &&
               postalCode != null && !postalCode.trim().isEmpty();
    }
    
    public String getDisplayLabel() {
        if (label != null && !label.trim().isEmpty()) {
            return label;
        }
        if (isDefault) {
            return "Endereço Principal";
        }
        return "Endereço";
    }
    
    @Override
    public String toString() {
        return "UserAddress{" +
                "id=" + id +
                ", street='" + street + '\'' +
                ", number='" + number + '\'' +
                ", city='" + city + '\'' +
                ", state='" + state + '\'' +
                ", postalCode='" + postalCode + '\'' +
                ", isDefault=" + isDefault +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        UserAddress that = (UserAddress) o;
        return id != null && id.equals(that.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}