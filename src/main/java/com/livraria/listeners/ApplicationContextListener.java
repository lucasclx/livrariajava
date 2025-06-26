package com.livraria.listeners;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Listener para inicialização do contexto da aplicação.
 */
public class ApplicationContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        String appName = ctx.getInitParameter("app.name");
        String appVersion = ctx.getInitParameter("app.version");
        ctx.log("Iniciando " + appName + " v" + appVersion);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // nothing to clean up
    }
}