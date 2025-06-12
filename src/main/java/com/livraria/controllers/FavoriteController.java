package com.livraria.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.FavoriteDAO;
import com.livraria.models.Livro;
import com.livraria.models.User;

@WebServlet("/favorites/*")
public class FavoriteController extends BaseController {

    private LivroDAO livroDAO;
    private FavoriteDAO favoriteDAO;

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        favoriteDAO = new FavoriteDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        checkAuthentication(request, response);

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
            listarFavoritos(request, response);
        } else if (pathInfo.equals("/count")) {
            contarFavoritos(request, response);
        } else if (pathInfo.equals("/suggestions")) {
            obterSugestoes(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        checkAuthentication(request, response);

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/toggle/")) {
            String idStr = pathInfo.substring("/toggle/".length());
            toggleFavorite(request, response, Integer.parseInt(idStr));
        } else if (pathInfo != null && pathInfo.startsWith("/add/")) {
            String idStr = pathInfo.substring("/add/".length());
            adicionarFavorito(request, response, Integer.parseInt(idStr));
        } else if (pathInfo != null && pathInfo.startsWith("/remove/")) {
            String idStr = pathInfo.substring("/remove/".length());
            removerFavorito(request, response, Integer.parseInt(idStr));
        } else if (pathInfo != null && pathInfo.equals("/clear")) {
            limparFavoritos(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    /**
     * Lista favoritos do usuário
     */
    private void listarFavoritos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);
            int page = getIntParameter(request, "page", 1);
            int pageSize = 12;

            List<Livro> favoritos = favoriteDAO.listarFavoritos(user.getId(), page, pageSize);
            int totalFavoritos = favoriteDAO.contarFavoritos(user.getId());

            // Buscar sugestões se não tem favoritos
            List<Livro> sugestoes = null;
            if (favoritos.isEmpty()) {
                sugestoes = livroDAO.buscarMaisVendidos(8);
            } else {
                sugestoes = favoriteDAO.buscarSugestoesPorFavoritos(user.getId(), 4);
            }

            request.setAttribute("favoritos", favoritos);
            request.setAttribute("sugestoes", sugestoes);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalFavoritos / pageSize));
            request.setAttribute("totalFavoritos", totalFavoritos);

            request.getRequestDispatcher("/WEB-INF/view/loja/favoritos.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Erro ao carregar favoritos", e);
        }
    }

    /**
     * Toggle favorito (adiciona se não existe, remove se existe)
     */
    private void toggleFavorite(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);

            // Verificar se o livro existe e está ativo
            Livro livro = livroDAO.buscarPorId(livroId);
            if (livro == null || !livro.isAtivo()) {
                sendJsonError(response, "Livro não encontrado ou não disponível");
                return;
            }

            // Verificar se já está nos favoritos
            boolean jaEstaNosFavoritos = favoriteDAO.verificarFavorito(user.getId(), livroId);

            boolean favorited;
            String message;

            if (jaEstaNosFavoritos) {
                // Remover dos favoritos
                favoriteDAO.remover(user.getId(), livroId);
                favorited = false;
                message = "Livro removido dos favoritos";
            } else {
                // Adicionar aos favoritos
                favoriteDAO.adicionar(user.getId(), livroId);
                favorited = true;
                message = "Livro adicionado aos favoritos";
            }

            // Retornar resposta JSON
            FavoriteResponse favResponse = new FavoriteResponse(favorited, message);
            sendJsonSuccess(response, favResponse);

        } catch (Exception e) {
            sendJsonError(response, "Erro ao atualizar favoritos: " + e.getMessage());
        }
    }

    /**
     * Adiciona aos favoritos
     */
    private void adicionarFavorito(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);

            // Verificar se o livro existe e está ativo
            Livro livro = livroDAO.buscarPorId(livroId);
            if (livro == null || !livro.isAtivo()) {
                sendJsonError(response, "Livro não encontrado ou não disponível");
                return;
            }

            // Verificar se já não está nos favoritos
            if (favoriteDAO.verificarFavorito(user.getId(), livroId)) {
                sendJsonError(response, "Livro já está nos favoritos");
                return;
            }

            // Adicionar aos favoritos
            boolean success = favoriteDAO.adicionar(user.getId(), livroId);

            if (success) {
                sendJsonSuccess(response, "Livro adicionado aos favoritos!");
            } else {
                sendJsonError(response, "Erro ao adicionar aos favoritos");
            }

        } catch (Exception e) {
            sendJsonError(response, "Erro ao adicionar favorito: " + e.getMessage());
        }
    }

    /**
     * Remove dos favoritos
     */
    private void removerFavorito(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);

            // Verificar se está nos favoritos
            if (!favoriteDAO.verificarFavorito(user.getId(), livroId)) {
                sendJsonError(response, "Livro não está nos favoritos");
                return;
            }

            // Remover dos favoritos
            boolean success = favoriteDAO.remover(user.getId(), livroId);

            if (success) {
                sendJsonSuccess(response, "Livro removido dos favoritos!");
            } else {
                sendJsonError(response, "Erro ao remover dos favoritos");
            }

        } catch (Exception e) {
            sendJsonError(response, "Erro ao remover favorito: " + e.getMessage());
        }
    }

    /**
     * Limpa todos os favoritos
     */
    private void limparFavoritos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);

            boolean success = favoriteDAO.limparFavoritos(user.getId());

            if (success) {
                sendJsonSuccess(response, "Todos os favoritos foram removidos!");
            } else {
                sendJsonError(response, "Erro ao limpar favoritos");
            }

        } catch (Exception e) {
            sendJsonError(response, "Erro ao limpar favoritos: " + e.getMessage());
        }
    }

    /**
     * Conta favoritos do usuário
     */
    private void contarFavoritos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);
            int count = favoriteDAO.contarFavoritos(user.getId());

            sendJsonSuccess(response, count);

        } catch (Exception e) {
            sendJsonError(response, "Erro ao contar favoritos");
        }
    }

    /**
     * Obtém sugestões baseadas nos favoritos
     */
    private void obterSugestoes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            User user = getAuthenticatedUser(request);
            int limit = getIntParameter(request, "limit", 6);

            List<Livro> sugestoes = favoriteDAO.buscarSugestoesPorFavoritos(user.getId(), limit);

            sendJsonSuccess(response, sugestoes);

        } catch (Exception e) {
            sendJsonError(response, "Erro ao obter sugestões");
        }
    }

    /**
     * Classe para resposta do toggle de favoritos
     */
    public static class FavoriteResponse {
        private boolean favorited;
        private String message;

        public FavoriteResponse(boolean favorited, String message) {
            this.favorited = favorited;
            this.message = message;
        }

        public boolean isFavorited() {
            return favorited;
        }

        public String getMessage() {
            return message;
        }
    }
}