package com.livraria.controllers;

import com.livraria.dao.CategoriaDAO;
import com.livraria.dao.LivroDAO;
import com.livraria.models.Categoria;
import com.livraria.models.Livro;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

/**
 * Very small REST controller used by the demo application.
 */
public class ApiController extends BaseController {

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
        String path = request.getPathInfo();
        if (path == null || "/".equals(path) || "/health".equals(path)) {
            Map<String, String> data = new HashMap<>();
            data.put("status", "ok");
            sendJsonSuccess(response, data);
            return;
        }

        try {
            if (path.startsWith("/livros")) {
                List<Livro> livros = livroDAO.findAtivos();
                sendJsonSuccess(response, livros);
            } else if (path.startsWith("/categorias")) {
                List<Categoria> categorias = categoriaDAO.listarAtivas();
                sendJsonSuccess(response, categorias);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            sendJsonError(response, "Erro ao processar requisição");
        }
    }
}
