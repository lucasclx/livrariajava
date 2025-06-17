package com.livraria.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.CategoriaDAO;
import com.livraria.dao.FavoriteDAO;
import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import com.livraria.models.User;

// Adicionando a anotação que estava em falta
@WebServlet("/loja/*")
public class LojaController extends BaseController {
    
    private LivroDAO livroDAO;
    private CategoriaDAO categoriaDAO;
    private FavoriteDAO favoriteDAO;
    
    @Override
    public void init() {
        livroDAO = new LivroDAO();
        categoriaDAO = new CategoriaDAO();
        favoriteDAO = new FavoriteDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
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
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "ID de recurso inválido.");
        } catch (SQLException e) {
            throw new ServletException("Erro de banco de dados no LojaController", e);
        }
    }
    
    private void mostrarPaginaInicial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        List<Livro> livrosDestaque = livroDAO.buscarDestaque(4);
        List<Livro> livrosMaisVendidos = livroDAO.buscarMaisVendidos(4);
        List<Categoria> categorias = categoriaDAO.listarAtivasComContagem(8);
        
        request.setAttribute("livrosDestaque", livrosDestaque);
        request.setAttribute("livrosMaisVendidos", livrosMaisVendidos);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/WEB-INF/view/loja/index.jsp").forward(request, response);
    }
    
    private void mostrarCatalogo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        int page = getIntParameter(request, "page", 1);
        int pageSize = 12;

        List<Livro> livros = livroDAO.listarAtivos(page, pageSize);
        int totalLivros = livroDAO.contarAtivos();
        
        request.setAttribute("livros", livros);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalLivros / pageSize));
        request.setAttribute("baseUrl", request.getContextPath() + "/loja/catalogo");

        request.getRequestDispatcher("/WEB-INF/view/loja/catalogo.jsp").forward(request, response);
    }
    
    private void mostrarCategoria(HttpServletRequest request, HttpServletResponse response, String categoriaSlug)
            throws ServletException, IOException, SQLException {
        
        Categoria categoria = categoriaDAO.buscarPorSlugOuNome(categoriaSlug);
        if (categoria == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoria não encontrada");
            return;
        }

        int page = getIntParameter(request, "page", 1);
        int pageSize = 12;
        
        List<Livro> livros = livroDAO.buscarPorCategoria(categoria.getId(), page, pageSize);
        int totalLivros = livroDAO.contarPorCategoria(categoria.getId());

        request.setAttribute("categoria", categoria);
        request.setAttribute("livros", livros);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalLivros / pageSize));
        request.setAttribute("baseUrl", request.getContextPath() + "/loja/categoria/" + categoria.getSlug());

        request.getRequestDispatcher("/WEB-INF/view/loja/categoria.jsp").forward(request, response);
    }
    
    private void mostrarDetalhesLivro(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException, SQLException {
        
        Livro livro = livroDAO.buscarPorIdComCategoria(livroId);
        if (livro == null || !livro.isAtivo()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
            return;
        }
        
        List<Livro> livrosRelacionados = livroDAO.buscarRelacionados(livro.getCategoriaId(), livro.getId(), 4);
        
        boolean isFavorito = false;
        User user = getAuthenticatedUser(request);
        if (user != null) {
            isFavorito = favoriteDAO.verificarFavorito(user.getId(), livroId);
        }
        
        request.setAttribute("livro", livro);
        request.setAttribute("livrosRelacionados", livrosRelacionados);
        request.setAttribute("isFavorito", isFavorito);
        
        request.getRequestDispatcher("/WEB-INF/view/loja/detalhes.jsp").forward(request, response);
    }
    
    private void buscarLivros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        
        String termo = request.getParameter("q");
        if (termo == null || termo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/loja/catalogo");
            return;
        }

        int page = getIntParameter(request, "page", 1);
        int pageSize = 12;

        List<Livro> livros = livroDAO.buscarPorTermo(termo, page, pageSize);
        int totalLivros = livroDAO.contarPorTermo(termo);

        request.setAttribute("livros", livros);
        request.setAttribute("termo", termo);
        request.setAttribute("totalLivros", totalLivros);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", (int) Math.ceil((double) totalLivros / pageSize));
        request.setAttribute("baseUrl", request.getContextPath() + "/loja/buscar?q=" + java.net.URLEncoder.encode(termo, "UTF-8"));
        
        request.getRequestDispatcher("/WEB-INF/view/loja/busca.jsp").forward(request, response);
    }
}