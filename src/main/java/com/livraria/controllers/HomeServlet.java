package com.livraria.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet para lidar com a página inicial da aplicação
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Debug - Pode ser removido após teste
        System.out.println("=== HomeServlet ===");
        System.out.println("RequestURI: " + request.getRequestURI());
        System.out.println("ContextPath: " + request.getContextPath());
        System.out.println("ServletPath: " + request.getServletPath());
        System.out.println("PathInfo: " + request.getPathInfo());
        System.out.println("==================");
        
        // Redirecionar para a loja principal
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + "/loja/");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}