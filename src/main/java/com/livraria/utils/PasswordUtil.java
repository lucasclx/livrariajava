package com.livraria.utils;

import java.security.SecureRandom;

/**
 * Utilitários para operações com senhas
 * Nota: Esta versão usa uma implementação simples para hash/verify
 * Em produção, use BCrypt ou outro algoritmo seguro
 */
public class PasswordUtil {
    
    /**
     * Gera hash da senha (implementação simplificada)
     * ATENÇÃO: Em produção, use BCrypt ou outro algoritmo seguro
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Senha não pode ser nula ou vazia");
        }
        
        // Implementação simplificada - APENAS PARA DESENVOLVIMENTO
        // Em produção, use BCrypt.hashpw(plainPassword, BCrypt.gensalt())
        return "simple_hash_" + plainPassword.hashCode();
    }
    
    /**
     * Verifica se a senha corresponde ao hash (implementação simplificada)package com.livraria.utils;

import java.security.SecureRandom;

/**
 * Utilitários para operações com senhas
 * Nota: Esta versão usa uma implementação simples para hash/verify
 * Em produção, use BCrypt ou outro algoritmo seguro
 */
public class PasswordUtil {
    
    /**
     * Gera hash da senha (implementação simplificada)
     * ATENÇÃO: Em produção, use BCrypt ou outro algoritmo seguro
     */
    public static String hash(String plainPassword) {
        if (plainPassword == null || plainPassword.isEmpty()) {
            throw new IllegalArgumentException("Senha não pode ser nula ou vazia");
        }
        
        // Implementação simplificada - APENAS PARA DESENVOLVIMENTO
        // Em produção, use BCrypt.hashpw(plainPassword, BCrypt.gensalt())
        return "simple_hash_" + plainPassword.hashCode();
    }
    
    /**
     * Verifica se a senha corresponde ao hash (implementação simplificada)
     * ATENÇÃO: Em produção, use BCrypt ou outro algoritmo seguro
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        // Implementação simplificada - APENAS PARA DESENVOLVIMENTO
        // Em produção, use BCrypt.checkpw(plainPassword, hashedPassword)
        String expectedHash = "simple_hash_" + plainPassword.hashCode();
        return expectedHash.equals(hashedPassword);
    }
    
    /**
     * Gera senha aleatória
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) {
            throw new IllegalArgumentException("Comprimento mínimo da senha é 8 caracteres");
        }
        
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    /**
     * Valida força da senha
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        // Pelo menos uma letra minúscula
        if (!password.matches(".*[a-z].*")) {
            return false;
        }
        
        // Pelo menos uma letra maiúscula
        if (!password.matches(".*[A-Z].*")) {
            return false;
        }
        
        // Pelo menos um número
        if (!password.matches(".*[0-9].*")) {
            return false;
        }
        
        return true;
    }
}
     * ATENÇÃO: Em produção, use BCrypt ou outro algoritmo seguro
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        
        // Implementação simplificada - APENAS PARA DESENVOLVIMENTO
        // Em produção, use BCrypt.checkpw(plainPassword, hashedPassword)
        String expectedHash = "simple_hash_" + plainPassword.hashCode();
        return expectedHash.equals(hashedPassword);
    }
    
    /**
     * Gera senha aleatória
     */
    public static String generateRandomPassword(int length) {
        if (length < 8) {
            throw new IllegalArgumentException("Comprimento mínimo da senha é 8 caracteres");
        }
        
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    /**
     * Valida força da senha
     */
    public static boolean isStrongPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        
        // Pelo menos uma letra minúscula
        if (!password.matches(".*[a-z].*")) {
            return false;
        }
        
        // Pelo menos uma letra maiúscula
        if (!password.matches(".*[A-Z].*")) {
            return false;
        }
        
        // Pelo menos um número
        if (!password.matches(".*[0-9].*")) {
            return false;
        }
        
        return true;
    }
}