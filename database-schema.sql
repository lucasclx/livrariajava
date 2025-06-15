-- Script de criação do banco de dados da Livraria
-- Execute este script no MySQL para criar todas as tabelas

-- Criar banco de dados se não existir
CREATE DATABASE IF NOT EXISTS livraria_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE livraria_db;

-- ========================================
-- TABELA DE USUÁRIOS
-- ========================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(500) NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(14),
    data_nascimento DATE,
    genero ENUM('M', 'F', 'Outro'),
    is_admin BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    email_verified_at TIMESTAMP NULL,
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_ativo (ativo),
    INDEX idx_admin (is_admin)
);

-- ========================================
-- TABELA DE ENDEREÇOS DE USUÁRIOS
-- ========================================
CREATE TABLE user_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    label VARCHAR(100),
    recipient_name VARCHAR(255) NOT NULL,
    street VARCHAR(255) NOT NULL,
    number VARCHAR(20) NOT NULL,
    complement VARCHAR(255),
    neighborhood VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state CHAR(2) NOT NULL,
    postal_code CHAR(8) NOT NULL,
    reference VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_default (is_default)
);

-- ========================================
-- TABELA DE CATEGORIAS
-- ========================================
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    slug VARCHAR(120) NOT NULL UNIQUE,
    imagem VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_slug (slug),
    INDEX idx_ativo (ativo),
    INDEX idx_nome (nome)
);

-- ========================================
-- TABELA DE LIVROS
-- ========================================
CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    isbn VARCHAR(20),
    editora VARCHAR(255),
    ano_publicacao YEAR,
    preco DECIMAL(10,2) NOT NULL,
    preco_promocional DECIMAL(10,2),
    paginas INT,
    sinopse TEXT,
    sumario TEXT,
    categoria_id INT,
    estoque INT NOT NULL DEFAULT 0,
    estoque_minimo INT DEFAULT 5,
    peso DECIMAL(5,2) DEFAULT 0.50,
    dimensoes VARCHAR(50),
    idioma VARCHAR(50) DEFAULT 'Português',
    edicao VARCHAR(50),
    encadernacao VARCHAR(50),
    imagem VARCHAR(255),
    galeria_imagens TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    destaque BOOLEAN DEFAULT FALSE,
    vendas_total INT DEFAULT 0,
    avaliacao_media DECIMAL(3,2) DEFAULT 0.00,
    total_avaliacoes INT DEFAULT 0,
    promocao_inicio TIMESTAMP NULL,
    promocao_fim TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (categoria_id) REFERENCES categorias(id) ON DELETE SET NULL,
    INDEX idx_categoria (categoria_id),
    INDEX idx_ativo (ativo),
    INDEX idx_destaque (destaque),
    INDEX idx_preco (preco),
    INDEX idx_estoque (estoque),
    INDEX idx_titulo (titulo),
    INDEX idx_autor (autor),
    INDEX idx_isbn (isbn),
    FULLTEXT idx_busca (titulo, autor, editora)
);

-- ========================================
-- TABELA DE CARRINHOS
-- ========================================
CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(255),
    user_id INT,
    status ENUM('active', 'completed', 'cancelled') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_session_id (session_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- ========================================
-- TABELA DE ITENS DO CARRINHO
-- ========================================
CREATE TABLE cart_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    stock_reserved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    INDEX idx_cart_id (cart_id),
    INDEX idx_livro_id (livro_id),
    UNIQUE KEY unique_cart_livro (cart_id, livro_id)
);

-- ========================================
-- TABELA DE CUPONS
-- ========================================
CREATE TABLE cupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    tipo ENUM('percentual', 'valor_fixo') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    valor_minimo_pedido DECIMAL(10,2),
    limite_uso INT,
    vezes_usado INT DEFAULT 0,
    primeiro_pedido_apenas BOOLEAN DEFAULT FALSE,
    valido_de TIMESTAMP NULL,
    valido_ate TIMESTAMP NULL,
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_codigo (codigo),
    INDEX idx_ativo (ativo),
    INDEX idx_validade (valido_de, valido_ate)
);

