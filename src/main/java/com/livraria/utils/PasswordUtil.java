package com.livraria.utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utilitários para operações com senhas.
 * 
 * NOTA: Esta implementação usa SHA-256 com salt para ser compatível com ambiente acadêmico.
 * Em produção, recomenda-se usar BCrypt ou Argon2.
 */
public class PasswordUtil {
    
    private static final String ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    private static final SecureRandom random = new SecureRandom();
    
    /**
     * Gera hash seguro da senha com salt
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Senha não pode ser nula ou vazia");
        }
        
        try {
            // Gerar salt aleatório
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            // Criar hash da senha + salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(plainPassword.getBytes("UTF-8"));
            
            // Combinar salt + hash em uma string
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            return Base64.getEncoder().encodeToString(combined);
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao gerar hash da senha", e);
        }
    }
    
    /**
     * Verifica se a senha corresponde ao hash
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        // Compatibilidade com hashes antigos (para transição)
        if (hashedPassword.startsWith("simple_hash_")) {
            return verifyLegacy(plainPassword, hashedPassword);
        }
        
        try {
            // Decodificar o hash armazenado
            byte[] combined = Base64.getDecoder().decode(hashedPassword);
            
            // Extrair salt e hash
            byte[] salt = new byte[SALT_LENGTH];
            byte[] storedHash = new byte[combined.length - SALT_LENGTH];
            
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            System.arraycopy(combined, SALT_LENGTH, storedHash, 0, storedHash.length);
            
            // Gerar hash da senha fornecida com o mesmo salt
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] testHash = md.digest(plainPassword.getBytes("UTF-8"));
            
            // Comparar os hashes
            return MessageDigest.isEqual(storedHash, testHash);
            
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Verifica senhas com hash legado (para compatibilidade)
     */
    private static boolean verifyLegacy(String plainPassword, String hashedPassword) {
        String expectedHash = "simple_hash_" + plainPassword.hashCode();
        return expectedHash.equals(hashedPassword);
    }
    
    /**
     * Verifica se uma senha precisa ser atualizada (hash legado)
     */
    public static boolean needsRehash(String hashedPassword) {
        return hashedPassword != null && hashedPassword.startsWith("simple_hash_");
    }
    
    /**
     * Gera senha aleatória segura
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) {
            throw new IllegalArgumentException("Comprimento mínimo da senha é 8 caracteres");
        }
        
        String upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String lowerCase = "abcdefghijklmnopqrstuvwxyz";
        String digits = "0123456789";
        String specialChars = "!@#$%^&*()_+-=[]{}|;:,.<>?";
        
        String allChars = upperCase + lowerCase + digits + specialChars;
        
        StringBuilder password = new StringBuilder();
        
        // Garantir pelo menos um caractere de cada tipo
        password.append(upperCase.charAt(random.nextInt(upperCase.length())));
        password.append(lowerCase.charAt(random.nextInt(lowerCase.length())));
        password.append(digits.charAt(random.nextInt(digits.length())));
        password.append(specialChars.charAt(random.nextInt(specialChars.length())));
        
        // Preencher o resto aleatoriamente
        for (int i = 4; i < length; i++) {
            password.append(allChars.charAt(random.nextInt(allChars.length())));
        }
        
        // Embaralhar a senha
        return shuffleString(password.toString());
    }
    
    /**
     * Embaralha uma string
     */
    private static String shuffleString(String input) {
        char[] chars = input.toCharArray();
        for (int i = chars.length - 1; i > 0; i--) {
            int j = random.nextInt(i + 1);
            char temp = chars[i];
            chars[i] = chars[j];
            chars[j] = temp;
        }
        return new String(chars);
    }
    
    /**
     * Valida força da senha
     */
    public static PasswordStrength checkPasswordStrength(String password) {
        if (password == null) {
            return new PasswordStrength(0, "Senha não fornecida");
        }
        
        int score = 0;
        StringBuilder feedback = new StringBuilder();
        
        // Verificar comprimento
        if (password.length() >= 8) {
            score += 2;
        } else if (password.length() >= 6) {
            score += 1;
            feedback.append("Use pelo menos 8 caracteres. ");
        } else {
            feedback.append("Muito curta (mínimo 6 caracteres). ");
        }
        
        // Verificar caracteres
        boolean hasUpper = password.matches(".*[A-Z].*");
        boolean hasLower = password.matches(".*[a-z].*");
        boolean hasDigit = password.matches(".*[0-9].*");
        boolean hasSpecial = password.matches(".*[^A-Za-z0-9].*");
        
        if (hasUpper) score++;
        else feedback.append("Adicione letras maiúsculas. ");
        
        if (hasLower) score++;
        else feedback.append("Adicione letras minúsculas. ");
        
        if (hasDigit) score++;
        else feedback.append("Adicione números. ");
        
        if (hasSpecial) score++;
        else feedback.append("Adicione caracteres especiais. ");
        
        // Verificar padrões comuns
        if (isCommonPassword(password)) {
            score = Math.max(0, score - 2);
            feedback.append("Evite senhas comuns. ");
        }
        
        // Verificar repetições
        if (hasRepeatingChars(password)) {
            score = Math.max(0, score - 1);
            feedback.append("Evite caracteres repetidos. ");
        }
        
        String level;
        if (score >= 6) level = "Forte";
        else if (score >= 4) level = "Média";
        else if (score >= 2) level = "Fraca";
        else level = "Muito Fraca";
        
        return new PasswordStrength(score, level, feedback.toString().trim());
    }
    
    /**
     * Verifica se é uma senha comum
     */
    private static boolean isCommonPassword(String password) {
        String[] commonPasswords = {
            "123456", "password", "123456789", "12345678", "12345",
            "1234567", "1234567890", "qwerty", "abc123", "111111",
            "123123", "admin", "letmein", "welcome", "monkey"
        };
        
        String lowerPassword = password.toLowerCase();
        for (String common : commonPasswords) {
            if (lowerPassword.equals(common)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Verifica se tem caracteres repetidos em sequência
     */
    private static boolean hasRepeatingChars(String password) {
        for (int i = 0; i < password.length() - 2; i++) {
            if (password.charAt(i) == password.charAt(i + 1) && 
                password.charAt(i) == password.charAt(i + 2)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Classe para representar a força da senha
     */
    public static class PasswordStrength {
        private final int score;
        private final String level;
        private final String feedback;
        
        public PasswordStrength(int score, String feedback) {
            this(score, "", feedback);
        }
        
        public PasswordStrength(int score, String level, String feedback) {
            this.score = score;
            this.level = level;
            this.feedback = feedback;
        }
        
        public int getScore() { return score; }
        public String getLevel() { return level; }
        public String getFeedback() { return feedback; }
        
        public boolean isStrong() { return score >= 6; }
        public boolean isAcceptable() { return score >= 4; }
        
        @Override
        public String toString() {
            return String.format("Força: %s (Score: %d) - %s", level, score, feedback);
        }
    }
    
    /**
     * Gera salt aleatório (para uso avançado)
     */
    public static String generateSalt() {
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }
    
    /**
     * Hash com salt customizado (para uso avançado)
     */
    public static String hashWithSalt(String plainPassword, String saltString) {
        try {
            byte[] salt = Base64.getDecoder().decode(saltString);
            
            MessageDigest md = MessageDigest.getInstance(ALGORITHM);
            md.update(salt);
            byte[] hashedPassword = md.digest(plainPassword.getBytes("UTF-8"));
            
            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);
            
            return Base64.getEncoder().encodeToString(combined);
            
        } catch (Exception e) {
            throw new RuntimeException("Erro ao gerar hash da senha", e);
        }
    }
}