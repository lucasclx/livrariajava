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
 * Filtro de autenticação CORRIGIDO
 * Remove verificação desnecessária e corrige problemas de redirecionamento
 */
public class AuthenticationFilter implements Filter {
    
    // URLs que NÃO precisam de autenticação
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
        "/", "/index.jsp", "/login", "/register", "/logout",
        "/loja/", "/loja/catalogo", "/loja/categoria", "/loja/livro", "/loja/buscar",
        "/api/health", "/api/livros", "/api/categorias", "/debug",
        "/assets", "/css", "/js", "/images", "/uploads", "/favicon.ico"
    );
    
    // URLs que precisam de autenticação
    private static final List<String> PROTECTED_PATHS = Arrays.asList(
        "/perfil", "/cart", "/checkout", "/favorites"
    );
    
    // URLs que precisam de admin
    private static final List<String> ADMIN_PATHS = Arrays.asList(
        "/admin", "/livros", "/categorias", "/usuarios"
    );
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AuthenticationFilter] Inicializado");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remover context path para obter path relativo
        String path = requestURI;
        if (contextPath != null && !contextPath.isEmpty()) {
            path = requestURI.substring(contextPath.length());
        }
        
        // Log para debug
        logRequest(httpRequest, path);
        
        // Verificar se é recurso estático
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Verificar se é path público
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        // Obter usuário da sessão
        HttpSession session = httpRequest.getSession(false);
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }
        
        // Verificar se precisa de autenticação
        if (needsAuthentication(path)) {
            if (user == null) {
                handleUnauthenticated(httpRequest, httpResponse, path);
                return;
            }
        }
        
        // Verificar se precisa de admin
        if (needsAdminAccess(path)) {
            if (user == null || !user.isAdmin()) {
                handleUnauthorized(httpRequest, httpResponse);
                return;
            }
        }
        
        // Adicionar informações do usuário no request
        if (user != null) {
            httpRequest.setAttribute("currentUser", user);
            httpRequest.setAttribute("isAuthenticated", true);
            httpRequest.setAttribute("isAdmin", user.isAdmin());
        } else {
            httpRequest.setAttribute("isAuthenticated", false);
            httpRequest.setAttribute("isAdmin", false);
        }
        
        // Continuar com a requisição
        chain.doFilter(request, response);
    }
    
    private boolean isStaticResource(String path) {
        return path.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|map)$");
    }
    
    private boolean isPublicPath(String path) {
        // Verificar paths exatos
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || path.startsWith(publicPath + "/")) {
                return true;
            }
        }
        
        // Verificar se inicia com /api/ (APIs são públicas por padrão)
        if (path.startsWith("/api/")) {
            return true;
        }
        
        return false;
    }
    
    private boolean needsAuthentication(String path) {
        for (String protectedPath : PROTECTED_PATHS) {
            if (path.startsWith(protectedPath)) {
                return true;
            }
        }
        return false;
    }
    
    private boolean needsAdminAccess(String path) {
        for (String adminPath : ADMIN_PATHS) {
            if (path.startsWith(adminPath)) {
                return true;
            }
        }
        return false;
    }
    
    private void handleUnauthenticated(HttpServletRequest request, HttpServletResponse response, String path) 
            throws IOException {
        
        // Se for requisição AJAX, retornar JSON
        if (isAjaxRequest(request)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\": \"Não autenticado\", \"redirect\": \"/login\"}");
            return;
        }
        
        // Salvar URL de destino para redirecionamento após login
        HttpSession session = request.getSession(true);
        session.setAttribute("redirectAfterLogin", request.getRequestURL().toString());
        
        // Redirecionar para login
        response.sendRedirect(request.getContextPath() + "/login");
    }
    
    private void handleUnauthorized(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        if (isAjaxRequest(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\": \"Acesso negado\"}");
            return;
        }
        
        // Redirecionar para página de erro ou home
        response.sendRedirect(request.getContextPath() + "/");
    }
    
    private boolean isAjaxRequest(HttpServletRequest request) {
        String ajaxHeader = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return "XMLHttpRequest".equals(ajaxHeader) || 
               (accept != null && accept.contains("application/json"));
    }
    
    private void logRequest(HttpServletRequest request, String path) {
        // Log mais limpo
        HttpSession session = request.getSession(false);
        String userInfo = "Anonymous";
        
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                userInfo = user.getEmail() + (user.isAdmin() ? " (Admin)" : "");
            }
        }
        
        // Log apenas para paths importantes (não recursos estáticos)
        if (!isStaticResource(path)) {
            System.out.println(String.format("[AUTH] %s %s - User: %s", 
                request.getMethod(), path, userInfo));
        }
    }
    
    @Override
    public void destroy() {
        System.out.println("[AuthenticationFilter] Destruído");
    }
}