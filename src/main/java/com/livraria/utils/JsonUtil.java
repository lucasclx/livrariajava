package com.livraria.utils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * Utilitário para serialização JSON simples - sem dependências externas
 * Para substituir o Gson e evitar problemas de dependências
 */
public class JsonUtil {
    
    private static final DateTimeFormatter JSON_DATE_FORMAT = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");
    
    /**
     * Converte objeto para JSON
     */
    public static String toJson(Object obj) {
        if (obj == null) {
            return "null";
        }
        
        if (obj instanceof String) {
            return "\"" + escapeString((String) obj) + "\"";
        }
        
        if (obj instanceof Number || obj instanceof Boolean) {
            return obj.toString();
        }
        
        if (obj instanceof BigDecimal) {
            return ((BigDecimal) obj).toString();
        }
        
        if (obj instanceof LocalDateTime) {
            return "\"" + ((LocalDateTime) obj).format(JSON_DATE_FORMAT) + "\"";
        }
        
        if (obj instanceof List) {
            return listToJson((List<?>) obj);
        }
        
        if (obj instanceof Map) {
            return mapToJson((Map<?, ?>) obj);
        }
        
        // Para objetos personalizados, usar reflexão básica
        return objectToJson(obj);
    }
    
    /**
     * Converte lista para JSON
     */
    private static String listToJson(List<?> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) sb.append(",");
            sb.append(toJson(list.get(i)));
        }
        sb.append("]");
        return sb.toString();
    }
    
    /**
     * Converte mapa para JSON
     */
    private static String mapToJson(Map<?, ?> map) {
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        
        for (Map.Entry<?, ?> entry : map.entrySet()) {
            if (!first) sb.append(",");
            first = false;
            
            sb.append("\"").append(escapeString(entry.getKey().toString())).append("\":");
            sb.append(toJson(entry.getValue()));
        }
        
        sb.append("}");
        return sb.toString();
    }
    
    /**
     * Converte objeto personalizado para JSON usando reflexão básica
     */
    private static String objectToJson(Object obj) {
        if (obj == null) return "null";
        
        StringBuilder sb = new StringBuilder("{");
        boolean first = true;
        
        try {
            java.lang.reflect.Field[] fields = obj.getClass().getDeclaredFields();
            
            for (java.lang.reflect.Field field : fields) {
                // Pular campos estáticos e transient
                int modifiers = field.getModifiers();
                if (java.lang.reflect.Modifier.isStatic(modifiers) || 
                    java.lang.reflect.Modifier.isTransient(modifiers)) {
                    continue;
                }
                
                field.setAccessible(true);
                Object value = field.get(obj);
                
                if (!first) sb.append(",");
                first = false;
                
                sb.append("\"").append(field.getName()).append("\":");
                sb.append(toJson(value));
            }
        } catch (IllegalAccessException e) {
            // Em caso de erro, retornar representação toString
            return "\"" + escapeString(obj.toString()) + "\"";
        }
        
        sb.append("}");
        return sb.toString();
    }
    
    /**
     * Escapa caracteres especiais em strings
     */
    private static String escapeString(String str) {
        if (str == null) return "";
        
        return str.replace("\\", "\\\\")
                 .replace("\"", "\\\"")
                 .replace("\n", "\\n")
                 .replace("\r", "\\r")
                 .replace("\t", "\\t")
                 .replace("\b", "\\b")
                 .replace("\f", "\\f");
    }
    
    /**
     * Cria resposta JSON de sucesso
     */
    public static String createSuccessResponse(String message, Object data) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"success\":true,");
        sb.append("\"message\":\"").append(escapeString(message)).append("\",");
        sb.append("\"data\":").append(toJson(data));
        sb.append("}");
        return sb.toString();
    }
    
    /**
     * Cria resposta JSON de erro
     */
    public static String createErrorResponse(String message) {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"success\":false,");
        sb.append("\"message\":\"").append(escapeString(message)).append("\",");
        sb.append("\"data\":null");
        sb.append("}");
        return sb.toString();
    }
    
    /**
     * Cria resposta JSON simples com dados
     */
    public static String createDataResponse(Object data) {
        return toJson(data);
    }
}