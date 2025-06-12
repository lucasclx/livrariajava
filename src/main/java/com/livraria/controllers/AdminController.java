package com.livraria.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.CategoriaDAO;
import com.livraria.dao.UserDAO;
import com.livraria.dao.OrderDAO;
import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import com.livraria.models.User;
import com.livraria.models.Order;

@WebServlet("/admin/*")
public class AdminController extends BaseController {
    
    private LivroDAO livroDAO;
    private CategoriaDAO categoriaDAO;
    private UserDAO userDAO;
    private OrderDAO orderDAO;
    
    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        categoriaDAO = new CategoriaDAO();
        userDAO = new UserDAO();
        orderDAO = new OrderDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAdminAccess(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/dashboard")) {
            mostrarDashboard(request, response);
        } else if (pathInfo.equals("/relatorios")) {
            mostrarRelatorios(request, response);
        } else if (pathInfo.equals("/usuarios")) {
            mostrarUsuarios(request, response);
        } else if (pathInfo.equals("/pedidos")) {
            mostrarPedidos(request, response);
        } else if (pathInfo.startsWith("/pedidos/")) {
            String idStr = pathInfo.substring("/pedidos/".length());
            mostrarDetalhesPedido(request, response, Integer.parseInt(idStr));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAdminAccess(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.startsWith("/pedidos/") && pathInfo.endsWith("/status")) {
            String idStr = pathInfo.substring("/pedidos/".length()).replace("/status", "");
            atualizarStatusPedido(request, response, Integer.parseInt(idStr));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Estatísticas principais
            int totalLivros = livroDAO.contar();
            int livrosEstoque = livroDAO.contarComEstoque();
            int estoqueBaixo = livroDAO.contarEstoqueBaixo();
            BigDecimal valorEstoque = livroDAO.calcularValorTotalEstoque();
            
            int totalCategorias = categoriaDAO.contar();
            int totalUsuarios = userDAO.contar();
            int totalPedidos = orderDAO.contar();
            BigDecimal faturamentoMes = orderDAO.calcularFaturamentoMesAtual();
            
            // Livros com estoque baixo
            List<Livro> livrosEstoqueBaixo = livroDAO.buscarEstoqueBaixo(10);
            
            // Livros sem estoque
            List<Livro> livrosSemEstoque = livroDAO.buscarSemEstoque(10);
            
            // Últimos pedidos
            List<Order> ultimosPedidos = orderDAO.buscarUltimos(10);
            
            // Livros mais vendidos no mês
            List<Livro> livrosMaisVendidos = livroDAO.buscarMaisVendidosMes(10);
            
            request.setAttribute("totalLivros", totalLivros);
            request.setAttribute("livrosEstoque", livrosEstoque);
            request.setAttribute("estoqueBaixo", estoqueBaixo);
            request.setAttribute("valorEstoque", valorEstoque);
            request.setAttribute("totalCategorias", totalCategorias);
            request.setAttribute("totalUsuarios", totalUsuarios);
            request.setAttribute("totalPedidos", totalPedidos);
            request.setAttribute("faturamentoMes", faturamentoMes);
            request.setAttribute("livrosEstoqueBaixo", livrosEstoqueBaixo);
            request.setAttribute("livrosSemEstoque", livrosSemEstoque);
            request.setAttribute("ultimosPedidos", ultimosPedidos);
            request.setAttribute("livrosMaisVendidos", livrosMaisVendidos);
            
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar dashboard", e);
        }
    }
    
    private void mostrarRelatorios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String periodo = request.getParameter("periodo");
            if (periodo == null) periodo = "30"; // 30 dias por padrão
            
            int dias = Integer.parseInt(periodo);
            
            // Métricas do período
            BigDecimal vendasTotal = orderDAO.calcularVendasPeriodo(dias);
            int pedidosTotal = orderDAO.contarPedidosPeriodo(dias);
            BigDecimal ticketMedio = pedidosTotal > 0 ? 
                vendasTotal.divide(new BigDecimal(pedidosTotal), 2, BigDecimal.ROUND_HALF_UP) : 
                BigDecimal.ZERO;
            int livrosVendidos = orderDAO.contarLivrosVendidosPeriodo(dias);
            int novosUsuarios = userDAO.contarNovosPeriodo(dias);
            
