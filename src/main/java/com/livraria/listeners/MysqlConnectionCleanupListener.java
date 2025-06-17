package com.livraria.listeners;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

/**
 * Listener para gerenciar o ciclo de vida do AbandonedConnectionCleanupThread do MySQL.
 * Isso previne memory leaks ao fazer o reload da aplicação no Tomcat.
 */
@WebListener
public class MysqlConnectionCleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Nenhuma ação necessária na inicialização.
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Força o encerramento da thread de limpeza do MySQL.
        try {
            sce.getServletContext().log("Encerrando a thread de limpeza de conexões do MySQL...");
            AbandonedConnectionCleanupThread.uncheckedShutdown();
            sce.getServletContext().log("Thread de limpeza do MySQL encerrada com sucesso.");
        } catch (Exception e) {
            sce.getServletContext().log("Erro ao encerrar a thread de limpeza de conexões do MySQL.", e);
        }
    }
}