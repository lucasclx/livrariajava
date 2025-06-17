package com.livraria.utils;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/**
 * Fábrica de conexões com o banco de dados usando DataSource (JNDI).
 * Esta é a abordagem recomendada para ambientes de servidor de aplicação como o Tomcat,
 * pois o servidor gerencia o pool de conexões e o ciclo de vida do driver.
 */
public class ConnectionFactory {

    private static DataSource dataSource;

    static {
        try {
            // Realiza o lookup do DataSource no contexto JNDI do Tomcat
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/livraria");
        } catch (NamingException e) {
            // Este é um erro fatal que impede a aplicação de se conectar ao banco.
            throw new RuntimeException("ERRO FATAL: Não foi possível encontrar o DataSource JNDI 'jdbc/livraria'. Verifique a configuração em context.xml e web.xml.", e);
        }
    }

    /**
     * Retorna uma nova conexão do pool de conexões gerenciado pelo Tomcat.
     * @return uma conexão com o banco de dados.
     * @throws SQLException se não for possível estabelecer a conexão.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("DataSource não foi inicializado corretamente.");
        }
        return dataSource.getConnection();
    }
}