package com.livraria.controllers.auth;

import java.io.IOException;
import java.time.LocalDate;
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

@WebServlet("/register")
public class RegisterController extends BaseController {
    
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
            response.sendRedirect(request.getContextPath() + "/perfil");
            return;
        }
        
        request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Coletar dados do formulário
            String name = getRequiredParameter(request, "name");
            String email = getRequiredParameter(request, "email");
            String password = getRequiredParameter(request, "password");
            String passwordConfirmation = getRequiredParameter(request, "password_confirmation");
            String telefone = request.getParameter("telefone");
            String cpf = request.getParameter("cpf");
            String dataNascimentoStr = request.getParameter("data_nascimento");
            String genero = request.getParameter("genero");
            
            // Validações
            StringBuilder errors = new StringBuilder();
            
            // Validar nome
            if (name.length() < 2 || name.length() > 255) {
                errors.append("Nome deve ter entre 2 e 255 caracteres. ");
            }
            
            // Validar email
            if (!ValidationUtil.isValidEmail(email)) {
                errors.append("Email inválido. ");
            } else {
                // Verificar se email já existe
                try {
                    if (userDAO.emailJaExiste(email)) {
                        errors.append("Email já está em uso. ");
                    }
                } catch (Exception e) {
                    throw new ServletException("Erro ao verificar email", e);
                }
            }
            
            // Validar senha
            if (password.length() < 6) {
                errors.append("Senha deve ter pelo menos 6 caracteres. ");
            }
            
            if (!password.equals(passwordConfirmation)) {
                errors.append("Confirmação de senha não confere. ");
            }
            
            // Validar telefone (se fornecido)
            if (telefone != null && !telefone.trim().isEmpty()) {
                if (!ValidationUtil.isValidPhone(telefone)) {
                    errors.append("Telefone inválido. ");
                }
            }
            
            // Validar CPF (se fornecido)
            if (cpf != null && !cpf.trim().isEmpty()) {
                if (!ValidationUtil.isValidCPF(cpf)) {
                    errors.append("CPF inválido. ");
                }
            }
            
            // Validar data de nascimento (se fornecida)
            LocalDate dataNascimento = null;
            if (dataNascimentoStr != null && !dataNascimentoStr.trim().isEmpty()) {
                try {
                    dataNascimento = LocalDate.parse(dataNascimentoStr);
                    if (dataNascimento.isAfter(LocalDate.now())) {
                        errors.append("Data de nascimento deve ser anterior a hoje. ");
                    }
                    if (dataNascimento.isBefore(LocalDate.now().minusYears(120))) {
                        errors.append("Data de nascimento inválida. ");
                    }
                } catch (Exception e) {
                    errors.append("Data de nascimento inválida. ");
                }
            }
            
            // Se há erros, retornar ao formulário
            if (errors.length() > 0) {
                request.setAttribute("error", errors.toString().trim());
                request.setAttribute("name", name);
                request.setAttribute("email", email);
                request.setAttribute("telefone", telefone);
                request.setAttribute("cpf", cpf);
                request.setAttribute("data_nascimento", dataNascimentoStr);
                request.setAttribute("genero", genero);
                
                request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
                return;
            }
            
            // Criar novo usuário
            User newUser = new User();
            newUser.setName(name);
            newUser.setEmail(email);
            newUser.setPassword(PasswordUtil.hash(password));
            newUser.setTelefone(telefone != null && !telefone.trim().isEmpty() ? telefone.trim() : null);
            newUser.setCpf(cpf != null && !cpf.trim().isEmpty() ? cpf.trim() : null);
            newUser.setDataNascimento(dataNascimento);
            newUser.setGenero(genero);
            newUser.setAdmin(false);
            newUser.setAtivo(true);
            
            // Salvar no banco
            User savedUser = userDAO.criar(newUser);
            
            // Fazer login automático
            HttpSession session = request.getSession(true);
            session.setAttribute("user", savedUser);
            session.setAttribute("user_name", savedUser.getName());
            
            // Redirecionar para página de boas-vindas
            redirectWithSuccess(response, request.getContextPath() + "/perfil", 
                "Conta criada com sucesso! Bem-vindo à Livraria Mil Páginas!");
            
        } catch (Exception e) {
            // Log do erro
            e.printStackTrace();
            
            // Retornar erro genérico
            request.setAttribute("error", "Erro interno do servidor. Tente novamente mais tarde.");
            request.getRequestDispatcher("/WEB-INF/view/auth/register.jsp").forward(request, response);
        }
    }
}