            // Top livros mais vendidos
            List<Livro> topLivros = livroDAO.buscarMaisVendidosPeriodo(dias, 10);
            
            // Vendas por categoria
            List<Object[]> vendasCategoria = orderDAO.calcularVendasPorCategoria(dias);
            
            // Vendas diárias
            List<Object[]> vendasDiarias = orderDAO.calcularVendasDiarias(dias);
            
            request.setAttribute("periodo", periodo);
            request.setAttribute("vendasTotal", vendasTotal);
            request.setAttribute("pedidosTotal", pedidosTotal);
            request.setAttribute("ticketMedio", ticketMedio);
            request.setAttribute("livrosVendidos", livrosVendidos);
            request.setAttribute("novosUsuarios", novosUsuarios);
            request.setAttribute("topLivros", topLivros);
            request.setAttribute("vendasCategoria", vendasCategoria);
            request.setAttribute("vendasDiarias", vendasDiarias);
            
            request.getRequestDispatcher("/admin/relatorios.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar relatórios", e);
        }
    }
    
    private void mostrarUsuarios(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String busca = request.getParameter("busca");
            String status = request.getParameter("status");
            int page = getIntParameter(request, "page", 1);
            int pageSize = 20;
            
            List<User> usuarios = userDAO.buscarComFiltros(busca, status, page, pageSize);
            int totalUsuarios = userDAO.contarComFiltros(busca, status);
            
            request.setAttribute("usuarios", usuarios);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalUsuarios / pageSize));
            request.setAttribute("busca", busca);
            request.setAttribute("statusFiltro", status);
            
            request.getRequestDispatcher("/admin/usuarios.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar usuários", e);
        }
    }
    
    private void mostrarPedidos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String status = request.getParameter("status");
            String dataInicio = request.getParameter("data_inicio");
            String dataFim = request.getParameter("data_fim");
            int page = getIntParameter(request, "page", 1);
            int pageSize = 20;
            
            List<Order> pedidos = orderDAO.buscarComFiltros(status, dataInicio, dataFim, page, pageSize);
            int totalPedidos = orderDAO.contarComFiltros(status, dataInicio, dataFim);
            
            request.setAttribute("pedidos", pedidos);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalPedidos / pageSize));
            request.setAttribute("statusFiltro", status);
            request.setAttribute("dataInicio", dataInicio);
            request.setAttribute("dataFim", dataFim);
            
            request.getRequestDispatcher("/admin/pedidos.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar pedidos", e);
        }
    }
    
    private void mostrarDetalhesPedido(HttpServletRequest request, HttpServletResponse response, int pedidoId)
            throws ServletException, IOException {
        
        try {
            Order pedido = orderDAO.buscarPorIdCompleto(pedidoId);
            if (pedido == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Pedido não encontrado");
                return;
            }
            
            request.setAttribute("pedido", pedido);
            request.getRequestDispatcher("/admin/pedido-detalhes.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar detalhes do pedido", e);
        }
    }
    
    private void atualizarStatusPedido(HttpServletRequest request, HttpServletResponse response, int pedidoId)
            throws ServletException, IOException {
        
        try {
            Order pedido = orderDAO.buscarPorId(pedidoId);
            if (pedido == null) {
                sendJsonError(response, "Pedido não encontrado");
                return;
            }
            
            String novoStatus = getRequiredParameter(request, "status");
            String observacoes = request.getParameter("observacoes");
            
            // Validar status
            if (!isValidOrderStatus(novoStatus)) {
                sendJsonError(response, "Status inválido");
                return;
            }
            
            // Atualizar status
            orderDAO.atualizarStatus(pedidoId, novoStatus, observacoes);
            
            // Se for cancelamento, devolver estoque
            if ("cancelled".equals(novoStatus) && !"cancelled".equals(pedido.getStatus())) {
                orderDAO.devolverEstoque(pedidoId);
            }
            
            sendJsonSuccess(response, "Status do pedido atualizado com sucesso!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao atualizar status: " + e.getMessage());
        }
    }
    
    private boolean isValidOrderStatus(String status) {
        String[] validStatuses = {
            "pending_payment", "confirmed", "preparing", "shipped", 
            "delivered", "cancelled", "payment_failed"
        };
        
        for (String validStatus : validStatuses) {
            if (validStatus.equals(status)) {
                return true;
            }
        }
        return false;
    }
}