package com.livraria.services;

import java.math.BigDecimal;

/**
 * Serviço responsável pelo cálculo do frete.
 */
public class ShippingService {

    /**
     * Calcula o valor do frete com base no peso do pedido e CEP de destino.
     * A lógica real deverá considerar integrações externas ou regras de negócio.
     *
     * @param weight Peso total do pedido em quilogramas
     * @param postalCode CEP de destino
     * @return Valor calculado do frete
     */
    public BigDecimal calculateShipping(double weight, String postalCode) {
        // Implementação simplificada apenas para demonstrar a interface do serviço
        return BigDecimal.ZERO;
    }
}
