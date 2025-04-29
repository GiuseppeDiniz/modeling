-- Tabela: parceiro
CREATE TABLE parceiro (
    id CHAR(36) PRIMARY KEY, -- UUID como CHAR(36)
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(20) UNIQUE,
    email VARCHAR(255),
    telefone VARCHAR(20)
);

-- Tabela: plano_assinatura
CREATE TABLE plano_assinatura (
    id CHAR(36) PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2),
    duracao_dias INT,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela: recurso_plano
CREATE TABLE recurso_plano (
    id CHAR(36) PRIMARY KEY,
    plano_id CHAR(36),
    nome VARCHAR(100),
    valor_limite INT,
    tipo ENUM('jogo', 'usuario', 'armazenamento', 'suporte'),
    FOREIGN KEY (plano_id) REFERENCES plano_assinatura(id) ON DELETE CASCADE
);

-- Tabela: contrato_parceiro
CREATE TABLE contrato_parceiro (
    id CHAR(36) PRIMARY KEY,
    parceiro_id CHAR(36),
    plano_id CHAR(36),
    data_inicio DATE,
    data_fim DATE,
    status ENUM('ativo', 'suspenso', 'cancelado', 'expirado'),
    renovacao_automatica BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (parceiro_id) REFERENCES parceiro(id) ON DELETE CASCADE,
    FOREIGN KEY (plano_id) REFERENCES plano_assinatura(id)
);

-- Tabela: registro_uso
CREATE TABLE registro_uso (
    id CHAR(36) PRIMARY KEY,
    contrato_id CHAR(36),
    recurso_nome VARCHAR(100),
    quantidade INT,
    data_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    jogo_id CHAR(36), -- NULLABLE
    FOREIGN KEY (jogo_id) REFERENCES jogo(id),
    FOREIGN KEY (contrato_id) REFERENCES contrato_parceiro(id)
);

CREATE TABLE jogo (
    id CHAR(36) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco_base DECIMAL(10,2), -- só usado em jogos de terceiros
    tipo_remuneracao ENUM('plataforma', 'por_assinatura', 'por_uso') DEFAULT 'plataforma',
    valor_por_uso DECIMAL(10,2),
    tipo_origem ENUM('interno', 'terceiro') DEFAULT 'interno',
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela: jogo_plano
CREATE TABLE jogo_plano (
    plano_id CHAR(36),
    jogo_id CHAR(36),
    PRIMARY KEY (plano_id, jogo_id),
    FOREIGN KEY (plano_id) REFERENCES plano_assinatura(id) ON DELETE CASCADE,
    FOREIGN KEY (jogo_id) REFERENCES jogo(id) ON DELETE CASCADE
);

CREATE TABLE instituicao (
    id CHAR(36) PRIMARY KEY,
    parceiro_id CHAR(36),
    nome VARCHAR(255) NOT NULL,
    FOREIGN KEY (parceiro_id) REFERENCES parceiro(id)
);

CREATE TABLE desenvolvedor (
    id CHAR(36) PRIMARY KEY,
    nome VARCHAR(255),
    email VARCHAR(255),
    tipo ENUM('interno', 'externo')
);

ALTER TABLE jogo ADD desenvolvedor_id CHAR(36);
ALTER TABLE jogo ADD FOREIGN KEY (desenvolvedor_id) REFERENCES desenvolvedor(id);

CREATE TABLE remuneracao_jogo (
    id CHAR(36) PRIMARY KEY,
    jogo_id CHAR(36),
    desenvolvedor_id CHAR(36),
    mes_ano CHAR(7), -- exemplo: '2025-04'
    total_uso INT,
    valor_pago DECIMAL(10,2),
    tipo_remuneracao ENUM('por_assinatura', 'por_uso'),
    data_pagamento DATE,
    FOREIGN KEY (jogo_id) REFERENCES jogo(id),
    FOREIGN KEY (desenvolvedor_id) REFERENCES desenvolvedor(id)
);

CREATE TABLE log_atividade_usuario (
    id CHAR(36) PRIMARY KEY,
    usuario_id CHAR(36),
    acao VARCHAR(255),
    recurso VARCHAR(100),
    descricao TEXT,
    ip_origem VARCHAR(45),
    user_agent TEXT,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE log_administrativo (
    id CHAR(36) PRIMARY KEY,
    admin_id CHAR(36),
    acao VARCHAR(255),
    entidade_afetada VARCHAR(100),
    id_entidade CHAR(36),
    detalhes TEXT,
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE historico_contrato (
    id CHAR(36) PRIMARY KEY,
    contrato_antigo_id CHAR(36),
    contrato_novo_id CHAR(36),
    data_migracao DATE,
    motivo TEXT,
    usuario_responsavel VARCHAR(100),
    FOREIGN KEY (contrato_antigo_id) REFERENCES contrato_parceiro(id),
    FOREIGN KEY (contrato_novo_id) REFERENCES contrato_parceiro(id)
);


