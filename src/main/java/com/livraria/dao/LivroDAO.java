package com.livraria.utils;

import javax.servlet.http.Part;
import java.io.*;
import java.nio.file.*;
import java.util.UUID;
import java.util.List;
import java.util.ArrayList;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;

/**
 * Utilitário para upload e manipulação de arquivos
 */
public class FileUploadUtil {
    
    // Configurações padrão
    private static final String DEFAULT_UPLOAD_DIR = "/var/livraria/uploads";
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    private static final String[] ALLOWED_IMAGE_TYPES = {"jpg", "jpeg", "png", "gif", "webp"};
    
    // Tamanhos para redimensionamento de imagens
    public static final int THUMBNAIL_SIZE = 150;
    public static final int SMALL_SIZE = 300;
    public static final int MEDIUM_SIZE = 600;
    public static final int LARGE_SIZE = 1200;
    
    /**
     * Faz upload de uma imagem
     */
    public static String uploadImage(Part filePart, String subfolder) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            throw new IllegalArgumentException("Arquivo não informado");
        }
        
        // Validar tipo do arquivo
        String originalFileName = getFileName(filePart);
        if (!isValidImageFile(originalFileName)) {
            throw new IllegalArgumentException("Tipo de arquivo não permitido. Use: " + String.join(", ", ALLOWED_IMAGE_TYPES));
        }
        
        // Validar tamanho
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("Arquivo muito grande. Tamanho máximo: " + formatFileSize(MAX_FILE_SIZE));
        }
        
        // Gerar nome único
        String extension = getFileExtension(originalFileName);
        String fileName = generateUniqueFileName(extension);
        
        // Criar diretórios se não existirem
        Path uploadPath = getUploadPath(subfolder);
        Files.createDirectories(uploadPath);
        
        // Caminho completo do arquivo
        Path filePath = uploadPath.resolve(fileName);
        
        try (InputStream inputStream = filePart.getInputStream()) {
            // Fazer upload do arquivo original
            Files.copy(inputStream, filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // Redimensionar imagem se necessário
            resizeImage(filePath, subfolder, fileName);
            
            return fileName;
        } catch (Exception e) {
            // Limpar arquivo se houve erro
            deleteFileIfExists(filePath);
            throw new IOException("Erro ao fazer upload do arquivo: " + e.getMessage(), e);
        }
    }
    
    /**
     * Upload de múltiplas imagens
     */
    public static List<String> uploadMultipleImages(List<Part> fileParts, String subfolder) throws IOException {
        List<String> uploadedFiles = new ArrayList<>();
        
        for (Part filePart : fileParts) {
            try {
                String fileName = uploadImage(filePart, subfolder);
                uploadedFiles.add(fileName);
            } catch (Exception e) {
                // Limpar arquivos já uploaded em caso de erro
                for (String uploadedFile : uploadedFiles) {
                    deleteImage(uploadedFile, subfolder);
                }
                throw e;
            }
        }
        
        return uploadedFiles;
    }
    
    /**
     * Exclui uma imagem e suas versões redimensionadas
     */
    public static boolean deleteImage(String fileName, String subfolder) {
        if (ValidationUtil.isNullOrEmpty(fileName)) {
            return false;
        }
        
        boolean success = true;
        Path uploadPath = getUploadPath(subfolder);
        
        // Excluir arquivo original
        success &= deleteFileIfExists(uploadPath.resolve(fileName));
        
        // Excluir versões redimensionadas
        String nameWithoutExt = getFileNameWithoutExtension(fileName);
        String extension = getFileExtension(fileName);
        
        success &= deleteFileIfExists(uploadPath.resolve(nameWithoutExt + "_thumb." + extension));
        success &= deleteFileIfExists(uploadPath.resolve(nameWithoutExt + "_small." + extension));
        success &= deleteFileIfExists(uploadPath.resolve(nameWithoutExt + "_medium." + extension));
        success &= deleteFileIfExists(uploadPath.resolve(nameWithoutExt + "_large." + extension));
        
        return success;
    }
    
    /**
     * Redimensiona imagem em vários tamanhos
     */
    private static void resizeImage(Path originalPath, String subfolder, String fileName) {
        try {
            BufferedImage originalImage = ImageIO.read(originalPath.toFile());
            if (originalImage == null) return;
            
            String nameWithoutExt = getFileNameWithoutExtension(fileName);
            String extension = getFileExtension(fileName);
            Path uploadPath = getUploadPath(subfolder);
            
            // Criar thumbnail
            BufferedImage thumbnail = resizeImage(originalImage, THUMBNAIL_SIZE, THUMBNAIL_SIZE);
            saveImage(thumbnail, uploadPath.resolve(nameWithoutExt + "_thumb." + extension), extension);
            
            // Criar versão pequena
            BufferedImage small = resizeImageProportional(originalImage, SMALL_SIZE);
            saveImage(small, uploadPath.resolve(nameWithoutExt + "_small." + extension), extension);
            
            // Criar versão média
            BufferedImage medium = resizeImageProportional(originalImage, MEDIUM_SIZE);
            saveImage(medium, uploadPath.resolve(nameWithoutExt + "_medium." + extension), extension);
            
            // Criar versão grande (se a original for maior)
            if (originalImage.getWidth() > LARGE_SIZE || originalImage.getHeight() > LARGE_SIZE) {
                BufferedImage large = resizeImageProportional(originalImage, LARGE_SIZE);
                saveImage(large, uploadPath.resolve(nameWithoutExt + "_large." + extension), extension);
            }
            
        } catch (Exception e) {
            // Log do erro, mas não interromper o processo
            System.err.println("Erro ao redimensionar imagem: " + e.getMessage());
        }
    }
    
    /**
     * Redimensiona imagem mantendo proporção
     */
    private static BufferedImage resizeImageProportional(BufferedImage original, int maxSize) {
        int width = original.getWidth();
        int height = original.getHeight();
        
        double ratio = Math.min((double) maxSize / width, (double) maxSize / height);
        
        int newWidth = (int) (width * ratio);
        int newHeight = (int) (height * ratio);
        
        return resizeImage(original, newWidth, newHeight);
    }
    
    /**
     * Redimensiona imagem com dimensões específicas
     */
    private static BufferedImage resizeImage(BufferedImage original, int width, int height) {
        Image scaledImage = original.getScaledInstance(width, height, Image.SCALE_SMOOTH);
        BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        
        Graphics2D g2d = resizedImage.createGraphics();
        g2d.drawImage(scaledImage, 0, 0, null);
        g2d.dispose();
        
        return resizedImage;
    }
    
    /**
     * Salva imagem no disco
     */
    private static void saveImage(BufferedImage image, Path path, String format) throws IOException {
        String formatName = format.toLowerCase();
        if ("jpg".equals(formatName)) {
            formatName = "jpeg";
        }
        
        ImageIO.write(image, formatName, path.toFile());
    }
    
    /**
     * Obtém caminho base para uploads
     */
    private static Path getUploadPath(String subfolder) {
        String baseDir = System.getProperty("upload.base.dir", DEFAULT_UPLOAD_DIR);
        return Paths.get(baseDir, subfolder);
    }
    
    /**
     * Gera nome único para arquivo
     */
    private static String generateUniqueFileName(String extension) {
        String uuid = UUID.randomUUID().toString().replace("-", "");
        String timestamp = String.valueOf(System.currentTimeMillis());
        return timestamp + "_" + uuid + "." + extension;
    }
    
    /**
     * Extrai nome do arquivo do Part
     */
    private static String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        if (contentDisposition != null) {
            for (String content : contentDisposition.split(";")) {
                if (content.trim().startsWith("filename")) {
                    String fileName = content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
                    return fileName;
                }
            }
        }
        return "unknown";
    }
    
    /**
     * Obtém extensão do arquivo
     */
    private static String getFileExtension(String fileName) {
        if (ValidationUtil.isNullOrEmpty(fileName)) return "";
        
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot == -1 || lastDot == fileName.length() - 1) {
            return "";
        }
        
        return fileName.substring(lastDot + 1).toLowerCase();
    }
    
    /**
     * Obtém nome do arquivo sem extensão
     */
    private static String getFileNameWithoutExtension(String fileName) {
        if (ValidationUtil.isNullOrEmpty(fileName)) return "";
        
        int lastDot = fileName.lastIndexOf('.');
        if (lastDot == -1) {
            return fileName;
        }
        
        return fileName.substring(0, lastDot);
    }
    
    /**
     * Verifica se arquivo é uma imagem válida
     */
    private static boolean isValidImageFile(String fileName) {
        String extension = getFileExtension(fileName);
        
        for (String allowedType : ALLOWED_IMAGE_TYPES) {
            if (allowedType.equals(extension)) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Exclui arquivo se existir
     */
    private static boolean deleteFileIfExists(Path path) {
        try {
            return Files.deleteIfExists(path);
        } catch (IOException e) {
            System.err.println("Erro ao excluir arquivo: " + path + " - " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Formata tamanho de arquivo
     */
    private static String formatFileSize(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return String.format("%.1f KB", bytes / 1024.0);
        if (bytes < 1024 * 1024 * 1024) return String.format("%.1f MB", bytes / (1024.0 * 1024.0));
        return String.format("%.1f GB", bytes / (1024.0 * 1024.0 * 1024.0));
    }
    
    /**
     * Verifica se arquivo existe
     */
    public static boolean fileExists(String fileName, String subfolder) {
        if (ValidationUtil.isNullOrEmpty(fileName)) return false;
        
        Path filePath = getUploadPath(subfolder).resolve(fileName);
        return Files.exists(filePath);
    }
    
    /**
     * Obtém URL completa do arquivo
     */
    public static String getFileUrl(String fileName, String subfolder, String contextPath) {
        if (ValidationUtil.isNullOrEmpty(fileName)) {
            return contextPath + "/assets/images/no-image.png";
        }
        
        return contextPath + "/uploads/" + subfolder + "/" + fileName;
    }
    
    /**
     * Obtém URL da versão redimensionada
     */
    public static String getResizedImageUrl(String fileName, String subfolder, String contextPath, String size) {
        if (ValidationUtil.isNullOrEmpty(fileName)) {
            return contextPath + "/assets/images/no-image.png";
        }
        
        String nameWithoutExt = getFileNameWithoutExtension(fileName);
        String extension = getFileExtension(fileName);
        String resizedFileName = nameWithoutExt + "_" + size + "." + extension;
        
        // Verificar se arquivo redimensionado existe
        if (fileExists(resizedFileName, subfolder)) {
            return contextPath + "/uploads/" + subfolder + "/" + resizedFileName;
        } else {
            // Retornar original se redimensionado não existir
            return getFileUrl(fileName, subfolder, contextPath);
        }
    }
    
    /**
     * Cria backup de arquivo
     */
    public static boolean backupFile(String fileName, String subfolder) {
        if (ValidationUtil.isNullOrEmpty(fileName)) return false;
        
        try {
            Path originalPath = getUploadPath(subfolder).resolve(fileName);
            Path backupPath = getUploadPath("backup/" + subfolder);
            
            Files.createDirectories(backupPath);
            
            String timestamp = String.valueOf(System.currentTimeMillis());
            String backupFileName = timestamp + "_" + fileName;
            
            Files.copy(originalPath, backupPath.resolve(backupFileName), StandardCopyOption.REPLACE_EXISTING);
            
            return true;
        } catch (IOException e) {
            System.err.println("Erro ao criar backup: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Limpa arquivos antigos (older than X days)
     */
    public static void cleanOldFiles(String subfolder, int daysOld) {
        try {
            Path uploadPath = getUploadPath(subfolder);
            if (!Files.exists(uploadPath)) return;
            
            long cutoffTime = System.currentTimeMillis() - (daysOld * 24L * 60L * 60L * 1000L);
            
            Files.walk(uploadPath)
                 .filter(Files::isRegularFile)
                 .filter(path -> {
                     try {
                         return Files.getLastModifiedTime(path).toMillis() < cutoffTime;
                     } catch (IOException e) {
                         return false;
                     }
                 })
                 .forEach(path -> {
                     try {
                         Files.delete(path);
                         System.out.println("Arquivo antigo removido: " + path);
                     } catch (IOException e) {
                         System.err.println("Erro ao remover arquivo antigo: " + path + " - " + e.getMessage());
                     }
                 });
                 
        } catch (IOException e) {
            System.err.println("Erro ao limpar arquivos antigos: " + e.getMessage());
        }
    }
    
    /**
     * Obtém informações do arquivo
     */
    public static FileInfo getFileInfo(String fileName, String subfolder) {
        if (ValidationUtil.isNullOrEmpty(fileName)) return null;
        
        try {
            Path filePath = getUploadPath(subfolder).resolve(fileName);
            if (!Files.exists(filePath)) return null;
            
            FileInfo info = new FileInfo();
            info.fileName = fileName;
            info.size = Files.size(filePath);
            info.lastModified = Files.getLastModifiedTime(filePath).toMillis();
            info.mimeType = Files.probeContentType(filePath);
            
            return info;
        } catch (IOException e) {
            return null;
        }
    }
    
    /**
     * Classe para informações de arquivo
     */
    public static class FileInfo {
        public String fileName;
        public long size;
        public long lastModified;
        public String mimeType;
        
        public String getFormattedSize() {
            return formatFileSize(size);
        }
        
        public java.util.Date getLastModifiedDate() {
            return new java.util.Date(lastModified);
        }
    }
    
    /**
     * Valida se imagem tem dimensões mínimas
     */
    public static boolean validateImageDimensions(Part filePart, int minWidth, int minHeight) {
        try (InputStream inputStream = filePart.getInputStream()) {
            BufferedImage image = ImageIO.read(inputStream);
            if (image == null) return false;
            
            return image.getWidth() >= minWidth && image.getHeight() >= minHeight;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Obtém dimensões da imagem
     */
    public static java.awt.Dimension getImageDimensions(Part filePart) {
        try (InputStream inputStream = filePart.getInputStream()) {
            BufferedImage image = ImageIO.read(inputStream);
            if (image == null) return null;
            
            return new java.awt.Dimension(image.getWidth(), image.getHeight());
        } catch (Exception e) {
            return null;
        }
    }
}