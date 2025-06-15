package com.livraria.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.livraria.models.User;
import com.livraria.utils.JsonUtil;

public abstract class BaseController extends HttpServlet {
    
    protected boolean isAuthenticated(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null;
    }
    
    protected User getAuthenticatedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }
    
    protected boolean isAdmin(HttpServletRequest request) {
        User user = getAuthenticatedUser(request);
        return user != null && user.isAdmin();
    }
    
    protected void redirectWithSuccess(HttpServletResponse response, HttpServletRequest request, String url, String message) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("success", message);
        response.sendRedirect(url);
    }
    
    protected void redirectWithError(HttpServletResponse response, HttpServletRequest request, String url, String message) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("error", message);
        response.sendRedirect(url);
    }
    
    protected void sendJson(HttpServletResponse response, int statusCode, String jsonString) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(statusCode);
        PrintWriter out = response.getWriter();
        out.print(jsonString);
        out.flush();
    }

    protected void sendJsonSuccess(HttpServletResponse response, Object data) throws IOException {
        String json = JsonUtil.createSuccessResponse("Operação realizada com sucesso", data);
        sendJson(response, HttpServletResponse.SC_OK, json);
    }
    
    protected void sendJsonError(HttpServletResponse response, String message, int statusCode) throws IOException {
        String json = JsonUtil.createErrorResponse(message);
        sendJson(response, statusCode, json);
    }
    
    protected void sendJsonError(HttpServletResponse response, String message) throws IOException {
        sendJsonError(response, message, HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    }
    
    /**
     * Verifica acesso de administrador. Retorna true se o acesso for permitido, false caso contrário.
     */
    protected boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado.");
            return false;
        }
        return true;
    }
    
    /**
     * Verifica autenticação. Retorna true se o acesso for permitido, false caso contrário.
     */
    protected boolean checkAuthentication(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        if (!isAuthenticated(request)) {
            String redirectUrl = request.getRequestURI();
            if (request.getQueryString() != null) {
                redirectUrl += "?" + request.getQueryString();
            }
            request.getSession().setAttribute("redirectAfterLogin", redirectUrl);
            redirectWithError(response, request, request.getContextPath() + "/login", "Você precisa fazer login para acessar esta página.");
            return false;
        }
        return true;
    }
    
    protected String getRequiredParameter(HttpServletRequest request, String paramName) 
            throws ServletException {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            throw new ServletException("Parâmetro obrigatório ausente: " + paramName);
        }
        return value.trim();
    }
    
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

    protected boolean getBooleanParameter(HttpServletRequest request, String paramName, boolean defaultValue) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        return "true".equalsIgnoreCase(value) || "on".equalsIgnoreCase(value) || "1".equals(value);
    }

    protected Double getDoubleParameter(HttpServletRequest request, String paramName, Double defaultValue) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(value.trim().replace(',', '.'));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}