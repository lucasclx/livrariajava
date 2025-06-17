// livrariajava/src/main/java/com/livraria/models/Livro.java

package com.livraria.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Modelo de Livro
 */
public class Livro {
    
    private Integer id;
    private String titulo;
    private String autor;
    private String isbn;
    private String editora;
    private Integer anoPublicacao;
    private BigDecimal preco;
    private BigDecimal precoPromocional;
    private Integer paginas;
    private String sinopse;
    private String sumario;
    private Integer categoriaId;
    private Integer estoque;
    private Integer estoqueMinimo;
    private Double peso;
    private String dimensoes;
    private String idioma;
    private String edicao;
    private String encadernacao;
    private String imagem;
    private String galeriaImagens;
    private boolean ativo;
    private boolean destaque;
    private Integer vendasTotal;
    private BigDecimal avaliacaoMedia;
    private Integer totalAvaliacoes;
    private LocalDateTime promocaoInicio;
    private LocalDateTime promocaoFim;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Categoria (relacionamento)
    private Categoria categoria;
    
    // Construtores
    public Livro() {
        this.ativo = true;
        this.destaque = false;
        this.vendasTotal = 0;
        this.avaliacaoMedia = BigDecimal.ZERO;
        this.totalAvaliacoes = 0;
        this.estoqueMinimo = 5;
        this.peso = 0.5;
        this.idioma = "Português";
    }
    
    // Getters e Setters ... (todos os getters e setters existentes)
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    
    public String getAutor() { return autor; }
    public void setAutor(String autor) { this.autor = autor; }
    
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    
    public String getEditora() { return editora; }
    public void setEditora(String editora) { this.editora = editora; }
    
    public Integer getAnoPublicacao() { return anoPublicacao; }
    public void setAnoPublicacao(Integer anoPublicacao) { this.anoPublicacao = anoPublicacao; }
    
    public BigDecimal getPreco() { return preco; }
    public void setPreco(BigDecimal preco) { this.preco = preco; }
    
    public BigDecimal getPrecoPromocional() { return precoPromocional; }
    public void setPrecoPromocional(BigDecimal precoPromocional) { this.precoPromocional = precoPromocional; }
    
    public Integer getPaginas() { return paginas; }
    public void setPaginas(Integer paginas) { this.paginas = paginas; }
    
    public String getSinopse() { return sinopse; }
    public void setSinopse(String sinopse) { this.sinopse = sinopse; }
    
    public String getSumario() { return sumario; }
    public void setSumario(String sumario) { this.sumario = sumario; }
    
    public Integer getCategoriaId() { return categoriaId; }
    public void setCategoriaId(Integer categoriaId) { this.categoriaId = categoriaId; }
    
    public Integer getEstoque() { return estoque; }
    public void setEstoque(Integer estoque) { this.estoque = estoque; }
    
    public Integer getEstoqueMinimo() { return estoqueMinimo; }
    public void setEstoqueMinimo(Integer estoqueMinimo) { this.estoqueMinimo = estoqueMinimo; }
    
    public Double getPeso() { return peso; }
    public void setPeso(Double peso) { this.peso = peso; }
    
    public String getDimensoes() { return dimensoes; }
    public void setDimensoes(String dimensoes) { this.dimensoes = dimensoes; }
    
    public String getIdioma() { return idioma; }
    public void setIdioma(String idioma) { this.idioma = idioma; }
    
    public String getEdicao() { return edicao; }
    public void setEdicao(String edicao) { this.edicao = edicao; }
    
    public String getEncadernacao() { return encadernacao; }
    public void setEncadernacao(String encadernacao) { this.encadernacao = encadernacao; }
    
    public String getImagem() { return imagem; }
    public void setImagem(String imagem) { this.imagem = imagem; }
    
