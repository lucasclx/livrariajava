package com.livraria.models;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Modelo de Categoria
 */
public class Categoria {
    
    private Integer id;
    private String nome;
    private String descricao;
    private String slug;
    private String imagem;
    private boolean ativo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Relacionamento com livros
    private List<Livro> livros;
    private Integer livrosCount;
    
    // Construtores
    public Categoria() {
        this.ativo = true;
    }
    
    public Categoria(String nome, String descricao) {
        this();
        this.nome = nome;
        this.descricao = descricao;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    
    public String getImagem() { return imagem; }
    public void setImagem(String imagem) { this.imagem = imagem; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public List<Livro> getLivros() { return livros; }
    public void setLivros(List<Livro> livros) { this.livros = livros; }
    
    public Integer getLivrosCount() { return livrosCount; }
    public void setLivrosCount(Integer livrosCount) { this.livrosCount = livrosCount; }
    
    // Métodos auxiliares
    public String getImagemUrl() {
        if (imagem != null && !imagem.trim().isEmpty()) {
            return "/livraria/uploads/categorias/" + imagem;
        }
        return "/livraria/assets/images/placeholder-category.jpg";
    }
    
    public String getDescricaoResumida(int maxLength) {
        if (descricao == null || descricao.length() <= maxLength) {
            return descricao;
        }
        return descricao.substring(0, maxLength) + "...";
    }
    
    public boolean temLivros() {
        return livrosCount != null && livrosCount > 0;
    }
    
    @Override
    public String toString() {
        return "Categoria{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", slug='" + slug + '\'' +
                ", ativo=" + ativo +
                ", livrosCount=" + livrosCount +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Categoria categoria = (Categoria) o;
        return id != null && id.equals(categoria.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}