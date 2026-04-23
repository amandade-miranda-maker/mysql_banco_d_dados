/*
LOJINHA MA 78
DATA: 22/04/2026
FEITO POR: AMANDA
CORRECOES: Padronizacao de nomes e correcao de tipos DECIMAL
*/

DROP DATABASE IF EXISTS lojinhaMA78;
CREATE DATABASE lojinhaMA78;
USE lojinhaMA78;

-- 1. Tabela Cliente (Sem alteracoes, estava correta)
CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    sobrenome_cliente VARCHAR(100),
    cpf_cliente VARCHAR(11) UNIQUE NOT NULL,
    telefone_cliente VARCHAR(20) UNIQUE NOT NULL,
    email_cliente VARCHAR(80) UNIQUE NOT NULL,
    cidade_cliente VARCHAR(50) NOT NULL,
    cep_cliente VARCHAR(10) NOT NULL
);

-- 2. Tabela Produto (Aumentei o DECIMAL para evitar erro de limite)
CREATE TABLE produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    descricao_produto TEXT,
    preco_produto DECIMAL(10, 2) NOT NULL, -- Alterado de (5,2) para (10,2)
    categoria_produto VARCHAR(20) NOT NULL,
    marca_produto VARCHAR(20) NOT NULL,
    codigo_barras VARCHAR(50) NOT NULL,
    data_validade_produto DATE DEFAULT '2026-01-01',
    peso_produto DECIMAL(8, 2) NOT NULL,
    status_produto ENUM('disponivel', 'indisponivel', 'NAN')
);

-- 3. Tabela Fornecedor
CREATE TABLE fornecedor (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome_fornecedor VARCHAR(100) NOT NULL,
    cnpj_fornecedor VARCHAR(20) NOT NULL UNIQUE,
    telefone_fornecedor VARCHAR(20) NOT NULL,
    email_fornecedor VARCHAR(100) NOT NULL UNIQUE,
    status_fornecedor ENUM('ativo', 'inativo', 'bloqueado')
);

-- 4. Tabela Venda
CREATE TABLE venda (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    data_hora_venda DATETIME NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    forma_pagamento VARCHAR(30) NOT NULL,
    desconto_venda DECIMAL(10, 2),
    id_cliente_na_tabela_venda INT,
    status_venda VARCHAR(20) NOT NULL,
    observacoes_venda TEXT,
    caixa_venda INT NOT NULL,
    FOREIGN KEY (id_cliente_na_tabela_venda) REFERENCES cliente (id_cliente)
);

-- 5. Tabela Item_Venda
CREATE TABLE item_venda (
    id_item_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT,
    id_produto INT,
    quantidade_item INT NOT NULL,
    preco_item DECIMAL(10, 2) NOT NULL,
    subtotal_item DECIMAL(10, 2) NOT NULL,
    imposto_item DECIMAL(10, 2),
    observacao_item TEXT,
    FOREIGN KEY (id_venda) REFERENCES venda (id_venda),
    FOREIGN KEY (id_produto) REFERENCES produto (id_produto),
    UNIQUE (id_venda, id_produto)
);

-- 6. Tabela Estoque
CREATE TABLE estoque (
    id_estoque INT PRIMARY KEY AUTO_INCREMENT,
    id_produto INT,
    quantidade_estoque INT NOT NULL,
    localizacao_estoque VARCHAR(30) NOT NULL,
    data_hora_entrada DATETIME NOT NULL,
    data_hora_saida DATETIME,
    lote VARCHAR(200) NOT NULL,
    validade DATETIME NOT NULL,
    status_estoque VARCHAR(20),
    FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
);

-- 7. Tabela Pagamento 
CREATE TABLE pagamento (
    id_pagamento INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT,
    tipo_pagamento VARCHAR(20),
    valor_pagamento DECIMAL(10, 2) NOT NULL, 
    data_pagamento DATETIME NOT NULL,
    parcelas_pagamento INT NOT NULL, 
    imposto_pagamento DECIMAL(10, 2) NOT NULL,
    bandeira_pagamento VARCHAR(20) DEFAULT 'PAGAMENTO SEM CARTAO',
    observacao_pagamento TEXT, 
    FOREIGN KEY (id_venda) REFERENCES venda (id_venda)
);

---
-- POPULANDO O BANCO (DML)
---

INSERT INTO cliente (nome_cliente, sobrenome_cliente, cpf_cliente, telefone_cliente, email_cliente, cidade_cliente, cep_cliente) VALUES
('Joao', 'Silva', '12345678901', '11988887777', 'joao.silva@email.com', 'Sao Paulo', '01001000'),
('Maria', 'Oliveira', '23456789012', '21977776666', 'maria.oliveira@email.com', 'Rio de Janeiro', '20001000');

INSERT INTO produto (nome_produto, descricao_produto, preco_produto, categoria_produto, marca_produto, codigo_barras, peso_produto, status_produto) VALUES
('Camiseta Basica', 'Algodao fio 30.1', 49.90, 'Vestuario', 'MarcaA', '789123456001', 0.20, 'disponivel'),
('Tenis Esportivo', 'Ideal para corrida', 150.00, 'Calcados', 'MarcaC', '789123456003', 0.80, 'disponivel');

INSERT INTO venda (data_hora_venda, valor_total, forma_pagamento, desconto_venda, id_cliente_na_tabela_venda, status_venda, caixa_venda) VALUES
('2026-04-22 10:30:00', 49.90, 'Cartao Credito', 0.00, 1, 'Finalizada', 1);

-- Agora os nomes das colunas batem com a tabela corrigida
INSERT INTO pagamento (id_venda, tipo_pagamento, valor_pagamento, data_pagamento, parcelas_pagamento, imposto_pagamento, bandeira_pagamento) VALUES
(1, 'Credito', 49.90, '2026-04-22 10:35:00', 1, 2.50, 'Mastercard');