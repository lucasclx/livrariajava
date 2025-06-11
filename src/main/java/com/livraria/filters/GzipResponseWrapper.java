package com.livraria.filters;

import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.zip.GZIPOutputStream;

/**
 * Response wrapper that compresses output using GZIP.
 */
public class GzipResponseWrapper extends HttpServletResponseWrapper {

    private GZIPOutputStream gzipStream;
    private ServletOutputStream outputStream;
    private PrintWriter writer;
    private ByteArrayOutputStream buffer = new ByteArrayOutputStream();

    public GzipResponseWrapper(HttpServletResponse response) throws IOException {
        super(response);
    }

    @Override
    public ServletOutputStream getOutputStream() throws IOException {
        if (writer != null) {
            throw new IllegalStateException("getWriter() has already been called");
        }
        if (outputStream == null) {
            gzipStream = new GZIPOutputStream(buffer);
            outputStream = new ServletOutputStream() {
                @Override
                public boolean isReady() {
                    return true;
                }

                @Override
                public void setWriteListener(WriteListener writeListener) {
                    // not implemented
                }

                @Override
                public void write(int b) throws IOException {
                    gzipStream.write(b);
                }
            };
        }
        return outputStream;
    }

    @Override
    public PrintWriter getWriter() throws IOException {
        if (outputStream != null) {
            throw new IllegalStateException("getOutputStream() has already been called");
        }
        if (writer == null) {
            gzipStream = new GZIPOutputStream(buffer);
            writer = new PrintWriter(new OutputStreamWriter(gzipStream, getCharacterEncoding()));
        }
        return writer;
    }

    public void finish() throws IOException {
        if (writer != null) {
            writer.close();
        } else if (outputStream != null) {
            outputStream.close();
        }
        if (gzipStream != null) {
            gzipStream.finish();
        }
        byte[] bytes = buffer.toByteArray();
        HttpServletResponse response = (HttpServletResponse) getResponse();
        response.setContentLength(bytes.length);
        response.getOutputStream().write(bytes);
    }
}
