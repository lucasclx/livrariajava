package com.livraria.controllers.api;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.livraria.controllers.BaseController;
import com.livraria.models.CartItem;
import com.livraria.services.CartService;

@WebServlet("/api/cart/*")
public class CartApiController extends BaseController {
    
    private CartService cartService;
    
    @Override
    public void init() throws ServletException {
        cartService = new CartService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/items")) {
                listarItens(request, response);
            } else if (pathInfo.equals("/count")) {
                contarItens(request, response);
            } else if (pathInfo.equals("/totals")) {
                obterTotais(request, response);
            } else if (pathInfo.equals("/validate")) {
                validarCarrinho(request, response);
            } else {
                sendJsonError(response, "Endpoint não encontrado", 404);
            }
        } catch (Exception e) {
            sendJsonError(response, "Erro ao processar requisição: " + e.getMessage(), 500);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.matches("/add/\\d+")) {
                int livroId = Integer.parseInt(pathInfo.substring("/add/".length()));
                adicionarItem(request, response, livroId);
            } else if (pathInfo != null && pathInfo.matches("/update/\\d+")) {
                int itemId = Integer.parseInt(pathInfo.substring("/update/".length()));
                atualizarItem(request, response, itemId);
            } else if (pathInfo != null && pathInfo.equals("/clear")) {
                limparCarrinho(request, response);
            } else {
                sendJsonError(response, "Endpoint não encontrado", 404);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "ID inválido", 400);
        } catch (Exception e) {
            sendJsonError(response, "Erro ao processar requisição: " + e.getMessage(), 500);
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null && pathInfo.matches("/remove/\\d+")) {
                int itemId = Integer.parseInt(pathInfo.substring("/remove/".length()));
                removerItem(request, response, itemId);
            } else {
                sendJsonError(response, "Endpoint não encontrado", 404);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "ID inválido", 400);
        } catch (Exception e) {
            sendJsonError(response, "Erro ao processar requisição: " + e.getMessage(), 500);
        }
    }
    
    private void listarItens(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<CartItem> items = cartService.listarItens(request);
        CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
        
        CarrinhoResponse carrinhoResponse = new CarrinhoResponse();
        carrinhoResponse.items = items;
        carrinhoResponse.totals = totais;
        carrinhoResponse.isEmpty = items.isEmpty();
        
        sendJsonSuccess(response, carrinhoResponse);
    }
    
    private void contarItens(HttpServletRequest request, HttpServletResponse response) throws Exception {
        int count = cartService.contarItens(request);
        sendJsonSuccess(response, new CountResponse(count));
    }
    
    private void obterTotais(HttpServletRequest request, HttpServletResponse response) throws Exception {
        CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
        sendJsonSuccess(response, totais);
    }
    
    private void adicionarItem(HttpServletRequest request, HttpServletResponse response, int livroId) throws Exception {
        int quantidade = getIntParameter(request, "quantity", 1);
        cartService.adicionarItem(request, livroId, quantidade);
        
        int novoCount = cartService.contarItens(request);
        CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
        
        AddItemResponse addResponse = new AddItemResponse();
        addResponse.count = novoCount;
        addResponse.totals = totais;
        addResponse.message = "Item adicionado ao carrinho com sucesso!";
        
        sendJsonSuccess(response, addResponse);
    }
    
    private void atualizarItem(HttpServletRequest request, HttpServletResponse response, int itemId) throws Exception {
        int quantidade = getIntParameter(request, "quantity", 1);
        cartService.atualizarQuantidade(request, itemId, quantidade);
        
        int novoCount = cartService.contarItens(request);
        CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
        
        UpdateItemResponse updateResponse = new UpdateItemResponse();
        updateResponse.count = novoCount;
        updateResponse.totals = totais;
        updateResponse.message = "Quantidade atualizada com sucesso!";
        
        sendJsonSuccess(response, updateResponse);
    }
    
    private void removerItem(HttpServletRequest request, HttpServletResponse response, int itemId) throws Exception {
        cartService.removerItem(request, itemId);
        
        int novoCount = cartService.contarItens(request);
        CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
        
        RemoveItemResponse removeResponse = new RemoveItemResponse();
        removeResponse.count = novoCount;
        removeResponse.totals = totais;
        removeResponse.message = "Item removido do carrinho!";
        
        sendJsonSuccess(response, removeResponse);
    }
    
    private void limparCarrinho(HttpServletRequest request, HttpServletResponse response) throws Exception {
        cartService.limparCarrinho(request);
        
        ClearCartResponse clearResponse = new ClearCartResponse();
        clearResponse.count = 0;
        clearResponse.message = "Carrinho limpo com sucesso!";
        
        sendJsonSuccess(response, clearResponse);
    }
    
    private void validarCarrinho(HttpServletRequest request, HttpServletResponse response) throws Exception {
        List<String> erros = cartService.validarEstoque(request);
        
        ValidateCartResponse validateResponse = new ValidateCartResponse();
        validateResponse.isValid = erros.isEmpty();
        validateResponse.errors = erros;
        validateResponse.message = erros.isEmpty() ? 
            "Carrinho válido" : 
            "Alguns itens não estão mais disponíveis";
            
        sendJsonSuccess(response, validateResponse);
    }

    // Classes de resposta para JSON
    private static class CarrinhoResponse {
        public List<CartItem> items;
        public CartService.CarrinhoTotais totals;
        public boolean isEmpty;
    }
    
    private static class CountResponse {
        public int count;
        public CountResponse(int count) { this.count = count; }
    }
    
    private static class AddItemResponse {
        public int count;
        public CartService.CarrinhoTotais totals;
        public String message;
    }
    
    private static class UpdateItemResponse {
        public int count;
        public CartService.CarrinhoTotais totals;
        public String message;
    }
    
    private static class RemoveItemResponse {
        public int count;
        public CartService.CarrinhoTotais totals;
        public String message;
    }
    
    private static class ClearCartResponse {
        public int count;
        public String message;
    }
    
    private static class ValidateCartResponse {
        public boolean isValid;
        public List<String> errors;
        public String message;
    }
}