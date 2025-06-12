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

@WebServlet("/search")
public class SearchController extends BaseController {
    
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
        
        String query = request.getParameter("q");
        String categoria = request.getParameter("categoria");
        String precoMin = request.getParameter("preco_min");
        String precoMax = request.getParameter("preco_max");
        String ordenacao = request.getParameter("ordem");
        int page = getIntParameter(request, "page", 1);
        int pageSize = 12;
        
        try {
            SearchResult result = realizarBusca(query, categoria, precoMin, precoMax, ordenacao, page, pageSize);
            
            // Carregar categorias para filtros
            List<Categoria> categorias = categoriaDAO.listarAtivas();
            
            // Salvar histórico de busca (se houver query)
            if (query != null && !query.trim().isEmpty()) {
                salvarHistoricoBusca(request, query);
            }
            
            // Sugestões se não houver resultados
            List<Livro> sugestoes = new ArrayList<>();
            if (result.getLivros().isEmpty() && query != null && !query.trim().isEmpty()) {
                sugestoes = obterSugestoesSemResultado(query);
            }
            
            request.setAttribute("livros", result.getLivros());
            request.setAttribute("totalLivros", result.getTotal());
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) result.getTotal() / pageSize));
            request.setAttribute("categorias", categorias);
            request.setAttribute("sugestoes", sugestoes);
            
            // Preservar parâmetros de busca
            request.setAttribute("query", query);
            request.setAttribute("categoriaFiltro", categoria);
            request.setAttribute("precoMin", precoMin);
            request.setAttribute("precoMax", precoMax);
            request.setAttribute("ordenacao", ordenacao);
            
            request.getRequestDispatcher("/WEB-INF/view/loja/busca.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao realizar busca", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Busca por POST - redirecionar para GET
        String query = request.getParameter("q");
        if (query != null && !query.trim().isEmpty()) {
            String redirectUrl = request.getContextPath() + "/search?q=" + 
                                java.net.URLEncoder.encode(query, "UTF-8");
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/loja/catalogo");
        }
    }
    
    /**
     * Realiza busca com filtros
     */
    private SearchResult realizarBusca(String query, String categoria, String precoMin, 
                                     String precoMax, String ordenacao, int page, int pageSize) 
            throws Exception {
        
        List<Livro> livros;
        int total;
        
        if (query == null || query.trim().isEmpty()) {
            // Busca sem termo - listar todos com filtros
            livros = livroDAO.buscarComFiltrosAvancados(null, categoria, precoMin, precoMax, 
                                                       ordenacao, page, pageSize);
            total = livroDAO.contarComFiltrosAvancados(null, categoria, precoMin, precoMax);
        } else {
            // Busca com termo
            livros = livroDAO.buscarComFiltrosAvancados(query, categoria, precoMin, precoMax, 
                                                       ordenacao, page, pageSize);
            total = livroDAO.contarComFiltrosAvancados(query, categoria, precoMin, precoMax);
        }
        
        return new SearchResult(livros, total, query);
    }
    
    /**
     * Salva histórico de busca na sessão
     */
    private void salvarHistoricoBusca(HttpServletRequest request, String query) {
        @SuppressWarnings("unchecked")
        List<String> historico = (List<String>) request.getSession().getAttribute("search_history");
        
        if (historico == null) {
            historico = new ArrayList<>();
        }
        
        // Remove se já existe
        historico.remove(query);
        
        // Adiciona no início
        historico.add(0, query);
        
        // Limita a 10 itens
        if (historico.size() > 10) {
            historico = historico.subList(0, 10);
        }
        
        request.getSession().setAttribute("search_history", historico);
    }
    
    /**
     * Obtém sugestões quando não há resultados
     */
    private List<Livro> obterSugestoesSemResultado(String query) throws Exception {
        // Buscar livros similares por palavras-chave
        String[] palavras = query.toLowerCase().split("\\s+");
        List<Livro> sugestoes = new ArrayList<>();
        
        for (String palavra : palavras) {
            if (palavra.length() > 2) {
                List<Livro> parciais = livroDAO.buscarPorTermo(palavra, 1, 5);
                for (Livro livro : parciais) {
                    if (!sugestoes.contains(livro)) {
                        sugestoes.add(livro);
                    }
                }
                if (sugestoes.size() >= 8) break;
            }
        }
        
        // Se ainda não tem sugestões, buscar livros populares
        if (sugestoes.isEmpty()) {
            sugestoes = livroDAO.buscarMaisVendidos(6);
        }
        
        return sugestoes;
    }
    
    /**
     * Classe para resultado de busca
     */
    public static class SearchResult {
        private List<Livro> livros;
        private int total;
        private String query;
        
        public SearchResult(List<Livro> livros, int total, String query) {
            this.livros = livros;
            this.total = total;
            this.query = query;
        }
        
        public List<Livro> getLivros() { return livros; }
        public int getTotal() { return total; }
        public String getQuery() { return query; }
    }
}