-- ========================================
-- TABELA DE PEDIDOS
-- ========================================
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    user_id INT NOT NULL,
    cart_id INT,
    cupom_id INT,
    subtotal DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    shipping_cost DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status ENUM('pending_payment', 'confirmed', 'payment_failed', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending_payment',
    notes TEXT,
    observacoes TEXT,
    tracking_code VARCHAR(100),
    
    -- Dados do endereço de entrega
    shipping_recipient_name VARCHAR(255) NOT NULL,
    shipping_street VARCHAR(255) NOT NULL,
    shipping_number VARCHAR(20) NOT NULL,
    shipping_complement VARCHAR(255),
    shipping_neighborhood VARCHAR(100) NOT NULL,
    shipping_city VARCHAR(100) NOT NULL,
    shipping_state CHAR(2) NOT NULL,
    shipping_postal_code CHAR(8) NOT NULL,
    shipping_reference VARCHAR(255),
    
    shipped_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE SET NULL,
    FOREIGN KEY (cupom_id) REFERENCES cupons(id) ON DELETE SET NULL,
    
    INDEX idx_order_number (order_number),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_payment_method (payment_method),
    INDEX idx_created_at (created_at)
);

-- ========================================
-- TABELA DE ITENS DO PEDIDO
-- ========================================
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE RESTRICT,
    
    INDEX idx_order_id (order_id),
    INDEX idx_livro_id (livro_id)
);

-- ========================================
-- TABELA DE FAVORITOS
-- ========================================
CREATE TABLE favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    livro_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_user_livro (user_id, livro_id),
    INDEX idx_user_id (user_id),
    INDEX idx_livro_id (livro_id)
);

-- ========================================
-- TABELA DE AVALIAÇÕES
-- ========================================
CREATE TABLE avaliacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    livro_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    titulo VARCHAR(255),
    comentario TEXT,
    aprovado BOOLEAN DEFAULT FALSE,
    recomenda BOOLEAN DEFAULT TRUE,
    vantagens TEXT,
    desvantagens TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    
    UNIQUE KEY unique_user_livro_review (user_id, livro_id),
    INDEX idx_livro_id (livro_id),
    INDEX idx_user_id (user_id),
    INDEX idx_aprovado (aprovado),
    INDEX idx_rating (rating)
);

-- ========================================
-- INSERÇÕES INICIAIS
-- ========================================

-- Inserir usuário administrador padrão
INSERT INTO users (name, email, password, is_admin, ativo) VALUES 
('Administrador', 'admin@livraria.com', 'MTIzNDU2eGi3t6h4MzIxEiO4aOLKFZmNzY2ZjYwNjc=', TRUE, TRUE);

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

-- ========================================
-- TRIGGERS PARA ATUALIZAÇÃO AUTOMÁTICA
-- ========================================

-- Trigger para atualizar vendas_total quando um pedido é confirmado
DELIMITER $
CREATE TRIGGER update_book_sales_after_order 
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF NEW.status = 'confirmed' AND OLD.status != 'confirmed' THEN
        UPDATE livros l
        JOIN order_items oi ON l.id = oi.livro_id
        SET l.vendas_total = l.vendas_total + oi.quantity
        WHERE oi.order_id = NEW.id;
    END IF;
END$
DELIMITER ;

-- Trigger para atualizar avaliação média dos livros
DELIMITER $
CREATE TRIGGER update_book_rating_after_review 
AFTER INSERT ON avaliacoes
FOR EACH ROW
BEGIN
    UPDATE livros 
    SET 
        avaliacao_media = (
            SELECT AVG(rating) 
            FROM avaliacoes 
            WHERE livro_id = NEW.livro_id AND aprovado = TRUE
        ),
        total_avaliacoes = (
            SELECT COUNT(*) 
            FROM avaliacoes 
            WHERE livro_id = NEW.livro_id AND aprovado = TRUE
        )
    WHERE id = NEW.livro_id;
END$
DELIMITER ;

