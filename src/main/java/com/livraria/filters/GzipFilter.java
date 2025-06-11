package com.livraria.filters;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Compresses responses using GZIP when supported by the client.
 */
public class GzipFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // no-op
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String enc = httpRequest.getHeader("Accept-Encoding");
        if (enc != null && enc.contains("gzip")) {
            httpResponse.setHeader("Content-Encoding", "gzip");
            GzipResponseWrapper wrapped = new GzipResponseWrapper(httpResponse);
            chain.doFilter(request, wrapped);
            wrapped.finish();
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // no-op
    }
}
