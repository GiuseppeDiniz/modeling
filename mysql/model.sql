-- Tabela Habilidade
CREATE TABLE habilidade (
    id VARCHAR(255) PRIMARY KEY,
    descricao TEXT,
    codigo_mec VARCHAR(255),
    id_obj_con VARCHAR(255)
);

CREATE TABLE jogo (
    id CHAR(36) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    desenvolvedor VARCHAR(255), -- pode ser "SG4L" ou outro
    descricao TEXT,
    preco_base DECIMAL(10,2), -- só usado em jogos de terceiros
    tipo_remuneracao ENUM('plataforma', 'por_assinatura', 'por_uso') DEFAULT 'plataforma',
    valor_por_uso DECIMAL(10,2),
    tipo_origem ENUM('interno', 'terceiro') DEFAULT 'interno',
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela Fase
CREATE TABLE fase (
    id VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    ordem INT NOT NULL,
    ativa BOOLEAN DEFAULT TRUE,
    jogo_id VARCHAR(255),
    FOREIGN KEY (jogo_id) REFERENCES jogo(id) ON DELETE CASCADE
);

-- Tabela Questao
CREATE TABLE questao (
    id VARCHAR(255) PRIMARY KEY,
    enunciado TEXT,
    equacao VARCHAR(255),
    resposta VARCHAR(255),
    rota VARCHAR(255),
    id_conteudo VARCHAR(255),
    ordem INT,
    ativa BOOLEAN DEFAULT TRUE,
    fase_id VARCHAR(255),
    FOREIGN KEY (fase_id) REFERENCES fase(id) ON DELETE CASCADE
);

-- Tabela de associação Fase <-> Habilidade
CREATE TABLE fase_habilidade (
    fase_id VARCHAR(255),
    habilidade_id VARCHAR(255),
    PRIMARY KEY (fase_id, habilidade_id),
    FOREIGN KEY (fase_id) REFERENCES fase(id) ON DELETE CASCADE,
    FOREIGN KEY (habilidade_id) REFERENCES habilidade(id) ON DELETE CASCADE
);

-- Tabela de associação Questao <-> Habilidade
CREATE TABLE questao_habilidade (
    questao_id VARCHAR(255),
    habilidade_id VARCHAR(255),
    PRIMARY KEY (questao_id, habilidade_id),
    FOREIGN KEY (questao_id) REFERENCES questao(id) ON DELETE CASCADE,
    FOREIGN KEY (habilidade_id) REFERENCES habilidade(id) ON DELETE CASCADE
);

CREATE INDEX idx_jogo_questao ON questao(id);
CREATE INDEX idx_jogo_fase ON fase(id);

--Representa colégios ou instituições contratantes.
CREATE TABLE parceiro (
    id UUID PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cnpj VARCHAR(20) UNIQUE,
    email VARCHAR(255),
    telefone VARCHAR(20)
);
