package com.livraria.controllers;

import java.io.File;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.livraria.dao.LivroDAO;
import com.livraria.dao.CategoriaDAO;
import com.livraria.models.Livro;
import com.livraria.models.Categoria;
import com.livraria.utils.FileUploadUtil;
import com.livraria.utils.ValidationUtil;

@WebServlet("/admin/livros/*")
@MultipartConfig(maxFileSize = 2097152) // 2MB
public class LivroController extends BaseController {
    
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
        
        checkAdminAccess(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
            listarLivros(request, response);
        } else if (pathInfo.equals("/create")) {
            mostrarFormularioCriacao(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring("/edit/".length());
            editarLivro(request, response, Integer.parseInt(idStr));
        } else if (pathInfo.startsWith("/show/")) {
            String idStr = pathInfo.substring("/show/".length());
            mostrarLivro(request, response, Integer.parseInt(idStr));
        } else if (pathInfo.startsWith("/delete/")) {
            String idStr = pathInfo.substring("/delete/".length());
            confirmarExclusao(request, response, Integer.parseInt(idStr));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAdminAccess(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/store")) {
            criarLivro(request, response);
        } else if (pathInfo.startsWith("/update/")) {
            String idStr = pathInfo.substring("/update/".length());
            atualizarLivro(request, response, Integer.parseInt(idStr));
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAdminAccess(request, response);
        
        String pathInfo = request.getPathInfo();
        if (pathInfo.startsWith("/")) {
            String idStr = pathInfo.substring("/".length());
            excluirLivro(request, response, Integer.parseInt(idStr));
        }
    }
    
    private void listarLivros(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String busca = request.getParameter("busca");
            String categoriaId = request.getParameter("categoria");
            String estoque = request.getParameter("estoque");
            int page = getIntParameter(request, "page", 1);
            int pageSize = 15;
            
            List<Livro> livros = livroDAO.buscarComFiltros(busca, categoriaId, estoque, page, pageSize);
            int totalLivros = livroDAO.contarComFiltros(busca, categoriaId, estoque);
            List<Categoria> categorias = categoriaDAO.listarAtivas();
            
            request.setAttribute("livros", livros);
            request.setAttribute("categorias", categorias);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalLivros / pageSize));
            request.setAttribute("busca", busca);
            request.setAttribute("categoriaFiltro", categoriaId);
            request.setAttribute("estoqueFiltro", estoque);
            
            request.getRequestDispatcher("/admin/livros/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao listar livros", e);
        }
    }
    
    private void mostrarFormularioCriacao(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Categoria> categorias = categoriaDAO.listarAtivas();
            request.setAttribute("categorias", categorias);
            request.getRequestDispatcher("/admin/livros/create.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar formulário", e);
        }
    }
    
    private void criarLivro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Validação básica
            String titulo = getRequiredParameter(request, "titulo");
            String autor = getRequiredParameter(request, "autor");
            Double preco = getDoubleParameter(request, "preco", null);
            Integer categoriaId = getIntParameter(request, "categoria_id", null);
            Integer estoque = getIntParameter(request, "estoque", null);
            
            if (preco == null || preco <= 0) {
                redirectWithError(response, request.getContextPath() + "/admin/livros/create", 
                    "Preço deve ser maior que zero");
                return;
            }
            
            if (categoriaId == null) {
                redirectWithError(response, request.getContextPath() + "/admin/livros/create", 
                    "Categoria é obrigatória");
                return;
            }
            
            if (estoque == null || estoque < 0) {
                redirectWithError(response, request.getContextPath() + "/admin/livros/create", 
                    "Estoque deve ser maior ou igual a zero");
                return;
            }
            
            // Criar objeto livro
            Livro livro = new Livro();
            livro.setTitulo(titulo);
            livro.setAutor(autor);
            livro.setIsbn(request.getParameter("isbn"));
            livro.setEditora(request.getParameter("editora"));
            livro.setAnoPublicacao(getIntParameter(request, "ano_publicacao", null));
            livro.setPreco(preco);
            livro.setPrecoPromocional(getDoubleParameter(request, "preco_promocional", null));
            livro.setPaginas(getIntParameter(request, "paginas", null));
            livro.setSinopse(request.getParameter("sinopse"));
            livro.setCategoriaId(categoriaId);
            livro.setEstoque(estoque);
            livro.setEstoqueMinimo(getIntParameter(request, "estoque_minimo", 5));
            livro.setPeso(getDoubleParameter(request, "peso", 0.5));
            livro.setIdioma(request.getParameter("idioma"));
            livro.setEdicao(request.getParameter("edicao"));
            livro.setEncadernacao(request.getParameter("encadernacao"));
            livro.setAtivo(getBooleanParameter(request, "ativo", true));
            livro.setDestaque(getBooleanParameter(request, "destaque", false));
            
            // Upload da imagem
            Part imagemPart = request.getPart("imagem");
            if (imagemPart != null && imagemPart.getSize() > 0) {
                String nomeImagem = FileUploadUtil.uploadImage(imagemPart, "livros");
                livro.setImagem(nomeImagem);
            }
            
            // Salvar no banco
            livroDAO.criar(livro);
            
            redirectWithSuccess(response, request.getContextPath() + "/admin/livros", 
                "Livro criado com sucesso!");
                
        } catch (Exception e) {
            redirectWithError(response, request.getContextPath() + "/admin/livros/create", 
                "Erro ao criar livro: " + e.getMessage());
        }
    }
    
    private void editarLivro(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Livro livro = livroDAO.buscarPorId(id);
            if (livro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
                return;
            }
            
            List<Categoria> categorias = categoriaDAO.listarAtivas();
            request.setAttribute("livro", livro);
            request.setAttribute("categorias", categorias);
            request.getRequestDispatcher("/admin/livros/edit.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar livro para edição", e);
        }
    }
    
    private void atualizarLivro(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Livro livro = livroDAO.buscarPorId(id);
            if (livro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
                return;
            }
            
            // Validação e atualização
            String titulo = getRequiredParameter(request, "titulo");
            String autor = getRequiredParameter(request, "autor");
            Double preco = getDoubleParameter(request, "preco", null);
            Integer categoriaId = getIntParameter(request, "categoria_id", null);
            Integer estoque = getIntParameter(request, "estoque", null);
            
            if (preco == null || preco <= 0) {
                redirectWithError(response, request.getContextPath() + "/admin/livros/edit/" + id, 
                    "Preço deve ser maior que zero");
                return;
            }
            
            // Atualizar campos
            livro.setTitulo(titulo);
            livro.setAutor(autor);
            livro.setIsbn(request.getParameter("isbn"));
            livro.setEditora(request.getParameter("editora"));
            livro.setAnoPublicacao(getIntParameter(request, "ano_publicacao", null));
            livro.setPreco(preco);
            livro.setPrecoPromocional(getDoubleParameter(request, "preco_promocional", null));
            livro.setPaginas(getIntParameter(request, "paginas", null));
            livro.setSinopse(request.getParameter("sinopse"));
            livro.setCategoriaId(categoriaId);
            livro.setEstoque(estoque);
            livro.setEstoqueMinimo(getIntParameter(request, "estoque_minimo", 5));
            livro.setPeso(getDoubleParameter(request, "peso", 0.5));
            livro.setIdioma(request.getParameter("idioma"));
            livro.setEdicao(request.getParameter("edicao"));
            livro.setEncadernacao(request.getParameter("encadernacao"));
            livro.setAtivo(getBooleanParameter(request, "ativo", true));
            livro.setDestaque(getBooleanParameter(request, "destaque", false));
            
            // Upload da nova imagem (se houver)
            Part imagemPart = request.getPart("imagem");
            if (imagemPart != null && imagemPart.getSize() > 0) {
                // Remover imagem antiga
                if (livro.getImagem() != null) {
                    FileUploadUtil.deleteImage(livro.getImagem(), "livros");
                }
                
                String nomeImagem = FileUploadUtil.uploadImage(imagemPart, "livros");
                livro.setImagem(nomeImagem);
            }
            
            // Atualizar no banco
            livroDAO.atualizar(livro);
            
            redirectWithSuccess(response, request.getContextPath() + "/admin/livros", 
                "Livro atualizado com sucesso!");
                
        } catch (Exception e) {
            redirectWithError(response, request.getContextPath() + "/admin/livros/edit/" + id, 
                "Erro ao atualizar livro: " + e.getMessage());
        }
    }
    
    private void mostrarLivro(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Livro livro = livroDAO.buscarPorIdComCategoria(id);
            if (livro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
                return;
            }
            
            request.setAttribute("livro", livro);
            request.getRequestDispatcher("/admin/livros/show.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar livro", e);
        }
    }
    
    private void confirmarExclusao(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Livro livro = livroDAO.buscarPorId(id);
            if (livro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Livro não encontrado");
                return;
            }
            
            request.setAttribute("livro", livro);
            request.getRequestDispatcher("/admin/livros/delete.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar livro", e);
        }
    }
    
    private void excluirLivro(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Livro livro = livroDAO.buscarPorId(id);
            if (livro == null) {
                sendJsonError(response, "Livro não encontrado");
                return;
            }
            
            // Verificar se pode ser excluído (sem pedidos vinculados)
            if (livroDAO.temPedidosVinculados(id)) {
                sendJsonError(response, "Não é possível excluir livro com pedidos vinculados");
                return;
            }
            
            // Remover imagem
            if (livro.getImagem() != null) {
                FileUploadUtil.deleteImage(livro.getImagem(), "livros");
            }
            
            // Excluir do banco
            livroDAO.excluir(id);
            
            sendJsonSuccess(response, "Livro excluído com sucesso!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao excluir livro: " + e.getMessage());
        }
    }
}