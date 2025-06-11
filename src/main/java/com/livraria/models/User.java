package com.livraria.models;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

/**
 * Modelo que representa um Usuário do sistema
 */
public class User {
    private Long id;
    private String name;
    private String email;
    private String password;
    private String telefone;
    private String cpf;
    private Boolean isAdmin;
    private Boolean ativo;
    private Timestamp emailVerifiedAt;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Relacionamentos
    private List<UserAddress> enderecos;
    private Cart cart;
    private List<Order> pedidos;
    private List<Livro> favoritos;
    
    // Construtores
    public User() {
        this.enderecos = new ArrayList<>();
        this.pedidos = new ArrayList<>();
        this.favoritos = new ArrayList<>();
        this.isAdmin = false;
        this.ativo = true;
    }
    
    public User(String name, String email, String password) {
        this();
        this.name = name;
        this.email = email;
        this.password = password;
    }
    
    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getTelefone() { return telefone; }
    public void setTelefone(String telefone) { this.telefone = telefone; }
    
    public String getCpf() { return cpf; }
    public void setCpf(String cpf) { this.cpf = cpf; }
    
    public Boolean getIsAdmin() { return isAdmin; }
    public void setIsAdmin(Boolean isAdmin) { this.isAdmin = isAdmin; }
    
    public Boolean getAtivo() { return ativo; }
    public void setAtivo(Boolean ativo) { this.ativo = ativo; }
    
    public Timestamp getEmailVerifiedAt() { return emailVerifiedAt; }
    public void setEmailVerifiedAt(Timestamp emailVerifiedAt) { this.emailVerifiedAt = emailVerifiedAt; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public List<UserAddress> getEnderecos() { return enderecos; }
    public void setEnderecos(List<UserAddress> enderecos) { this.enderecos = enderecos; }
    
    public Cart getCart() { return cart; }
    public void setCart(Cart cart) { this.cart = cart; }
    
    public List<Order> getPedidos() { return pedidos; }
    public void setPedidos(List<Order> pedidos) { this.pedidos = pedidos; }
    
    public List<Livro> getFavoritos() { return favoritos; }
    public void setFavoritos(List<Livro> favoritos) { this.favoritos = favoritos; }
    
    // Métodos auxiliares
    public boolean isEmailVerified() {
        return this.emailVerifiedAt != null;
    }
    
    public boolean isAdmin() {
        return this.isAdmin != null && this.isAdmin;
    }
    
    public boolean isAtivo() {
        return this.ativo != null && this.ativo;
    }
    
    public String getInitials() {
        if (this.name == null || this.name.trim().isEmpty()) {
            return "U";
        }
        
        String[] parts = this.name.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, 1).toUpperCase();
        } else {
            return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
        }
    }
    
    public String getFirstName() {
        if (this.name == null || this.name.trim().isEmpty()) {
            return "";
        }
        return this.name.split("\\s+")[0];
    }
    
    public String getStatusTexto() {
        return this.ativo ? "Ativo" : "Inativo";
    }
    
    public String getStatusCor() {
        return this.ativo ? "success" : "danger";
    }
    
    public String getTipoUsuario() {
        return isAdmin() ? "Administrador" : "Cliente";
    }
    
    public UserAddress getEnderecoPrincipal() {
        if (this.enderecos == null || this.enderecos.isEmpty()) {
            return null;
        }
        
        return this.enderecos.stream()
                            .filter(endereco -> endereco.getPrincipal() != null && endereco.getPrincipal())
                            .findFirst()
                            .orElse(this.enderecos.get(0));
    }
    
    public void adicionarEndereco(UserAddress endereco) {
        if (this.enderecos == null) {
            this.enderecos = new ArrayList<>();
        }
        endereco.setUser(this);
        this.enderecos.add(endereco);
    }
    
    public void adicionarFavorito(Livro livro) {
        if (this.favoritos == null) {
            this.favoritos = new ArrayList<>();
        }
        if (!this.favoritos.contains(livro)) {
            this.favoritos.add(livro);
        }
    }
    
    public void removerFavorito(Livro livro) {
        if (this.favoritos != null) {
            this.favoritos.remove(livro);
        }
    }
    
    public boolean isFavorito(Livro livro) {
        return this.favoritos != null && this.favoritos.contains(livro);
    }
    
    public boolean isFavorito(Long livroId) {
        if (this.favoritos == null || livroId == null) return false;
        return this.favoritos.stream()
                            .anyMatch(livro -> livroId.equals(livro.getId()));
    }
    
    public int getTotalPedidos() {
        return this.pedidos != null ? this.pedidos.size() : 0;
    }
    
    public int getTotalFavoritos() {
        return this.favoritos != null ? this.favoritos.size() : 0;
    }
    
    // Validações
    public boolean isEmailValido() {
        if (this.email == null || this.email.trim().isEmpty()) {
            return false;
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        return this.email.matches(emailRegex);
    }
    
    public boolean isCpfValido() {
        if (this.cpf == null || this.cpf.trim().isEmpty()) {
            return true; // CPF é opcional
        }
        
        String cpfLimpo = this.cpf.replaceAll("[^0-9]", "");
        return cpfLimpo.length() == 11;
    }
    
    // toString para debug
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", isAdmin=" + isAdmin +
                ", ativo=" + ativo +
                '}';
    }
    
    // equals e hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return id != null && id.equals(user.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}