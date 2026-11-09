package com.aeroconnect.filter;

import jakarta.servlet.*;
import java.io.IOException;

/**
 * EncodingFilter — ensures all requests and responses use UTF-8 encoding.
 */
public class EncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }
}
