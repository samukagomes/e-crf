
CREATE TABLE User(
    id int PRIMARY KEY UNIQUE NOT NULL,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    senha VARCHAR(20),
    perfil_id INT,
    FOREIGN KEY (perfil_id) REFERENCES Perfil(id)
);

CREATE TABLE Perfil(
    id int PRIMARY KEY UNIQUE NOT NULL,
    nome VARCHAR(50) NOT NULL,
    descricao VARCHAR(200)
);

CREATE TABLE PERMICAO(
    id int PRIMARY KEY UNIQUE NOT NULL,
    nome VARCHAR(100),
    tipo VARCHAR(50)
);

CREATE TABLE Perfil_permicao(
    id int PRIMARY KEY UNIQUE NOT NULL,
    perfil_id INT,
    permicao_id INT,
    FOREIGN KEY (perfil_id) REFERENCES Perfil(id),
    FOREIGN KEY(permicao_id) REFERENCES Permicao(id)
);

CREATE TABLE Estudo(
    id int PRIMARY KEY UNIQUE NOT NULL,
    nome VARCHAR(50)
);

CREATE TABLE Acesso_estudo(
    id int PRIMARY KEY UNIQUE NOT NULL,
    estudo_id int,
    users_id int,
    FOREIGN KEY(estudo_id) REFERENCES Estudo(id),
    Foreign Key (users_id) REFERENCES User(id)
);

CREATE TABLE Voluntario(
    id int PRIMARY KEY UNIQUE NOT NULL,
    nome varchar(150),
    status_voluntario VARCHAR(20),
    visita_id int,
    estudo_id int,
    FOREIGN KEY(visita_id) REFERENCES Visita(id),
    FOREIGN KEY(estudo_id) REFERENCES Estudo(id)
);

CREATE TABLE Visita(
    id INT PRIMARY KEY UNIQUE NOT NULL,
    nome varchar(30) NOT NULL,
    estudo_id int,
    FOREIGN KEY(estudo_id) REFERENCES Estudo(id)
);

CREATE TABLE Form (
    id INT PRIMARY KEY UNIQUE NOT NULL,
    nome VARCHAR(150)
);

CREATE TABLE Visita_form(
    id INT PRIMARY KEY UNIQUE NOT NULL,
    form_id int,
    visita_id int,
    FOREIGN KEY(form_id) REFERENCES Form(id),
    FOREIGN KEY(visita_id) REFERENCES Visita(id)
);

CREATE TABLE Campos_form(
    id INT PRIMARY KEY UNIQUE NOT NULL,
    nome varchar(100),
    campo_json json, 
    form_id int,
    FOREIGN KEY(form_id) REFERENCES Form(id)
);

CREATE TABLE Query(
    id INT PRIMARY KEY UNIQUE NOT NULL,
    titulo VARCHAR(50),
    descricao VARCHAR(200),
    form_id int,
    campos_form_id int,
    FOREIGN KEY(form_id) REFERENCES Form(id),
    FOREIGN KEY(form_id) REFERENCES Campos_form(id)
);

-----------------------------------------------
--INSERE USUARIO
--Usuario 1
INSERT INTO User (id, nome, email, senha, perfil_id)
VALUES(1, 'Samuel Gomes', 'Samuka.gj2@gmail.com', '1234', 1),
(2, 'Ayla Giselle', 'Ayla.giselle1@gmail.com', '1234', 2);

--INSERIR PERFIL
--perfil 1
INSERT INTO Perfil (id, nome, descricao)
VALUES(1, 'Admin', 'Administrador do sistema'),
(2, 'Data Manager', 'Gerenciador de dados');

--INSERIR RELACIONAMENTO PERFIL/ PERMIÇÃO
--Relaacionamento 1
INSERT INTO Perfil_permicao (id, perfil_id, permicao_id)
VALUES(1, 1, 1), (2, 1, 2), (3, 1, 3), (4, 1, 4);
--Relacionamento 2
INSERT INTO Perfil_permicao (id, perfil_id, permicao_id)
VALUES(5, 2, 2), (6, 2, 3);

