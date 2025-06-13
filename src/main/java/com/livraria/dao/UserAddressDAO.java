package com.livraria.dao;

import com.livraria.models.UserAddress;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * DAO para operações com endereços de usuários
 */
public class UserAddressDAO extends BaseDAO<UserAddress> {

    @Override
    protected String getTableName() {
        return "user_addresses";
    }

    @Override
    public UserAddress findById(Long id) {
        String sql = "SELECT * FROM user_addresses WHERE id = ?";
        return executeSingleQuery(sql, this::mapRowToAddress, id);
    }
    
    public List<UserAddress> findByUserId(Integer userId) {
        String sql = "SELECT * FROM user_addresses WHERE user_id = ? ORDER BY is_default DESC, label ASC";
        return executeQuery(sql, this::mapRowToAddress, userId);
    }

    @Override
    public UserAddress save(UserAddress address) {
        String sql = "INSERT INTO user_addresses (user_id, label, recipient_name, street, number, complement, neighborhood, city, state, postal_code, reference, is_default, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        int id = executeInsert(sql,
            address.getUserId(), address.getLabel(), address.getRecipientName(),
            address.getStreet(), address.getNumber(), address.getComplement(),
            address.getNeighborhood(), address.getCity(), address.getState(),
            address.getPostalCode(), address.getReference(), address.isDefault()
        );
        address.setId(id);
        return address;
    }

    @Override
    public UserAddress update(UserAddress address) {
        String sql = "UPDATE user_addresses SET label = ?, recipient_name = ?, street = ?, number = ?, complement = ?, neighborhood = ?, city = ?, state = ?, postal_code = ?, reference = ?, is_default = ?, updated_at = NOW() WHERE id = ?";
        
        executeUpdate(sql,
            address.getLabel(), address.getRecipientName(),
            address.getStreet(), address.getNumber(), address.getComplement(),
            address.getNeighborhood(), address.getCity(), address.getState(),
            address.getPostalCode(), address.getReference(), address.isDefault(),
            address.getId()
        );
        return address;
    }

    @Override
    public boolean delete(Long id) {
        String sql = "DELETE FROM user_addresses WHERE id = ?";
        return executeUpdate(sql, id) > 0;
    }
    
    @Override
    protected UserAddress mapResultSetToEntity(ResultSet rs) throws SQLException {
        return mapRowToAddress(rs);
    }
    
    private UserAddress mapRowToAddress(ResultSet rs) throws SQLException {
        UserAddress address = new UserAddress();
        address.setId(rs.getInt("id"));
        address.setUserId(rs.getInt("user_id"));
        address.setLabel(rs.getString("label"));
        address.setRecipientName(rs.getString("recipient_name"));
        address.setStreet(rs.getString("street"));
        address.setNumber(rs.getString("number"));
        address.setComplement(rs.getString("complement"));
        address.setNeighborhood(rs.getString("neighborhood"));
        address.setCity(rs.getString("city"));
        address.setState(rs.getString("state"));
        address.setPostalCode(rs.getString("postal_code"));
        address.setReference(rs.getString("reference"));
        address.setDefault(rs.getBoolean("is_default"));
        address.setCreatedAt(toLocalDateTime(rs.getTimestamp("created_at")));
        address.setUpdatedAt(toLocalDateTime(rs.getTimestamp("updated_at")));
        return address;
    }
    
    // Métodos não utilizados da classe abstrata
    @Override
    public List<UserAddress> findAll() {
        throw new UnsupportedOperationException("Não suportado. Use findByUserId.");
    }
}