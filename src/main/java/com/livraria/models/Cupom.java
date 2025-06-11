package com.livraria.models;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Modelo de Cupom de Desconto
 */
public class Cupom {
    
    // Tipos de cupom
    public static final String TIPO_PERCENTUAL = "percentual";
    public static final String TIPO_VALOR_FIXO = "valor_fixo";
    
    private Integer id;
    private String codigo;
    private String descricao;
    private String tipo;
    private BigDecimal valor;
    private BigDecimal valorMinimoPedido;
    private Integer limiteUso;
    private Integer vezesUsado;
    private boolean primeiroPedidoApenas;
    private LocalDateTime validoDe;
    private LocalDateTime validoAte;
    private boolean ativo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Construtores
    public Cupom() {
        this.ativo = true;
        this.vezesUsado = 0;
        this.primeiroPedidoApenas = false;
    }
    
    // Getters e Setters
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    
    public BigDecimal getValor() { return valor; }
    public void setValor(BigDecimal valor) { this.valor = valor; }
    
    public BigDecimal getValorMinimoPedido() { return valorMinimoPedido; }
    public void setValorMinimoPedido(BigDecimal valorMinimoPedido) { this.valorMinimoPedido = valorMinimoPedido; }
    
    public Integer getLimiteUso() { return limiteUso; }
    public void setLimiteUso(Integer limiteUso) { this.limiteUso = limiteUso; }
    
    public Integer getVezesUsado() { return vezesUsado; }
    public void setVezesUsado(Integer vezesUsado) { this.vezesUsado = vezesUsado; }
    
    public boolean isPrimeiroPedidoApenas() { return primeiroPedidoApenas; }
    public void setPrimeiroPedidoApenas(boolean primeiroPedidoApenas) { this.primeiroPedidoApenas = primeiroPedidoApenas; }
    
    public LocalDateTime getValidoDe() { return validoDe; }
    public void setValidoDe(LocalDateTime validoDe) { this.validoDe = validoDe; }
    
    public LocalDateTime getValidoAte() { return validoAte; }
    public void setValidoAte(LocalDateTime validoAte) { this.validoAte = validoAte; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    // Métodos de negócio
    public boolean isValido(BigDecimal valorPedido, boolean isPrimeiroPedido) {
        if (!ativo) return false;
        
        LocalDateTime now = LocalDateTime.now();
        if (validoDe != null && now.isBefore(validoDe)) return false;
        if (validoAte != null && now.isAfter(validoAte)) return false;
        
        if (limiteUso != null && vezesUsado >= limiteUso) return false;
        
        if (valorMinimoPedido != null && valorPedido.compareTo(valorMinimoPedido) < 0) return false;
        
        if (primeiroPedidoApenas && !isPrimeiroPedido) return false;
        
        return true;
    }
    
    public BigDecimal calcularDesconto(BigDecimal valorPedido) {
        if (!isValido(valorPedido, false)) return BigDecimal.ZERO;
        
        if (TIPO_PERCENTUAL.equals(tipo)) {
            return valorPedido.multiply(valor).divide(new BigDecimal(100));
        } else if (TIPO_VALOR_FIXO.equals(tipo)) {
            return valor.min(valorPedido);
        }
        
        return BigDecimal.ZERO;
    }
    
    public String getValorFormatado() {
        if (TIPO_PERCENTUAL.equals(tipo)) {
            return valor + "%";
        }
        return "R$ " + String.format("%.2f", valor.doubleValue()).replace(".", ",");
    }
    
    public CupomStatus getStatus() {
        if (!ativo) {
            return new CupomStatus("inativo", "Inativo", "secondary");
        }
        
        LocalDateTime now = LocalDateTime.now();
        if (validoDe != null && now.isBefore(validoDe)) {
            return new CupomStatus("futuro", "Não Iniciado", "info");
        }
        
        if (validoAte != null && now.isAfter(validoAte)) {
            return new CupomStatus("expirado", "Expirado", "danger");
        }
        
        if (limiteUso != null && vezesUsado >= limiteUso) {
            return new CupomStatus("esgotado", "Esgotado", "warning");
        }
        
        return new CupomStatus("ativo", "Ativo", "success");
    }
    
    public int getDiasRestantes() {
        if (validoAte == null || validoAte.isBefore(LocalDateTime.now())) {
            return 0;
        }
        return (int) java.time.Duration.between(LocalDateTime.now(), validoAte).toDays();
    }
    
    public Integer getUsosRestantes() {
        if (limiteUso == null) {
            return null; // Ilimitado
        }
        return Math.max(0, limiteUso - vezesUsado);
    }
    
    // Classe auxiliar para status
    public static class CupomStatus {
        private String status;
        private String texto;
        private String cor;
        
        public CupomStatus(String status, String texto, String cor) {
            this.status = status;
            this.texto = texto;
            this.cor = cor;
        }
        
        // Getters
        public String getStatus() { return status; }
        public String getTexto() { return texto; }
        public String getCor() { return cor; }
    }
}