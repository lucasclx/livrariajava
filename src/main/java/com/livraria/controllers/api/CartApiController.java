package com.livraria.controllers.api;

import com.livraria.controllers.BaseController;
import com.livraria.services.CartService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/api/cart/*")
public class CartApiController extends BaseController {

    private CartService cartService;

    @Override
    public void init() throws ServletException {
        super.init();
        cartService = new CartService();
    }

    /**
     * Lida com as requisições POST para a API do carrinho.
     * Rota: /api/cart/add/{idDoLivro}
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo != null && pathInfo.matches("/add/\\d+")) {
                int livroId = Integer.parseInt(pathInfo.substring("/add/".length()));
                adicionarItem(request, response, livroId);
            } else {
                sendJsonError(response, "Endpoint não encontrado", 404);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "ID do livro é inválido", 400);
        } catch (IllegalArgumentException e) {
            sendJsonError(response, e.getMessage(), 400); // Erro de negócio (ex: sem estoque)
        } catch (Exception e) {
            e.printStackTrace(); // Logar o erro completo no servidor
            sendJsonError(response, "Erro interno ao processar sua solicitação.", 500);
        }
    }

    /**
     * Processa a adição de um item ao carrinho e retorna uma resposta JSON.
     */
    private void adicionarItem(HttpServletRequest request, HttpServletResponse response, int livroId) throws Exception {
        int quantidade = getIntParameter(request, "quantity", 1);
        
        cartService.adicionarItem(request, livroId, quantidade);
        
        // Busca o total de itens atualizado da sessão
        Integer novoTotalItens = (Integer) request.getSession().getAttribute("cart_count");
        if (novoTotalItens == null) {
            novoTotalItens = 0;
        }

        // Cria um objeto simples para a resposta JSON
        var responseData = new Object() {
            public final String message = "Livro adicionado com sucesso!";
            public final int cartCount = novoTotalItens;
        };

        sendJsonSuccess(response, responseData);
    }
}