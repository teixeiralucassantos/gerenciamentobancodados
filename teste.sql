-- Create a new database called 'BibliotecaDB'
-- Connect to the 'master' database to run this snippet
USE master
GO
IF NOT EXISTS (
   SELECT name
   FROM sys.databases
   WHERE name = N'BibliotecaDB'
)
CREATE DATABASE [BibliotecaDB]
GO

USE [BibliotecaDB]
GO

/* ======================= TABELAS ======================== */

CREATE TABLE editora (
    editora_Nome VARCHAR(100) PRIMARY KEY NOT NULL,
    editora_Endereco VARCHAR(200) NOT NULL,
    editora_Telefone VARCHAR(50) NOT NULL
);

CREATE TABLE livro (
    livro_ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    livro_Titulo VARCHAR(100) NOT NULL,
    livro_Editora VARCHAR(100) NOT NULL CONSTRAINT fk_editora_nome FOREIGN KEY REFERENCES editora(editora_Nome) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE filial_biblioteca (
    filial_ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    filial_Nome VARCHAR(100) NOT NULL,
    filial_Endereco VARCHAR(200) NOT NULL
);

CREATE TABLE usuario (
    usuario_Cartao INT PRIMARY KEY NOT NULL IDENTITY (100,1),
    usuario_Nome VARCHAR(100) NOT NULL,
    usuario_Endereco VARCHAR(200) NOT NULL,
    usuario_Telefone VARCHAR(50) NOT NULL
);

CREATE TABLE emprestimo_livros (
    emprestimo_ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    emprestimo_LivroID INT NOT NULL CONSTRAINT fk_livro_id FOREIGN KEY REFERENCES livro(livro_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    emprestimo_FilialID INT NOT NULL CONSTRAINT fk_filial_id FOREIGN KEY REFERENCES filial_biblioteca(filial_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    emprestimo_Cartao INT NOT NULL CONSTRAINT fk_cartao FOREIGN KEY REFERENCES usuario(usuario_Cartao) ON UPDATE CASCADE ON DELETE CASCADE,
    emprestimo_DataRetirada VARCHAR(50) NOT NULL,
    emprestimo_DataDevolucao VARCHAR(50) NOT NULL
);

CREATE TABLE copias_livro (
    copias_ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    copias_LivroID INT NOT NULL CONSTRAINT fk_livro_id_copias FOREIGN KEY REFERENCES livro(livro_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    copias_FilialID INT NOT NULL CONSTRAINT fk_filial_id_copias FOREIGN KEY REFERENCES filial_biblioteca(filial_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    copias_Quantidade INT NOT NULL
);

CREATE TABLE autores_livro (
    autores_ID INT PRIMARY KEY NOT NULL IDENTITY (1,1),
    autores_LivroID INT NOT NULL CONSTRAINT fk_livro_id_autores FOREIGN KEY REFERENCES livro(livro_ID) ON UPDATE CASCADE ON DELETE CASCADE,
    autores_Nome VARCHAR(50) NOT NULL
);

/* ======================== FIM DAS TABELAS ======================== */

/* ===================== POPULANDO AS TABELAS ===================== */

INSERT INTO editora
    (editora_Nome, editora_Endereco, editora_Telefone)
    VALUES
    ('Editora Alfa', '123 Rua do Conhecimento, São Paulo, SP', '11-91234-5678'),
    ('Editora Beta', '456 Avenida da Leitura, Rio de Janeiro, RJ', '21-98765-4321'),
    ('Editora Gama', '789 Rua das Letras, Belo Horizonte, MG', '31-99876-5432');

INSERT INTO livro
    (livro_Titulo, livro_Editora)
    VALUES 
    ('A Sombra do Vento', 'Editora Alfa'),
    ('O Iluminado', 'Editora Beta'),
    ('1984', 'Editora Gama'),
    ('O Senhor dos Anéis', 'Editora Alfa'),
    ('O Hobbit', 'Editora Beta');

INSERT INTO filial_biblioteca
    (filial_Nome, filial_Endereco)
    VALUES
    ('Filial Centro', '10 Rua da Praça, São Paulo, SP'),
    ('Filial Norte', '20 Avenida das Flores, São Paulo, SP');

INSERT INTO usuario
    (usuario_Nome, usuario_Endereco, usuario_Telefone)
    VALUES
    ('Carlos Silva', '789 Rua da Paz, São Paulo, SP', '11-91234-5678'),
    ('Ana Oliveira', '1010 Avenida da Esperança, São Paulo, SP', '11-97654-3210'),
    ('Roberto Santos', '1122 Rua do Sol, São Paulo, SP', '11-93456-7890');

INSERT INTO emprestimo_livros
    (emprestimo_LivroID, emprestimo_FilialID, emprestimo_Cartao, emprestimo_DataRetirada, emprestimo_DataDevolucao)
    VALUES
    (1, 1, 100, '2024-01-10', '2024-01-20'),
    (2, 1, 101, '2024-01-15', '2024-01-25');

INSERT INTO copias_livro
    (copias_LivroID, copias_FilialID, copias_Quantidade)
    VALUES
    (1, 1, 5),
    (2, 1, 3),
    (1, 2, 2),
    (3, 1, 4);

INSERT INTO autores_livro
    (autores_LivroID, autores_Nome)
    VALUES
    (1, 'Carlos Ruiz Zafón'),
    (2, 'Stephen King'),
    (3, 'George Orwell'),
    (4, 'J.R.R. Tolkien'),
    (5, 'J.R.R. Tolkien');

/* ======================== FIM DO PREENCHIMENTO DAS TABELAS ======================== */

/* =================== PROCEDIMENTOS ARMAZENADOS ============================ */

/* #1- Quantas cópias do livro "O Senhor dos Anéis" estão disponíveis na filial "Filial Centro"? */

CREATE PROCEDURE dbo.copiasNoCentro 
(@tituloLivro VARCHAR(70) = 'O Senhor dos Anéis', @nomeFilial VARCHAR(70) = 'Filial Centro')
AS
SELECT copias.copias_FilialID AS [ID da Filial], filial.filial_Nome AS [Nome da Filial],
       copias.copias_Quantidade AS [Número de Cópias],
       livro.livro_Titulo AS [Título do Livro]
FROM copias_livro AS copias
    INNER JOIN livro ON copias.copias_LivroID = livro.livro_ID
    INNER JOIN filial_biblioteca AS filial ON copias.copias_FilialID = filial.filial_ID
WHERE livro.livro_Titulo = @tituloLivro AND filial.filial_Nome = @nomeFilial;
GO
EXEC dbo.copiasNoCentro;

 /* #2- Quantas cópias do livro "O Senhor dos Anéis" estão disponíveis em cada filial? */

CREATE PROCEDURE dbo.copiasEmTodasFiliais 
(@tituloLivro VARCHAR(70) = 'O Senhor dos Anéis')
AS
SELECT copias.copias_FilialID AS [ID da Filial], filial.filial_Nome AS [Nome da Filial],
       copias.copias_Quantidade AS [Número de Cópias],
       livro.livro_Titulo AS [Título do Livro]
FROM copias_livro AS copias
    INNER JOIN livro ON copias.copias_LivroID = livro.livro_ID
    INNER JOIN filial_biblioteca AS filial ON copias.copias_FilialID = filial.filial_ID
WHERE livro.livro_Titulo = @tituloLivro;
GO
EXEC dbo.copiasEmTodasFiliais;

/* #3- Recuperar os nomes de todos os usuários que não possuem livros emprestados. */

CREATE PROCEDURE dbo.usuariosSemEmprestimos
AS
SELECT usuario_Nome FROM usuario
WHERE NOT EXISTS
    (SELECT * FROM emprestimo_livros
     WHERE emprestimo_Cartao = usuario_Cartao);
GO
EXEC dbo.usuariosSemEmprestimos;

/* #4- Para cada livro emprestado da filial "Filial Centro" com a Data de Devolução sendo hoje, recuperar o título do livro, o nome do usuário e o endereço do usuário. */

CREATE PROCEDURE dbo.infoEmprestimosFilialCentro 
(@dataDevolucao DATE = NULL, @nomeFilial VARCHAR(50) = 'Filial Centro')
AS
SET @dataDevolucao = GETDATE();
SELECT filial.filial_Nome AS [Nome da Filial], livro.livro_Titulo AS [Título do Livro],
       usuario.usuario_Nome AS [Nome do Usuário], usuario.usuario_Endereco AS [Endereço do Usuário],
       emprestimo.emprestimo_DataRetirada AS [Data de Retirada]
FROM emprestimo_livros AS emprestimo
    INNER JOIN filial_biblioteca AS filial ON emprestimo.emprestimo_FilialID = filial.filial_ID
    INNER JOIN livro ON emprestimo.emprestimo_LivroID = livro.livro_ID
    INNER JOIN usuario ON emprestimo.emprestimo_Cartao = usuario.usuario_Cartao
WHERE filial.filial_Nome = @nomeFilial AND emprestimo.emprestimo_DataDevolucao = @dataDevolucao;
GO
EXEC dbo.infoEmprestimosFilialCentro;

/* #5- Criar um procedimento armazenado que retorne todos os autores de um determinado livro. */

CREATE PROCEDURE dbo.autoresDoLivro
(@tituloLivro VARCHAR(70))
AS
SELECT autores.autores_Nome AS [Nome do Autor]
FROM autores_livro AS autores
    INNER JOIN livro ON autores.autores_LivroID = livro.livro_ID
WHERE livro.livro_Titulo = @tituloLivro;
GO
EXEC dbo.autoresDoLivro @tituloLivro = 'O Senhor dos Anéis';

/* #6- Criar um procedimento armazenado que insira um novo livro na base de dados. */

CREATE PROCEDURE dbo.inserirNovoLivro
(@titulo VARCHAR(100), @editoraNome VARCHAR(100))
AS
BEGIN
    INSERT INTO livro (livro_Titulo, livro_Editora) VALUES (@titulo, @editoraNome);
END;
GO
EXEC dbo.inserirNovoLivro @titulo = 'O Mundo de Sofia', @editoraNome = 'Editora Gama';

/* #7- Criar um procedimento armazenado que insira um novo empréstimo de livro. */

CREATE PROCEDURE dbo.novoEmprestimo
(@livroID INT, @filialID INT, @cartaoUsuario INT, @dataRetirada VARCHAR(50), @dataDevolucao VARCHAR(50))
AS
BEGIN
    INSERT INTO emprestimo_livros (emprestimo_LivroID, emprestimo_FilialID, emprestimo_Cartao, emprestimo_DataRetirada, emprestimo_DataDevolucao)
    VALUES (@livroID, @filialID, @cartaoUsuario, @dataRetirada, @dataDevolucao);
END;
GO
EXEC dbo.novoEmprestimo @livroID = 1, @filialID = 1, @cartaoUsuario = 100, @dataRetirada = '2024-01-01', @dataDevolucao = '2024-01-10';

/* ==================== FIM DOS PROCEDIMENTOS ARMAZENADOS ======================= */
