package com.livraria.controllers;

import com.livraria.utils.FileUploadUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Simple servlet to handle file uploads using {@link FileUploadUtil}.
 */
@MultipartConfig
public class FileUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file");
        if (filePart == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Arquivo não enviado");
            return;
        }
        try {
            String filename = FileUploadUtil.uploadImage(filePart, "");
            response.setContentType("application/json;charset=UTF-8");
            Map<String, String> data = new HashMap<>();
            data.put("filename", filename);
            String json = new com.google.gson.Gson().toJson(data);
            response.getWriter().write(json);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
