package com.livraria.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Fábrica de conexões com o banco de dados usando DriverManager.
 * Esta é uma abordagem mais simples, ideal para desenvolvimento e projetos menores,
 * pois não depende da configuração JNDI do servidor.
 */
public class ConnectionFactory {

    // --- Detalhes da Conexão ---
    // Substitua com suas credenciais, se forem diferentes.
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/livraria_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Sao_Paulo&useUnicode=true&characterEncoding=UTF-8";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = ""; // Coloque sua senha do MySQL aqui, se houver.

    /**
     * Carrega o driver do MySQL uma única vez quando a classe é inicializada.
     */
    static {
        try {
            // Carrega a classe do driver na memória
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            // Este é um erro fatal que impede a aplicação de se conectar ao banco.
            throw new RuntimeException("ERRO FATAL: Driver JDBC do MySQL não encontrado.", e);
        }
    }

    /**
     * Retorna uma nova conexão com o banco de dados a cada chamada.
     * * @return uma conexão com o banco de dados.
     * @throws SQLException se não for possível estabelecer a conexão.
     */
    public static Connection getConnection() throws SQLException {
        // Tenta estabelecer a conexão usando os dados fornecidos
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}