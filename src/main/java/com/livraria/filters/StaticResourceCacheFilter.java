package com.livraria.filters;

import java.io.IOException;
import java.util.concurrent.TimeUnit;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebFilter(urlPatterns = {"*.css", "*.js", "*.png", "*.jpg", "*.gif", "*.ico", "*.woff", "*.woff2", "*.ttf", "*.svg"})
public class StaticResourceCacheFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();

        // Cache por 1 ano para recursos estáticos
        if (isStaticResource(uri)) {
            httpResponse.setHeader("Cache-Control", "public, max-age=31536000");
            httpResponse.setDateHeader("Expires", System.currentTimeMillis() + TimeUnit.DAYS.toMillis(365));
            httpResponse.setHeader("Vary", "Accept-Encoding");
        }

        chain.doFilter(request, response);
    }

    private boolean isStaticResource(String uri) {
        return uri.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|woff|woff2|ttf|svg)$");
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}