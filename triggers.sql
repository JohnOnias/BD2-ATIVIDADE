use ReservaEsportiva; 

/* to do 
	dois triggers
	e uma função 
    
    as consultas tem que fazer sentido para que sejam avaliadas 
*/


delimiter // 
	create trigger atualizar_estoque_equipamentos
    before insert on Reserva
    for each row
    begin
		/* declare qtd_disponivel int default 0; 
		select e.quantidade_disponivel into qtd_disponivel from Equipamento e where e.id_equipamento = new.id_equipamento; 
		if qtd_disponivel > 0 then
				set qtd_disponivel = qtd_disponivel - 1; 
				update Equipamento
				set quantidade_disponivel = qtd_disponivel
                where id_equipamento = new.id_equipamento; */
                
				 -- verificar se tem punição ativa
                call verificar_punicao_usuario(new.id_usuario);
                 -- faz a reserva
                call fazer_reserva(new.id_usuario, new.id_equipamento, new.data_inicio, new.data_fim); 
	
        /* else 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Quantidade de equipamento insuficiente!, tente novamente mais tarde!';
        end if; */ 
    end //
delimiter ;

/*
delimiter // 
	create trigger verificar_punicao
    before insert on Reserva
    for each row
    begin 
		declare status_punicao varchar(20);
		select p.status into status_punicao from Punicao p where p.id_usuario = new.id_usuario limit 1; 
		if status_punicao is not null and status_punicao != 'Resolvida' then
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'Usuario possui uma punição ativa, não podendo reservar esse quipamento';
		end if ;
    end //
delimiter ; */



 -- tive que transformar o trigger em uma procedure para ser mais util e usar de prioridade no chamado 
delimiter //
create procedure verificar_punicao_usuario(in p_id_usuario int)
begin
    declare status_punicao varchar(20);

    select p.status
    into status_punicao
    from Punicao p
    where p.id_usuario = p_id_usuario
    limit 1;

    if status_punicao is not null and status_punicao != 'Resolvida' then
        signal sqlstate '45000'
        set message_text = 'Usuário possui uma punição ativa, não podendo reservar esse equipamento';
    end if;
end //
delimiter ;

