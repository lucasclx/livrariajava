package com.livraria.controllers;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.CategoriaDAO;
import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import com.livraria.models.User;

/**
 * Controller para a loja/catálogo público
 */
@WebServlet(name = "LojaController", urlPatterns = {"/loja/*"})
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
        
        // Log para debug
        System.out.println("LojaController - pathInfo: " + pathInfo);
        System.out.println("LojaController - requestURI: " + request.getRequestURI());
        System.out.println("LojaController - contextPath: " + request.getContextPath());
        
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
                try {
                    int livroId = Integer.parseInt(livroIdStr);
                    mostrarDetalhesLivro(request, response, livroId);
                } catch (NumberFormatException e) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            } else if (pathInfo.equals("/buscar")) {
                buscarLivros(request, response);
            } else if (pathInfo.equals("/favoritos")) {
                mostrarFavoritos(request, response);
            } else if (pathInfo.equals("/busca-ajax")) {
                buscarLivrosAjax(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erro no LojaController", e);
        }
    }
    
    private void mostrarPaginaInicial(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Dados fictícios para teste
            List<Livro> livrosDestaque = criarLivrosFicticios();
            List<Livro> livrosMaisVendidos = criarLivrosFicticios();
            List<Categoria> categorias = criarCategoriasFicticias();
            List<Livro> ofertas = criarLivrosFicticios();
            
            // Estatísticas
            int totalLivros = 150;
            int totalCategorias = 12;
            int totalAutores = 85;
            int livrosEstoque = 120;
            
            // Preparar atributos
            request.setAttribute("livrosDestaque", livrosDestaque);
            request.setAttribute("livrosMaisVendidos", livrosMaisVendidos);
            request.setAttribute("categorias", categorias);
            request.setAttribute("ofertas", ofertas);
            request.setAttribute("totalLivros", totalLivros);
            request.setAttribute("totalCategorias", totalCategorias);
            request.setAttribute("totalAutores", totalAutores);
            request.setAttribute("livrosEstoque", livrosEstoque);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Em caso de erro, carregar página com dados vazios
            request.setAttribute("livrosDestaque", new ArrayList<>());
            request.setAttribute("livrosMaisVendidos", new ArrayList<>());
            request.setAttribute("categorias", new ArrayList<>());
            request.setAttribute("ofertas", new ArrayList<>());
            request.setAttribute("totalLivros", 0);
            request.setAttribute("totalCategorias", 0);
            request.setAttribute("totalAutores", 0);
            request.setAttribute("livrosEstoque", 0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/index.jsp").forward(request, response);
        }
    }
    
    private void mostrarCatalogo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String busca = request.getParameter("busca");
            String categoriaParam = request.getParameter("categoria");
            String ordem = request.getParameter("ordem");
            
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;
            
            // Dados fictícios para teste
            List<Livro> livros = criarLivrosFicticios();
            List<Categoria> categorias = criarCategoriasFicticias();
            
            request.setAttribute("livros", livros);
            request.setAttribute("categorias", categorias);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", 1);
            request.setAttribute("busca", busca);
            request.setAttribute("categoriaFiltro", categoriaParam);
            request.setAttribute("ordem", ordem);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/catalogo.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar catálogo", e);
        }
    }
    
    private void mostrarCategoria(HttpServletRequest request, HttpServletResponse response, String categoriaSlug)
            throws ServletException, IOException {
        
        try {
            // Simular categoria
            Categoria categoria = new Categoria();
            categoria.setId(1);
            categoria.setNome("Ficção");
            categoria.setDescricao("Livros de ficção e literatura");
            categoria.setSlug("ficcao");
            categoria.setAtivo(true);
            
            List<Livro> livros = criarLivrosFicticios();
            
            request.setAttribute("categoria", categoria);
            request.setAttribute("livros", livros);
            request.setAttribute("totalLivros", livros.size());
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/categoria.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar categoria", e);
        }
    }
    
    private void mostrarDetalhesLivro(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException {
        
        try {
            // Simular livro
            Livro livro = criarLivroFicticio();
            livro.setId(livroId);
            
            List<Livro> livrosRelacionados = criarLivrosFicticios();
            
            boolean isFavorito = false;
            if (isAuthenticated(request)) {
                User user = getAuthenticatedUser(request);
                // Verificar favoritos
            }
            
            request.setAttribute("livro", livro);
            request.setAttribute("livrosRelacionados", livrosRelacionados);
            request.setAttribute("isFavorito", isFavorito);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/detalhes.jsp").forward(request, response);
            
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
            
            List<Livro> livros = criarLivrosFicticios();
            
            request.setAttribute("livros", livros);
            request.setAttribute("termo", termo);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/busca.jsp").forward(request, response);
            
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
            List<Livro> favoritos = criarLivrosFicticios();
            
            request.setAttribute("favoritos", favoritos);
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);
            
            request.getRequestDispatcher("/WEB-INF/views/loja/favoritos.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar favoritos", e);
        }
    }
    
    private void buscarLivrosAjax(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String termo = request.getParameter("q");
            
            if (termo == null || termo.trim().length() < 2) {
                sendJsonSuccess(response, new ArrayList<>());
                return;
            }
            
            List<Livro> livros = criarLivrosFicticios();
            sendJsonSuccess(response, livros);
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao buscar livros");
        }
    }
    
    // Métodos auxiliares para criar dados fictícios
    private List<Livro> criarLivrosFicticios() {
        List<Livro> livros = new ArrayList<>();
        
        for (int i = 1; i <= 8; i++) {
            Livro livro = criarLivroFicticio();
            livro.setId(i);
            livro.setTitulo("Livro Exemplo " + i);
            livros.add(livro);
        }
        
        return livros;
    }
    
    private Livro criarLivroFicticio() {
        Livro livro = new Livro();
        livro.setId(1);
        livro.setTitulo("O Senhor dos Anéis");
        livro.setAutor("J.R.R. Tolkien");
        livro.setEditora("HarperCollins");
        livro.setPreco(java.math.BigDecimal.valueOf(45.90));
        livro.setEstoque(10);
        livro.setSinopse("Uma épica jornada pela Terra Média...");
        livro.setAtivo(true);
        
        return livro;
    }
    
    private List<Categoria> criarCategoriasFicticias() {
        List<Categoria> categorias = new ArrayList<>();
        
        String[] nomes = {"Ficção", "Romance", "Técnico", "História", "Biografias", "Infantil"};
        
        for (int i = 0; i < nomes.length; i++) {
            Categoria categoria = new Categoria();
            categoria.setId(i + 1);
            categoria.setNome(nomes[i]);
            categoria.setSlug(nomes[i].toLowerCase());
            categoria.setAtivo(true);
            categoria.setLivrosCount(10 + i * 5);
            categorias.add(categoria);
        }
        
        return categorias;
    }
}