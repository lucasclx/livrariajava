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
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            sendJsonError(response, "Erro ao validar carrinho: " + e.getMessage());
        }
    }
    
    // Classes de resposta
    public static class CarrinhoResponse {
        public List<CartItem> items;
        public CartService.CarrinhoTotais totals;
        public boolean isEmpty;
    }
    
    public static class AddItemResponse {
        public int count;
        public CartService.CarrinhoTotais totals;
        public String message;
    }
    
    public static class UpdateItemResponse {
        public int count;
        public CartService.CarrinhoTotais totals;
        public String message;
    }
    
    public static class RemoveItemResponse {
        public int count;
        public CartService.CarrinhoTotais totals;
        public String message;
    }
    
    public static class ClearCartResponse {
        public int count;
        public String message;
    }
    
    public static class ValidateCartResponse {
        public boolean isValid;
        public List<String> errors;
        public String message;
    }
} ao processar requisição: " + e.getMessage());
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
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "ID inválido");
        } catch (Exception e) {
            sendJsonError(response, "Erro ao processar requisição: " + e.getMessage());
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
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (NumberFormatException e) {
            sendJsonError(response, "ID inválido");
        } catch (Exception e) {
            sendJsonError(response, "Erro ao processar requisição: " + e.getMessage());
        }
    }
    
    private void listarItens(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            List<CartItem> items = cartService.listarItens(request);
            CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
            
            CarrinhoResponse carrinhoResponse = new CarrinhoResponse();
            carrinhoResponse.items = items;
            carrinhoResponse.totals = totais;
            carrinhoResponse.isEmpty = items.isEmpty();
            
            sendJsonSuccess(response, carrinhoResponse);
        } catch (Exception e) {
            sendJsonError(response, "Erro ao listar itens do carrinho: " + e.getMessage());
        }
    }
    
    private void contarItens(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int count = cartService.contarItens(request);
            sendJsonSuccess(response, count);
        } catch (Exception e) {
            sendJsonError(response, "Erro ao contar itens do carrinho");
        }
    }
    
    private void obterTotais(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
            sendJsonSuccess(response, totais);
        } catch (Exception e) {
            sendJsonError(response, "Erro ao calcular totais do carrinho");
        }
    }
    
    private void adicionarItem(HttpServletRequest request, HttpServletResponse response, int livroId)
            throws IOException {
        try {
            int quantidade = getIntParameter(request, "quantity", 1);
            
            cartService.adicionarItem(request, livroId, quantidade);
            
            // Retornar informações atualizadas
            int novoCount = cartService.contarItens(request);
            CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
            
            AddItemResponse addResponse = new AddItemResponse();
            addResponse.count = novoCount;
            addResponse.totals = totais;
            addResponse.message = "Item adicionado ao carrinho com sucesso!";
            
            sendJsonSuccess(response, addResponse);
            
        } catch (IllegalArgumentException e) {
            sendJsonError(response, e.getMessage());
        } catch (Exception e) {
            sendJsonError(response, "Erro ao adicionar item ao carrinho: " + e.getMessage());
        }
    }
    
    private void atualizarItem(HttpServletRequest request, HttpServletResponse response, int itemId)
            throws IOException {
        try {
            int quantidade = getIntParameter(request, "quantity", 1);
            
            cartService.atualizarQuantidade(request, itemId, quantidade);
            
            // Retornar informações atualizadas
            int novoCount = cartService.contarItens(request);
            CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
            
            UpdateItemResponse updateResponse = new UpdateItemResponse();
            updateResponse.count = novoCount;
            updateResponse.totals = totais;
            updateResponse.message = "Quantidade atualizada com sucesso!";
            
            sendJsonSuccess(response, updateResponse);
            
        } catch (IllegalArgumentException e) {
            sendJsonError(response, e.getMessage());
        } catch (Exception e) {
            sendJsonError(response, "Erro ao atualizar item: " + e.getMessage());
        }
    }
    
    private void removerItem(HttpServletRequest request, HttpServletResponse response, int itemId)
            throws IOException {
        try {
            cartService.removerItem(request, itemId);
            
            // Retornar informações atualizadas
            int novoCount = cartService.contarItens(request);
            CartService.CarrinhoTotais totais = cartService.calcularTotais(request);
            
            RemoveItemResponse removeResponse = new RemoveItemResponse();
            removeResponse.count = novoCount;
            removeResponse.totals = totais;
            removeResponse.message = "Item removido do carrinho!";
            
            sendJsonSuccess(response, removeResponse);
            
        } catch (IllegalArgumentException e) {
            sendJsonError(response, e.getMessage());
        } catch (Exception e) {
            sendJsonError(response, "Erro ao remover item: " + e.getMessage());
        }
    }
    
    private void limparCarrinho(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            cartService.limparCarrinho(request);
            
            ClearCartResponse clearResponse = new ClearCartResponse();
            clearResponse.count = 0;
            clearResponse.message = "Carrinho limpo com sucesso!";
            
            sendJsonSuccess(response, clearResponse);
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao limpar carrinho: " + e.getMessage());
        }
    }
    
    private void validarCarrinho(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            List<String> erros = cartService.validarEstoque(request);
            
            ValidateCartResponse validateResponse = new ValidateCartResponse();
            validateResponse.isValid = erros.isEmpty();
            validateResponse.errors = erros;
            validateResponse.message = erros.isEmpty() ? 
                "Carrinho válido" : 
                "Alguns itens não estão mais disponíveis";
            
            sendJsonSuccess(response, validateResponse);
            
        } catch (Exception e) {
            sendJsonError(response, "Erro