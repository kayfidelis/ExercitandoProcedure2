create database db_transact_26_09; 
use db_transact_26_09;

create table tbl_Cliente(
	cd_Cliente int primary key auto_increment,
	nm_Logradouro varchar(80) not null,
	no_Logradouro varchar(5) not null,
	ds_Complemento varchar(30) not null,
	nm_Bairro varchar(20) not null,
	ds_Login varchar(80) not null,
	ds_Senha char(6) not null,
	sg_Status bit not null
);

create table tbl_CliPF(
	cd_CliPF int primary key auto_increment,
	cd_Cliente int,
	nm_Cliente varchar(80) not null,
	sg_sexo enum('m','f'),
	no_CPF char(11) not null,
	constraint foreign key(cd_Cliente) references tbl_Cliente(cd_Cliente)
);


create table tbl_CliPJ(
	cd_CliPJ int primary key auto_increment,
	cd_Cliente int,
	nm_razaoSocial varchar(80) not null,
	no_CNPJ char(14) not null,
	constraint foreign key(cd_Cliente) references tbl_Cliente(cd_Cliente)
);

create table tbl_foneCli(
	cd_foneCli int primary key auto_increment,
	cd_Cliente int,
	no_Telefone char(11) not null,
	constraint foreign key(cd_Cliente) references tbl_Cliente(cd_Cliente)
);

-- STORED PROCEDURE -- 

drop procedure if exists sp_insCli;
delimiter $$
create procedure sp_insCli(
	in pTipoPessoa char(1),
	in pLog varchar(80),
    in pNolog varchar(5),
    in pComp varchar(30),
    in pBairro varchar(20),
    in pLogin varchar(80),
    in pSenha varchar(6),
    in pNomeCli varchar(80),
    in pSex char(1),
    in pCPF char(11),
    in pRZS varchar(80),
    in pCNPJ char(14),
    in pTelefone char(11)
)
begin 
	declare vCd int;
    declare erro_SQL tinyint default false;
    declare continue handler for sqlexception set erro_SQL = true;
    start transaction;
    if (pTipoPessoa = 'F') then 
    insert into tbl_Cliente(nm_Logradouro, no_Logradouro, ds_Complemento,nm_Bairro, ds_Login, ds_Senha, sg_Status)
    values(pLog, pNolog, pComp, pBairro, pLogin, pSenha,1);
    set vCd = last_insert_id();
    insert into tbl_clipf(cd_Cliente, nm_Cliente, sg_sexo, no_CPF)
    values(vCd, pNomeCli, pSex, pCPF);
    insert tbl_fonecli(cd_Cliente, no_Telefone)
    values (vCd, pTelefone);
    
    else
	insert into tbl_Cliente(nm_Logradouro, no_Logradouro, ds_Complemento,nm_Bairro, ds_Login, ds_Senha, sg_Status)
    values(pLog, pNolog, pComp, pBairro, pLogin, pSenha,1);
    set vCd = last_insert_id();
    insert into tbl_clipj(cd_Cliente, nm_razaoSocial, no_CNPJ)
    values(vCd, pRZS, pCNPJ);
    insert tbl_fonecli(cd_Cliente, no_Telefone)
    values (vCd, pTelefone);
    
    end if;
	
    if(erro_SQL = false) then 
		commit;
        select 'Operação executada com sucesso !!';
     else 
		rollback;
        select 'Ocorreu algum erro ao enviar os registros!';
	end if;
end $$
delimiter ;

call sp_insCli ('F','Rua Camargo Coelho','570','','Vila Ipojuca','julio@gmail.com','123456','Juliano Souza','m','11122233304','','','11999687574');
call sp_insCli ('J','Rua Comandante Sampaio','1580','','Km18','adm.marisa@marisa.com.br','mari@@','','','','Lojas Marisa','11222333100040','11985621145');