    public String getGaleriaImagens() { return galeriaImagens; }
    public void setGaleriaImagens(String galeriaImagens) { this.galeriaImagens = galeriaImagens; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
    
    public boolean isDestaque() { return destaque; }
    public void setDestaque(boolean destaque) { this.destaque = destaque; }
    
    public Integer getVendasTotal() { return vendasTotal; }
    public void setVendasTotal(Integer vendasTotal) { this.vendasTotal = vendasTotal; }
    
    public BigDecimal getAvaliacaoMedia() { return avaliacaoMedia; }
    public void setAvaliacaoMedia(BigDecimal avaliacaoMedia) { this.avaliacaoMedia = avaliacaoMedia; }
    
    public Integer getTotalAvaliacoes() { return totalAvaliacoes; }
    public void setTotalAvaliacoes(Integer totalAvaliacoes) { this.totalAvaliacoes = totalAvaliacoes; }
    
    public LocalDateTime getPromocaoInicio() { return promocaoInicio; }
    public void setPromocaoInicio(LocalDateTime promocaoInicio) { this.promocaoInicio = promocaoInicio; }
    
    public LocalDateTime getPromocaoFim() { return promocaoFim; }
    public void setPromocaoFim(LocalDateTime promocaoFim) { this.promocaoFim = promocaoFim; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    public Categoria getCategoria() { return categoria; }
    public void setCategoria(Categoria categoria) { this.categoria = categoria; }

    // --- INÍCIO DAS MODIFICAÇÕES ---
    
    // Métodos de negócio
    public BigDecimal getPrecoFinal() {
        if (isTemPromocao()) {
            return precoPromocional;
        }
        return preco;
    }
    
    public String getPrecoFormatado() {
        return String.format("R$ %.2f", getPrecoFinal().doubleValue()).replace(".", ",");
    }
    
    public boolean isTemPromocao() {
        if (precoPromocional == null || preco == null) return false;
        if (precoPromocional.compareTo(preco) >= 0) return false;
        
        LocalDateTime now = LocalDateTime.now();
        if (promocaoInicio != null && now.isBefore(promocaoInicio)) return false;
        if (promocaoFim != null && now.isAfter(promocaoFim)) return false;
        
        return true;
    }
    
    public int getDesconto() {
        if (!isTemPromocao()) return 0;
        
        BigDecimal diferenca = preco.subtract(precoPromocional);
        BigDecimal percentual = diferenca.divide(preco, 4, BigDecimal.ROUND_HALF_UP)
                                        .multiply(new BigDecimal(100));
        
        return percentual.intValue();
    }
    
    public String getImagemUrl() {
        if (imagem != null && !imagem.trim().isEmpty()) {
            return "/livraria/uploads/livros/" + imagem;
        }
        return getPlaceholderImage();
    }
    
    public StatusEstoque getStatusEstoque() {
        if (estoque == null || estoque == 0) {
            return new StatusEstoque("sem_estoque", "danger", "Esgotado");
        } else if (estoqueMinimo != null && estoque <= estoqueMinimo) {
            return new StatusEstoque("estoque_baixo", "warning", "Últimas unidades");
        } else {
            return new StatusEstoque("disponivel", "success", "Disponível");
        }
    }
    
    public boolean isEstoqueBaixo() {
        return estoqueMinimo != null && estoque != null && estoque <= estoqueMinimo && estoque > 0;
    }
    
    public boolean isEmEstoque() {
        return estoque != null && estoque > 0;
    }
    
    private String getPlaceholderImage() {
        return "/livraria/assets/images/placeholder-book.jpg";
    }
    
    // Classes auxiliares
    public static class StatusEstoque {
        private String status;
        private String cor;
        private String texto;
        
        public StatusEstoque(String status, String cor, String texto) {
            this.status = status;
            this.cor = cor;
            this.texto = texto;
        }
        
        // Getters
        public String getStatus() { return status; }
        public String getCor() { return cor; }
        public String getTexto() { return texto; }
    }
    
    // --- FIM DAS MODIFICAÇÕES ---
    
    @Override
    public String toString() {
        return "Livro{" +
                "id=" + id +
                ", titulo='" + titulo + '\'' +
                ", autor='" + autor + '\'' +
                ", preco=" + preco +
                ", estoque=" + estoque +
                ", ativo=" + ativo +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Livro livro = (Livro) o;
        return id != null && id.equals(livro.id);
    }
    
    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }
}