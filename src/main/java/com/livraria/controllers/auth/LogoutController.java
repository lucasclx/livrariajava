package com.livraria.controllers.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.livraria.controllers.BaseController;

@WebServlet("/logout")
public class LogoutController extends BaseController {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        realizarLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        realizarLogout(request, response);
    }
    
    private void realizarLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession(false);
        String userName = null;
        
        if (session != null) {
            userName = (String) session.getAttribute("user_name");
            
            // Invalidar sessão
            session.invalidate();
        }
        
        // Redirecionar para página inicial com mensagem
        String message = userName != null ? 
            "Logout realizado com sucesso! Até logo, " + userName + "!" :
            "Logout realizado com sucesso!";
            
        redirectWithSuccess(response, request.getContextPath() + "/", message);
    }
}