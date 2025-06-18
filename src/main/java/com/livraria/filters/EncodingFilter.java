package com.livraria.filters;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Filtro para garantir encoding UTF-8 em todas as requisições
 */
@WebFilter("/*")
public class EncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.trim().isEmpty()) {
            encoding = encodingParam;
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Definir encoding para request
        if (httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(encoding);
        }
        
        // --- CORREÇÃO INÍCIO ---
        // A linha que definia o Content-Type foi removida.
        // O servidor de aplicação (Tomcat) irá agora definir o MIME type correto para cada recurso.
        // A linha httpResponse.setContentType("text/html; charset=" + encoding); foi removida daqui.
        // --- CORREÇÃO FIM ---
        
        // Definir encoding para response ainda é uma boa prática
        httpResponse.setCharacterEncoding(encoding);
        
        // Headers de segurança
        addSecurityHeaders(httpResponse);
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Limpeza se necessário
    }
    
    /**
     * Adiciona headers de segurança
     */
    private void addSecurityHeaders(HttpServletResponse response) {
        // Prevenir XSS
        response.setHeader("X-XSS-Protection", "1; mode=block");
        
        // Prevenir MIME sniffing
        response.setHeader("X-Content-Type-Options", "nosniff");
        
        // Frame options (prevenir clickjacking)
        response.setHeader("X-Frame-Options", "DENY");
        
        // Referrer Policy
        response.setHeader("Referrer-Policy", "strict-origin-when-cross-origin");
        
        // Content Security Policy (básico)
        response.setHeader("Content-Security-Policy", 
            "default-src 'self'; " +
            "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
            "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net https://cdnjs.cloudflare.com; " +
            "font-src 'self' https://fonts.gstatic.com https://cdnjs.cloudflare.com; " +
            "img-src 'self' data: https:; " +
            "connect-src 'self';"
        );
    }
}