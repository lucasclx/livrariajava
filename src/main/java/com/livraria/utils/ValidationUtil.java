package com.livraria.utils;

/**
 * Utilitários para validação de dados
 * Versão corrigida para resolver problemas de compilação
 */
public class ValidationUtil {

    /**
     * Valida formato de email (implementação básica e segura)
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        email = email.trim();
        
        // Verificações básicas
        if (email.length() < 5 || email.length() > 254) {
            return false;
        }
        
        // Deve conter exatamente um @
        int atCount = 0;
        int atPosition = -1;
        for (int i = 0; i < email.length(); i++) {
            if (email.charAt(i) == '@') {
                atCount++;
                atPosition = i;
            }
        }
        
        if (atCount != 1) {
            return false;
        }
        
        // Verificar se @ não está no início ou fim
        if (atPosition == 0 || atPosition == email.length() - 1) {
            return false;
        }
        
        // Separar parte local e domínio
        String localPart = email.substring(0, atPosition);
        String domain = email.substring(atPosition + 1);
        
        // Validar parte local
        if (localPart.length() == 0 || localPart.length() > 64) {
            return false;
        }
        
        // Validar domínio
        if (domain.length() == 0 || domain.length() > 253) {
            return false;
        }
        
        // Domínio deve conter pelo menos um ponto
        if (!domain.contains(".")) {
            return false;
        }
        
        // Verificar caracteres válidos na parte local
        if (!isValidLocalPart(localPart)) {
            return false;
        }
        
        // Verificar caracteres válidos no domínio
        if (!isValidDomain(domain)) {
            return false;
        }
        
        return true;
    }
    
    /**
     * Valida parte local do email (antes do @)
     */
    private static boolean isValidLocalPart(String localPart) {
        if (localPart == null || localPart.isEmpty()) {
            return false;
        }
        
        // Não pode começar ou terminar com ponto
        if (localPart.startsWith(".") || localPart.endsWith(".")) {
            return false;
        }
        
        // Não pode ter pontos consecutivos
        if (localPart.contains("..")) {
            return false;
        }
        
        // Verificar caracteres válidos
        for (char c : localPart.toCharArray()) {
            if (!isValidEmailChar(c, true)) {
                return false;
            }
        }
        
        return true;
    }
    
    /**
     * Valida domínio do email (depois do @)
     */
    private static boolean isValidDomain(String domain) {
        if (domain == null || domain.isEmpty()) {
            return false;
        }
        
        // Não pode começar ou terminar com ponto ou hífen
        if (domain.startsWith(".") || domain.endsWith(".") || 
            domain.startsWith("-") || domain.endsWith("-")) {
            return false;
        }
        
        // Dividir em partes pelo ponto
        String[] parts = domain.split("\\.");
        if (parts.length < 2) {
            return false;
        }
        
        // Validar cada parte do domínio
        for (String part : parts) {
            if (part.isEmpty() || part.length() > 63) {
                return false;
            }
            
            // Não pode começar ou terminar com hífen
            if (part.startsWith("-") || part.endsWith("-")) {
                return false;
            }
            
            // Verificar caracteres válidos
            for (char c : part.toCharArray()) {
                if (!isValidEmailChar(c, false)) {
                    return false;
                }
            }
        }
        
        // A última parte (TLD) deve ter pelo menos 2 caracteres
        String tld = parts[parts.length - 1];
        if (tld.length() < 2) {
            return false;
        }
        
        return true;
    }
    
    /**
     * Verifica se o caractere é válido para email
     */
    private static boolean isValidEmailChar(char c, boolean isLocalPart) {
        // Letras e números são sempre válidos
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) {
            return true;
        }
        
