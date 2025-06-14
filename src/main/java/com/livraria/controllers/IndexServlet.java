package com.livraria.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet de página inicial que redireciona para index.jsp
 */
@WebServlet(urlPatterns = {"/", "/index"})
public class IndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    /**
     * Construtor padrão
     */
    public IndexServlet() {
        super();
    }
    
    /**
     * Handles GET requests - encaminha para index.jsp
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Log para debug
        System.out.println("[IndexServlet] Redirecionando para index.jsp");
        
        // Encaminhar para a página index.jsp
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
    
    /**
     * Handles POST requests - redireciona para GET
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}