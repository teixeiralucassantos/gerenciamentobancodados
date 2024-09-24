# Sistema de Gerenciamento de Biblioteca

Este repositório contém um script SQL para a criação e gerenciamento de um banco de dados chamado `BibliotecaDB`, projetado para gerenciar informações sobre livros, editoras, usuários e empréstimos em uma biblioteca.

## Objetivo

O objetivo deste sistema é fornecer uma estrutura eficiente para armazenar e manipular dados relacionados a livros, editoras, usuários e suas interações, como empréstimos de livros. O sistema pode ser utilizado por bibliotecas para gerenciar seu acervo, rastrear empréstimos e organizar informações sobre usuários e editoras.

## Estrutura do Banco de Dados

O banco de dados `BibliotecaDB` contém as seguintes tabelas:

1. **editora**: Armazena informações sobre as editoras dos livros.
   - `editora_Nome`: Nome da editora (chave primária).
   - `editora_Endereco`: Endereço da editora.
   - `editora_Telefone`: Telefone de contato da editora.

2. **livro**: Armazena informações sobre os livros disponíveis na biblioteca.
   - `livro_ID`: Identificador único do livro (chave primária).
   - `livro_Titulo`: Título do livro.
   - `livro_Editora`: Nome da editora do livro (chave estrangeira referenciando a tabela `editora`).

3. **filial_biblioteca**: Armazena informações sobre as filiais da biblioteca.
   - `filial_ID`: Identificador único da filial (chave primária).
   - `filial_Nome`: Nome da filial.
   - `filial_Endereco`: Endereço da filial.

4. **usuario**: Armazena informações sobre os usuários da biblioteca.
   - `usuario_Cartao`: Número do cartão do usuário (chave primária).
   - `usuario_Nome`: Nome do usuário.
   - `usuario_Endereco`: Endereço do usuário.
   - `usuario_Telefone`: Telefone do usuário.

5. **emprestimo_livros**: Registra os empréstimos de livros pelos usuários.
   - `emprestimo_ID`: Identificador único do empréstimo (chave primária).
   - `emprestimo_LivroID`: Identificador do livro emprestado (chave estrangeira referenciando a tabela `livro`).
   - `emprestimo_FilialID`: Identificador da filial onde o livro foi emprestado (chave estrangeira referenciando a tabela `filial_biblioteca`).
   - `emprestimo_Cartao`: Número do cartão do usuário que fez o empréstimo (chave estrangeira referenciando a tabela `usuario`).
   - `emprestimo_DataRetirada`: Data de retirada do livro.
   - `emprestimo_DataDevolucao`: Data prevista para devolução do livro.

6. **copias_livro**: Armazena a quantidade de cópias de cada livro em cada filial.
   - `copias_ID`: Identificador único da cópia (chave primária).
   - `copias_LivroID`: Identificador do livro (chave estrangeira referenciando a tabela `livro`).
   - `copias_FilialID`: Identificador da filial (chave estrangeira referenciando a tabela `filial_biblioteca`).
   - `copias_Quantidade`: Número de cópias disponíveis.

7. **autores_livro**: Armazena informações sobre os autores dos livros.
   - `autores_ID`: Identificador único do autor (chave primária).
   - `autores_LivroID`: Identificador do livro (chave estrangeira referenciando a tabela `livro`).
   - `autores_Nome`: Nome do autor.

## Populando as Tabelas

O script inclui comandos `INSERT` para popular as tabelas com dados de exemplo, permitindo que os usuários testem e utilizem o banco de dados imediatamente após a criação.

## Procedimentos Armazenados

Vários procedimentos armazenados foram criados para facilitar o gerenciamento e a consulta de dados:

1. **copiasNoCentro**: Retorna o número de cópias de um livro disponível em uma filial específica.
2. **copiasEmTodasFiliais**: Retorna o número de cópias de um livro disponível em todas as filiais.
3. **usuariosSemEmprestimos**: Recupera os nomes de todos os usuários que não possuem livros emprestados.
4. **infoEmprestimosFilialCentro**: Recupera informações sobre livros emprestados em uma filial específica com a data de devolução sendo hoje.
5. **autoresDoLivro**: Retorna os nomes de todos os autores de um livro específico.
6. **inserirNovoLivro**: Insere um novo livro na base de dados.
7. **novoEmprestimo**: Registra um novo empréstimo de livro.

## Conclusão

Este sistema oferece uma solução robusta para gerenciar informações relacionadas a uma biblioteca, facilitando o rastreamento de livros, editoras e empréstimos. Através do uso de tabelas estruturadas e procedimentos armazenados, o `BibliotecaDB` fornece uma base sólida para o desenvolvimento de aplicações mais complexas.

## Como Usar

1. Execute o script SQL em um servidor de banco de dados SQL Server.
2. Utilize os procedimentos armazenados para interagir com os dados.
3. Modifique o banco de dados conforme necessário para atender às suas necessidades específicas.
