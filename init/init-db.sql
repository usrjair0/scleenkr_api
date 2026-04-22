-- $cleenkr Database Schema 2026
-- Nome do Banco de Dados: scleenkr

BEGIN;

-- 1. Gestão de Empresas (Unidades de Negócio)
CREATE TABLE IF NOT EXISTS empresas (
    id_empresa SERIAL PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    nome_fantasia VARCHAR(255),
    cnpj VARCHAR(20) UNIQUE,
    inscricao_estadual VARCHAR(20),
    endereco TEXT,
    cidade VARCHAR(100),
    estado CHARACTER(2),
    cep VARCHAR(10),
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Operadores e Atendentes
CREATE TABLE IF NOT EXISTS atendentes (
    id_atendente SERIAL PRIMARY KEY,
    id_empresa INTEGER REFERENCES empresas(id_empresa),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Controle de Fluxo de Caixa (Sessões)
CREATE TABLE IF NOT EXISTS sessoes_caixa (
    id_sessao SERIAL PRIMARY KEY,
    id_atendente INTEGER REFERENCES atendentes(id_atendente),
    id_empresa INTEGER REFERENCES empresas(id_empresa),
    data_abertura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fechamento TIMESTAMP,
    valor_inicial NUMERIC(10, 2) DEFAULT 0,
    valor_final NUMERIC(10, 2),
    status VARCHAR(20) DEFAULT 'aberta'
);

-- 4. Registro de Vendas
CREATE TABLE IF NOT EXISTS vendas (
    id_venda SERIAL PRIMARY KEY,
    id_sessao INTEGER REFERENCES sessoes_caixa(id_sessao),
    id_atendente INTEGER REFERENCES atendentes(id_atendente),
    id_empresa INTEGER REFERENCES empresas(id_empresa),
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor_total_bruto NUMERIC(10, 2) NOT NULL,
    valor_pago_total NUMERIC(10, 2) NOT NULL,
    valor_troco NUMERIC(10, 2) DEFAULT 0,
    quantidade_itens INTEGER DEFAULT 0,
    status_venda VARCHAR(50) DEFAULT 'Finalizada',
    editada BOOLEAN DEFAULT FALSE
);

-- 5. Itens da Transação (Snapshot de Venda)
CREATE TABLE IF NOT EXISTS itens_vendidos (
    id_item SERIAL PRIMARY KEY,
    venda_id INTEGER REFERENCES vendas(id_venda) ON DELETE CASCADE,
    id_produto INTEGER,
    categoria VARCHAR(100),
    descricao_item TEXT NOT NULL,
    preco_unitario NUMERIC(10, 2) NOT NULL,
    quantidade INTEGER NOT NULL,
    subtotal NUMERIC(10, 2) NOT NULL
);

-- 6. Detalhamento de Pagamentos e Referências
CREATE TABLE IF NOT EXISTS pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    venda_id INTEGER REFERENCES vendas(id_venda) ON DELETE CASCADE,
    metodo VARCHAR(50) NOT NULL,
    valor_pago NUMERIC(10, 2) NOT NULL,
    referencia_metodo VARCHAR(255)
);

-- 7. Catálogo de Produtos e Gestão de Estoque
CREATE TABLE IF NOT EXISTS produtos (
    id_produto SERIAL PRIMARY KEY,
    id_empresa INTEGER REFERENCES empresas(id_empresa),
    categoria VARCHAR(100),
    descricao TEXT NOT NULL,
    preco NUMERIC(10, 2) NOT NULL,
    custo_unitario NUMERIC(10, 2) DEFAULT 0,
    estoque_atual INTEGER DEFAULT 0,
    tipo_item VARCHAR(50) DEFAULT 'Produto',
    codigo_barra VARCHAR(50),
    ativo BOOLEAN DEFAULT TRUE
);

-- 8. Sangrias e Retiradas de Caixa
CREATE TABLE IF NOT EXISTS retiradas_caixa (
    id_retirada SERIAL PRIMARY KEY,
    id_empresa INTEGER REFERENCES empresas(id_empresa),
    id_sessao INTEGER REFERENCES sessoes_caixa(id_sessao),
    valor NUMERIC(10, 2) NOT NULL,
    motivo VARCHAR(255),
    observacao TEXT,
    data_retirada TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Relatórios e Observações Diárias
CREATE TABLE IF NOT EXISTS observacoes_diarias (
    id_observacao SERIAL PRIMARY KEY,
    id_empresa INTEGER REFERENCES empresas(id_empresa),
    data_observacao DATE UNIQUE NOT NULL,
    texto TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMIT;

-- Inserir SEUS produtos específicos
INSERT INTO produtos (categoria, descricao, preco, tipo_item, estoque_atual) VALUES
('Cópia', 'pb', 0.50, 'Serviço', 1000),
('Cópia', 'cl', 2.00, 'Serviço', 1000),
('Impressão', 'a4pb', 2.00, 'Serviço', 1000),
('Impressão', 'a4cl', 5.00, 'Serviço', 1000),
('Impressão', 'a3pb', 4.00, 'Serviço', 1000),
('Impressão', 'a3cl', 9.00, 'Serviço', 1000),
('Revelação', '3x4', 10.00, 'Serviço', 1000),
('Revelação', '10x15', 3.50, 'Serviço', 1000),
('Revelação', '15x20', 7.00, 'Serviço', 1000),
('Scan', 'a4', 1.50, 'Serviço', 1000),
('Scan', 'a3', 3.00, 'Serviço', 1000),
('Encadernação', '25 FLS', 10.00, 'Serviço', 1000),
('Encadernação', '50 FLS', 13.00, 'Serviço', 1000),
('Encadernação', '70 FLS', 18.00, 'Serviço', 1000),
('Encadernação', '85 FLS', 21.00, 'Serviço', 1000),
('Encadernação', '100 FLS', 23.00, 'Serviço', 1000),
('Encadernação', '120 FLS', 27.00, 'Serviço', 1000),
('Encadernação', '150 FLS', 29.00, 'Serviço', 1000),
('Encadernação', '160 FLS', 31.90, 'Serviço', 1000),
('Encadernação', '200 FLS', 42.90, 'Serviço', 1000),
('Encadernação', '250 FLS', 46.90, 'Serviço', 1000),
('Encadernação', '350 FLS', 52.90, 'Serviço', 1000),
('Encadernação', '400 FLS', 58.90, 'Serviço', 1000),
('Encadernação', '450 FLS', 63.90, 'Serviço', 1000),
('Documento', 'currículo 2 folhas + envelope', 10.00, 'Serviço', 1000),
('Documento', 'Contrato (somente digitação até 4 fls)', 40.00, 'Serviço', 1000),
('Documento', 'Boletim Ocorrência', 40.00, 'Serviço', 1000),
('Documento', 'MEI cancelamento', 30.00, 'Serviço', 1000),
('Documento', 'Envelope Pardo', 1.00, 'Produto', 1000),
('Papelaria', 'Cola Branca', 2.00, 'Produto', 1000),
('Papelaria', 'Cartolina', 2.50, 'Produto', 1000),
('Serviço', 'Currículo enviar por zap/email', 4.00, 'Serviço', 1000),
('Serviço', 'acesso a internet balcao', 2.00, 'Serviço', 1000),
('Serviço', 'agendamentos ( TODOS)', 10.00, 'Serviço', 1000),
('Documento', 'Alistamento Militar', 15.00, 'Serviço', 1000),
('Apostila Color', 'Apostila C/ 100 folhas', 79.90, 'Produto', 1000),
('Apostila Color', 'Apostila C/ 200 Folhas', 139.90, 'Produto', 1000),
('Apostila Color', 'Apostila C/ 25 folhas', 29.90, 'Produto', 1000),
('Apostila Color', 'Apostila C/ 50 folhas', 49.00, 'Produto', 1000),
('Apostila Color', 'Apostila Color C/ 100 folhas', 89.90, 'Produto', 1000),
('Apostila Color', 'Apostila Color C/ 200 Folhas', 149.90, 'Produto', 1000),
('Apostila Color', 'Apostila Color C/ 50 folhas', 65.90, 'Produto', 1000),
('Apostila Color', 'Apostila Color.C/ 25 folhas', 44.50, 'Produto', 1000),
('Papelaria', 'Blocão A3', 98.00, 'Produto', 1000),
('Papelaria', 'Caneta', 2.50, 'Produto', 1000),
('Papelaria', 'Caneta BIC', 2.50, 'Produto', 1000),
('Documento', 'Certidãp Negativa (cada site)', 10.00, 'Serviço', 1000),
('Documento', 'contra cheque (TODOS)', 10.00, 'Serviço', 1000),
('Documento', 'CPF ( CORREÇÃO DE DADOS)', 15.00, 'Serviço', 1000),
('Documento', 'cpf impresso colorido', 8.00, 'Serviço', 1000),
('Documento', 'CPF impresso colorido e plastficado', 10.00, 'Serviço', 1000),
('Documento', 'CPF impresso preto e branco', 8.00, 'Serviço', 1000),
('Documento', 'CPF impresso preto e branco plastificado', 9.00, 'Serviço', 1000),
('Serviço', 'digitaçao a4 cada folha', 10.00, 'Serviço', 1000),
('Serviço', 'Duda (cada)', 6.00, 'Serviço', 1000),
('Serviço', 'e-brat', 30.00, 'Serviço', 1000),
('Revelação', 'Foto 5x7 passaporte com data', 10.00, 'Serviço', 1000),
('Serviço', 'GOV.br cadastro/criação de senha', 20.00, 'Serviço', 1000),
('Serviço', 'GPS-previdendia social-inss', 6.00, 'Serviço', 1000),
('Serviço', 'grt cada', 6.00, 'Serviço', 1000),
('Impressão', 'Impressão 3 Color. 50 unidades (imagens) - cada', 7.00, 'Serviço', 1000),
('Impressão', 'Impressão A3 100 (textos) - cada', 4.00, 'Serviço', 1000),
('Impressão', 'impressão A3 5 unidades (imagens) - cada', 8.00, 'Serviço', 1000),
('Impressão', 'Impressão A3 Color (imagens) - cada', 12.00, 'Serviço', 1000),
('Impressão', 'Impressão A3 Color (textos)- cada', 5.00, 'Serviço', 1000),
('Impressão', 'impressão A3 Color. 50 unidades (textos) - cada', 4.00, 'Serviço', 1000),
('Impressão', 'impressão A3 Color. 10 unidades (imagens ) - cada', 9.00, 'Serviço', 1000),
('Impressão', 'impressão A3 Color. 10 unidades (textos) - cada', 6.00, 'Serviço', 1000),
('Impressão', 'impressão A3 Color. 20 unidades ( imagens) - cada', 8.00, 'Serviço', 1000),
('Impressão', 'impressão A3 Color. 5 unidades (imagens) - cada', 10.00, 'Serviço', 1000),
('Impressão', 'Impressão A4 color c/imagens 5f em diante', 4.00, 'Serviço', 1000),
('Impressão', 'Impressão A4 color textos 100f em diante', 3.00, 'Serviço', 1000),
('Impressão', 'Impressão A4 color textos 10f em diante', 2.50, 'Serviço', 1000),
('Impressão', 'Impressão A4 color textos 5f em diante', 3.00, 'Serviço', 1000),
('Impressão', 'Impressão A4 Color. (textos) no verso', 1.30, 'Serviço', 1000),
('Impressão', 'impressão A4 Color. 10 unidade (textos)', 2.50, 'Serviço', 1000),
('Impressão', 'impressão A4 Color. 10 unidades (imagens) - cada', 3.50, 'Serviço', 1000),
('Impressão', 'Impressão A4 Color. 100 unidade (textos) -cada', 1.30, 'Serviço', 1000),
('Impressão', 'impressão A4 color. 20 unidades (imagens) - cada', 3.00, 'Serviço', 1000),
('Impressão', 'Impressão A4 Color. 20 unidades (textos) - cada', 2.00, 'Serviço', 1000),
('Impressão', 'Impressão A4 Color. 5 unidades (imagens) - cada', 4.00, 'Serviço', 1000),
('Impressão', 'impressão A4 Color. 50 unidades ( imagens) - cada', 2.50, 'Serviço', 1000),
('Impressão', 'Impressão A4 Color. 50 unidades (textos) - cada', 1.50, 'Serviço', 1000),
('Impressão', 'Impressão A4 comum color 20 un. textos - cada', 2.00, 'Serviço', 1000),
('Impressão', 'impressão A4 folha comum color 5 unid. textos (cada)', 3.00, 'Serviço', 1000),
('Impressão', 'impressao colorida A3 por lado', 12.00, 'Serviço', 1000),
('Impressão', 'Impressão couche 210g A3 PB', 10.00, 'Serviço', 1000),
('Impressão', 'Impressão couche 210g A4 PB', 8.00, 'Serviço', 1000),
('Impressão', 'Impressão couche A4 colorido', 12.00, 'Serviço', 1000),
('Impressão', 'Impressão de textos em couche A3 colorido', 15.00, 'Serviço', 1000),
('Impressão', 'Impressão folha A4 Color. 100 unidades (imagens) - cada', 2.00, 'Serviço', 1000),
('Serviço', 'informaçoes de pagts. efetuados bradesco detran', 6.00, 'Serviço', 1000),
('Serviço', 'IPTU', 6.00, 'Serviço', 1000),
('Serviço', 'IPVA', 6.00, 'Serviço', 1000),
('Serviço', 'MEI boleto', 6.00, 'Serviço', 1000),
('Serviço', 'MEI declaração anual', 30.00, 'Serviço', 1000),
('Serviço', 'MEI fazer inscrição', 50.00, 'Serviço', 1000),
('Serviço', 'multa bradesco', 6.00, 'Serviço', 1000),
('Plastificação', 'plastificação A3', 25.00, 'Serviço', 1000),
('Plastificação', 'plastificaçao A4', 14.00, 'Serviço', 1000),
('Plastificação', 'plastificaçao CPF', 7.00, 'Serviço', 1000),
('Plastificação', 'plastificaçao identidade', 9.00, 'Serviço', 1000),
('Plastificação', 'plastificaçao meia A4', 12.00, 'Serviço', 1000),
('Papelaria', 'Porta Retrato 10x15', 10.00, 'Produto', 1000),
('Papelaria', 'Porta Retrato com Vidro', 14.00, 'Produto', 1000),
('Revelação', 'Quadro Acrílico com Foto 10X15', 13.90, 'Serviço', 1000),
('Revelação', 'Quadro de madeira com vidro e foto 10X15', 16.90, 'Serviço', 1000),
('Papelaria', 'RESMA DE PAPEL A4', 32.90, 'Produto', 1000),
('Revelação', 'revelaçao kodad 15x20 acima 50 UNID', 6.00, 'Serviço', 1000),
('Revelação', 'revelaçao kodak 10x15 acima 50 UNID', 3.00, 'Serviço', 1000),
('Revelação', 'revelaçao kodak 15x20', 7.00, 'Serviço', 1000),
('Cópia', 'xeros acima de 100 unid do mesmo original', 0.15, 'Serviço', 1000),
('Cópia', 'xerox A3 colorida', 6.00, 'Serviço', 1000),
('Cópia', 'xerox color', 2.00, 'Serviço', 1000),
('Cópia', 'xerox preto e branco A3', 2.50, 'Serviço', 1000),
('Papelaria', 'topo de bolo couche (editando)', 20.00, 'Produto', 1000),
('Serviço', 'SPC E SERASA CNPJ', 40.00, 'Serviço', 1000),
('Serviço', 'SPC E SERASA CPF', 25.00, 'Serviço', 1000),
('Serviço', 'Acesso Internet', 2.00, 'Serviço', 1000),
('Documento', 'CPF impresso P/B', 8.00, 'Serviço', 1000),
('Documento', 'CPF impresso plastificado', 9.00, 'Serviço', 1000),
('Documento', 'Certidão Negativa', 10.00, 'Serviço', 1000),
('Papelaria', 'Caneta BIC', 2.50, 'Produto', 1000),
('Serviço', 'GPS previdência social', 6.00, 'Serviço', 1000),
('Serviço', 'Digitação A4 cada folha', 10.00, 'Serviço', 1000),
('Serviço', 'GOV.br cadastro/criação de senha', 20.00, 'Serviço', 1000);

-- Inserir empresa de exemplo
INSERT INTO empresas (razao_social, nome_fantasia, cnpj, telefone, email) VALUES 
('Fast Cash Comércio LTDA', 'Fast Cash Store', '12.345.678/0001-90', '(11) 9999-8888', 'contato@fastcash.com.br');