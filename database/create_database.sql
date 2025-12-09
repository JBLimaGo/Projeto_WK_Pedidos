-- Script de criação do banco de dados MySQL
-- Sistema de Pedidos WK

-- Criar banco de dados
CREATE DATABASE IF NOT EXISTS pedidos
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

USE pedidos;

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
  codigo INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  cidade VARCHAR(100) NOT NULL,
  uf CHAR(2) NOT NULL,
  INDEX idx_nome (nome),
  INDEX idx_cidade (cidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Produtos
CREATE TABLE IF NOT EXISTS produtos (
  codigo INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(200) NOT NULL,
  preco_venda DECIMAL(10,2) NOT NULL,
  INDEX idx_descricao (descricao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
  numero_pedido INT AUTO_INCREMENT PRIMARY KEY,
  data_emissao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  codigo_cliente INT NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  INDEX idx_data_emissao (data_emissao),
  INDEX idx_codigo_cliente (codigo_cliente),
  CONSTRAINT fk_pedido_cliente
    FOREIGN KEY (codigo_cliente)
    REFERENCES clientes(codigo)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabela de Itens dos Pedidos
CREATE TABLE IF NOT EXISTS pedidos_produtos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  numero_pedido INT NOT NULL,
  id_item INT NOT NULL,
  codigo_produto INT NOT NULL,
  quantidade DOUBLE NOT NULL,
  valor_unitario DECIMAL(10,2) NOT NULL,
  valor_total DECIMAL(10,2) NOT NULL,
  INDEX idx_numero_pedido (numero_pedido),
  INDEX idx_codigo_produto (codigo_produto),
  CONSTRAINT fk_item_pedido
    FOREIGN KEY (numero_pedido)
    REFERENCES pedidos(numero_pedido)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_item_produto
    FOREIGN KEY (codigo_produto)
    REFERENCES produtos(codigo)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Inserir dados de exemplo para testes

-- Clientes de exemplo
INSERT INTO clientes (nome, cidade, uf) VALUES
  ('João Silva', 'São Paulo', 'SP'),
  ('Maria Oliveira', 'Rio de Janeiro', 'RJ'),
  ('Pedro Santos', 'Belo Horizonte', 'MG'),
  ('Ana Costa', 'Curitiba', 'PR'),
  ('Carlos Souza', 'Porto Alegre', 'RS');

-- Produtos de exemplo
INSERT INTO produtos (descricao, preco_venda) VALUES
  ('Notebook Dell Inspiron 15', 3500.00),
  ('Mouse Logitech MX Master', 350.00),
  ('Teclado Mecânico Keychron', 450.00),
  ('Monitor LG 27 Polegadas', 1200.00),
  ('Webcam Logitech C920', 550.00),
  ('Headset HyperX Cloud', 380.00),
  ('SSD Samsung 1TB', 600.00),
  ('Memória RAM 16GB DDR4', 400.00),
  ('HD Externo 2TB', 500.00),
  ('Mousepad Gamer Grande', 80.00);

-- Pedidos de exemplo
INSERT INTO pedidos (data_emissao, codigo_cliente, valor_total) VALUES
  (NOW(), 1, 4300.00),
  (NOW(), 2, 2350.00);

-- Itens do primeiro pedido
INSERT INTO pedidos_produtos (numero_pedido, id_item, codigo_produto, quantidade, valor_unitario, valor_total) VALUES
  (1, 1, 1, 1, 3500.00, 3500.00),
  (1, 2, 2, 1, 350.00, 350.00),
  (1, 3, 3, 1, 450.00, 450.00);

-- Itens do segundo pedido
INSERT INTO pedidos_produtos (numero_pedido, id_item, codigo_produto, quantidade, valor_unitario, valor_total) VALUES
  (2, 1, 4, 1, 1200.00, 1200.00),
  (2, 2, 5, 1, 550.00, 550.00),
  (2, 3, 7, 1, 600.00, 600.00);
