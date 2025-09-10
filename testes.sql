 -- 1 Tempo de uso da reserva

-- Deve retornar 2 (14h → 16h)
SELECT fn_tempo_uso(1) AS 'quantidade de horas';

-- Deve retornar 1 (10h → 11h30)
SELECT fn_tempo_uso(2) AS 'quantidade de horas';


-- 2 Verificar se usuário está punido

-- Usuário 1 (tem punição ativa)
SELECT fn_usuario_punido(1) AS 'punição: 1 - sim, 0 não,  2 resolvido';

-- Usuário 2 (punição já resolvida)
SELECT fn_usuario_punido(2) AS 'punição: 1 - sim, 0 não,  2 resolvido';

-- Usuário 4 (sem punição)
SELECT fn_usuario_punido(4) AS 'punição: 1 - sim, 0 não, 2 resolvido';


-- 3 Testar Procedures
-- 3.1 Listar reservas de um usuário
CALL sp_listar_reservas_usuario(1);
CALL sp_listar_reservas_usuario(2);

-- 3.2 Criar reserva (cenários diferentes)
-- Caso 1: Usuário punido tentando reservar
CALL sp_criar_reserva(1, 1, '2025-09-20 10:00:00', '2025-09-20 12:00:00');
-- Deve dar ERRO: "Usuário está punido e não pode reservar."

-- Caso 2: Equipamento sem disponibilidade
-- Forçar indisponibilidade
UPDATE Equipamento SET quantidade_disponivel = 0 WHERE id_equipamento = 2;
CALL sp_criar_reserva(4, 2, '2025-09-21 08:00:00', '2025-09-21 09:00:00');
-- Deve dar ERRO: "Equipamento indisponível para reserva."

-- Caso 3: Reserva válida
UPDATE Equipamento SET quantidade_disponivel = 4 WHERE id_equipamento = 2;
CALL sp_criar_reserva(4, 2, '2025-09-21 08:00:00', '2025-09-21 09:00:00');
-- Deve inserir nova reserva com status 'Pendente'

-- 4. Testar Triggers
-- 4.1 Aprovação de reserva (diminui quantidade disponível)
-- Antes de aprovar
SELECT quantidade_disponivel FROM Equipamento WHERE id_equipamento = 2;

-- Aprovar reserva id 3
UPDATE Reserva SET status = 'Aprovada' WHERE id_reserva = 3;

-- Depois de aprovar (quantidade_disponivel deve reduzir -1)
SELECT quantidade_disponivel FROM Equipamento WHERE id_equipamento = 2;


-- 4.2 Cancelamento de reserva aprovada (restaura quantidade)
-- Cancelar a reserva 3
UPDATE Reserva SET status = 'Cancelada' WHERE id_reserva = 3;
-- Verificar se voltou +1 no equipamento
SELECT quantidade_disponivel FROM Equipamento WHERE id_equipamento = 2;


-- 5. Consultas Extras de Validação
-- Verificar todas as reservas
SELECT * FROM Reserva;

-- Verificar punições ativas
SELECT * FROM Punicao WHERE status = 'Ativa';

-- Verificar histórico de retiradas/devoluções
SELECT * FROM RetiradaDevolucao;


































