CREATE DATABASE gestor_financas
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE gestor_financas;

-- TABELA CATEGORIA
CREATE TABLE categoria (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(50)    NOT NULL,
    limite_mensal DECIMAL(10,2)  NULL,
    cor           VARCHAR(10)    NULL
);
^

-- DADOS INICIAIS CATEGORIAS
INSERT INTO categoria (nome, limite_mensal, cor) VALUES
  ('Alimentação',   200.00, '#FF5733'),
  ('Transporte',    100.00, '#33C1FF'),
  ('Lazer',         150.00, '#9B59B6'),
  ('Salário',     NULL,     '#2ECC71'),
  ('Outro',       NULL,     '#95A5A6');

  -- TABELA TRANSACAO
CREATE TABLE transacao (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    valor         DECIMAL(10,2)  NOT NULL,
    data_mov      DATE           NOT NULL,
    tipo          ENUM('RECEITA','DESPESA') NOT NULL,
    descricao     VARCHAR(255)   NULL,
    categoria_id  INT            NOT NULL,
    CONSTRAINT fk_transacao_categoria
      FOREIGN KEY (categoria_id)
      REFERENCES categoria(id)
      ON UPDATE CASCADE
      ON DELETE RESTRICT
);

-- DADOS TRANSACOES
INSERT INTO transacao (valor, data_mov, tipo, descricao, categoria_id) VALUES
  (850.00, '2026-02-01', 'RECEITA', 'Salário fevereiro',   4),
  (25.50, '2026-02-02',  'DESPESA', 'Almoço faculdade',    1),
  (15.00, '2026-02-03',  'DESPESA', 'Autocarro',           2),
  (40.00, '2026-02-05',  'DESPESA', 'Cinema',              3),
  (1200.00,'2026-02-10', 'RECEITA', 'Freelance',           4);


  -- VIEW SALDO TOTAL
CREATE VIEW vw_saldo_total AS
SELECT SUM(CASE WHEN tipo = 'RECEITA' THEN valor ELSE -valor END) AS saldo_total
FROM transacao;

-- VIEW TOTAIS POR CATEGORIA
CREATE VIEW vw_totais_categoria AS
SELECT c.nome AS categoria,
       SUM(CASE WHEN t.tipo = 'RECEITA' THEN t.valor ELSE 0 END) AS receitas,
       SUM(CASE WHEN t.tipo = 'DESPESA' THEN t.valor ELSE 0 END) AS despesas
FROM categoria c
LEFT JOIN transacao t ON t.categoria_id = c.id
GROUP BY c.id, c.nome;