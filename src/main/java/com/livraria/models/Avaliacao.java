package com.livraria.models;

import java.sql.Timestamp;
import java.util.List;
import java.util.ArrayList;

/**
 * Modelo que representa uma Categoria de livros
 */
public class Categoria {
    private Long id;
    private String nome;
    private String descricao;
    private String imagem;
    private String slug;
    private Boolean ativo;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Relacionamentos
    private List<Livro> livros;
    private Integer livrosCount;
    
    // Construtores
    public Categoria() {
        this.livros = new ArrayList<>();
        this.ativo = true;
    }
    
    public Categoria(String nome) {
        this();
        this.nome = nome;
        this.slug = gerarSlug(nome);
    }
    
    public Categoria(String nome, String descricao) {
        this(nome);
        this.descricao = descricao;
    }
    
    // Getters e Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { 
        this.nome = nome;
        this.slug = gerarSlug(nome);
    }
    
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public String getImagem() { return imagem; }
    public void setImagem(String imagem) { this.imagem = imagem; }
    
    public String getSlug() { return slug; }
    public void setSlug(String slug) { this.slug = slug; }
    
    public Boolean getAtivo() { return ativo; }
    public void setAtivo(Boolean ativo) { this.ativo = ativo; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public List<Livro> getLivros() { return livros; }
    public void setLivros(List<Livro> livros) { 
        this.livros = livros;
        this.livrosCount = livros != null ? livros.size() : 0;
    }
    
    public Integer getLivrosCount() { 
        if (livrosCount != null) return livrosCount;
        return livros != null ? livros.size() : 0;
    }
    public void setLivrosCount(Integer livrosCount) { this.livrosCount = livrosCount; }
    
    // Métodos auxiliares
    public String getImagemUrl() {
        if (this.imagem != null && !this.imagem.isEmpty()) {
            return "/livraria/images/categorias/" + this.imagem;
        }
        return "/livraria/assets/images/no-category.png";
    }
    
    public String getStatusTexto() {
        return this.ativo ? "Ativa" : "Inativa";
    }
    
    public String getStatusCor() {
        return this.ativo ? "success" : "danger";
    }
    
    private String gerarSlug(String texto) {
        if (texto == null || texto.trim().isEmpty()) {
            return "";
        }
        
        return texto.toLowerCase()
                   .trim()
                   .replaceAll("[àáâãäå]", "a")
                   .replaceAll("[èéêë]", "e")
                   .replaceAll("[ìíîï]", "i")
                   .replaceAll("[òóôõö]", "o")
                   .replaceAll("[ùúûü]", "u")
                   .replaceAll("[ç]", "c")
                   .replaceAll("[ñ]", "n")
                   .replaceAll("[^a-z0-9]", "-")
                   .replaceAll("-+", "-")
                   .replaceAll("^-|-$", "");
    }
    
    public void adicionarLivro(Livro livro) {
        if (this.livros == null) {
            this.livros = new ArrayList<>();
        }
        this.livros.add(livro);
        livro.setCategoria(this);
        this.livrosCount = this.livros.size();
    }
    
    public void removerLivro(Livro livro) {
        if (this.livros != null) {
            this.livros.remove(livro);
            this.livrosCount = this.livros.size();
        }
    }
    
    public int getTotalLivros() {
        return getLivrosCount();
    }
    
    public int getLivrosAtivos() {
        if (this.livros == null) return 0;
        return (int) this.livros.stream()
                                .filter(livro -> livro.getAtivo() != null && livro.getAtivo())
                                .count();
    }
    
    public int getLivrosEmEstoque() {
        if (this.livros == null) return 0;
        return (int) this.livros.stream()
                                .filter(livro -> livro.getAtivo() != null && livro.getAtivo())
                                .filter(livro -> livro.getEstoque() != null && livro.getEstoque() > 0)
                                .count();
    }
    
    // toString para debug
    @Override
    public String toString() {
        return "Categoria{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", slug='" + slug + '\'' +
                ", ativo=" + ativo +
                ", livrosCount=" + getLivrosCount() +
                '}';
    }
    
    // equals e hashCode
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