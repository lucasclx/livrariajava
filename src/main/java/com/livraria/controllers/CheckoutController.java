package com.livraria.controllers;

import com.livraria.dao.CartDAO;
import com.livraria.dao.UserAddressDAO;
import com.livraria.models.Cart;
import com.livraria.models.Order;
import com.livraria.models.User;
import com.livraria.models.UserAddress;
import com.livraria.services.CartService;
import com.livraria.services.OrderService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutController extends BaseController {

    private CartService cartService;
    private OrderService orderService;
    private UserAddressDAO userAddressDAO;
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        cartService = new CartService();
        orderService = new OrderService();
        userAddressDAO = new UserAddressDAO();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Verificar autenticação
        checkAuthentication(request, response);
        User user = getAuthenticatedUser(request);
        if (user == null) {
            redirectWithError(response, request, request.getContextPath() + "/login", "Você precisa estar logado para finalizar a compra.");
            return;
        }

        try {
            // 2. Obter carrinho e verificar se não está vazio
            Cart cart = cartService.obterCarrinho(request);
            if (cart == null || cartService.contarItens(request) == 0) {
                redirectWithError(response, request, request.getContextPath() + "/cart", "Seu carrinho está vazio.");
                return;
            }
            
            // 3. Validar estoque
            List<String> stockErrors = cartService.validarEstoque(request);
            if (!stockErrors.isEmpty()) {
                String errorMessage = "Itens indisponíveis: " + String.join(", ", stockErrors);
                redirectWithError(response, request, request.getContextPath() + "/cart", errorMessage);
                return;
            }
            
            // 4. Carregar dados para a página de checkout
            CartService.CarrinhoTotais totals = cartService.calcularTotais(request);
            List<UserAddress> addresses = userAddressDAO.findByUserId(user.getId());

            request.setAttribute("totals", totals);
            request.setAttribute("items", cartService.listarItens(request));
            request.setAttribute("addresses", addresses);
            
            // 5. Encaminhar para a view
            request.getRequestDispatcher("/WEB-INF/view/loja/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Erro ao carregar a página de checkout.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAuthentication(request, response);
        User user = getAuthenticatedUser(request);
        if (user == null) {
            sendJsonError(response, "Sessão expirada. Faça login novamente.");
            return;
        }

        try {
            // 1. Obter carrinho
            Cart cart = cartService.obterOuCriarCarrinho(request);

            // 2. Obter dados do formulário
            String paymentMethod = getRequiredParameter(request, "payment_method");
            int addressId = getIntParameter(request, "address_id", 0);
            
            if (addressId == 0) {
                 throw new IllegalArgumentException("Selecione um endereço de entrega.");
            }
            
            UserAddress address = userAddressDAO.findById((long) addressId);
            if (address == null || !address.getUserId().equals(user.getId())) {
                throw new SecurityException("Endereço inválido ou não pertence ao usuário.");
            }
            
            // 3. Chamar o serviço para criar o pedido
            Order order = orderService.createOrder(user, cart, address, paymentMethod);
            
            // 4. Limpar o carrinho da sessão após a compra bem-sucedida
            request.getSession().removeAttribute("cart_id");
            request.getSession().removeAttribute("cart_count");
            
            // 5. Redirecionar para a página de sucesso
            redirectWithSuccess(response, request, request.getContextPath() + "/perfil/pedidos", 
                "Pedido #" + order.getOrderNumber() + " realizado com sucesso!");

        } catch (IllegalArgumentException | SecurityException e) {
            e.printStackTrace();
            redirectWithError(response, request, request.getContextPath() + "/checkout", e.getMessage());
        } catch (IllegalStateException e) {
            e.printStackTrace();
            redirectWithError(response, request, request.getContextPath() + "/cart", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(response, request, request.getContextPath() + "/checkout", "Ocorreu um erro inesperado ao processar seu pedido. Tente novamente.");
        }
    }
}