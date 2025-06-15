package com.livraria.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.util.Enumeration;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.livraria.utils.ConnectionFactory;
import com.livraria.models.User;

/**
 * Servlet de debug melhorado para diagnosticar problemas
 */
@WebServlet("/debug")
public class DebugServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html><head><title>Debug - Livraria</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 20px; }");
            out.println(".section { margin-bottom: 30px; border: 1px solid #ddd; padding: 15px; }");
            out.println(".ok { color: green; }");
            out.println(".error { color: red; }");
            out.println(".warning { color: orange; }");
            out.println("table { border-collapse: collapse; width: 100%; }");
            out.println("th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }");
            out.println("th { background-color: #f2f2f2; }");
            out.println("</style></head><body>");
            
            out.println("<h1>🔧 Debug da Aplicação Livraria</h1>");
            
            // Informações do Sistema
            debugSystemInfo(out);
            
            // Informações da Requisição
            debugRequestInfo(out, request);
            
            // Informações da Sessão
            debugSessionInfo(out, request);
            
            // Teste de Conexão com Banco
            debugDatabaseConnection(out);
            
            // Informações do Servlet Context
            debugServletContext(out, request);
            
            // Status das Rotas
            debugRouteStatus(out, request);
            
            out.println("</body></html>");
            
        } catch (Exception e) {
            out.println("<div class='error'>ERRO: " + e.getMessage() + "</div>");
            e.printStackTrace(out);
        } finally {
            out.close();
        }
    }
    
    private void debugSystemInfo(PrintWriter out) {
        out.println("<div class='section'>");
        out.println("<h2>🖥️ Informações do Sistema</h2>");
        out.println("<table>");
        out.println("<tr><th>Propriedade</th><th>Valor</th></tr>");
        out.println("<tr><td>Java Version</td><td>" + System.getProperty("java.version") + "</td></tr>");
        out.println("<tr><td>Java Vendor</td><td>" + System.getProperty("java.vendor") + "</td></tr>");
        out.println("<tr><td>OS Name</td><td>" + System.getProperty("os.name") + "</td></tr>");
        out.println("<tr><td>OS Version</td><td>" + System.getProperty("os.version") + "</td></tr>");
        out.println("<tr><td>User Dir</td><td>" + System.getProperty("user.dir") + "</td></tr>");
        out.println("<tr><td>Catalina Base</td><td>" + System.getProperty("catalina.base") + "</td></tr>");
        out.println("<tr><td>Catalina Home</td><td>" + System.getProperty("catalina.home") + "</td></tr>");
        out.println("</table>");
        out.println("</div>");
    }
    
    private void debugRequestInfo(PrintWriter out, HttpServletRequest request) {
        out.println("<div class='section'>");
        out.println("<h2>📡 Informações da Requisição</h2>");
        out.println("<table>");
        out.println("<tr><th>Propriedade</th><th>Valor</th></tr>");
        out.println("<tr><td>Request URL</td><td>" + request.getRequestURL() + "</td></tr>");
        out.println("<tr><td>Request URI</td><td>" + request.getRequestURI() + "</td></tr>");
        out.println("<tr><td>Context Path</td><td>" + request.getContextPath() + "</td></tr>");
        out.println("<tr><td>Servlet Path</td><td>" + request.getServletPath() + "</td></tr>");
        out.println("<tr><td>Path Info</td><td>" + request.getPathInfo() + "</td></tr>");
        out.println("<tr><td>Query String</td><td>" + request.getQueryString() + "</td></tr>");
        out.println("<tr><td>Method</td><td>" + request.getMethod() + "</td></tr>");
        out.println("<tr><td>Remote Addr</td><td>" + request.getRemoteAddr() + "</td></tr>");
        out.println("<tr><td>User Agent</td><td>" + request.getHeader("User-Agent") + "</td></tr>");
        out.println("</table>");
        
        out.println("<h3>Headers</h3>");
        out.println("<table>");
        out.println("<tr><th>Header</th><th>Valor</th></tr>");
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String headerName = headerNames.nextElement();
            out.println("<tr><td>" + headerName + "</td><td>" + request.getHeader(headerName) + "</td></tr>");
        }
        out.println("</table>");
        out.println("</div>");
    }
    
    private void debugSessionInfo(PrintWriter out, HttpServletRequest request) {
        out.println("<div class='section'>");
        out.println("<h2>🔐 Informações da Sessão</h2>");
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            out.println("<table>");
            out.println("<tr><th>Propriedade</th><th>Valor</th></tr>");
            out.println("<tr><td>Session ID</td><td>" + session.getId() + "</td></tr>");
            out.println("<tr><td>Creation Time</td><td>" + new java.util.Date(session.getCreationTime()) + "</td></tr>");
            out.println("<tr><td>Last Accessed</td><td>" + new java.util.Date(session.getLastAccessedTime()) + "</td></tr>");
            out.println("<tr><td>Max Inactive Interval</td><td>" + session.getMaxInactiveInterval() + " segundos</td></tr>");
            out.println("<tr><td>Is New</td><td>" + session.isNew() + "</td></tr>");
            out.println("</table>");
            
            out.println("<h3>Atributos da Sessão</h3>");
            out.println("<table>");
            out.println("<tr><th>Atributo</th><th>Valor</th><th>Tipo</th></tr>");
            
            Enumeration<String> attributeNames = session.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String attrName = attributeNames.nextElement();
                Object attrValue = session.getAttribute(attrName);
                String valueStr = attrValue != null ? attrValue.toString() : "null";
                String typeStr = attrValue != null ? attrValue.getClass().getSimpleName() : "null";
                
                if (attrValue instanceof User) {
                    User user = (User) attrValue;
                    valueStr = "User{id=" + user.getId() + ", name='" + user.getName() + "', admin=" + user.isAdmin() + "}";
                }
                
                out.println("<tr><td>" + attrName + "</td><td>" + valueStr + "</td><td>" + typeStr + "</td></tr>");
            }
            out.println("</table>");
        } else {
            out.println("<div class='warning'>Nenhuma sessão ativa</div>");
        }
        out.println("</div>");
    }
    
    private void debugDatabaseConnection(PrintWriter out) {
        out.println("<div class='section'>");
        out.println("<h2>🗄️ Conexão com Banco de Dados</h2>");
        
        try (Connection conn = ConnectionFactory.getConnection()) {
            out.println("<div class='ok'>✅ Conexão estabelecida com sucesso!</div>");
            
            DatabaseMetaData metaData = conn.getMetaData();
            out.println("<table>");
            out.println("<tr><th>Propriedade</th><th>Valor</th></tr>");
            out.println("<tr><td>Database Product</td><td>" + metaData.getDatabaseProductName() + "</td></tr>");
            out.println("<tr><td>Database Version</td><td>" + metaData.getDatabaseProductVersion() + "</td></tr>");
            out.println("<tr><td>Driver Name</td><td>" + metaData.getDriverName() + "</td></tr>");
            out.println("<tr><td>Driver Version</td><td>" + metaData.getDriverVersion() + "</td></tr>");
            out.println("<tr><td>URL</td><td>" + metaData.getURL() + "</td></tr>");
            out.println("<tr><td>Username</td><td>" + metaData.getUserName() + "</td></tr>");
            out.println("<tr><td>Auto Commit</td><td>" + conn.getAutoCommit() + "</td></tr>");
            out.println("<tr><td>Read Only</td><td>" + conn.isReadOnly() + "</td></tr>");
            out.println("</table>");
            
        } catch (Exception e) {
            out.println("<div class='error'>❌ Erro na conexão: " + e.getMessage() + "</div>");
            out.println("<pre>");
            e.printStackTrace(new PrintWriter(out));
            out.println("</pre>");
        }
        out.println("</div>");
    }
    
    private void debugServletContext(PrintWriter out, HttpServletRequest request) {
        out.println("<div class='section'>");
        out.println("<h2>🌐 Servlet Context</h2>");
        
        out.println("<table>");
        out.println("<tr><th>Propriedade</th><th>Valor</th></tr>");
        out.println("<tr><td>Context Path</td><td>" + request.getContextPath() + "</td></tr>");
        out.println("<tr><td>Server Info</td><td>" + getServletContext().getServerInfo() + "</td></tr>");
        out.println("<tr><td>Servlet Context Name</td><td>" + getServletContext().getServletContextName() + "</td></tr>");
        out.println("<tr><td>Real Path</td><td>" + getServletContext().getRealPath("/") + "</td></tr>");
        out.println("</table>");
        
        out.println("<h3>Init Parameters</h3>");
        out.println("<table>");
        out.println("<tr><th>Parâmetro</th><th>Valor</th></tr>");
        Enumeration<String> initParams = getServletContext().getInitParameterNames();
        while (initParams.hasMoreElements()) {
            String paramName = initParams.nextElement();
            out.println("<tr><td>" + paramName + "</td><td>" + getServletContext().getInitParameter(paramName) + "</td></tr>");
        }
        out.println("</table>");
        out.println("</div>");
    }
    
    private void debugRouteStatus(PrintWriter out, HttpServletRequest request) {
        out.println("<div class='section'>");
        out.println("<h2>🛤️ Status das Rotas</h2>");
        
        String[] routes = {
            "/", "/loja/", "/loja/catalogo", "/login", "/register", "/logout",
            "/admin/", "/api/health", "/api/livros", "/api/categorias",
            "/cart/", "/favorites/", "/perfil/"
        };
        
        out.println("<table>");
        out.println("<tr><th>Rota</th><th>Status</th><th>Descrição</th></tr>");
        
        for (String route : routes) {
            String fullUrl = request.getScheme() + "://" + request.getServerName() + 
                           ":" + request.getServerPort() + request.getContextPath() + route;
            
            String status = "📝 Não testada";
            String description = "Rota padrão do sistema";
            
            if (route.equals("/")) {
                status = "🔄 IndexServlet";
                description = "Página inicial - pode estar causando redirecionamentos incorretos";
            } else if (route.startsWith("/loja/")) {
                status = "🏪 LojaController";
                description = "Controlador da loja - verificar mapeamento";
            } else if (route.startsWith("/api/")) {
                status = "🔌 API";
                description = "Endpoints da API REST";
            } else if (route.startsWith("/admin/")) {
                status = "🔒 Admin";
                description = "Área administrativa - requer autenticação";
            }
            
            out.println("<tr><td><a href='" + fullUrl + "' target='_blank'>" + route + "</a></td>");
            out.println("<td>" + status + "</td>");
            out.println("<td>" + description + "</td></tr>");
        }
        out.println("</table>");
        
        out.println("<div class='warning'>");
        out.println("<h3>⚠️ Possíveis Problemas Detectados:</h3>");
        out.println("<ul>");
        out.println("<li>IndexServlet pode estar interferindo com outras rotas</li>");
        out.println("<li>Múltiplos redirecionamentos para index.jsp detectados nos logs</li>");
        out.println("<li>Verificar se web.xml está configurado corretamente</li>");
        out.println("<li>Considerar usar filtros em vez de múltiplos servlets para autenticação</li>");
        out.println("</ul>");
        out.println("</div>");
        
        out.println("</div>");
    }
}