use reservaesportiva; 

########################## TRIGGERS #####################################

# Atualizar quantidade disponível ao aprovar reserva 
DELIMITER //
CREATE TRIGGER trg_atualiza_quantidade_apos_aprovacao
AFTER UPDATE ON Reserva
FOR EACH ROW
BEGIN
    IF NEW.status = 'Aprovada' AND OLD.status <> 'Aprovada' THEN
        UPDATE Equipamento
        SET quantidade_disponivel = quantidade_disponivel - 1
        WHERE id_equipamento = NEW.id_equipamento;
    END IF;
END //
DELIMITER ;

# Restaurar quantidade disponível ao cancelar reserva

DELIMITER //
CREATE TRIGGER trg_restaurar_quantidade_apos_cancelamento
AFTER UPDATE ON Reserva
FOR EACH ROW
BEGIN
    IF NEW.status = 'Cancelada' AND OLD.status = 'Aprovada' THEN
        UPDATE Equipamento
        SET quantidade_disponivel = quantidade_disponivel + 1
        WHERE id_equipamento = NEW.id_equipamento;
    END IF;
END //
DELIMITER ;


############################ Functions ##########################################

# Calcula O tempo de uso da reserva (em horas) 
DELIMITER //
CREATE FUNCTION fn_tempo_uso(idRes INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE horas INT;
    SELECT TIMESTAMPDIFF(HOUR, data_inicio, data_fim) INTO horas FROM Reserva
    WHERE id_reserva = idRes;
    
    RETURN horas;
END //
DELIMITER ;

select fn_tempo_uso(1) as "Tempo de uso";
select fn_tempo_uso(2) as "Tempo de uso";
select fn_tempo_uso(3) as "Tempo de uso";

# Verificar se usuário está punido (1 = sim, 0 = não,, 2 = resolvido )
DELIMITER //
CREATE FUNCTION fn_usuario_punido(idUser INT) 
RETURNS TINYINT
DETERMINISTIC
BEGIN
    DECLARE resultado TINYINT DEFAULT 0;
    IF EXISTS ( SELECT 1 FROM Punicao WHERE id_usuario = idUser AND status = 'Ativa') THEN
        SET resultado = 1;
	elseif (select 1 from Punicao where id_usuario - idUser and status = 'Resolvido') then
		set resultado = 2;
    END IF;
    RETURN resultado;
END //
DELIMITER ;

select fn_usuario_punido(1);
select fn_usuario_punido(2);
select fn_usuario_punido(3);


#################################### Procedures ######################################

# Listar reservas de um usuário
DELIMITER //
CREATE PROCEDURE sp_listar_reservas_usuario(IN idUser INT)
BEGIN
    SELECT r.id_reserva, e.nome AS equipamento, r.data_inicio, r.data_fim, r.status
    FROM Reserva r
    INNER JOIN Equipamento e ON r.id_equipamento = e.id_equipamento
    WHERE r.id_usuario = idUser;
END //
DELIMITER ;
-- testando
call sp_listar_reservas_usuario(1);
call sp_listar_reservas_usuario(2);
call sp_listar_reservas_usuario(3); 

# Criar reserva (com verificação de punição e disponibilidade)
DELIMITER //
CREATE PROCEDURE sp_criar_reserva(IN idUser INT, IN idEquip INT, IN dtInicio DATETIME, IN dtFim DATETIME)
BEGIN
    DECLARE disponivel INT;
    DECLARE punido TINYINT;
    DECLARE mensagem VARCHAR(100);

    # Verificar punição
    SET punido = fn_usuario_punido(idUser);
    
    IF punido = 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuário está punido e não pode reservar.';
    END IF;

    # Verificar disponibilidade
    SELECT quantidade_disponivel INTO disponivel
    FROM Equipamento
    WHERE id_equipamento = idEquip;

    IF disponivel <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Equipamento indisponível para reserva.';
    END IF;

   # Criar reserva
    INSERT INTO Reserva (id_usuario, id_equipamento, data_reserva, data_inicio, data_fim, status)
    VALUES (idUser, idEquip, CURDATE(), dtInicio, dtFim, 'Pendente');
END //
DELIMITER ;

-- testando
call sp_criar_reserva(3, 2, '2025-09-09 10:00:00', '2025-09-09 11:00:00');
call sp_criar_reserva(1, 2, '2025-09-09 10:00:00', '2025-09-09 11:00:00'); # não vai funcionar



 -- inner join criado de ultima hora para facilitar a visulaização
DELIMITER //
CREATE PROCEDURE inner_tabela(IN id_user INT)
BEGIN
    SELECT 
        u.nome AS nome_usuario,
        e.nome AS nome_equipamento,
        
        r.data_reserva,
        r.data_inicio,
        r.data_fim as 'entregue'
    FROM 
        Reserva r
    INNER JOIN Equipamento e ON r.id_equipamento = e.id_equipamento
    INNER JOIN Usuario u ON r.id_usuario = u.id_usuario
    WHERE u.id_usuario = id_user;
END //
DELIMITER ;

-- testando
call inner_tabela(1);





























