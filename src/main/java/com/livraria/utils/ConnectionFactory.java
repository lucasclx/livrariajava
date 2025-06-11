package com.livraria.utils;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Factory for obtaining database connections from the configured JNDI DataSource.
 */
public class ConnectionFactory {

    private static DataSource dataSource;

    static {
        try {
            Context ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/livraria");
        } catch (Exception e) {
            throw new ExceptionInInitializerError("Cannot initialize DataSource", e);
        }
    }

    /**
     * Returns a connection from the configured DataSource.
     */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}
