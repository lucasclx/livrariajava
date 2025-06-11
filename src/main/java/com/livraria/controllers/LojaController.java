package com.livraria.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.CategoriaDAO;
import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import com.livraria.models.User;
import com.livraria.utils.PaginationUtil;

@WebServlet({"/", "/loja/*"})
public class LojaController extends BaseController {
    
    private LivroDAO livroDAO;
    private CategoriaDAO categoriaDAO;
    
    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        categoriaDAO = new CategoriaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();
        
        // Página inicial
        if (servletPath.equals("/") || pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
            mostrarPaginaInicial(request, response);
        } else if (pathInfo.equals("/catalogo")) {
            mostrarCatalogo(request, response);
        } else if (pathInfo.startsWith("/categoria/")) {
            String categoriaSlug = pathInfo.substring("/categoria/".length());
            mostrarCategoria(request, response, categoriaSlug);
        } else if (pathInfo.startsWith("/livro/")) {
            String livroIdStr = pathInfo.substring("/livro/".length());
            mostrarDetalhesLivro(request, response, Integer.parseInt(livroIdStr));
        } else if (pathInfo.equals("/buscar")) {
            buscarLivros(request, response);
        } else if (pathInfo.equals("/favoritos")) {
            mostrarFavoritos(request, response);
        } else if (pathInfo.equals("/busca-ajax")) {
            buscarLivrosAjax(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void mostrarPaginaInicial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Livros em destaque
            List<Livro> livrosDestaque = livroDAO.buscarDestaque(8);
            if (livrosDestaque.isEmpty()) {
                livrosDestaque = livroDAO.buscarMaisRecentes(8);
            }
            
            // 2. Livros mais vendidos
            List<Livro> livrosMaisVendidos = livroDAO.buscarMaisVendidos(6);
            if (livrosMaisVendidos.isEmpty()) {
                livrosMaisVendidos = livroDAO.buscarAleatorios(6);
            }
            
            // 3. Categorias com contagem de livros
            List<Categoria> categorias = categoriaDAO.listarAtivasComContagem(8);
            
            // 4. Ofertas especiais (livros em promoção)
            List<Livro> ofertas = livroDAO.buscarPromocoes(4);
            if (ofertas.isEmpty()) {
                ofertas = livroDAO.buscarPorPrecoMaximo(50.0, 4);
            }
            
            // 5. Estatísticas da loja
            int totalLivros = livroDAO.contarAtivos();
            int totalCategorias = categoriaDAO.contarAtivasComLivros();
            int totalAutores = livroDAO.contarAutoresAtivos();
            int livrosEstoque = livroDAO.somarEstoque();
            
            // 6. Catálogo completo (primeira página)
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            List<Livro> livrosCatalogo = livroDAO.listarAtivos(page, pageSize);
            int totalLivrosCatalogo = livroDAO.contarAtivos();
            
            // Preparar atributos
            request.setAttribute("livrosDestaque", livrosDestaque);
            request.setAttribute("livrosMaisVendidos", livrosMaisVendidos);
            request.setAttribute("categorias", categorias);
            request.setAttribute("ofertas", ofertas);
            request.setAttribute("totalLivros", totalLivros);
            request.setAttribute("totalCategorias", totalCategorias);
            request.setAttribute("totalAutores", totalAutores);
            request.setAttribute("livrosEstoque", livrosEstoque);
            request.setAttribute("livrosCatalogo", livrosCatalogo);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", PaginationUtil.calcularTotalPaginas(totalLivrosCatalogo, pageSize));
            
            request.getRequestDispatcher("/loja/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Em caso de erro, carregar página com dados vazios
            request.setAttribute("livrosDestaque", List.of());
            request.setAttribute("livrosMaisVendidos", List.of());
            request.setAttribute("categorias", List.of());
            request.setAttribute("ofertas", List.of());
            request.setAttribute("totalLivros", 0);
            request.setAttribute("totalCategorias", 0);
            request.setAttribute("totalAutores", 0);
            request.setAttribute("livrosEstoque", 0);
            request.setAttribute("livrosCatalogo", List.of());
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            
            request.getRequestDispatcher("/loja/index.jsp").forward(request, response);
        }
    }
    
    private void mostrarCatalogo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String busca = request.getParameter("busca");
            String categoriaParam = request.getParameter("categoria");
            Double precoMin = getDoubleParameter(request, "preco_min", null);
            Double precoMax = getDoubleParameter(request, "preco_max", null);
            Boolean disponivel = getBooleanParameter(request, "disponivel", null);
            Boolean promocao = getBooleanParameter(request, "promocao", null);
            String ordem = request.getParameter("ordem");
            String direcao = request.getParameter("direcao");
            
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            
            // Buscar livros com filtros
            List<Livro> livros = livroDAO.buscarComFiltrosCompletos(
                busca, categoriaParam, precoMin, precoMax, disponivel, promocao, 
                ordem, direcao, page, pageSize
            );
            
            int totalLivros = livroDAO.contarComFiltrosCompletos(
                busca, categoriaParam, precoMin, precoMax, disponivel, promocao
            );
            
            // Buscar categorias para filtros
            List<Categoria> categorias = categoriaDAO.listarAtivasComContagem();
            
            request.setAttribute("livros", livros);
            request.setAttribute("categorias", categorias);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", PaginationUtil.calcularTotalPaginas(totalLivros, pageSize));
            request.setAttribute("busca", busca);
            request.setAttribute("categoriaFiltro", categoriaParam);
            request.setAttribute("precoMin", precoMin);
            request.setAttribute("precoMax", precoMax);
            request.setAttribute("disponivel", disponivel);
            request.setAttribute("promocao", promocao);
            request.setAttribute("ordem", ordem);
            request.setAttribute("direcao", direcao);
            
            request.getRequestDispatcher("/loja/catalogo.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar catálogo", e);
        }
    }
    
    private void mostrarCategoria(HttpServletRequest request, HttpServletResponse response, String categoriaSlug)
            throws ServletException, IOException {
        
        try {
            // Buscar categoria pelo slug ou nome
            Categoria categoria = categoriaDAO.buscarPorSlugOuNome(categoriaSlug);
            if (categoria == null || !categoria.isAtivo()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoria não encontrada");
                return;
            }
            
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            
            List<Livro> livros = livroDAO.buscarPorCategoria(categoria.getId(), page, pageSize);
            int totalLivros = livroDAO.contarPorCategoria(categoria.getId());
            
            request.setAttribute("categoria", categoria);
            request.setAttribute("livros", livros);
            request.setAttribute("totalLivros", totalLivros);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", PaginationUtil.calcularTotalPaginas(totalLivros, pageSize));
            
            request.getRequestDispatcher("/loja/categoria.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar categoria", e);
        }
    }
    
    private void mostrarDetalhesLivro(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException {
        
        try {
            Livro livro = livroDAO.buscarPorIdComCategoria(livroId);
            if (livro == null || !livro.isAtivo()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
                return;
            }
            
            // Livros relacionados (mesma categoria)
            List<Livro> livrosRelacionados = List.of();
            if (livro.getCategoriaId() != null) {
                livrosRelacionados = livroDAO.buscarRelacionados(livro.getCategoriaId(), livroId, 4);
            }
            
            // Verificar se está nos favoritos do usuário
            boolean isFavorito = false;
            if (isAuthenticated(request)) {
                User user = getAuthenticatedUser(request);
                isFavorito = livroDAO.estaNosfavoritos(livroId, user.getId());
            }
            
            // Buscar avaliações do livro
            // List<Avaliacao> avaliacoes = avaliacaoDAO.buscarPorLivro(livroId, 1, 10);
            
            request.setAttribute("livro", livro);
            request.setAttribute("livrosRelacionados", livrosRelacionados);
            request.setAttribute("isFavorito", isFavorito);
            // request.setAttribute("avaliacoes", avaliacoes);
            
            request.getRequestDispatcher("/loja/detalhes.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar detalhes do livro", e);
        }
    }
    
    private void buscarLivros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String termo = request.getParameter("q");
            
            if (termo == null || termo.trim().isEmpty()) {
                redirectWithError(response, request.getContextPath() + "/loja/catalogo", 
                    "Digite um termo para buscar");
                return;
            }
            
            termo = termo.trim();
            if (termo.length() < 2) {
                redirectWithError(response, request.getContextPath() + "/loja/catalogo", 
                    "Digite pelo menos 2 caracteres para buscar");
                return;
            }
            
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            
            List<Livro> livros = livroDAO.buscarPorTermo(termo, page, pageSize);
            int totalLivros = livroDAO.contarPorTermo(termo);
            
            request.setAttribute("livros", livros);
            request.setAttribute("termo", termo);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", PaginationUtil.calcularTotalPaginas(totalLivros, pageSize));
            
            request.getRequestDispatcher("/loja/busca.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao buscar livros", e);
        }
    }
    
    private void mostrarFavoritos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAuthenticated(request)) {
            response.sendRedirect(request.getContextPath() + "/login?message=" + 
                java.net.URLEncoder.encode("Você precisa estar logado para ver seus favoritos", "UTF-8"));
            return;
        }
        
        try {
            User user = getAuthenticatedUser(request);
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            
            List<Livro> favoritos = livroDAO.buscarFavoritos(user.getId(), page, pageSize);
            int totalFavoritos = livroDAO.contarFavoritos(user.getId());
            
            request.setAttribute("favoritos", favoritos);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", PaginationUtil.calcularTotalPaginas(totalFavoritos, pageSize));
            
            request.getRequestDispatcher("/loja/favoritos.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar favoritos", e);
        }
    }
    
    private void buscarLivrosAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String termo = request.getParameter("q");
            
            if (termo == null || termo.trim().length() < 2) {
                sendJsonSuccess(response, List.of());
                return;
            }
            
            List<Livro> livros = livroDAO.buscarParaAutocomplete(termo, 8);
            sendJsonSuccess(response, livros);
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao buscar livros");
        }
    }
}