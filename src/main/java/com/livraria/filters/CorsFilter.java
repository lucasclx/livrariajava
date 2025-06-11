package com.livraria.filters;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Basic CORS filter allowing configuration via init parameters.
 */
public class CorsFilter implements Filter {
    private String allowedOrigins = "*";
    private String allowedMethods = "GET,POST,PUT,DELETE,OPTIONS";
    private String allowedHeaders = "Content-Type";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        String origins = filterConfig.getInitParameter("allowedOrigins");
        if (origins != null) {
            allowedOrigins = origins;
        }
        String methods = filterConfig.getInitParameter("allowedMethods");
        if (methods != null) {
            allowedMethods = methods;
        }
        String headers = filterConfig.getInitParameter("allowedHeaders");
        if (headers != null) {
            allowedHeaders = headers;
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setHeader("Access-Control-Allow-Origin", allowedOrigins);
        httpResponse.setHeader("Access-Control-Allow-Methods", allowedMethods);
        httpResponse.setHeader("Access-Control-Allow-Headers", allowedHeaders);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