-- Trigger para atualizar avaliação após aprovação
DELIMITER $
CREATE TRIGGER update_book_rating_after_approval 
AFTER UPDATE ON avaliacoes
FOR EACH ROW
BEGIN
    IF NEW.aprovado != OLD.aprovado THEN
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
END$
DELIMITER ;

-- ========================================
-- VIEWS ÚTEIS
-- ========================================

-- View para livros com informações da categoria
CREATE VIEW vw_livros_categoria AS
SELECT 
    l.*,
    c.nome as categoria_nome,
    c.slug as categoria_slug
FROM livros l
LEFT JOIN categorias c ON l.categoria_id = c.id;

-- View para pedidos com informações do usuário
CREATE VIEW vw_pedidos_usuario AS
SELECT 
    o.*,
    u.name as user_name,
    u.email as user_email
FROM orders o
JOIN users u ON o.user_id = u.id;

-- View para estatísticas de vendas
CREATE VIEW vw_estatisticas_vendas AS
SELECT 
    DATE(o.created_at) as data_venda,
    COUNT(*) as total_pedidos,
    SUM(o.total) as faturamento_dia,
    AVG(o.total) as ticket_medio
FROM orders o
WHERE o.status IN ('confirmed', 'processing', 'shipped', 'delivered')
GROUP BY DATE(o.created_at)
ORDER BY data_venda DESC;

-- ========================================
-- PROCEDIMENTOS ARMAZENADOS
-- ========================================

-- Procedimento para limpar carrinhos abandonados
DELIMITER $
CREATE PROCEDURE LimparCarrinhosAbandonados(IN dias_inativo INT)
BEGIN
    DELETE FROM carts 
    WHERE status = 'active' 
    AND updated_at < DATE_SUB(NOW(), INTERVAL dias_inativo DAY);
    
    SELECT ROW_COUNT() as carrinhos_removidos;
END$
DELIMITER ;

-- Procedimento para relatório de vendas por período
DELIMITER $
CREATE PROCEDURE RelatorioVendasPeriodo(
    IN data_inicio DATE, 
    IN data_fim DATE
)
BEGIN
    SELECT 
        DATE(o.created_at) as data_venda,
        COUNT(*) as total_pedidos,
        SUM(o.total) as faturamento,
        AVG(o.total) as ticket_medio,
        SUM(oi.quantity) as livros_vendidos
    FROM orders o
    JOIN order_items oi ON o.id = oi.order_id
    WHERE DATE(o.created_at) BETWEEN data_inicio AND data_fim
    AND o.status IN ('confirmed', 'processing', 'shipped', 'delivered')
    GROUP BY DATE(o.created_at)
    ORDER BY data_venda;
END$
DELIMITER ;

-- ========================================
-- ÍNDICES ADICIONAIS PARA PERFORMANCE
-- ========================================

-- Índices compostos para melhorar consultas
CREATE INDEX idx_orders_user_status ON orders(user_id, status);
CREATE INDEX idx_orders_date_status ON orders(created_at, status);
CREATE INDEX idx_livros_categoria_ativo ON livros(categoria_id, ativo);
CREATE INDEX idx_livros_preco_ativo ON livros(preco, ativo);
CREATE INDEX idx_avaliacoes_livro_aprovado ON avaliacoes(livro_id, aprovado);

-- ========================================
-- COMENTÁRIOS FINAIS
-- ========================================

/*
Este script cria um banco de dados completo para a livraria com:

1. Estrutura de usuários e autenticação
2. Sistema de produtos (livros) com categorias
3. Carrinho de compras
4. Sistema de pedidos completo
5. Favoritos e avaliações
6. Sistema de cupons de desconto
7. Triggers para atualizações automáticas
8. Views para consultas otimizadas
9. Procedimentos para manutenção

Para usar:
1. Execute este script no MySQL
2. Configure o context.xml com os dados de conexão
3. Inicie a aplicação

Usuário admin padrão:
- Email: admin@livraria.com
- Senha: 123456 (altere após o primeiro login)
*/