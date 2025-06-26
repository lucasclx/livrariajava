package com.livraria.utils;

import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;
import java.util.UUID;

public class FileUploadUtil {

    private static final String UPLOAD_BASE_PATH = "/uploads/";
    private static final long MAX_FILE_SIZE = 2 * 1024 * 1024; // 2MB
    private static final String[] ALLOWED_IMAGE_TYPES = {
        "image/jpeg", "image/jpg", "image/png", "image/gif", "image/webp"
    };

    /**
     * Faz upload de imagem
     */
    public static String uploadImage(Part filePart, String folder) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            throw new IllegalArgumentException("Arquivo não fornecido");
        }

        // Validar tamanho
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("Arquivo muito grande. Máximo permitido: 2MB");
        }

        // Validar tipo
        String contentType = filePart.getContentType();
        if (!isValidImageType(contentType)) {
            throw new IllegalArgumentException("Tipo de arquivo não permitido. Use: JPG, PNG, GIF ou WebP");
        }

        // Gerar nome único
        String originalFilename = getFileName(filePart);
        String extension = getFileExtension(originalFilename);
        String newFilename = UUID.randomUUID().toString() + "." + extension;

        // Criar diretório se não existir
        String uploadPath = getUploadPath() + folder;
        Path uploadDir = Paths.get(uploadPath);
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }

        // Salvar arquivo
        Path filePath = uploadDir.resolve(newFilename);
        try (InputStream inputStream = filePart.getInputStream()) {
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
        }

        return newFilename;
    }

    /**
     * Remove imagem
     */
    public static boolean deleteImage(String filename, String folder) {
        if (filename == null || filename.trim().isEmpty()) {
            return false;
        }

        try {
            Path filePath = Paths.get(getUploadPath() + folder, filename);
            return Files.deleteIfExists(filePath);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Verifica se o tipo de arquivo é uma imagem válida
     */
    private static boolean isValidImageType(String contentType) {
        if (contentType == null) return false;

        for (String allowedType : ALLOWED_IMAGE_TYPES) {
            if (allowedType.equals(contentType)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Extrai nome do arquivo do Part
     */
    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "unknown";
    }

    /**
     * Extrai extensão do arquivo
     */
    private static String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "jpg"; // extensão padrão
        }
        return filename.substring(filename.lastIndexOf('.') + 1).toLowerCase();
    }

    /**
     * Obtém caminho base para uploads
     */
    private static String getUploadPath() {
        // Em um ambiente real, isso deveria vir de configuração
        String webAppPath = System.getProperty("catalina.base", System.getProperty("user.dir"));
        return webAppPath + "/webapps/livrariajava" + UPLOAD_BASE_PATH;
    }

    /**
     * Gera URL pública para a imagem
     */
    public static String getImageUrl(String filename, String folder) {
        if (filename == null || filename.trim().isEmpty()) {
            return "/livrariajava/assets/images/placeholder.jpg";
        }
        return "/livrariajava" + UPLOAD_BASE_PATH + folder + "/" + filename;
    }

    /**
     * Valida se arquivo existe
     */
    public static boolean fileExists(String filename, String folder) {
        if (filename == null || filename.trim().isEmpty()) {
            return false;
        }

        Path filePath = Paths.get(getUploadPath() + folder, filename);
        return Files.exists(filePath);
    }

    /**
     * Obtém tamanho do arquivo em bytes
     */
    public static long getFileSize(String filename, String folder) {
        try {
            Path filePath = Paths.get(getUploadPath() + folder, filename);
            return Files.size(filePath);
        } catch (IOException e) {
            return 0;
        }
    }

    /**
     * Lista arquivos em uma pasta
     */
    public static String[] listFiles(String folder) {
        try {
            Path folderPath = Paths.get(getUploadPath() + folder);
            if (!Files.exists(folderPath)) {
                return new String[0];
            }

            return Files.list(folderPath)
                       .filter(Files::isRegularFile)
                       .map(path -> path.getFileName().toString())
                       .toArray(String[]::new);
        } catch (IOException e) {
            return new String[0];
        }
    }
}