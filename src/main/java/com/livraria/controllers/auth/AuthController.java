package com.livraria.controllers.auth;

import java.io.IOException;
import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet; // REMOVIDO PARA EVITAR CONFLITO
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.livraria.controllers.BaseController;
import com.livraria.dao.UserDAO;
import com.livraria.models.User;
import com.livraria.utils.PasswordUtil;
import com.livraria.utils.ValidationUtil;

// @WebServlet(urlPatterns = {"/login", "/register", "/logout"}) // REMOVIDO
public class AuthController extends BaseController {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        switch (servletPath) {
            case "/login":
                mostrarLogin(request, response);
                break;
            case "/register":
                mostrarRegistro(request, response);
                break;
            case "/logout":
                realizarLogout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        
        switch (servletPath) {
            case "/login":
                processarLogin(request, response);
                break;
            case "/register":
                processarRegistro(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void mostrarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
    }
    
    private void mostrarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
    }
    
    private void processarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = getRequiredParameter(request, "email");
            String password = getRequiredParameter(request, "password");
            
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Email inválido");
                mostrarLogin(request, response);
                return;
            }
            
            User user = userDAO.buscarPorEmail(email);
            
            if (user == null || !PasswordUtil.verify(password, user.getPassword())) {
                request.setAttribute("error", "Email ou senha incorretos");
                mostrarLogin(request, response);
                return;
            }
            
            if (!user.isAtivo()) {
                request.setAttribute("error", "Esta conta foi desativada.");
                mostrarLogin(request, response);
                return;
            }
            
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            response.sendRedirect(request.getContextPath() + (user.isAdmin() ? "/admin/dashboard" : "/perfil"));
            
        } catch (Exception e) {
            request.setAttribute("error", "Ocorreu um erro interno. Tente novamente.");
            mostrarLogin(request, response);
        }
    }
    
    private void processarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Implementação do registro (semelhante ao processarLogin)
        // Esta funcionalidade está implementada no RegisterController.java
    }
    
    private void realizarLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login?success=Logout realizado com sucesso!");
    }
}