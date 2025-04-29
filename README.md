# Modelagem de dados SG4L

#[VISUALIZE EER](https://github.com/GiuseppeDiniz/modeling/blob/main/mysql/modeling-sg4l.svg)

## 🧠 VISÃO GERAL DO SISTEMA

A plataforma permite que **parceiros** (empresas, colégios, instituições etc.) contratem **planos de assinatura** que fornecem acesso a jogos e recursos (como número de usuários, armazenamento, suporte). O sistema:

- Registra o **uso de recursos** por contrato.
- Suporta jogos **internos e de terceiros**.
- Remunera desenvolvedores conforme o uso ou o modelo de remuneração contratado.
- Rastreia ações administrativas e de usuários.
- Permite controlar e migrar contratos entre planos.

---

## 📊 ENTIDADES PRINCIPAIS E REGRAS DE NEGÓCIO

---

### `parceiro`

- Representa um cliente corporativo (ex: escola, instituição).
- Cada parceiro pode ter:
    - Múltiplas instituições associadas (`instituicao`).
    - Múltiplos contratos (`contrato_parceiro`).
- Campos importantes:
    - `cnpj` é **único**, para garantir identidade fiscal.
    - Dados de contato opcionais.

---

### `plano_assinatura`

- Representa um plano contratável com:
    - Nome, descrição, preço, duração e status de atividade.
- Pode ser atribuído a múltiplos parceiros.
- Um plano define os limites via `recurso_plano`.
- Pode conter acesso a diversos jogos via `jogo_plano`.

---

### `recurso_plano`

- Define os recursos que um plano oferece.
- Associado a um plano (`plano_id`), cada registro define:
    - Um tipo de recurso: `'jogo'`, `'usuario'`, `'armazenamento'`, `'suporte'`.
    - O nome do recurso (ex: "Usuários simultâneos") e o limite permitido.

**Regra importante:** um plano pode ter múltiplos recursos diferentes.

---

### `contrato_parceiro`

- Representa a contratação de um plano por um parceiro.
- Possui:
    - Datas de início/fim.
    - Status: `'ativo'`, `'suspenso'`, `'cancelado'`, `'expirado'`.
    - Opção de renovação automática.
- Serve como base para controle de uso de recursos (`registro_uso`).

---

### `registro_uso`

- Registra o uso de um recurso de um contrato.
- Pode estar vinculado a um `jogo` específico (ou não).
- Campos:
    - `recurso_nome`: referência textual ao recurso usado.
    - `quantidade`: quantidade consumida no registro.
    - `data_registro`: timestamp automático.
- Usado para controle de limites e cálculo de remuneração.

---

### `jogo`

- Representa um jogo disponível na plataforma.
- Atributos:
    - `tipo_origem`: `'interno'` ou `'terceiro'`.
    - `tipo_remuneracao`: define o modelo de pagamento ao desenvolvedor:
        - `'plataforma'` → incluso no plano.
        - `'por_assinatura'` → baseado no número de contratos que o incluem.
        - `'por_uso'` → baseado em registros de uso.
    - `valor_por_uso`: usado para jogos com `tipo_remuneracao = 'por_uso'`.
    - `ativo`: controle de disponibilidade.
    - `preco_base`: usado para precificação de jogos de terceiros.
- Pode estar vinculado a um desenvolvedor e a planos (`jogo_plano`).

---

### `jogo_plano`

- Tabela associativa que define quais jogos estão disponíveis em cada plano.
- Relacionamento **muitos para muitos** entre planos e jogos.
- Quando um parceiro contrata um plano, ele recebe acesso aos jogos vinculados a esse plano.

---

### `instituicao`

- Representa uma instituição associada a um parceiro.
- Ex: uma escola ligada a uma mantenedora (`parceiro`).
- Cada parceiro pode ter várias instituições.

---

### `desenvolvedor`

- Representa o criador do jogo (interno ou externo).
- Campos:
    - Nome, email e tipo (`'interno'`, `'externo'`).
- Pode receber remuneração conforme uso.

---

### `remuneracao_jogo`

- Registra quanto foi pago a um desenvolvedor por um jogo em determinado mês.
- Inclui:
    - Total de uso.
    - Valor pago.
    - Tipo de remuneração.
    - Data do pagamento.
- Permite auditoria e controle de pagamento a desenvolvedores de jogos.

---

## 📜 LOGS E HISTÓRICO

---

### `log_atividade_usuario`

- Rastreia ações feitas por usuários da plataforma.
- Campos:
    - `acao`, `recurso`, `descricao`, `ip_origem`, `user_agent`.
- Útil para auditoria de uso e segurança.

---

### `log_administrativo`

- Registra ações realizadas por administradores do sistema.
- Ex: alterações de planos, usuários, jogos etc.
- Armazena a entidade afetada e o identificador associado.

---

### `historico_contrato`

- Registra mudanças de contrato, como:
    - Migração de um plano para outro.
    - Cancelamento e criação de novo contrato.
- Campos:
    - Contrato antigo/novo.
    - Data da migração.
    - Motivo e responsável pela ação.

---

## ✅ CONSIDERAÇÕES FINAIS

Este modelo suporta:

- **Crescimento escalável com múltiplos parceiros e planos.**
- **Rastreabilidade completa de uso e remuneração.**
- **Flexibilidade para jogos internos e de terceiros.**
- **Auditoria com logs robustos.**
- **Migrações de plano com histórico vinculado.**
