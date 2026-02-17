/*1. DDL*/

drop table if exists usuarios;

drop table if exists produtos;

drop table if exists itens_pedido;

drop table if exists pedidos;

create table usuarios (
    id integer primary key autoincrement, 
    nome varchar(50), sobrenome varchar(50), 
    email varchar(50) unique, 
    data_nascimento date, 
    genero varchar(1) check (genero in ('M', 'F', null)) default null, 
    ativo boolean default true, 
    created_at timestamp default current_timestamp
    );

create table produtos (
    id integer primary key autoincrement, 
    nome varchar(50), 
    preco decimal(10, 2), 
    created_at timestamp default current_timestamp
    );

create table itens_pedido (
    id integer primary key autoincrement, 
    pedidoid integer, 
    produtoid integer, 
    quantidade integer, 
    foreign key (pedidoid) references pedidos (id), 
    foreign key (produtoid) references produtos (id)
    );

create table pedidos (
    id integer primary key, 
    usuarioid integer, 
    status varchar(20) check (status in ('pendente', 'processando', 'enviado', 'entregue', 'cancelado')) default 'pendente', 
    forma_pagamento varchar(20) check (forma_pagamento in ('cartao', 'boleto', 'pix')) default 'cartao', 
    created_at timestamp default current_timestamp, 
    foreign key (usuarioid) references usuarios (id)
    );

/*2. DML*/
-- usuarios
insert into usuarios (nome, sobrenome, email, data_nascimento, genero) values ('Ana', 'Banana', 'ana.banana@gmail.com', '1990-01-31', 'F');

insert into usuarios (nome, sobrenome, email, data_nascimento, genero) values ('Beto', 'Barreto', 'betinho_99@hotmail.com', '1995-11-15', 'M');

insert into usuarios (nome, sobrenome, email, data_nascimento, genero) values ('Carlos', 'Santana', 'carlitos.bataquara@yahoo.com', '1998-08-21', 'M');

-- produtos
insert into produtos (nome, preco) values ('camisa', 50.00);

insert into produtos (nome, preco) values ('cueca', 20.00);

insert into produtos (nome, preco) values ('calça', 100.00);

insert into produtos (nome, preco) values ('meia', 10.00);

-- pedidos
with
usuario as (select id from usuarios where nome = 'Ana')
insert into pedidos (usuarioid, status, forma_pagamento) values ((select id from usuario), 'entregue', 'cartao');

with
usuario as (select id from usuarios where nome = 'Beto')
insert into pedidos (usuarioid, status, forma_pagamento) values ((select id from usuario), 'entregue', 'boleto');

with
usuario as (select id from usuarios where nome = 'Carlos')
insert into pedidos (usuarioid, status, forma_pagamento) values ((select id from usuario), 'entregue', 'pix');

-- itens_pedido
with
produto1 as (select id from produtos where nome = 'cueca'),
produto2 as (select id from produtos where nome = 'calça')
insert into itens_pedido (pedidoid, produtoid, quantidade) values 
(1, (select id from produto1), 2),
(1, (select id from produto2), 3);

with
produto1 as (select id from produtos where nome = 'calça'),
produto2 as (select id from produtos where nome = 'meia')
insert into itens_pedido (pedidoid, produtoid, quantidade) values
(2, (select id from produto1), 3),
(2, (select id from produto2), 2);

with
produto1 as (select id from produtos where nome = 'camisa'),
produto2 as (select id from produtos where nome = 'meia')
insert into itens_pedido (pedidoid, produtoid, quantidade) values
(3, (select id from produto1), 5),
(3, (select id from produto2), 5);

/*3. SQL*/
select
    pedidos.id                                                        as pedido,
    strftime('%Y-%m-%d', pedidos.created_at)                          as data_de_compra,
    concat (usuarios.nome, ' ', usuarios.sobrenome)                   as usuário,
    strftime('%Y', 'now') - strftime('%Y', usuarios.data_nascimento)  as idade,
    usuarios.genero                                                   as gênero,
    pedidos.forma_pagamento                                           as forma_pagamento,
    pedidos.status                                                    as status,
    produtos.nome                                                     as produto,
    itens_pedido.quantidade                                           as quantidade,
    produtos.preco                                                    as preco,
    (produtos.preco * itens_pedido.quantidade)                        as subtotal
from
    usuarios
    left join pedidos on usuarios.id = pedidos.usuarioid
    left join itens_pedido on pedidos.id = itens_pedido.pedidoid
    left join produtos on itens_pedido.produtoid = produtos.id
where
    1 = 1
    and pedidos.status = 'entregue'
;