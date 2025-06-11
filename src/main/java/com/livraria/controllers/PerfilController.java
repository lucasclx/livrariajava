package com.livraria.controllers;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.UserDAO;
import com.livraria.dao.OrderDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.models.User;
import com.livraria.models.Order;
import com.livraria.models.Livro;
import com.livraria.models.Avaliacao;
import com.livraria.utils.PasswordUtil;
import com.livraria.utils.ValidationUtil;

public class PerfilController extends BaseController {
    
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    private LivroDAO livroDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
        livroDAO = new LivroDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAuthentication(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
            mostrarPerfil(request, response);
        } else if (pathInfo.equals("/editar")) {
            mostrarFormularioEdicao(request, response);
        } else if (pathInfo.equals("/pedidos")) {
            mostrarPedidos(request, response);
        } else if (pathInfo.equals("/favoritos")) {
            mostrarFavoritos(request, response);
        } else if (pathInfo.equals("/avaliacoes")) {
            mostrarAvaliacoes(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAuthentication(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo.equals("/atualizar")) {
            atualizarPerfil(request, response);
        } else if (pathInfo.equals("/alterar-senha")) {
            alterarSenha(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void mostrarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = getAuthenticatedUser(request);
            
            // Estatísticas do usuário
            int totalPedidos = orderDAO.contarPorUsuario(user.getId());
            double valorTotalGasto = orderDAO.calcularTotalGastoPorUsuario(user.getId());
            int livrosFavoritos = livroDAO.contarFavoritos(user.getId());
            int avaliacoesFeitas = avaliacaoDAO.contarPorUsuario(user.getId());
            
            // Últimos pedidos
            List<Order> ultimosPedidos = orderDAO.buscarUltimosPorUsuario(user.getId(), 5);
            
            // Livros favoritos
            List<Livro> favoritos = livroDAO.buscarFavoritos(user.getId(), 1, 6);
            
            request.setAttribute("user", user);
            request.setAttribute("totalPedidos", totalPedidos);
            request.setAttribute("valorTotalGasto", valorTotalGasto);
            request.setAttribute("livrosFavoritos", livrosFavoritos);
            request.setAttribute("avaliacoesFeitas", avaliacoesFeitas);
            request.setAttribute("ultimosPedidos", ultimosPedidos);
            request.setAttribute("favoritos", favoritos);
            
            request.getRequestDispatcher("/perfil/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar perfil", e);
        }
    }
    
    private void mostrarFormularioEdicao(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        User user = getAuthenticatedUser(request);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/perfil/editar.jsp").forward(request, response);
    }
    
    private void atualizarPerfil(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = getAuthenticatedUser(request);
            
            String name = getRequiredParameter(request, "name");
            String email = getRequiredParameter(request, "email");
            String telefone = request.getParameter("telefone");
            String dataNascimentoStr = request.getParameter("data_nascimento");
            String genero = request.getParameter("genero");
            
            // Validações
            if (name.length() < 2 || name.length() > 255) {
                redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                    "Nome deve ter entre 2 e 255 caracteres");
                return;
            }
            
            if (!ValidationUtil.isValidEmail(email)) {
                redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                    "Email inválido");
                return;
            }
            
            // Verificar se email já existe para outro usuário
            if (userDAO.emailJaExisteParaOutroUsuario(email, user.getId())) {
                redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                    "Email já está em uso por outro usuário");
                return;
            }
            
            // Validar telefone (se informado)
            if (telefone != null && !telefone.trim().isEmpty()) {
                if (!ValidationUtil.isValidPhone(telefone)) {
                    redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                        "Telefone inválido");
                    return;
                }
            }
            
            // Validar data de nascimento (se informada)
            LocalDate dataNascimento = null;
            if (dataNascimentoStr != null && !dataNascimentoStr.trim().isEmpty()) {
                try {
                    dataNascimento = LocalDate.parse(dataNascimentoStr);
                    if (dataNascimento.isAfter(LocalDate.now())) {
                        redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                            "Data de nascimento deve ser anterior a hoje");
                        return;
                    }
                } catch (Exception e) {
                    redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                        "Data de nascimento inválida");
                    return;
                }
            }
            
            // Atualizar dados
            user.setName(name);
            user.setEmail(email);
            user.setTelefone(telefone != null && !telefone.trim().isEmpty() ? telefone.trim() : null);
            user.setDataNascimento(dataNascimento);
            user.setGenero(genero);
            
            userDAO.atualizar(user);
            
            // Atualizar sessão
            request.getSession().setAttribute("user", user);
            request.getSession().setAttribute("user_name", user.getName());
            
            redirectWithSuccess(response, request.getContextPath() + "/perfil", 
                "Perfil atualizado com sucesso!");
            
        } catch (Exception e) {
            redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                "Erro ao atualizar perfil: " + e.getMessage());
        }
    }
    
    private void alterarSenha(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = getAuthenticatedUser(request);
            
            String senhaAtual = getRequiredParameter(request, "senha_atual");
            String novaSenha = getRequiredParameter(request, "nova_senha");
            String confirmacao = getRequiredParameter(request, "nova_senha_confirmation");
            
            // Verificar senha atual
            if (!PasswordUtil.verify(senhaAtual, user.getPassword())) {
                redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                    "Senha atual incorreta");
                return;
            }
            
            // Validar nova senha
            if (novaSenha.length() < 8) {
                redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                    "Nova senha deve ter pelo menos 8 caracteres");
                return;
            }
            
            if (!novaSenha.equals(confirmacao)) {
                redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                    "Confirmação da nova senha não confere");
                return;
            }
            
            // Atualizar senha
            user.setPassword(PasswordUtil.hash(novaSenha));
            userDAO.atualizarSenha(user.getId(), user.getPassword());
            
            redirectWithSuccess(response, request.getContextPath() + "/perfil", 
                "Senha alterada com sucesso!");
            
        } catch (Exception e) {
            redirectWithError(response, request.getContextPath() + "/perfil/editar", 
                "Erro ao alterar senha: " + e.getMessage());
        }
    }
    
    private void mostrarPedidos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = getAuthenticatedUser(request);
            int page = getIntParameter(request, "page", 1);
            int pageSize = 10;
            
            List<Order> pedidos = orderDAO.buscarPorUsuario(user.getId(), page, pageSize);
            int totalPedidos = orderDAO.contarPorUsuario(user.getId());
            
            request.setAttribute("pedidos", pedidos);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalPedidos / pageSize));
            
            request.getRequestDispatcher("/perfil/pedidos.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar pedidos", e);
        }
    }
    
    private void mostrarFavoritos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            User user = getAuthenticatedUser(request);
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            
            List<Livro> favoritos = livroDAO.buscarFavoritos(user.getId(), page, pageSize);
            int totalFavoritos = livroDAO.contarFavoritos(user.getId());
            
            request.setAttribute("favoritos", favoritos);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalFavoritos / pageSize));
            
            request.getRequestDispatcher("/perfil/favoritos.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar favoritos", e);
        }
    }
    
}