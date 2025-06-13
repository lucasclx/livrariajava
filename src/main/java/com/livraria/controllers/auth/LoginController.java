package com.livraria.controllers.auth;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.livraria.controllers.BaseController;
import com.livraria.dao.UserDAO;
import com.livraria.models.User;
import com.livraria.utils.PasswordUtil;
import com.livraria.utils.ValidationUtil;

@WebServlet("/login")
public class LoginController extends BaseController {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Se já está logado, redirecionar
        if (isAuthenticated(request)) {
            User user = getAuthenticatedUser(request);
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/perfil");
            }
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String email = getRequiredParameter(request, "email");
            String password = getRequiredParameter(request, "password");
            String redirectUrl = request.getParameter("redirect");
            boolean remember = getBooleanParameter(request, "remember", false);
            
            // Validações básicas
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Email inválido");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
                return;
            }
            
            if (password.length() < 1) {
                request.setAttribute("error", "Senha é obrigatória");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Buscar usuário por email
            User user = userDAO.buscarPorEmail(email);
            
            if (user == null) {
                // Não revelar se o email existe ou não por segurança
                request.setAttribute("error", "Email ou senha incorretos");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Verificar senha
            if (!PasswordUtil.verify(password, user.getPassword())) {
                request.setAttribute("error", "Email ou senha incorretos");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Verificar se usuário está ativo
            if (!user.isAtivo()) {
                request.setAttribute("error", "Sua conta foi desativada. Entre em contato com o suporte.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Atualizar último login
            userDAO.atualizarUltimoLogin(user.getId());
            
            // Criar sessão
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("user_name", user.getName());
            session.setAttribute("loginTime", System.currentTimeMillis());
            
            // Configurar timeout da sessão (30 minutos)
            session.setMaxInactiveInterval(30 * 60);
            
            // Migrar carrinho de sessão para usuário logado (se existir)
            try {
                // Implementar migração de carrinho aqui se necessário
            } catch (Exception e) {
                // Log do erro, mas não interrompe o login
                System.err.println("Erro ao migrar carrinho: " + e.getMessage());
            }
            
            // Determinar URL de redirecionamento
            String targetUrl;
            if (redirectUrl != null && !redirectUrl.trim().isEmpty() && 
                redirectUrl.startsWith(request.getContextPath())) {
                targetUrl = redirectUrl;
            } else if (user.isAdmin()) {
                targetUrl = request.getContextPath() + "/admin/dashboard";
            } else {
                targetUrl = request.getContextPath() + "/loja/";
            }
            
            // Redirecionar com mensagem de sucesso
            redirectWithSuccess(response, targetUrl, "Login realizado com sucesso! Bem-vindo, " + user.getName());
            
        } catch (Exception e) {
            // Log do erro
            e.printStackTrace();
            
            // Retornar erro genérico
            request.setAttribute("error", "Ocorreu um erro interno. Tente novamente mais tarde.");
            request.getRequestDispatcher("/WEB-INF/view/auth/login.jsp").forward(request, response);
        }
    }
}