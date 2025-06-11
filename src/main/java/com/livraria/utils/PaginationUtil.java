package com.livraria.utils;

public class PaginationUtil {

    /**
     * Calcula total de páginas
     */
    public static int calcularTotalPaginas(int totalItens, int itensPorPagina) {
        if (itensPorPagina <= 0) {
            throw new IllegalArgumentException("Itens por página deve ser maior que zero");
        }
        return (int) Math.ceil((double) totalItens / itensPorPagina);
    }
    
    /**
     * Calcula offset para SQL
     */
    public static int calcularOffset(int pagina, int itensPorPagina) {
        if (pagina < 1) {
            throw new IllegalArgumentException("Página deve ser maior que zero");
        }
        return (pagina - 1) * itensPorPagina;
    }
    
    /**
     * Valida parâmetros de paginação
     */
    public static void validarPaginacao(int pagina, int itensPorPagina) {
        if (pagina < 1) {
            throw new IllegalArgumentException("Página deve ser maior que zero");
        }
        if (itensPorPagina < 1 || itensPorPagina > 100) {
            throw new IllegalArgumentException("Itens por página deve estar entre 1 e 100");
        }
    }
    
    /**
     * Cria objeto de informações de paginação
     */
    public static PaginationInfo criarInfo(int paginaAtual, int itensPorPagina, int totalItens) {
        validarPaginacao(paginaAtual, itensPorPagina);
        
        int totalPaginas = calcularTotalPaginas(totalItens, itensPorPagina);
        boolean temProxima = paginaAtual < totalPaginas;
        boolean temAnterior = paginaAtual > 1;
        
        return new PaginationInfo(paginaAtual, itensPorPagina, totalItens, totalPaginas, temAnterior, temProxima);
    }
    
    /**
     * Classe para informações de paginação
     */
    public static class PaginationInfo {
        private final int paginaAtual;
        private final int itensPorPagina;
        private final int totalItens;
        private final int totalPaginas;
        private final boolean temAnterior;
        private final boolean temProxima;
        
        public PaginationInfo(int paginaAtual, int itensPorPagina, int totalItens, 
                             int totalPaginas, boolean temAnterior, boolean temProxima) {
            this.paginaAtual = paginaAtual;
            this.itensPorPagina = itensPorPagina;
            this.totalItens = totalItens;
            this.totalPaginas = totalPaginas;
            this.temAnterior = temAnterior;
            this.temProxima = temProxima;
        }
        
        // Getters
        public int getPaginaAtual() { return paginaAtual; }
        public int getItensPorPagina() { return itensPorPagina; }
        public int getTotalItens() { return totalItens; }
        public int getTotalPaginas() { return totalPaginas; }
        public boolean isTemAnterior() { return temAnterior; }
        public boolean isTemProxima() { return temProxima; }
        public int getPaginaAnterior() { return Math.max(1, paginaAtual - 1); }
        public int getProximaPagina() { return Math.min(totalPaginas, paginaAtual + 1); }
    }
}
