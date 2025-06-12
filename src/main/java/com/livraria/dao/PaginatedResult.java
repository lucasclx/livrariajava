package com.livraria.dao;

import java.util.List;

/**
 * Classe para representar resultados paginados
 */
public class PaginatedResult<T> {
    
    private List<T> items;
    private int currentPage;
    private int pageSize;
    private int totalItems;
    private int totalPages;
    
    public PaginatedResult(List<T> items, int currentPage, int pageSize, int totalItems) {
        this.items = items;
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalItems = totalItems;
        this.totalPages = (int) Math.ceil((double) totalItems / pageSize);
    }
    
    // Getters
    public List<T> getItems() { return items; }
    public int getCurrentPage() { return currentPage; }
    public int getPageSize() { return pageSize; }
    public int getTotalItems() { return totalItems; }
    public int getTotalPages() { return totalPages; }
    
    // Métodos de conveniência
    public boolean hasNext() {
        return currentPage < totalPages;
    }
    
    public boolean hasPrevious() {
        return currentPage > 1;
    }
    
    public int getNextPage() {
        return hasNext() ? currentPage + 1 : currentPage;
    }
    
    public int getPreviousPage() {
        return hasPrevious() ? currentPage - 1 : currentPage;
    }
    
    public boolean isEmpty() {
        return items == null || items.isEmpty();
    }
    
    public int getStartItem() {
        if (isEmpty()) return 0;
        return (currentPage - 1) * pageSize + 1;
    }
    
    public int getEndItem() {
        if (isEmpty()) return 0;
        return Math.min(currentPage * pageSize, totalItems);
    }
    
    @Override
    public String toString() {
        return String.format("PaginatedResult{items=%d, page=%d/%d, total=%d}", 
                           items.size(), currentPage, totalPages, totalItems);
    }
}