package com.livraria.utils;

public class FormatUtil {

	 /**
     * Formata valor monetário
     */
    public static String formatarMoeda(double valor) {
        return String.format("R$ %.2f", valor).replace(".", ",");
    }
    
    /**
     * Formata valor monetário (BigDecimal)
     */
    public static String formatarMoeda(java.math.BigDecimal valor) {
        if (valor == null) return "R$ 0,00";
        return formatarMoeda(valor.doubleValue());
    }
    
    /**
     * Formata CEP
     */
    public static String formatarCEP(String cep) {
        if (cep == null) return "";
        String clean = cep.replaceAll("[^0-9]", "");
        if (clean.length() == 8) {
            return clean.substring(0, 5) + "-" + clean.substring(5);
        }
        return cep;
    }
    
    /**
     * Formata telefone
     */
    public static String formatarTelefone(String telefone) {
        if (telefone == null) return "";
        String clean = telefone.replaceAll("[^0-9]", "");
        
        if (clean.length() == 10) {
            return String.format("(%s) %s-%s", 
                clean.substring(0, 2), 
                clean.substring(2, 6), 
                clean.substring(6));
        } else if (clean.length() == 11) {
            return String.format("(%s) %s-%s", 
                clean.substring(0, 2), 
                clean.substring(2, 7), 
                clean.substring(7));
        }
        
        return telefone;
    }
    
    /**
     * Trunca texto
     */
    public static String truncar(String texto, int limite) {
        if (texto == null || texto.length() <= limite) {
            return texto;
        }
        return texto.substring(0, limite) + "...";
    }
    
    /**
     * Capitaliza primeira letra
     */
    public static String capitalizar(String texto) {
        if (texto == null || texto.isEmpty()) {
            return texto;
        }
        return texto.substring(0, 1).toUpperCase() + texto.substring(1).toLowerCase();
    }
}