--INSERE PERMIÇÃO
INSERT INTO Permicao (id, nome, tipo)
VALUES(1, 'USER', 'CREATE'), (2, 'USER', 'VIEW'), 
(3, 'USER', 'UPDATE'), (4, 'USER', 'DELETE');

--INSERIR ESTUDO
INSERT INTO Estudo (id, nome)
VALUES(1, 'PFIZER'),(2,'EVI');

--INSERIR RELACIONAMENTO USER/ ESTUDO
INSERT INTO Acesso_estudo (id, estudo_id, user_id)
VALUES (1, 1, 1), (2, 2, 2);

--INSERIR VISITA
INSERT INTO Visita (id, nome, estudo_id)
VALUES (1, 'V0', 1), (2, 'V1', 1), 
(3, 'V2', 1), (4, 'V3', 1),
(5, 'V0', 2), (6, 'V1', 2), 
(7, 'V2', 2), (8, 'V3', 2);

--INSERIR VOLUNTARIOS
INSERT INTO Voluntario (id, nome, status_voluntario, estudo_id, visita_id)
VALUES (1, 'Voluntario 1', 'Triado', 1, 2), 
(2, 'Voluntario 2', 'Randomizado', 1, 4),
(3, 'Voluntario 1', 'Agendado', 2, 5), 
(4, 'Voluntario 2', 'Randomizado', 2, 8);

--INSERIR FORMULARIOS
INSERT INTO Form (id, nome)
VALUES (1, 'Data da visita'), (2, 'Termo de consentimento'),
(3, 'Randomização');

--INSERIR RELACIONAMENTO FORMULARIO/ VISITA
INSERT INTO Visita_form(id, visita_id, form_id)
VALUES (1, 1, 1), (2, 2, 1), (3, 3, 1), (4, 4, 1), (5, 5, 1), 
(6, 6, 1), (7, 7, 1), (8, 8, 1), (9, 1, 2), (10, 7, 2), 
(11, 3, 3), (12, 8, 3)

--INSERIR CAMPOS DOS FORMULARIOS
INSERT INTO Campos_form (id, nome, campo_json, form_id)
VALUES (1, 'Data', '{"Ordem":[1,1],"Type": "DATE"}', 1)
-----------------------------------------------



--seleciona o usuario, perfil e permição/ tipo
SELECT u.nome AS Nome_usuario, perfil.nome AS Perfil, 
permicao.nome AS Permição, permicao.tipo AS Tipo 
FROM User u 
left join perfil on u.id = perfil.id 
left join Perfil_permicao on perfil.id = Perfil_permicao.perfil_id
left join Permicao on Perfil_permicao.permicao_id = permicao.id
order by u.nome

--Seleciona usuario por estudo
SELECT u.nome as Nome_usuario, e.nome AS Estudo 
FROM User u
left join Acesso_estudo ae ON u.id =ae.user_id
left join Estudo e on ae.estudo_id = e.id
order by u.nome

--Seleciona voluntario por/ visita por estudo
SELECT e.nome as Estudo, vt.nome as Visita, 
vl.nome As Voluntario, vl.status_voluntario AS Status
From Voluntario vl
left join Visita vt on vt.id = vl.visita_id 
left join Estudo e on e.id = vl.estudo_id
order by e.nome

--Seleciona os formularios de cada visita
SELECT e.nome as Estudo, v.nome as visita, f.nome
FROM Form f
left join Visita_form vf on f.id = vf.form_id
left join visita v on vf.visita_id = v.id
left join Estudo e on v.estudo_id = e.id
order by e.nome

--Selecion os campos dos formularios com os formularios
SELECT cp.nome as campos_form, f.nome
From Form f
left join Campos_form cp on cp.form_id = f.id
order by f.nome