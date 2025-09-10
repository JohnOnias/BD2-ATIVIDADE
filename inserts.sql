use reservaesportiva;

INSERT INTO Usuario (nome, email, telefone, tipo) VALUES
('Ana Silva', 'ana.silva@email.com', '11999999999', 'Aluno'),
('Bruno Oliveira', 'bruno.oliveira@email.com', '11988888888', 'Aluno'),
('Carlos Souza', 'carlos.souza@email.com', '11977777777', 'Funcionário'),
('Daniela Lima', 'daniela.lima@email.com', '11966666666', 'Aluno'),
('Eduardo Gomes', 'eduardo.gomes@email.com', '11955555555', 'Funcionário'),
('Fernanda Rocha', 'fernanda.rocha@email.com', '11944444444', 'Aluno'),
('Gabriel Costa', 'gabriel.costa@email.com', '11933333333', 'Aluno'),
('Helena Martins', 'helena.martins@email.com', '11922222222', 'Aluno'),
('Igor Ferreira', 'igor.ferreira@email.com', '11911111111', 'Aluno'),
('Juliana Dias', 'juliana.dias@email.com', '11900000000', 'Funcionário');



INSERT INTO Equipamento (nome, descricao, quantidade_total, quantidade_disponivel) VALUES
('Bola de Futebol', 'Bola oficial tamanho 5', 10, 8),
('Rede de Vôlei', 'Rede padrão oficial', 4, 4),
('Coletes', 'Coletes para identificação de times', 20, 15),
('Cones de Treinamento', 'Cones plásticos para marcação de campo', 50, 50),
('Bola de Basquete', 'Bola de basquete tamanho oficial', 8, 6);

INSERT INTO Reserva (id_usuario, id_equipamento, data_reserva, data_inicio, data_fim, status) VALUES
(1, 1, '2025-09-01', '2025-09-10 14:00:00', '2025-09-10 16:00:00', 'Concluída'),
(2, 3, '2025-09-02', '2025-09-12 10:00:00', '2025-09-12 11:30:00', 'Concluída'),
(4, 2, '2025-09-03', '2025-09-15 08:00:00', '2025-09-15 09:00:00', 'Pendente');


# Para reserva id 1
INSERT INTO RetiradaDevolucao (id_reserva, data_retirada, data_devolucao, observacao) VALUES
(1, '2025-09-10 13:50:00', '2025-09-10 16:05:00', 'Equipamento devolvido em bom estado');

# Para reserva id 2
INSERT INTO RetiradaDevolucao (id_reserva, data_retirada, data_devolucao, observacao) VALUES
(2, '2025-09-12 09:50:00', '2025-09-12 11:35:00', 'Leve desgaste nos coletes');



# Usuário atrasou a devolução
INSERT INTO Punicao (id_usuario, id_reserva, data_punicao, motivo, tipo, penalidade) VALUES
(2, 2, '2025-09-13', 'Devolução com atraso de 30 minutos', 'Atraso', 'Advertência');

# Usuário danificou bola de futebol
INSERT INTO Punicao (id_usuario, id_reserva, data_punicao, motivo, tipo, penalidade, status) VALUES
(1, 1, '2025-09-11', 'Furo na bola após o uso', 'Dano', 'Suspensão', 'Ativa');

