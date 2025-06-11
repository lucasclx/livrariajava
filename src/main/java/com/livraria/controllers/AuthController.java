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

@WebServlet({"/login", "/register", "/logout"})
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
        
        // Se já está logado, redireciona
        if (isAuthenticated(request)) {
            User user = getAuthenticatedUser(request);
            if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/");
            }
            return;
        }
        
        request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
    }
    
    private void mostrarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Se já está logado, redireciona
        if (isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
    }
    
    private void processarLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String email = getRequiredParameter(request, "email");
            String password = getRequiredParameter(request, "password");
            String redirect = request.getParameter("redirect");
            
            // Validação básica
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Email inválido");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Buscar usuário
            User user = userDAO.buscarPorEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email ou senha incorretos");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Verificar senha
            if (!PasswordUtil.verify(password, user.getPassword())) {
                request.setAttribute("error", "Email ou senha incorretos");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Verificar se usuário está ativo
            if (!user.isAtivo()) {
                request.setAttribute("error", "Conta desativada. Entre em contato com o suporte");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }
            
            // Criar sessão
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("user_id", user.getId());
            session.setAttribute("user_name", user.getName());
            session.setAttribute("is_admin", user.isAdmin());
            
            // Atualizar último login
            userDAO.atualizarUltimoLogin(user.getId());
            
            // Redirecionar
            String redirectUrl = "/";
            if (redirect != null && !redirect.trim().isEmpty()) {
                redirectUrl = redirect;
            } else if (user.isAdmin()) {
                redirectUrl = "/admin";
            }
            
            response.sendRedirect(request.getContextPath() + redirectUrl);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erro interno. Tente novamente");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }
    
    private void processarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String name = getRequiredParameter(request, "name");
            String email = getRequiredParameter(request, "email");
            String password = getRequiredParameter(request, "password");
            String passwordConfirmation = getRequiredParameter(request, "password_confirmation");
            
            // Validações
            if (name.length() < 2 || name.length() > 255) {
                request.setAttribute("error", "Nome deve ter entre 2 e 255 caracteres");
                preencherCamposRegistro(request, name, email);
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Email inválido");
                preencherCamposRegistro(request, name, email);
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            
            if (password.length() < 8) {
                request.setAttribute("error", "Senha deve ter pelo menos 8 caracteres");
                preencherCamposRegistro(request, name, email);
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(passwordConfirmation)) {
                request.setAttribute("error", "Confirmação de senha não confere");
                preencherCamposRegistro(request, name, email);
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            
            // Verificar se email já existe
            if (userDAO.emailJaExiste(email)) {
                request.setAttribute("error", "Email já está em uso");
                preencherCamposRegistro(request, name, email);
                request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
                return;
            }
            
            // Criar usuário
            User user = new User();
            user.setName(name);
            user.setEmail(email);
            user.setPassword(PasswordUtil.hash(password));
            user.setAtivo(true);
            user.setAdmin(false);
            
            user = userDAO.criar(user);
            
            // Fazer login automaticamente
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("user_id", user.getId());
            session.setAttribute("user_name", user.getName());
            session.setAttribute("is_admin", user.isAdmin());
            
            // Redirecionar com mensagem de sucesso
            response.sendRedirect(request.getContextPath() + "/?success=" + 
                java.net.URLEncoder.encode("Conta criada com sucesso! Bem-vindo(a)!", "UTF-8"));
            
        } catch (Exception e) {
            request.setAttribute("error", "Erro interno. Tente novamente");
            request.getRequestDispatcher("/auth/register.jsp").forward(request, response);
        }
    }
    
    private void realizarLogout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/?success=" + 
            java.net.URLEncoder.encode("Logout realizado com sucesso!", "UTF-8"));
    }
    
    private void preencherCamposRegistro(HttpServletRequest request, String name, String email) {
        request.setAttribute("name", name);
        request.setAttribute("email", email);
    }
}