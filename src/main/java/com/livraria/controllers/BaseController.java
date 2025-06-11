package com.livraria.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.livraria.models.User;

/**
 * Controlador base com funcionalidades comuns
 */
public abstract class BaseController extends HttpServlet {
    
    protected Gson gson = new Gson();
    
    /**
     * Verifica se o usuário está autenticado
     */
    protected boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null;
    }
    
    /**
     * Obtém o usuário autenticado
     */
    protected User getAuthenticatedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
    
    /**
     * Verifica se o usuário é administrador
     */
    protected boolean isAdmin(HttpServletRequest request) {
        User user = getAuthenticatedUser(request);
        return user != null && user.isAdmin();
    }
    
    /**
     * Redireciona com mensagem de sucesso
     */
    protected void redirectWithSuccess(HttpServletResponse response, String url, String message) throws IOException {
        response.sendRedirect(url + "?success=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
    
    /**
     * Redireciona com mensagem de erro
     */
    protected void redirectWithError(HttpServletResponse response, String url, String message) throws IOException {
        response.sendRedirect(url + "?error=" + java.net.URLEncoder.encode(message, "UTF-8"));
    }
    
    /**
     * Retorna resposta JSON de sucesso
     */
    protected void sendJsonSuccess(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        JsonResponse jsonResponse = new JsonResponse(true, "Operação realizada com sucesso", data);
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
    
    /**
     * Retorna resposta JSON de erro
     */
    protected void sendJsonError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        JsonResponse jsonResponse = new JsonResponse(false, message, null);
        out.print(gson.toJson(jsonResponse));
        out.flush();
    }
    
    /**
     * Verifica acesso de administrador
     */
    protected void checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, 
                "Acesso negado. Apenas administradores podem acessar esta área.");
            return;
        }
    }
    
    /**
     * Verifica autenticação
     */
    protected void checkAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
    }
    
    /**
     * Obtém parâmetro obrigatório
     */
    protected String getRequiredParameter(HttpServletRequest request, String paramName) 
            throws ServletException {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            throw new ServletException("Parâmetro obrigatório ausente: " + paramName);
        }
        return value.trim();
    }
    
    /**
     * Obtém parâmetro inteiro
     */
    protected Integer getIntParameter(HttpServletRequest request, String paramName, Integer defaultValue) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Obtém parâmetro decimal
     */
    protected Double getDoubleParameter(HttpServletRequest request, String paramName, Double defaultValue) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(value.trim().replace(",", "."));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
    
    /**
     * Obtém parâmetro boolean
     */
    protected Boolean getBooleanParameter(HttpServletRequest request, String paramName, Boolean defaultValue) {
        String value = request.getParameter(paramName);
        if (value == null) {
            return defaultValue;
        }
        return "true".equals(value) || "on".equals(value) || "1".equals(value);
    }
    
    /**
     * Classe para respostas JSON padronizadas
     */
    public static class JsonResponse {
        private boolean success;
        private String message;
        private Object data;
        
        public JsonResponse(boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }
        
        // Getters
        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Object getData() { return data; }
    }
}