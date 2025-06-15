package com.livraria.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet para página inicial - CORRIGIDO
 * Agora só intercepta "/" e "/index", não conflita com outras rotas
 */
@WebServlet(name = "IndexServlet", urlPatterns = {"/index"})
public class IndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // Debug log
        System.out.println("[IndexServlet] RequestURI: " + requestURI);
        System.out.println("[IndexServlet] ContextPath: " + contextPath);
        
        // Se a requisição é exatamente para a raiz, redirecionar para /loja/
        if (requestURI.equals(contextPath + "/") || requestURI.equals(contextPath + "/index")) {
            response.sendRedirect(contextPath + "/loja/");
            return;
        }
        
        // Caso contrário, encaminhar para index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}