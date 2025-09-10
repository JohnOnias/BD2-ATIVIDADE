-- Criando o banco
CREATE DATABASE ReservaEsportiva;
USE ReservaEsportiva;

-- Tabela de usuários
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    tipo ENUM('Aluno', 'Funcionário') DEFAULT 'Aluno'
);

-- Tabela de equipamentos
CREATE TABLE Equipamento (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    quantidade_total INT NOT NULL,
    quantidade_disponivel INT NOT NULL
);

-- Tabela de reservas
CREATE TABLE Reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_equipamento INT NOT NULL,
    data_reserva DATE NOT NULL,
    data_inicio DATETIME NOT NULL,
    data_fim DATETIME NOT NULL,
    status ENUM('Pendente', 'Aprovada', 'Concluída', 'Cancelada') DEFAULT 'Pendente',
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_equipamento) REFERENCES Equipamento(id_equipamento)
);

-- Tabela de responsáveis (quem gerencia o empréstimo)
CREATE TABLE Responsavel (
    id_responsavel INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50)
);

-- Tabela de retirada e devolução (controle físico do equipamento)
CREATE TABLE RetiradaDevolucao (
    id_movimento INT AUTO_INCREMENT PRIMARY KEY,
    id_reserva INT NOT NULL,
    data_retirada DATETIME,
    data_devolucao DATETIME,
    observacao TEXT,
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);
-- Tabela de punição (controle sobre punições em usuarios)
CREATE TABLE Punicao (
    id_punicao INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_reserva INT,
    data_punicao DATE NOT NULL,
    motivo TEXT NOT NULL,
    tipo ENUM('Atraso', 'Dano', 'Perda', 'Conduta Inadequada') NOT NULL,
    penalidade ENUM('Advertência', 'Suspensão', 'Banimento') NOT NULL,
    status ENUM('Ativa', 'Resolvida') DEFAULT 'Ativa',
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva)
);