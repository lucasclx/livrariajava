package com.livraria.models;

import java.time.LocalDateTime;

/**
 * Modelo que representa uma Avaliação de livro
 */
public class Avaliacao {
    
    private Integer id;
    private Integer livroId;
    private Integer userId;
    private Integer rating;  // 1 a 5 estrelas
    private String titulo;
    private String comentario;
    private boolean aprovado;
    private boolean recomenda;
    private String vantagens;
    private String desvantagens;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Relacionamentos
    private Livro livro;
    private User user;
    
    // Construtores
    public Avaliacao() {
        this.aprovado = false;
        this.recomenda = true;
    }
    
    public Avaliacao(Integer livroId, Integer userId, Integer rating, String comentario) {
        this();
        this.livroId = livroId;
        this.userId = userId;
        this.rating = rating;
        this.comentario = comentario;
    }
    
    public Avaliacao(Integer livroId, Integer userId, Integer rating, String titulo, String comentario) {
        this(livroId, userId, rating, comentario);
        this.titulo = titulo;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public Integer getLivroId() { return livroId; }
    public void setLivroId(Integer livroId) { this.livroId = livroId; }
    
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { 
        if (rating != null && (rating < 1 || rating > 5)) {
            throw new IllegalArgumentException("Rating deve estar entre 1 e 5");
        }
        this.rating = rating; 
    }
    
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    
    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }
    
    public boolean isAprovado() { return aprovado; }
    public void setAprovado(boolean aprovado) { this.aprovado = aprovado; }
    
    public boolean isRecomenda() { return recomenda; }
    public void setRecomenda(boolean recomenda) { this.recomenda = recomenda; }
    
    public String getVantagens() { return vantagens; }
    public void setVantagens(String vantagens) { this.vantagens = vantagens; }
    
    public String getDesvantagens() { return desvantagens; }
    public void setDesvantagens(String desvantagens) { this.desvantagens = desvantagens; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public Livro getLivro() { return livro; }
    public void setLivro(Livro livro) { this.livro = livro; }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    // Métodos auxiliares
    public String getRatingStars() {
        if (rating == null) return "";
        
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("★");
            } else {
                stars.append("☆");
            }
        }
        return stars.toString();
    }
    
    public String getRatingStarsHtml() {
        if (rating == null) return "";
        
        StringBuilder stars = new StringBuilder();
        for (int i = 1; i <= 5; i++) {
            if (i <= rating) {
                stars.append("<i class='fas fa-star text-warning'></i>");
            } else {
                stars.append("<i class='far fa-star text-muted'></i>");
            }
        }
        return stars.toString();
    }
    
    public String getStatusTexto() {
        return aprovado ? "Aprovado" : "Pendente";
    }
    
    public String getStatusCor() {
        return aprovado ? "success" : "warning";
    }
    
    public boolean temComentario() {
        return comentario != null && !comentario.trim().isEmpty();
    }
    
    public boolean temTitulo() {
        return titulo != null && !titulo.trim().isEmpty();
    }
    
    public boolean temVantagens() {
        return vantagens != null && !vantagens.trim().isEmpty();
    }
    
    public boolean temDesvantagens() {
        return desvantagens != null && !desvantagens.trim().isEmpty();
    }
    
    public String getComentarioResumido(int maxLength) {
        if (!temComentario()) return "";
        
        if (comentario.length() <= maxLength) {
            return comentario;
        }
        return comentario.substring(0, maxLength) + "...";
    }
    
    public String getRatingText() {
        if (rating == null) return "Sem avaliação";
        
        switch (rating) {
            case 1: return "Péssimo";
            case 2: return "Ruim";
            case 3: return "Regular";
            case 4: return "Bom";
            case 5: return "Excelente";
            default: return "Indefinido";
        }
    }
    
    public String getRecomendaTexto() {
        return recomenda ? "Sim" : "Não";
    }
    
    public String getRecomendaIcon() {
        return recomenda ? "👍" : "👎";
    }
    
    public boolean isCompleta() {
        return rating != null && rating > 0 && temComentario();
    }
    
    public String getDataFormatada() {
        if (createdAt == null) return "";
        
        java.time.format.DateTimeFormatter formatter = 
            java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return createdAt.format(formatter);
    }
    
    public String getDataRelativa() {
        if (createdAt == null) return "";
        
        LocalDateTime now = LocalDateTime.now();
        java.time.Duration duration = java.time.Duration.between(createdAt, now);
        
        long days = duration.toDays();
        long hours = duration.toHours();
        long minutes = duration.toMinutes();
        
        if (days > 0) {
            return days + " dia" + (days > 1 ? "s" : "") + " atrás";
        } else if (hours > 0) {
            return hours + " hora" + (hours > 1 ? "s" : "") + " atrás";
        } else if (minutes > 0) {
            return minutes + " minuto" + (minutes > 1 ? "s" : "") + " atrás";
        } else {
            return "Agora mesmo";
        }
    }
    
    @Override
    public String toString() {
        return "Avaliacao{" +
                "id=" + id +
                ", livroId=" + livroId +
                ", userId=" + userId +
                ", rating=" + rating +
                ", aprovado=" + aprovado +
                ", recomenda=" + recomenda +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Avaliacao avaliacao = (Avaliacao) o;
        return id != null && id.equals(avaliacao.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}