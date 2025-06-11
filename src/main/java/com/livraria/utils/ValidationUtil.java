package com.livraria.utils;

public class ValidationUtil {

    private static final Pattern EMAIL_PATTERN = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        );
        
        private static final Pattern PHONE_PATTERN = Pattern.compile(
            "^\\(?\\d{2}\\)?[\\s-]?\\d{4,5}[\\s-]?\\d{4}$"
        );
        
        private static final Pattern ISBN_PATTERN = Pattern.compile(
            "^(?:ISBN(?:-1[03])?:?\\s*)?(?=[0-9X]{10}$|(?=(?:[0-9]+[-\\s]){3})[-\\s0-9X]{13}$|97[89][0-9]{10}$|(?=(?:[0-9]+[-\\s]){4})[-\\s0-9]{17}$)(?:97[89][-\\s]?)?[0-9]{1,5}[-\\s]?[0-9]+[-\\s]?[0-9]+[-\\s]?[0-9X]$"
        );
        
        /**
         * Valida formato de email
         */
        public static boolean isValidEmail(String email) {
            return email != null && EMAIL_PATTERN.matcher(email.trim()).matches();
        }
        
        /**
         * Valida formato de telefone brasileiro
         */
        public static boolean isValidPhone(String phone) {
            if (phone == null) return false;
            
            String cleanPhone = phone.replaceAll("[\\s()-]", "");
            return PHONE_PATTERN.matcher(phone).matches() && 
                   (cleanPhone.length() == 10 || cleanPhone.length() == 11);
        }
        
        /**
         * Valida formato de CEP
         */
        public static boolean isValidCEP(String cep) {
            if (cep == null) return false;
            
            String cleanCEP = cep.replaceAll("[^0-9]", "");
            return cleanCEP.length() == 8;
        }
        
        /**
         * Valida ISBN
         */
        public static boolean isValidISBN(String isbn) {
            return isbn != null && ISBN_PATTERN.matcher(isbn.trim()).matches();
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
