package com.livraria.utils;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class ConnectionFactory {

    private static DataSource dataSource;

    static {
        try {
            Context initCtx = new InitialContext();
            // O lookup JNDI padrão para aplicações web
            Context envCtx = (Context) initCtx.lookup("java:comp/env");
            // Busca o DataSource configurado no context.xml ou web.xml
            dataSource = (DataSource) envCtx.lookup("jdbc/livraria");
        } catch (Exception e) {
            // Lançar um erro claro em caso de falha é essencial para o diagnóstico
            throw new RuntimeException("ERRO FATAL: Não foi possível inicializar o DataSource JNDI 'jdbc/livraria'. Verifique as configurações do servidor (context.xml).", e);
        }
    }

    /**
     * Retorna uma conexão do pool de conexões.
     * @return uma conexão com o banco de dados
     * @throws SQLException se o DataSource não estiver inicializado ou se não for possível obter a conexão.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource não foi inicializado. A aplicação não pôde se conectar ao banco de dados.");
        }
        return dataSource.getConnection();
    }
}