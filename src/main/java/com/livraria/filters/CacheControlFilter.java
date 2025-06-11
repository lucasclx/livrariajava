package com.livraria.filters;

import javax.servlet.*;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Adds cache headers to static resources.
 */
public class CacheControlFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no initialization needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setHeader("Cache-Control", "public, max-age=31536000");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // no-op
    }
}