        // Caracteres especiais permitidos
        if (isLocalPart) {
            // Na parte local, permitir alguns caracteres especiais
            return c == '.' || c == '_' || c == '-' || c == '+';
        } else {
            // No domínio, permitir apenas hífen
            return c == '-';
        }
    }

    /**
     * Valida formato de telefone brasileiro
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        
        // Remove formatação
        String cleanPhone = phone.replaceAll("[\\s()\\-]", "");
        
        // Verifica se contém apenas números
        for (char c : cleanPhone.toCharArray()) {
            if (c < '0' || c > '9') {
                return false;
            }
        }
        
        // Verifica tamanho (10 ou 11 dígitos)
        int length = cleanPhone.length();
        return length == 10 || length == 11;
    }

    /**
     * Valida formato de CEP brasileiro
     */
    public static boolean isValidCEP(String cep) {
        if (cep == null || cep.trim().isEmpty()) {
            return false;
        }
        
        // Remove formatação
        String cleanCEP = cep.replaceAll("[^0-9]", "");
        
        // Deve ter exatamente 8 dígitos
        return cleanCEP.length() == 8;
    }

    /**
     * Valida ISBN
     */
    public static boolean isValidISBN(String isbn) {
        if (isbn == null || isbn.trim().isEmpty()) {
            return false;
        }
        
        // Remove formatação
        String cleanISBN = isbn.replaceAll("[^0-9X]", "");
        
        // ISBN-10 ou ISBN-13
        return cleanISBN.length() == 10 || cleanISBN.length() == 13;
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
        if (value == null) {
            return false;
        }
        
        double val = value.doubleValue();
        double minVal = min != null ? min.doubleValue() : Double.MIN_VALUE;
        double maxVal = max != null ? max.doubleValue() : Double.MAX_VALUE;
        
        return val >= minVal && val <= maxVal;
    }

    /**
     * Valida CPF brasileiro
     */
    public static boolean isValidCPF(String cpf) {
        if (cpf == null || cpf.trim().isEmpty()) {
            return false;
        }
        
        // Remove formatação
        cpf = cpf.replaceAll("[^0-9]", "");
        
        // Deve ter 11 dígitos
        if (cpf.length() != 11) {
            return false;
        }
        
        // Verifica se todos os dígitos são iguais (inválido)
        boolean allSame = true;
        for (int i = 1; i < cpf.length(); i++) {
            if (cpf.charAt(i) != cpf.charAt(0)) {
                allSame = false;
                break;
            }
        }
        if (allSame) {
            return false;
        }
        
        // Calcula primeiro dígito verificador
        int sum = 0;
        for (int i = 0; i < 9; i++) {
            sum += (cpf.charAt(i) - '0') * (10 - i);
        }
        int firstDigit = 11 - (sum % 11);
        if (firstDigit >= 10) {
            firstDigit = 0;
        }
        
        // Calcula segundo dígito verificador
        sum = 0;
        for (int i = 0; i < 10; i++) {
            sum += (cpf.charAt(i) - '0') * (11 - i);
        }
        int secondDigit = 11 - (sum % 11);
        if (secondDigit >= 10) {
            secondDigit = 0;
        }
        
        // Verifica se os dígitos calculados conferem
        return (cpf.charAt(9) - '0') == firstDigit && 
               (cpf.charAt(10) - '0') == secondDigit;
    }

    /**
     * Sanitiza string para prevenir XSS
     */
    public static String sanitizeHtml(String input) {
        if (input == null) {
            return null;
        }
        
        return input.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#x27;")
                   .replace("/", "&#x2F;");
    }
    
    /**
     * Valida se string tem tamanho dentro do limite
     */
    public static boolean isValidLength(String str, int minLength, int maxLength) {
        if (str == null) {
            return minLength == 0;
        }
        
        int length = str.trim().length();
        return length >= minLength && length <= maxLength;
    }
    
    /**
     * Valida se número é positivo
     */
    public static boolean isPositive(Number number) {
        return number != null && number.doubleValue() > 0;
    }
    
    /**
     * Valida se número é não-negativo (>= 0)
     */
    public static boolean isNonNegative(Number number) {
        return number != null && number.doubleValue() >= 0;
    }
}