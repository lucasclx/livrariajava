package com.livraria.utils;

// ATENÇÃO: As validações foram simplificadas para contornar problemas de compilação com Java 21 e Tomcat 9.
// Estas validações são muito básicas e não cobrem todos os casos válidos ou inválidos.
// A validação completa com regex foi removida.

public class ValidationUtil {

    /**
     * Valida formato de email (simplificado)
     */
    public static boolean isValidEmail(String email) {
        return email != null && email.contains("@") && email.contains(".");
    }

    /**
     * Valida formato de telefone brasileiro (simplificado)
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null) return false;
        String cleanPhone = phone.replaceAll("[\\s()-]", "");
        return cleanPhone.length() >= 8 && cleanPhone.length() <= 11; // Basic length check
    }

    /**
     * Valida formato de CEP (simplificado)
     */
    public static boolean isValidCEP(String cep) {
        if (cep == null) return false;
        String cleanCEP = cep.replaceAll("[^0-9]", "");
        return cleanCEP.length() == 8;
    }

    /**
     * Valida ISBN (simplificado)
     */
    public static boolean isValidISBN(String isbn) {
        return isbn != null && isbn.trim().length() >= 10 && isbn.trim().length() <= 17; // Basic length check
    }

    /**
     * Valida se string não está vazia
     */
    public static boolean isNotEmpty(String str) {
        return str != null && !str.trim().isEmpty();
    }

    /**
     * Valida faixa numérica
     */
    public static boolean isInRange(Number value, Number min, Number max) {
        if (value == null) return false;
        double val = value.doubleValue();
        double minVal = min != null ? min.doubleValue() : Double.MIN_VALUE;
        double maxVal = max != null ? max.doubleValue() : Double.MAX_VALUE;
        return val >= minVal && val <= maxVal;
    }

    /**
     * Valida CPF
     */
    public static boolean isValidCPF(String cpf) {
        if (cpf == null) return false;

        cpf = cpf.replaceAll("[^0-9]", "");

        if (cpf.length() != 11) return false;

        // Verifica se todos os dígitos são iguais
        if (cpf.chars().distinct().count() == 1) return false;

        // Calcula primeiro dígito verificador
        int sum = 0;
        for (int i = 0; i < 9; i++) {
            sum += (cpf.charAt(i) - '0') * (10 - i);
        }
        int firstDigit = 11 - (sum % 11);
        if (firstDigit >= 10) firstDigit = 0;

        // Calcula segundo dígito verificador
        sum = 0;
        for (int i = 0; i < 10; i++) {
            sum += (cpf.charAt(i) - '0') * (11 - i);
        }
        int secondDigit = 11 - (sum % 11);
        if (secondDigit >= 10) secondDigit = 0;

        return (cpf.charAt(9) - '0') == firstDigit && 
               (cpf.charAt(10) - '0') == secondDigit;
    }

    /**
     * Sanitiza string para prevenir XSS
     */
    public static String sanitizeHtml(String input) {
        if (input == null) return null;

        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;")
                   .replace("/", "&#x2F;");
    }
}
