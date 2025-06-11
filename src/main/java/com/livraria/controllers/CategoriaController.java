package com.livraria.controllers;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.livraria.dao.CategoriaDAO;
import com.livraria.models.Categoria;
import com.livraria.utils.FileUploadUtil;
import com.livraria.utils.SlugUtil;

@MultipartConfig(maxFileSize = 2097152) // 2MB
public class CategoriaController extends BaseController {
    
    private CategoriaDAO categoriaDAO;
    
    @Override
    public void init() throws ServletException {
        categoriaDAO = new CategoriaDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        checkAdminAccess(request, response);
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/index")) {
            listarCategorias(request, response);
        } else if (pathInfo.equals("/create")) {
            mostrarFormularioCriacao(request, response);
        } else if (pathInfo.startsWith("/edit/")) {
            String idStr = pathInfo.substring("/edit/".length());
            editarCategoria(request, response, Integer.parseInt(idStr));
        } else if (pathInfo.startsWith("/show/")) {
            String idStr = pathInfo.substring("/show/".length());
            mostrarCategoria(request, response, Integer.parseInt(idStr));
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
            criarCategoria(request, response);
        } else if (pathInfo.startsWith("/update/")) {
            String idStr = pathInfo.substring("/update/".length());
            atualizarCategoria(request, response, Integer.parseInt(idStr));
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
            excluirCategoria(request, response, Integer.parseInt(idStr));
        }
    }
    
    private void listarCategorias(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int page = getIntParameter(request, "page", 1);
            int pageSize = 10;
            
            List<Categoria> categorias = categoriaDAO.listarComPaginacao(page, pageSize);
            int totalCategorias = categoriaDAO.contar();
            
            request.setAttribute("categorias", categorias);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalCategorias / pageSize));
            
            request.getRequestDispatcher("/admin/categorias/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao listar categorias", e);
        }
    }
    
    private void mostrarFormularioCriacao(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/admin/categorias/create.jsp").forward(request, response);
    }
    
    private void criarCategoria(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Validação básica
            String nome = getRequiredParameter(request, "nome");
            
            if (nome.length() < 3 || nome.length() > 100) {
                redirectWithError(response, request.getContextPath() + "/admin/categorias/create", 
                    "Nome deve ter entre 3 e 100 caracteres");
                return;
            }
            
            // Verificar se nome já existe
            if (categoriaDAO.existeNome(nome, null)) {
                redirectWithError(response, request.getContextPath() + "/admin/categorias/create", 
                    "Já existe uma categoria com este nome");
                return;
            }
            
            // Criar objeto categoria
            Categoria categoria = new Categoria();
            categoria.setNome(nome);
            categoria.setDescricao(request.getParameter("descricao"));
            categoria.setSlug(SlugUtil.gerarSlug(nome));
            categoria.setAtivo(getBooleanParameter(request, "ativo", true));
            
            // Upload da imagem
            Part imagemPart = request.getPart("imagem");
            if (imagemPart != null && imagemPart.getSize() > 0) {
                String nomeImagem = FileUploadUtil.uploadImage(imagemPart, "categorias");
                categoria.setImagem(nomeImagem);
            }
            
            // Salvar no banco
            categoriaDAO.criar(categoria);
            
            redirectWithSuccess(response, request.getContextPath() + "/admin/categorias", 
                "Categoria criada com sucesso!");
                
        } catch (Exception e) {
            redirectWithError(response, request.getContextPath() + "/admin/categorias/create", 
                "Erro ao criar categoria: " + e.getMessage());
        }
    }
    
    private void editarCategoria(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Categoria categoria = categoriaDAO.buscarPorId(id);
            if (categoria == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoria não encontrada");
                return;
            }
            
            request.setAttribute("categoria", categoria);
            request.getRequestDispatcher("/admin/categorias/edit.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar categoria para edição", e);
        }
    }
    
    private void atualizarCategoria(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Categoria categoria = categoriaDAO.buscarPorId(id);
            if (categoria == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoria não encontrada");
                return;
            }
            
            // Validação básica
            String nome = getRequiredParameter(request, "nome");
            
            if (nome.length() < 3 || nome.length() > 100) {
                redirectWithError(response, request.getContextPath() + "/admin/categorias/edit/" + id, 
                    "Nome deve ter entre 3 e 100 caracteres");
                return;
            }
            
            // Verificar se nome já existe (exceto para a categoria atual)
            if (categoriaDAO.existeNome(nome, id)) {
                redirectWithError(response, request.getContextPath() + "/admin/categorias/edit/" + id, 
                    "Já existe uma categoria com este nome");
                return;
            }
            
            // Atualizar campos
            String nomeAnterior = categoria.getNome();
            categoria.setNome(nome);
            categoria.setDescricao(request.getParameter("descricao"));
            categoria.setAtivo(getBooleanParameter(request, "ativo", true));
            
            // Atualizar slug se nome mudou
            if (!nomeAnterior.equals(nome)) {
                categoria.setSlug(SlugUtil.gerarSlug(nome));
            }
            
            // Upload da nova imagem (se houver)
            Part imagemPart = request.getPart("imagem");
            if (imagemPart != null && imagemPart.getSize() > 0) {
                // Remover imagem antiga
                if (categoria.getImagem() != null) {
                    FileUploadUtil.deleteImage(categoria.getImagem(), "categorias");
                }
                
                String nomeImagem = FileUploadUtil.uploadImage(imagemPart, "categorias");
                categoria.setImagem(nomeImagem);
            }
            
            // Atualizar no banco
            categoriaDAO.atualizar(categoria);
            
            redirectWithSuccess(response, request.getContextPath() + "/admin/categorias", 
                "Categoria atualizada com sucesso!");
                
        } catch (Exception e) {
            redirectWithError(response, request.getContextPath() + "/admin/categorias/edit/" + id, 
                "Erro ao atualizar categoria: " + e.getMessage());
        }
    }
    
    private void mostrarCategoria(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Categoria categoria = categoriaDAO.buscarPorIdComLivros(id);
            if (categoria == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoria não encontrada");
                return;
            }
            
            request.setAttribute("categoria", categoria);
            request.getRequestDispatcher("/admin/categorias/show.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar categoria", e);
        }
    }
    
    private void confirmarExclusao(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Categoria categoria = categoriaDAO.buscarPorId(id);
            if (categoria == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Categoria não encontrada");
                return;
            }
            
            // Verificar se tem livros vinculados
            int totalLivros = categoriaDAO.contarLivrosVinculados(id);
            
            request.setAttribute("categoria", categoria);
            request.setAttribute("totalLivros", totalLivros);
            request.getRequestDispatcher("/admin/categorias/delete.jsp").forward(request, response);
            
        } catch (Exception e) {
            throw new ServletException("Erro ao carregar categoria", e);
        }
    }
    
    private void excluirCategoria(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {
        
        try {
            Categoria categoria = categoriaDAO.buscarPorId(id);
            if (categoria == null) {
                sendJsonError(response, "Categoria não encontrada");
                return;
            }
            
            // Verificar se tem livros vinculados
            if (categoriaDAO.contarLivrosVinculados(id) > 0) {
                sendJsonError(response, "Não é possível excluir categoria que possui livros vinculados");
                return;
            }
            
            // Remover imagem
            if (categoria.getImagem() != null) {
                FileUploadUtil.deleteImage(categoria.getImagem(), "categorias");
            }
            
            // Excluir do banco
            categoriaDAO.excluir(id);
            
            sendJsonSuccess(response, "Categoria excluída com sucesso!");
            
        } catch (Exception e) {
            sendJsonError(response, "Erro ao excluir categoria: " + e.getMessage());
        }
    }
}