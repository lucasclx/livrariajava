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
        HttpSession session = (HttpSession) request.getAttribute("session");
        if (session != null) {
             session.setAttribute("success", message);
        }
        response.sendRedirect(url);
    }
    
    /**
     * Redireciona com mensagem de erro
     */
    protected void redirectWithError(HttpServletResponse response, String url, String message) throws IOException {
        HttpSession session = (HttpSession) request.getAttribute("session");
        if (session != null) {
            session.setAttribute("error", message);
        }
        response.sendRedirect(url);
    }
    
    /**
     * Retorna resposta JSON
     */
    protected void sendJson(HttpServletResponse response, int statusCode, Object data) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(statusCode);
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(data));
        out.flush();
    }

    /**
     * Retorna resposta JSON de sucesso (status 200)
     */
    protected void sendJsonSuccess(HttpServletResponse response, Object data) throws IOException {
        sendJson(response, HttpServletResponse.SC_OK, new JsonResponse(true, "Operação realizada com sucesso", data));
    }
    
    /**
     * Retorna resposta JSON de erro com status customizado
     */
    protected void sendJsonError(HttpServletResponse response, String message, int statusCode) throws IOException {
        sendJson(response, statusCode, new JsonResponse(false, message, null));
    }
    
    /**
     * Verifica acesso de administrador e redireciona ou retorna erro
     */
    protected void checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado.");
        }
    }
    
    /**
     * Verifica autenticação e redireciona se não estiver logado
     */
    protected void checkAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        if (!isAuthenticated(request)) {
            String redirectUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                redirectUrl += "?" + request.getQueryString();
            }
            redirectWithError(response, request.getContextPath() + "/login", "Você precisa fazer login para acessar esta página.");
        }
    }
    
    /**
     * Obtém parâmetro obrigatório da requisição
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
     * Obtém parâmetro inteiro da requisição
     */
    protected int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
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
     * Classe para respostas JSON padronizadas
     */
    public static class JsonResponse {
        private final boolean success;
        private final String message;
        private final Object data;
        
        public JsonResponse(boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }
    }
}