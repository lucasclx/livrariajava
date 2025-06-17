-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema livraria_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `livraria_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci ;
USE `livraria_db` ;

-- -----------------------------------------------------
-- Table `livraria_db`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`categorias` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `descricao` TEXT NULL DEFAULT NULL,
  `slug` VARCHAR(120) NOT NULL,
  `imagem` VARCHAR(255) NULL DEFAULT NULL,
  `ativo` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nome` (`nome` ASC),
  UNIQUE INDEX `slug` (`slug` ASC),
  INDEX `idx_slug` (`slug` ASC),
  INDEX `idx_ativo` (`ativo` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`livros`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`livros` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(255) NOT NULL,
  `autor` VARCHAR(255) NOT NULL,
  `isbn` VARCHAR(20) NULL DEFAULT NULL,
  `editora` VARCHAR(255) NULL DEFAULT NULL,
  `ano_publicacao` YEAR NULL DEFAULT NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  `preco_promocional` DECIMAL(10,2) NULL DEFAULT NULL,
  `paginas` INT NULL DEFAULT NULL,
  `sinopse` TEXT NULL DEFAULT NULL,
  `sumario` TEXT NULL DEFAULT NULL,
  `categoria_id` INT NULL DEFAULT NULL,
  `estoque` INT NOT NULL DEFAULT 0,
  `estoque_minimo` INT NOT NULL DEFAULT 5,
  `peso` DECIMAL(5,2) NULL DEFAULT 0.50,
  `dimensoes` VARCHAR(50) NULL DEFAULT NULL,
  `idioma` VARCHAR(50) NULL DEFAULT 'Português',
  `edicao` VARCHAR(50) NULL DEFAULT NULL,
  `encadernacao` VARCHAR(50) NULL DEFAULT NULL,
  `imagem` VARCHAR(255) NULL DEFAULT NULL,
  `galeria_imagens` TEXT NULL DEFAULT NULL,
  `ativo` TINYINT(1) NOT NULL DEFAULT 1,
  `destaque` TINYINT(1) NOT NULL DEFAULT 0,
  `vendas_total` INT NOT NULL DEFAULT 0,
  `avaliacao_media` DECIMAL(3,2) NOT NULL DEFAULT 0.00,
  `total_avaliacoes` INT NOT NULL DEFAULT 0,
  `promocao_inicio` TIMESTAMP NULL DEFAULT NULL,
  `promocao_fim` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_categoria` (`categoria_id` ASC),
  INDEX `idx_ativo_destaque` (`ativo` ASC, `destaque` ASC),
  FULLTEXT INDEX `idx_busca` (`titulo`, `autor`, `editora`),
  CONSTRAINT `livros_ibfk_1`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `livraria_db`.`categorias` (`id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(500) NOT NULL,
  `telefone` VARCHAR(20) NULL DEFAULT NULL,
  `cpf` VARCHAR(14) NULL DEFAULT NULL,
  `data_nascimento` DATE NULL DEFAULT NULL,
  `genero` ENUM('M', 'F', 'Outro') NULL DEFAULT NULL,
  `is_admin` TINYINT(1) NOT NULL DEFAULT 0,
  `ativo` TINYINT(1) NOT NULL DEFAULT 1,
  `email_verified_at` TIMESTAMP NULL DEFAULT NULL,
  `last_login_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC),
  INDEX `idx_email` (`email` ASC),
  INDEX `idx_ativo` (`ativo` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`avaliacoes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`avaliacoes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `livro_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `rating` INT NOT NULL,
  `titulo` VARCHAR(255) NULL DEFAULT NULL,
  `comentario` TEXT NULL DEFAULT NULL,
  `aprovado` TINYINT(1) NOT NULL DEFAULT 0,
  `recomenda` TINYINT(1) NOT NULL DEFAULT 1,
  `vantagens` TEXT NULL DEFAULT NULL,
  `desvantagens` TEXT NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_user_livro_review` (`user_id` ASC, `livro_id` ASC),
  INDEX `idx_livro_aprovado` (`livro_id` ASC, `aprovado` ASC),
  CONSTRAINT `avaliacoes_ibfk_1`
    FOREIGN KEY (`livro_id`)
    REFERENCES `livraria_db`.`livros` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `avaliacoes_ibfk_2`
    FOREIGN KEY (`user_id`)
    REFERENCES `livraria_db`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`carts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`carts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `session_id` VARCHAR(255) NULL DEFAULT NULL,
  `user_id` INT NULL DEFAULT NULL,
  `status` ENUM('active', 'completed', 'cancelled') NOT NULL DEFAULT 'active',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_id_status` (`user_id` ASC, `status` ASC),
  CONSTRAINT `carts_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `livraria_db`.`users` (`id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`cart_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`cart_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cart_id` INT NOT NULL,
  `livro_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `price` DECIMAL(10,2) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_cart_livro` (`cart_id` ASC, `livro_id` ASC),
  INDEX `livro_id` (`livro_id` ASC),
  CONSTRAINT `cart_items_ibfk_1`
    FOREIGN KEY (`cart_id`)
    REFERENCES `livraria_db`.`carts` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2`
    FOREIGN KEY (`livro_id`)
    REFERENCES `livraria_db`.`livros` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`cupons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`cupons` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `codigo` VARCHAR(50) NOT NULL,
  `descricao` VARCHAR(255) NULL DEFAULT NULL,
  `tipo` ENUM('percentual', 'valor_fixo') NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `valor_minimo_pedido` DECIMAL(10,2) NULL DEFAULT NULL,
  `limite_uso` INT NULL DEFAULT NULL,
  `vezes_usado` INT NOT NULL DEFAULT 0,
  `primeiro_pedido_apenas` TINYINT(1) NOT NULL DEFAULT 0,
  `valido_de` TIMESTAMP NULL DEFAULT NULL,
  `valido_ate` TIMESTAMP NULL DEFAULT NULL,
  `ativo` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `codigo` (`codigo` ASC),
  INDEX `idx_codigo_ativo` (`codigo` ASC, `ativo` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`favoritos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`favoritos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `livro_id` INT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `unique_user_livro` (`user_id` ASC, `livro_id` ASC),
  INDEX `livro_id` (`livro_id` ASC),
  CONSTRAINT `favoritos_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `livraria_db`.`users` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `favoritos_ibfk_2`
    FOREIGN KEY (`livro_id`)
    REFERENCES `livraria_db`.`livros` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_number` VARCHAR(50) NOT NULL,
  `user_id` INT NOT NULL,
  `cart_id` INT NULL DEFAULT NULL,
  `cupom_id` INT NULL DEFAULT NULL,
  `subtotal` DECIMAL(10,2) NOT NULL,
  `desconto` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `shipping_cost` DECIMAL(10,2) NOT NULL,
  `total` DECIMAL(10,2) NOT NULL,
  `payment_method` VARCHAR(50) NOT NULL,
  `status` ENUM('pending_payment', 'confirmed', 'payment_failed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') NOT NULL DEFAULT 'pending_payment',
  `notes` TEXT NULL DEFAULT NULL,
  `observacoes` TEXT NULL DEFAULT NULL,
  `tracking_code` VARCHAR(100) NULL DEFAULT NULL,
  `shipping_recipient_name` VARCHAR(255) NOT NULL,
  `shipping_street` VARCHAR(255) NOT NULL,
  `shipping_number` VARCHAR(20) NOT NULL,
  `shipping_complement` VARCHAR(255) NULL DEFAULT NULL,
  `shipping_neighborhood` VARCHAR(100) NOT NULL,
  `shipping_city` VARCHAR(100) NOT NULL,
  `shipping_state` CHAR(2) NOT NULL,
  `shipping_postal_code` CHAR(8) NOT NULL,
  `shipping_reference` VARCHAR(255) NULL DEFAULT NULL,
  `shipped_at` TIMESTAMP NULL DEFAULT NULL,
  `delivered_at` TIMESTAMP NULL DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `order_number` (`order_number` ASC),
  INDEX `cart_id` (`cart_id` ASC),
  INDEX `cupom_id` (`cupom_id` ASC),
  INDEX `idx_user_status` (`user_id` ASC, `status` ASC),
  INDEX `idx_created_at` (`created_at` ASC),
  CONSTRAINT `orders_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `livraria_db`.`users` (`id`)
    ON DELETE RESTRICT,
  CONSTRAINT `orders_ibfk_2`
    FOREIGN KEY (`cart_id`)
    REFERENCES `livraria_db`.`carts` (`id`)
    ON DELETE SET NULL,
  CONSTRAINT `orders_ibfk_3`
    FOREIGN KEY (`cupom_id`)
    REFERENCES `livraria_db`.`cupons` (`id`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`order_items` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NOT NULL,
  `livro_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  `total_price` DECIMAL(10,2) NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_order_id` (`order_id` ASC),
  INDEX `idx_livro_id` (`livro_id` ASC),
  CONSTRAINT `order_items_ibfk_1`
    FOREIGN KEY (`order_id`)
    REFERENCES `livraria_db`.`orders` (`id`)
    ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2`
    FOREIGN KEY (`livro_id`)
    REFERENCES `livraria_db`.`livros` (`id`)
    ON DELETE RESTRICT)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- Table `livraria_db`.`user_addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `livraria_db`.`user_addresses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `label` VARCHAR(100) NULL DEFAULT NULL,
  `recipient_name` VARCHAR(255) NOT NULL,
  `street` VARCHAR(255) NOT NULL,
  `number` VARCHAR(20) NOT NULL,
  `complement` VARCHAR(255) NULL DEFAULT NULL,
  `neighborhood` VARCHAR(100) NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `state` CHAR(2) NOT NULL,
  `postal_code` CHAR(8) NOT NULL,
  `reference` VARCHAR(255) NULL DEFAULT NULL,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_id` (`user_id` ASC),
  CONSTRAINT `user_addresses_ibfk_1`
    FOREIGN KEY (`user_id`)
    REFERENCES `livraria_db`.`users` (`id`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_unicode_ci;


-- -----------------------------------------------------
-- View `livraria_db`.`vw_livros_completos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `livraria_db`.`vw_livros_completos`;
USE `livraria_db`;
CREATE OR REPLACE VIEW `vw_livros_completos` AS 
SELECT 
    l.*,
    c.nome AS categoria_nome,
    c.slug AS categoria_slug
FROM 
    `livros` l
LEFT JOIN 
    `categorias` c ON l.categoria_id = c.id;

-- -----------------------------------------------------
-- View `livraria_db`.`vw_pedidos_completos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `livraria_db`.`vw_pedidos_completos`;
USE `livraria_db`;
CREATE OR REPLACE VIEW `vw_pedidos_completos` AS 
SELECT 
    o.*,
    u.name AS user_name,
    u.email AS user_email
FROM 
    `orders` o
JOIN 
    `users` u ON o.user_id = u.id;

-- -----------------------------------------------------
-- Stored Procedure `sp_limpar_carrinhos_abandonados`
-- -----------------------------------------------------
DELIMITER $$
USE `livraria_db`$$
CREATE PROCEDURE `sp_limpar_carrinhos_abandonados`(IN dias_inativo INT)
BEGIN
    DELETE FROM carts 
    WHERE status = 'active' 
    AND updated_at < DATE_SUB(NOW(), INTERVAL dias_inativo DAY);
    
    SELECT ROW_COUNT() as carrinhos_removidos;
END$$
DELIMITER ;

-- -----------------------------------------------------
-- Triggers
-- -----------------------------------------------------
DELIMITER $$
USE `livraria_db`$$
CREATE TRIGGER `trg_update_book_rating_after_review`
AFTER UPDATE ON `avaliacoes`
FOR EACH ROW
BEGIN
    IF NEW.aprovado = TRUE THEN
        UPDATE livros 
        SET 
            avaliacao_media = (
                SELECT COALESCE(AVG(rating), 0) 
                FROM avaliacoes 
                WHERE livro_id = NEW.livro_id AND aprovado = TRUE
            ),
            total_avaliacoes = (
                SELECT COUNT(*) 
                FROM avaliacoes 
                WHERE livro_id = NEW.livro_id AND aprovado = TRUE
            )
        WHERE id = NEW.livro_id;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
USE `livraria_db`$$
CREATE TRIGGER `trg_update_book_sales_after_order_update`
AFTER UPDATE ON `orders`
FOR EACH ROW
BEGIN
    -- Apenas executa se o status mudou para 'confirmed'
    IF NEW.status = 'confirmed' AND OLD.status != 'confirmed' THEN
        UPDATE livros l
        INNER JOIN order_items oi ON l.id = oi.livro_id
        SET l.vendas_total = l.vendas_total + oi.quantity
        WHERE oi.order_id = NEW.id;
    END IF;
END$$
DELIMITER ;

-- ========================================
-- INSERÇÕES INICIAIS
-- ========================================

-- Inserir usuário administrador padrão
INSERT INTO users (name, email, password, is_admin, ativo) VALUES 
('Administrador', 'admin@livraria.com', 'h/BQytsjSgoAp+ZZzh0QGdAHbKt05GyWo4bfo7h0XjS6zGtEPRuGtPPVEWWQn1KX', TRUE, TRUE);

-- Inserir categorias iniciais
INSERT INTO categorias (nome, descricao, slug, ativo) VALUES 
('Ficção', 'Livros de ficção, romances e literatura em geral', 'ficcao', TRUE),
('Não-Ficção', 'Livros técnicos, biografias, história e outros', 'nao-ficcao', TRUE),
('Infantil', 'Livros infantis e juvenis', 'infantil', TRUE),
('Técnico', 'Livros técnicos, programação, ciências', 'tecnico', TRUE),
('Autoajuda', 'Livros de desenvolvimento pessoal e autoajuda', 'autoajuda', TRUE),
('História', 'Livros de história e ciências humanas', 'historia', TRUE),
('Ciências', 'Livros de ciências exatas e biológicas', 'ciencias', TRUE),
('Arte', 'Livros de arte, design e cultura', 'arte', TRUE);

-- Inserir alguns livros de exemplo
INSERT INTO livros (titulo, autor, preco, categoria_id, estoque, ativo, destaque) VALUES 
('Dom Casmurro', 'Machado de Assis', 29.90, 1, 15, TRUE, TRUE),
('O Cortiço', 'Aluísio Azevedo', 24.90, 1, 20, TRUE, FALSE),
('Sapiens', 'Yuval Noah Harari', 49.90, 2, 10, TRUE, TRUE),
('Clean Code', 'Robert C. Martin', 89.90, 4, 8, TRUE, TRUE),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 19.90, 3, 25, TRUE, TRUE);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;