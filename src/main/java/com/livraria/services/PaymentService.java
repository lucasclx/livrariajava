package com.livraria.services;

import com.livraria.models.Order;
import java.math.BigDecimal;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Serviço responsável pelo processamento de pagamentos - Versão Completa
 */
public class PaymentService {
    
    private static final Random random = new Random();
    
    /**
     * Realiza o processamento do pagamento de um pedido.
     * CORRIGIDO: Agora retorna boolean
     *
     * @param order Pedido a ter o pagamento processado
     * @return true se o pagamento foi processado com sucesso, false caso contrário
     */
    public boolean processPayment(Order order) {
        // Validações básicas
        if (order == null) {
            return false;
        }
        
        if (order.getTotal() == null || order.getTotal().compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }
        
        if (order.getPaymentMethod() == null || order.getPaymentMethod().trim().isEmpty()) {
            return false;
        }
        
        try {
            // Simular tempo de processamento baseado no método de pagamento
            simulateProcessingTime(order.getPaymentMethod());
            
            // Simular processamento baseado no método de pagamento
            return processPaymentByMethod(order);
            
        } catch (Exception e) {
            // Log do erro em um ambiente real
            System.err.println("Erro no processamento do pagamento: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Processa pagamento baseado no método específico
     */
    private boolean processPaymentByMethod(Order order) throws InterruptedException {
        String paymentMethod = order.getPaymentMethod().toLowerCase();
        
        switch (paymentMethod) {
            case "credit_card":
                return processCreditCardPayment(order);
            case "debit_card":
                return processDebitCardPayment(order);
            case "pix":
                return processPixPayment(order);
            case "boleto":
                return processBoletoPayment(order);
            case "paypal":
                return processPayPalPayment(order);
            default:
                return processGenericPayment(order);
        }
    }
    
    /**
     * Processa pagamento com cartão de crédito
     */
    private boolean processCreditCardPayment(Order order) throws InterruptedException {
        // Simular validações específicas do cartão
        Thread.sleep(2000); // Tempo de processamento
        
        // Simular diferentes cenários
        double successRate = 0.92; // 92% de sucesso para cartão de crédito
        
        // Valores muito altos têm menor taxa de sucesso
        if (order.getTotal().compareTo(new BigDecimal("1000")) > 0) {
            successRate = 0.85;
        }
        
        return random.nextDouble() < successRate;
    }
    
    /**
     * Processa pagamento com cartão de débito
     */
    private boolean processDebitCardPayment(Order order) throws InterruptedException {
        Thread.sleep(1500);
        
        // Débito tem taxa de sucesso ligeiramente menor
        double successRate = 0.88;
        
        return random.nextDouble() < successRate;
    }
    
    /**
     * Processa pagamento via PIX
     */
    private boolean processPixPayment(Order order) throws InterruptedException {
        Thread.sleep(500); // PIX é mais rápido
        
        // PIX tem alta taxa de sucesso
        double successRate = 0.95;
        
        return random.nextDouble() < successRate;
    }
    
    /**
     * Processa pagamento via boleto
     */
    private boolean processBoletoPayment(Order order) throws InterruptedException {
        Thread.sleep(1000);
        
        // Boleto sempre "gera" com sucesso, mas pagamento será confirmado depois
        // Para simulação, consideramos que sempre funciona
        return true;
    }
    
    /**
     * Processa pagamento via PayPal
     */
    private boolean processPayPalPayment(Order order) throws InterruptedException {
        Thread.sleep(3000); // PayPal pode ser mais lento
        
        double successRate = 0.90;
        
        return random.nextDouble() < successRate;
    }
    
    /**
     * Processa pagamento genérico
     */
    private boolean processGenericPayment(Order order) throws InterruptedException {
        Thread.sleep(2000);
        
        // Taxa de sucesso padrão
        double successRate = 0.85;
        
        return random.nextDouble() < successRate;
    }
    
    /**
     * Simula tempo de processamento baseado no método
     */
    private void simulateProcessingTime(String paymentMethod) throws InterruptedException {
        int baseTime = 1000; // 1 segundo base
        
        switch (paymentMethod.toLowerCase()) {
            case "pix":
                Thread.sleep(baseTime / 2); // PIX é mais rápido
                break;
            case "credit_card":
            case "debit_card":
                Thread.sleep(baseTime + ThreadLocalRandom.current().nextInt(1000));
                break;
            case "paypal":
                Thread.sleep(baseTime * 2); // PayPal pode ser mais lento
                break;
            case "boleto":
                Thread.sleep(baseTime);
                break;
            default:
                Thread.sleep(baseTime);
        }
    }
    
    /**
     * Valida dados do cartão (simulação)
     */
    public boolean validateCreditCard(String cardNumber, String expiryDate, String cvv) {
        if (cardNumber == null || cardNumber.length() < 13 || cardNumber.length() > 19) {
            return false;
        }
        
        if (expiryDate == null || !expiryDate.matches("\\d{2}/\\d{2}")) {
            return false;
        }
        
        if (cvv == null || !cvv.matches("\\d{3,4}")) {
            return false;
        }
        
        // Algoritmo de Luhn simplificado (para teste)
        return isValidCardNumber(cardNumber);
    }
    
    /**
     * Valida número do cartão usando algoritmo de Luhn
     */
    private boolean isValidCardNumber(String cardNumber) {
        String cleanNumber = cardNumber.replaceAll("\\s", "");
        
        if (!cleanNumber.matches("\\d+")) {
            return false;
        }
        
        int sum = 0;
        boolean alternate = false;
        
        for (int i = cleanNumber.length() - 1; i >= 0; i--) {
            int digit = Character.getNumericValue(cleanNumber.charAt(i));
            
            if (alternate) {
                digit *= 2;
                if (digit > 9) {
                    digit = (digit % 10) + 1;
                }
            }
            
            sum += digit;
            alternate = !alternate;
        }
        
        return sum % 10 == 0;
    }
    
    /**
     * Gera código de transação (simulação)
     */
    public String generateTransactionCode(Order order) {
        String prefix = getMethodPrefix(order.getPaymentMethod());
        long timestamp = System.currentTimeMillis();
        int randomSuffix = ThreadLocalRandom.current().nextInt(1000, 9999);
        
        return prefix + timestamp + randomSuffix;
    }
    
    /**
     * Obtém prefixo baseado no método de pagamento
     */
    private String getMethodPrefix(String paymentMethod) {
        switch (paymentMethod.toLowerCase()) {
            case "credit_card": return "CC";
            case "debit_card": return "DC";
            case "pix": return "PX";
            case "boleto": return "BL";
            case "paypal": return "PP";
            default: return "GN";
        }
    }
    
    /**
     * Calcula taxa de processamento
     */
    public BigDecimal calculateProcessingFee(Order order) {
        BigDecimal amount = order.getTotal();
        String method = order.getPaymentMethod().toLowerCase();
        
        switch (method) {
            case "credit_card":
                return amount.multiply(new BigDecimal("0.035")); // 3.5%
            case "debit_card":
                return amount.multiply(new BigDecimal("0.025")); // 2.5%
            case "pix":
                return BigDecimal.ZERO; // PIX sem taxa
            case "boleto":
                return new BigDecimal("3.50"); // Taxa fixa
            case "paypal":
                return amount.multiply(new BigDecimal("0.055")); // 5.5%
            default:
                return amount.multiply(new BigDecimal("0.030")); // 3.0%
        }
    }
    
    /**
     * Verifica se método de pagamento é suportado
     */
    public boolean isPaymentMethodSupported(String paymentMethod) {
        if (paymentMethod == null) return false;
        
        String[] supportedMethods = {
            "credit_card", "debit_card", "pix", "boleto", "paypal"
        };
        
        String method = paymentMethod.toLowerCase();
        for (String supported : supportedMethods) {
            if (supported.equals(method)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Obtém limite máximo para o método de pagamento
     */
    public BigDecimal getPaymentMethodLimit(String paymentMethod) {
        switch (paymentMethod.toLowerCase()) {
            case "pix":
                return new BigDecimal("5000.00"); // R$ 5.000
            case "boleto":
                return new BigDecimal("10000.00"); // R$ 10.000
            case "credit_card":
                return new BigDecimal("50000.00"); // R$ 50.000
            case "debit_card":
                return new BigDecimal("5000.00"); // R$ 5.000
            case "paypal":
                return new BigDecimal("20000.00"); // R$ 20.000
            default:
                return new BigDecimal("1000.00"); // R$ 1.000
        }
    }
    
    /**
     * Verifica se valor está dentro do limite
     */
    public boolean isAmountWithinLimit(BigDecimal amount, String paymentMethod) {
        BigDecimal limit = getPaymentMethodLimit(paymentMethod);
        return amount.compareTo(limit) <= 0;
    }
    
    /**
     * Simula estorno de pagamento
     */
    public boolean refundPayment(Order order, BigDecimal refundAmount) {
        if (order == null || refundAmount == null) {
            return false;
        }
        
        if (refundAmount.compareTo(order.getTotal()) > 0) {
            return false; // Não pode estornar mais que o valor pago
        }
        
        try {
            // Simular tempo de processamento do estorno
            Thread.sleep(1500);
            
            // Simular alta taxa de sucesso para estornos
            return random.nextDouble() < 0.95;
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            return false;
        }
    }
    
    /**
     * Obtém informações de status do pagamento
     */
    public PaymentStatus getPaymentStatus(String transactionId) {
        if (transactionId == null || transactionId.trim().isEmpty()) {
            return new PaymentStatus("invalid", "ID de transação inválido");
        }
        
        // Simular consulta de status
        double randomValue = random.nextDouble();
        
        if (randomValue < 0.7) {
            return new PaymentStatus("completed", "Pagamento processado com sucesso");
        } else if (randomValue < 0.85) {
            return new PaymentStatus("pending", "Pagamento em processamento");
        } else if (randomValue < 0.95) {
            return new PaymentStatus("failed", "Falha no processamento");
        } else {
            return new PaymentStatus("cancelled", "Pagamento cancelado");
        }
    }
    
    /**
     * Classe para representar status do pagamento
     */
    public static class PaymentStatus {
        private String status;
        private String message;
        private String transactionId;
        private java.time.LocalDateTime timestamp;
        
        public PaymentStatus(String status, String message) {
            this.status = status;
            this.message = message;
            this.timestamp = java.time.LocalDateTime.now();
        }
        
        // Getters
        public String getStatus() { return status; }
        public String getMessage() { return message; }
        public String getTransactionId() { return transactionId; }
        public java.time.LocalDateTime getTimestamp() { return timestamp; }
        
        // Setters
        public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
        
        public boolean isCompleted() { return "completed".equals(status); }
        public boolean isPending() { return "pending".equals(status); }
        public boolean isFailed() { return "failed".equals(status); }
        public boolean isCancelled() { return "cancelled".equals(status); }
    }
    
    /**
     * Obtém métodos de pagamento disponíveis
     */
    public String[] getAvailablePaymentMethods() {
        return new String[]{
            "credit_card",
            "debit_card", 
            "pix",
            "boleto",
            "paypal"
        };
    }
    
    /**
     * Obtém nome amigável do método de pagamento
     */
    public String getPaymentMethodDisplayName(String paymentMethod) {
        switch (paymentMethod.toLowerCase()) {
            case "credit_card": return "Cartão de Crédito";
            case "debit_card": return "Cartão de Débito";
            case "pix": return "PIX";
            case "boleto": return "Boleto Bancário";
            case "paypal": return "PayPal";
            default: return "Outro";
        }
    }
}