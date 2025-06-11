package com.livraria.utils;

public class SlugUtil {

    /**
     * Gera slug a partir de string
     */
    public static String gerarSlug(String input) {
        if (input == null || input.trim().isEmpty()) {
            return "";
        }
        
        String slug = input.toLowerCase().trim();
        
        // Remover acentos
        slug = slug.replace("á", "a").replace("à", "a").replace("ã", "a").replace("â", "a")
                  .replace("é", "e").replace("ê", "e").replace("í", "i").replace("ó", "o")
                  .replace("ô", "o").replace("õ", "o").replace("ú", "u").replace("û", "u")
                  .replace("ç", "c").replace("ñ", "n");
        
        // Substituir espaços e caracteres especiais por hífen
        slug = slug.replaceAll("[^a-z0-9]+", "-");
        
        // Remover hífens do início e fim
        slug = slug.replaceAll("^-+|-+$", "");
        
        // Evitar hífens consecutivos
        slug = slug.replaceAll("-+", "-");
        
        return slug;
    }
    
    /**
     * Gera slug único verificando no banco
     */
    public static String gerarSlugUnico(String input, java.util.function.Function<String, Boolean> existsChecker) {
        String baseSlug = gerarSlug(input);
        String uniqueSlug = baseSlug;
        int counter = 1;
        
        while (existsChecker.apply(uniqueSlug)) {
            uniqueSlug = baseSlug + "-" + counter;
            counter++;
        }
        
        return uniqueSlug;
    }
}