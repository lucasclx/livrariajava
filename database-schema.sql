-- Script de criação do banco de dados para Livraria Java
-- Execute este script no seu MySQL para criar as tabelas necessárias

CREATE DATABASE IF NOT EXISTS livraria_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE livraria_db;

-- Tabela de usuários
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(14),
    data_nascimento DATE,
    genero ENUM('masculino', 'feminino', 'outro'),
    is_admin BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    email_verified_at TIMESTAMP NULL,
    last_login_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_ativo (ativo)
);

-- Tabela de categorias
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    slug VARCHAR(120) UNIQUE,
    imagem VARCHAR(255),
    ativo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_ativo (ativo)
);

-- Tabela de livros
CREATE TABLE livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    isbn VARCHAR(20),
    editora VARCHAR(100),
    ano_publicacao INT,
    preco DECIMAL(10,2) NOT NULL,
    preco_promocional DECIMAL(10,2),
    paginas INT,
    sinopse TEXT,
    sumario TEXT,
    categoria_id INT,
    estoque INT DEFAULT 0,
    estoque_minimo INT DEFAULT 5,
    peso DECIMAL(5,2) DEFAULT 0.5,
    dimensoes VARCHAR(50),
    idioma VARCHAR(30) DEFAULT 'Português',
    edicao VARCHAR(50),
    encadernacao VARCHAR(30),
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
    INDEX idx_titulo (titulo),
    INDEX idx_autor (autor),
    INDEX idx_categoria (categoria_id),
    INDEX idx_ativo (ativo),
    INDEX idx_destaque (destaque),
    INDEX idx_preco (preco),
    INDEX idx_estoque (estoque)
);

-- Tabela de endereços dos usuários
CREATE TABLE user_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    label VARCHAR(50),
    recipient_name VARCHAR(255),
    street VARCHAR(255) NOT NULL,
    number VARCHAR(20) NOT NULL,
    complement VARCHAR(100),
    neighborhood VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(2) NOT NULL,
    postal_code VARCHAR(10) NOT NULL,
    reference VARCHAR(255),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);

-- Tabela de carrinhos
CREATE TABLE carts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(100),
    user_id INT,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_session_id (session_id),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- Tabela de itens do carrinho
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
    INDEX idx_livro_id (livro_id)
);

-- Tabela de cupons
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
    INDEX idx_ativo (ativo)
);

-- Tabela de pedidos
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    cart_id INT,
    user_id INT NOT NULL,
    cupom_id INT,
    subtotal DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0.00,
    shipping_cost DECIMAL(10,2) DEFAULT 0.00,
    total DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(30) DEFAULT 'pending_payment',
    notes TEXT,
    observacoes TEXT,
    tracking_code VARCHAR(100),
    shipped_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    
    -- Endereço de entrega
    shipping_recipient_name VARCHAR(255),
    shipping_street VARCHAR(255),
    shipping_number VARCHAR(20),
    shipping_complement VARCHAR(100),
    shipping_neighborhood VARCHAR(100),
    shipping_city VARCHAR(100),
    shipping_state VARCHAR(2),
    shipping_postal_code VARCHAR(10),
    shipping_reference VARCHAR(255),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE SET NULL,
    FOREIGN KEY (cupom_id) REFERENCES cupons(id) ON DELETE SET NULL,
    INDEX idx_order_number (order_number),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
);

-- Tabela de itens do pedido
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

-- Tabela de favoritos
CREATE TABLE favoritos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    livro_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    UNIQUE KEY unique_favorite (user_id, livro_id),
    INDEX idx_user_id (user_id),
    INDEX idx_livro_id (livro_id)
);

-- Tabela de avaliações
CREATE TABLE avaliacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    livro_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
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
    UNIQUE KEY unique_user_review (livro_id, user_id),
    INDEX idx_livro_id (livro_id),
    INDEX idx_user_id (user_id),
    INDEX idx_aprovado (aprovado)
);

-- Inserir dados iniciais

-- Usuário administrador padrão
INSERT INTO users (name, email, password, is_admin, ativo) 
VALUES ('Administrador', 'admin@livraria.com', 'simple_hash_123456', TRUE, TRUE);

-- Categorias iniciais
INSERT INTO categorias (nome, descricao, slug, ativo) VALUES 
('Ficção', 'Livros de ficção em geral', 'ficcao', TRUE),
('Romance', 'Livros de romance', 'romance', TRUE),
('Suspense', 'Livros de suspense e thriller', 'suspense', TRUE),
('Fantasia', 'Livros de fantasia e ficção científica', 'fantasia', TRUE),
('Biografias', 'Biografias e autobiografias', 'biografias', TRUE),
('Tecnologia', 'Livros sobre tecnologia e programação', 'tecnologia', TRUE),
('Negócios', 'Livros sobre negócios e empreendedorismo', 'negocios', TRUE),
('Autoajuda', 'Livros de autoajuda e desenvolvimento pessoal', 'autoajuda', TRUE);

-- Livros de exemplo
INSERT INTO livros (titulo, autor, isbn, editora, ano_publicacao, preco, categoria_id, estoque, sinopse, ativo, destaque) VALUES 
('O Senhor dos Anéis', 'J.R.R. Tolkien', '9788533613379', 'Martins Fontes', 2000, 45.90, 4, 10, 'Uma épica jornada pela Terra Média.', TRUE, TRUE),
('1984', 'George Orwell', '9788535914849', 'Companhia das Letras', 2009, 32.90, 1, 15, 'Um clássico da distopia moderna.', TRUE, TRUE),
('O Código Limpo', 'Robert C. Martin', '9788576082675', 'Alta Books', 2012, 89.90, 6, 8, 'Habilidades práticas do Agile Software.', TRUE, FALSE),
('Sapiens', 'Yuval Noah Harari', '9788525432228', 'L&PM', 2015, 54.90, 5, 12, 'Uma breve história da humanidade.', TRUE, TRUE);

-- Cupom de teste
INSERT INTO cupons (codigo, descricao, tipo, valor, ativo) 
VALUES ('BEMVINDO10', 'Desconto de 10% para novos clientes', 'percentual', 10.00, TRUE);
