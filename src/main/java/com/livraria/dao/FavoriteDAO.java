package com.livraria.dao;

import com.livraria.models.Livro;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

/**
 * DAO mínimo para favoritos - versão simplificada
 */
public class FavoriteDAO {
    
    /**
     * Verifica se o livro está nos favoritos do usuário
     */
    public boolean verificarFavorito(int userId, int livroId) throws SQLException {
        // Implementação básica - sempre retorna false por enquanto
        return false;
    }
    
    /**
     * Adiciona livro aos favoritos
     */
    public boolean adicionar(int userId, int livroId) throws SQLException {
        // Implementação básica - sempre retorna true por enquanto
        return true;
    }
    
    /**
     * Remove livro dos favoritos
     */
    public boolean remover(int userId, int livroId) throws SQLException {
        // Implementação básica - sempre retorna true por enquanto
        return true;
    }
    
    /**
     * Lista favoritos do usuário
     */
    public List<Livro> listarFavoritos(int userId, int page, int pageSize) throws SQLException {
        // Retorna lista vazia por enquanto
        return new ArrayList<>();
    }
    
    /**
     * Conta favoritos do usuário
     */
    public int contarFavoritos(int userId) throws SQLException {
        // Retorna 0 por enquanto
        return 0;
    }
}