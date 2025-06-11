package com.livraria.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.FavoriteDAO;
import com.livraria.models.Livro;
import com.livraria.models.User;

public class FavoriteController extends BaseController {

    private LivroDAO livroDAO;
    private FavoriteDAO favoriteDAO;

    @Override
    public void init() throws ServletException {
        livroDAO = new LivroDAO();
        favoriteDAO = new FavoriteDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        checkAuthentication(request, response);

        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.startsWith("/toggle/")) {
            String idStr = pathInfo.substring("/toggle/".length());
            toggleFavorite(request, response, Integer.parseInt(idStr));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

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
            if (jaEstaNosFavoritos) {
                // Remover dos favoritos
                favoriteDAO.remover(user.getId(), livroId);
                favorited = false;
            } else {
                // Adicionar aos favoritos
                favoriteDAO.adicionar(user.getId(), livroId);
                favorited = true;
            }

            // Retornar resposta JSON
            sendJsonSuccess(response, new FavoriteResponse(favorited));

        } catch (Exception e) {
            sendJsonError(response, "Erro ao atualizar favoritos: " + e.getMessage());
        }
    }

    /**
     * Classe para resposta do toggle de favoritos
     */
    public static class FavoriteResponse {
        private boolean favorited;

        public FavoriteResponse(boolean favorited) {
            this.favorited = favorited;
        }

        public boolean isFavorited() {
            return favorited;
        }
    }
}
