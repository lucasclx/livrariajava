package com.livraria.filters;

import com.livraria.models.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Filtro para verificar autenticação do usuário
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    // URLs que não precisam de autenticação
    private static final List<String> PUBLIC_URLS = Arrays.asList(
        "/",
        "/loja",
        "/loja/",
        "/loja/index",
        "/loja/catalogo",
        "/loja/detalhes",
        "/loja/categoria",
        "/loja/buscar",
        "/login",
        "/register",
        "/auth/login",
        "/auth/register", 
        "/auth/logout",
        "/api/livros",
        "/api/categorias",
        "/assets",
        "/css",
        "/js",
        "/images",
        "/uploads",
        "/favicon.ico"
    );
    
    // URLs que precisam de autenticação mas não de admin
    private static final List<String> USER_URLS = Arrays.asList(
        "/perfil",
        "/orders",
        "/cart",
        "/checkout",
        "/favoritos"
    );
    
    // URLs que precisam de autenticação de admin
    private static final List<String> ADMIN_URLS = Arrays.asList(
        "/admin",
        "/dashboard",
        "/livros/create",
        "/livros/edit",
        "/livros/delete",
        "/categorias",
        "/usuarios",
        "/relatorios"
    );
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialização do filtro
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        // Log da requisição para debug
        logRequest(httpRequest, path);
        
        // Verificar se é uma URL pública
        if (isPublicUrl(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Obter sessão e usuário
        HttpSession session = httpRequest.getSession(false);
        User user = null;
        
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        // Verificar se usuário está autenticado
        if (user == null) {
            handleUnauthenticated(httpRequest, httpResponse, path);
            return;
        }
        
        // Verificar se usuário está ativo
        if (!user.isAtivo()) {
            handleInactiveUser(httpRequest, httpResponse);
            return;
        }
        
        // Verificar permissões de admin se necessário
        if (isAdminUrl(path) && !user.isAdmin()) {
            handleUnauthorized(httpRequest, httpResponse);
            return;
        }
        
        // Atualizar última atividade
        updateLastActivity(session);
        
        // Adicionar informações do usuário no request
        httpRequest.setAttribute("currentUser", user);
        httpRequest.setAttribute("isAuthenticated", true);
        httpRequest.setAttribute("isAdmin", user.isAdmin());
        
        // Continuar com a requisição
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Limpeza do filtro
    }
    
    /**
     * Verifica se a URL é pública (não precisa de autenticação)
     */
    private boolean isPublicUrl(String path) {
        // URLs exatas
        if (PUBLIC_URLS.contains(path)) {
            return true;
        }
        
        // URLs que começam com determinados prefixos
        for (String publicUrl : PUBLIC_URLS) {
            if (path.startsWith(publicUrl)) {
                return true;
            }
        }
        
        // Verificar se é arquivo estático
        if (isStaticResource(path)) {
            return true;
        }
        
        // APIs públicas
        if (path.startsWith("/api/") && isPublicApiPath(path)) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Verifica se é um recurso estático
     */
    private boolean isStaticResource(String path) {
        return path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$");
    }
    
    /**
     * Verifica se é uma API pública
     */
    private boolean isPublicApiPath(String path) {
        return path.matches("^/api/(livros|categorias)(/.*)?$") || 
               path.equals("/api/search") ||
               path.equals("/api/health");
    }
    
    /**
     * Verifica se a URL precisa de permissões de admin
     */
    private boolean isAdminUrl(String path) {
        for (String adminUrl : ADMIN_URLS) {
            if (path.startsWith(adminUrl)) {
                return true;
            }
        }
        
        // Verificar operações específicas que precisam de admin
        if (path.matches("^/livros/\\d+/(edit|delete)$")) {
            return true;
        }
        
        if (path.matches("^/categorias/(create|\\d+/(edit|delete))$")) {
            return true;
        }
        
        return false;
    }
    
    /**
     * Trata usuário não autenticado
     */
    private void handleUnauthenticated(HttpServletRequest request, HttpServletResponse response, String path) 
            throws IOException {
        
        // Se for requisição AJAX, retornar status 401
        if (isAjaxRequest(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Usuário não autenticado\", \"redirect\": \"/login\"}");
            return;
        }
        
        // Salvar URL de destino para redirecionamento após login
        HttpSession session = request.getSession(true);
        if (!path.equals("/login") && !path.equals("/register")) {
            session.setAttribute("redirectAfterLogin", request.getRequestURL().toString());
            if (request.getQueryString() != null) {
                session.setAttribute("redirectAfterLogin", 
                    session.getAttribute("redirectAfterLogin") + "?" + request.getQueryString());
            }
        }
        
        // Adicionar mensagem
        session.setAttribute("error", "Você precisa fazer login para acessar esta página");
        
        // Redirecionar para login
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    /**
     * Trata usuário inativo
     */
    private void handleInactiveUser(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Invalidar sessão
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        if (isAjaxRequest(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Conta inativa\", \"redirect\": \"/login\"}");
            return;
        }
        
        // Redirecionar para login com mensagem
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("error", "Sua conta está inativa. Entre em contato com o suporte.");
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    /**
     * Trata usuário sem permissão
     */
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (isAjaxRequest(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Acesso negado\"}");
            return;
        }
        
        // Redirecionar para página de erro ou dashboard
        HttpSession session = request.getSession();
        session.setAttribute("error", "Você não tem permissão para acessar esta página");
        
        User user = (User) session.getAttribute("user");
        if (user != null && user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
    }
    
    /**
     * Verifica se é uma requisição AJAX
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        String ajaxHeader = request.getHeader("X-Requested-With");
        String contentType = request.getContentType();
        String accept = request.getHeader("Accept");
        
        return "XMLHttpRequest".equals(ajaxHeader) ||
               (contentType != null && contentType.contains("application/json")) ||
               (accept != null && accept.contains("application/json"));
    }
    
    /**
     * Atualiza última atividade do usuário
     */
    private void updateLastActivity(HttpSession session) {
        session.setAttribute("lastActivity", System.currentTimeMillis());
        
        // Verificar timeout de sessão (opcional)
        long lastActivity = (Long) session.getAttribute("lastActivity");
        long sessionTimeout = 30 * 60 * 1000; // 30 minutos
        
        if (System.currentTimeMillis() - lastActivity > sessionTimeout) {
            session.invalidate();
        }
    }
    
    /**
     * Log da requisição para debug
     */
    private void logRequest(HttpServletRequest request, String path) {
        if (shouldLogRequest(path)) {
            System.out.println(String.format("[AUTH] %s %s - User: %s", 
                request.getMethod(), 
                path,
                getUserFromSession(request)));
        }
    }
    
    /**
     * Verifica se deve logar a requisição
     */
    private boolean shouldLogRequest(String path) {
        // Não logar recursos estáticos
        return !isStaticResource(path) && 
               !path.startsWith("/assets/") &&
               !path.equals("/favicon.ico");
    }
    
    /**
     * Obtém usuário da sessão para log
     */
    private String getUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                return user.getEmail() + (user.isAdmin() ? " (Admin)" : " (User)");
            }
        }
        return "Anonymous";
    }
    
    /**
     * Verifica se usuário tem permissão específica
     */
    public static boolean hasPermission(HttpServletRequest request, String permission) {
        User user = (User) request.getAttribute("currentUser");
        if (user == null) return false;
        
        switch (permission) {
            case "ADMIN":
                return user.isAdmin();
            case "USER":
                return user.isAtivo();
            case "CREATE_BOOK":
                return user.isAdmin();
            case "EDIT_BOOK":
                return user.isAdmin();
            case "DELETE_BOOK":
                return user.isAdmin();
            case "MANAGE_CATEGORIES":
                return user.isAdmin();
            case "MANAGE_USERS":
                return user.isAdmin();
            case "VIEW_REPORTS":
                return user.isAdmin();
            default:
                return false;
        }
    }
    
    /**
     * Verifica se usuário pode acessar recurso específico
     */
    public static boolean canAccessResource(HttpServletRequest request, String resourceType, Long resourceId) {
        User user = (User) request.getAttribute("currentUser");
        if (user == null) return false;
        
        // Admin pode acessar tudo
        if (user.isAdmin()) return true;
        
        switch (resourceType) {
            case "ORDER":
                // Usuário só pode ver seus próprios pedidos
                // Aqui seria necessário verificar no banco se o pedido pertence ao usuário
                return true; // Implementar verificação específica
                
            case "PROFILE":
                // Usuário só pode ver/editar seu próprio perfil
                return user.getId().equals(resourceId);
                
            case "FAVORITE":
                // Usuário só pode gerenciar seus próprios favoritos
                return true; // Implementar verificação específica
                
            default:
                return false;
        }
    }
    
    /**
     * Método utilitário para verificar autenticação em servlets
     */
    public static User getAuthenticatedUser(HttpServletRequest request) {
        return (User) request.getAttribute("currentUser");
    }
    
    /**
     * Método utilitário para verificar se usuário está autenticado
     */
    public static boolean isAuthenticated(HttpServletRequest request) {
        Boolean authenticated = (Boolean) request.getAttribute("isAuthenticated");
        return authenticated != null && authenticated;
    }
    
    /**
     * Método utilitário para verificar se usuário é admin
     */
    public static boolean isAdmin(HttpServletRequest request) {
        Boolean admin = (Boolean) request.getAttribute("isAdmin");
        return admin != null && admin;
    }
    
    /**
     * Força logout do usuário
     */
    public static void forceLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    /**
     * Renova token de sessão (segurança)
     */
    public static void renewSession(HttpServletRequest request) {
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            // Salvar dados importantes
            User user = (User) oldSession.getAttribute("user");
            String redirectAfterLogin = (String) oldSession.getAttribute("redirectAfterLogin");
            
            // Invalidar sessão antiga
            oldSession.invalidate();
            
            // Criar nova sessão
            HttpSession newSession = request.getSession(true);
            if (user != null) {
                newSession.setAttribute("user", user);
                newSession.setAttribute("loginTime", System.currentTimeMillis());
                newSession.setAttribute("lastActivity", System.currentTimeMillis());
            }
            if (redirectAfterLogin != null) {
                newSession.setAttribute("redirectAfterLogin", redirectAfterLogin);
            }
        }
    }
}