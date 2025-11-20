--Arquivo com as consultas embutidas na aplicacao. Para cada uma delas, havera um enunciado, seguido do codigo SQL.

-- 1. Cadastra um usuario (sem ainda colocar de qual/quais tipos ele é). A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*INSERT INTO usuario (CPF, prenome, sobrenome, data_nasc, email)
VALUES (%s, %s, %s, %s, %s);*/

INSERT INTO usuario (CPF, prenome, sobrenome, data_nasc, email)
VALUES ('99988877766', 'Novo', 'Usuario', '1995-03-20', 'novo.usuario@email.com');

-- 2. Cadastra um usuário como adquirente. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*INSERT INTO adquirente (CPF,pontuacao_credito)
VALUES (%s, %s);*/

INSERT INTO adquirente (CPF,pontuacao_credito)
VALUES ('99988877766', 820);

-- 3. Cadastra um usuário como proprietário. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*INSERT INTO proprietario (CPF)
VALUES (%s);*/

INSERT INTO proprietario (CPF)
VALUES ('99988877766');

-- 4. Cadastra um usuário como corretor. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*INSERT INTO corretor (CPF, especialidade, creci_codigo, regiao_atuacao)
VALUES (%s, %s, %s, %s);*/

INSERT INTO corretor (CPF, especialidade, creci_codigo, regiao_atuacao)
VALUES ('99988877766', 'Apartamento', '123456', 'Moema');

-- 5. Insere a senha com hash na tabela login (de forma segura). A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/* INSERT INTO login (CPF, senha)
VALUES (%s, %s);*/

INSERT INTO login (CPF, senha)
VALUES ('99988877766', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3');

-- 6. Insere um ou mais telefones para um usuário. A consulta é construída dinamicamente para inserir múltiplas linhas de uma vez.(A lógica em Python primeiro verifica se o usuário ultrapassará o limite de 3 telefones antes de executar esta consulta).
-- A seguir apresentamos um exemplo de uso para 2 telefones, substituindo os %s por valores.

/*INSERT INTO tel_usuario(CPF, telefone) VALUES (%s, %s), (%s, %s);*/

INSERT INTO tel_usuario(CPF, telefone) 
VALUES ('99988877766', '11988887777'), ('99988877766', '11955554444');

-- 7. Obtém o total de telefones cadastrados para um usuário específico. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*SELECT COUNT(*) AS total
FROM tel_usuario
WHERE CPF = %s;*/

SELECT COUNT(*) AS total
FROM tel_usuario
WHERE CPF = '99988877766';

-- 8. Remove um ou mais telefones de um usuário, especificados em uma lista. (A lógica em Python primeiro verifica se a remoção deixará o usuário com menos de um telefone antes de executar esta consulta).
-- A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*DELETE FROM tel_usuario
WHERE CPF = %s AND telefone = ANY(%s);*/

DELETE FROM tel_usuario
WHERE CPF = '99988877766' AND telefone = ANY(ARRAY['11955554444']);

-- 9. Deleta um usuário. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*DELETE FROM usuario
WHERE CPF = %s;*/

DELETE FROM usuario
WHERE CPF = '99988877766';

-- 10. Obtém um perfil dos interesses de um adquirente, contando quantos contratos ele assinou, agrupados por tipo de imóvel (ex: Apartamento), finalidade (ex: Residencial) e tipo de contrato (ex: Venda). A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*SELECT u.prenome, u.sobrenome, i.tipo AS tipo_de_imovel, i.finalidade, c.tipo AS tipo_de_contrato, COUNT(*) AS total_de_contratos
FROM usuario u
JOIN assina a ON u.CPF = a.CPF_adq
JOIN contrato c ON a.codigo_c = c.codigo
JOIN imovel i ON c.matricula_imovel = i.matricula
WHERE u.CPF = %s
GROUP BY u.CPF, i.tipo, i.finalidade, c.tipo 
ORDER BY u.prenome, total_de_contratos DESC;*/

SELECT u.prenome, u.sobrenome, i.tipo AS tipo_de_imovel, i.finalidade, c.tipo AS tipo_de_contrato, COUNT(*) AS total_de_contratos
FROM usuario u
JOIN assina a ON u.CPF = a.CPF_adq
JOIN contrato c ON a.codigo_c = c.codigo
JOIN imovel i ON c.matricula_imovel = i.matricula
WHERE u.CPF = '99988877766'
GROUP BY u.CPF, i.tipo, i.finalidade, c.tipo 
ORDER BY u.prenome, total_de_contratos DESC;

-- 11. Lista todos os imóveis de um proprietário e inclui informações do contrato associado (como status e data de fim), se houver.(A consulta SQL é apenas a primeira etapa. O código Python subsequente itera sobre os resultados para: verificar se contratos 'Ativos' já expiraram (comparando data_fim com a data atual), atualizar o status no banco se um contrato tiver expirado)
-- A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*SELECT i.matricula, i.logradouro, i.numero, c.codigo, c.status, c.valor, c.data_fim
FROM imovel i
LEFT JOIN contrato c ON i.matricula = c.matricula_imovel
WHERE i.CPF_prop = %s;*/

SELECT i.matricula, i.logradouro, i.numero, c.codigo, c.status, c.valor, c.data_fim
FROM imovel i
LEFT JOIN contrato c ON i.matricula = c.matricula_imovel
WHERE i.CPF_prop = '99988877766';

-- 12. Filtra imóveis com base nos parâmetros fornecidos, permitindo uma filtragem flexível. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

	-- Cenário A: Filtro Simples (Sem Comodidades). Busca imóveis que correspondam a um ou mais critérios simples (ex: por bairro, tipo, faixa de valor). A cláusula WHERE é montada dinamicamente. O GROUP BY é usado para agrupar as múltiplas imagens de cada imóvel.

/*SELECT DISTINCT i.*, array_agg(DISTINCT img.imovel_image_url) AS imagens
FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
LEFT JOIN imagem_imovel img ON i.matricula = img.matricula
WHERE i.tipo = %s AND i.bairro = %s AND i.valor_venal >= %s
GROUP BY i.matricula;*/

SELECT i.*, array_agg(DISTINCT img.imovel_image_url) AS imagens
FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
LEFT JOIN imagem_imovel img ON i.matricula = img.matricula
WHERE i.tipo = 'Apartamento' 
  AND i.bairro = 'Tatuapé' 
  AND i.valor_venal >= 800000
GROUP BY i.matricula;

	-- Cenário B: Filtro por Comodidades (Lógica Especial). Busca imóveis que possuam todas as comodidades que o usuário queira.

/*SELECT i.*, array_agg(DISTINCT img.imovel_image_url) AS imagens
FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
LEFT JOIN imagem_imovel img ON i.matricula = img.matricula
WHERE i.bairro = %s AND c.comodidade = ANY(%s)
GROUP BY i.matricula
HAVING COUNT(DISTINCT c.comodidade) = %s;*/

SELECT i.*, array_agg(DISTINCT img.imovel_image_url) AS imagens
FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
LEFT JOIN imagem_imovel img ON i.matricula = img.matricula
WHERE i.bairro = 'Tatuapé' AND c.comodidade = ANY(ARRAY['Elevador', 'Academia'])
GROUP BY i.matricula
HAVING COUNT(DISTINCT c.comodidade) = 2;

-- 13. Obtém os status de um imóvel (o código em python confere se a data de fim de um contrato já passou. Se tiver, altera o status do contrato para finalizado e o status do imóvel para disponível). A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*SELECT c.codigo, c.status, c.data_fim FROM imovel i 
LEFT JOIN contrato c ON i.matricula = c.matricula_imovel 
WHERE i.matricula = %s 
ORDER BY c.codigo DESC;*/

SELECT c.codigo, c.status, c.data_fim FROM imovel i 
LEFT JOIN contrato c ON i.matricula = c.matricula_imovel 
WHERE i.matricula = '1001001001001002' 
ORDER BY c.codigo DESC;

-- 14. Atualiza os dados cadastrais básicos (nome, email, imagem de perfil) de um usuário. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*UPDATE usuario
SET prenome = %s, sobrenome = %s, email = %s, profile_image_url = %s
WHERE CPF = %s;*/

UPDATE usuario
SET prenome = 'Ana Maria', 
    sobrenome = 'Silva Souza', 
    email = 'ana.nova@email.com', 
    profile_image_url = 'https://exemplo.com/fotos/ana_silva_v2.jpg'
WHERE CPF = '12345678901';

-- 15. Cadastra um novo imóvel no sistema, associando-o a um proprietário existente. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*INSERT INTO imovel (matricula, n_quartos, valor_venal, metragem, tipo, mobiliado, possui_garagem, n_reformas, finalidade, logradouro, complemento, numero, CEP, cidade, CPF_prop, descricao, bairro)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);*/

INSERT INTO imovel (matricula, n_quartos, valor_venal, metragem, tipo, mobiliado, possui_garagem, n_reformas, finalidade, logradouro, complemento, numero, CEP, cidade, CPF_prop, descricao, bairro)
VALUES ('1001001001001011', 3, 950000.00, 180.0, 'Casa', false, true, 1, 'Residencial', 
'Rua Maria Amália Lopes de Azevedo', NULL, '3000', '02350001', 'São Paulo', '60590810211',
'Casa espaçosa no Tremembé, 3 quartos, perto da serra.','Tremembé');

-- 16. Atualiza características de um imóvel. A consulta UPDATE é construída dinamicamente para alterar apenas os campos que foram fornecidos (não nulos). A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

	-- EXEMPLO: Se o usuário quiser alterar apenas o valor_venal e o n_reformas
/*UPDATE imovel
SET valor_venal = %s, n_reformas = %s
WHERE matricula = %s;*/

UPDATE imovel
SET valor_venal = 1050000.00, n_reformas = 2
WHERE matricula = '1001001001001011';

-- 17. Altera o proprietário associado a um imóvel específico. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*UPDATE imovel
SET CPF_prop = %s
WHERE matricula = %s;*/

UPDATE imovel
SET CPF_prop = '98765432109'
WHERE matricula = '1001001001001011';

-- 18. Adiciona uma ou mais comodidades a um imóvel. A consulta é construída dinamicamente para inserir múltiplas linhas de uma vez. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.
	
	--Exemplo para 2 itens
/*INSERT INTO comodidades_imovel(matricula, comodidade) 
VALUES (%s, %s), (%s, %s);*/

INSERT INTO comodidades_imovel(matricula, comodidade) 
VALUES ('1001001001001011', 'Churrasqueira'), 
       ('1001001001001011', 'Quintal');

-- 19. Remove uma ou mais comodidades de um imóvel específico. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*DELETE FROM comodidades_imovel
WHERE matricula = %s AND comodidade = ANY(%s);*/

DELETE FROM comodidades_imovel
WHERE matricula = '1001001001001011' AND comodidade = ANY(ARRAY['Quintal']);

-- 20. Deleta um imóvel do sistema. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*DELETE FROM imovel
WHERE matricula = %s;*/

DELETE FROM imovel
WHERE matricula = '1001001001001011';

-- 21. Vincula uma URL de imagem a um imóvel específico. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*INSERT INTO imagem_imovel (matricula, imovel_image_url)
VALUES (%s, %s);*/

INSERT INTO imagem_imovel (matricula, imovel_image_url)
VALUES ('1001001001001011', 'http://localhost:5000/static/uploads/imoveis/1001001001001011_0.jpg');

-- 22. Remove o vinculo de uma imagem especifica com um imovel banco de dados. A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*DELETE FROM imagem_imovel
WHERE matricula = %s AND imovel_image_url = %s;*/

DELETE FROM imagem_imovel
WHERE matricula = '1001001001001011' 
  AND imovel_image_url = 'http://localhost:5000/static/uploads/imoveis/1001001001001011_0.jpg';

-- 23. Obtém contratos de aluguel ativos que estão perto de vencer (dentro de um intervalo de 30 dias a partir da data atual). A seguir apresentamos um exemplo de uso, substituindo os %s por valores.

/*SELECT * FROM contrato
WHERE tipo='Aluguel' AND status = 'Ativo' AND
data_fim BETWEEN %s AND %s;*/

SELECT * FROM contrato
WHERE tipo='Aluguel' AND status = 'Ativo' AND
data_fim BETWEEN '2025-11-19' AND '2025-12-19';

-- 24. Insere um novo contrato (Venda ou Aluguel) no sistema, vinculando um imóvel a um proprietário e a um corretor responsável.

/*INSERT INTO contrato (codigo, valor, status, data_inicio, data_fim, tipo, matricula_imovel, CPF_prop, CPF_corretor)
VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);*/

INSERT INTO contrato (codigo, valor, status, data_inicio, data_fim, tipo, matricula_imovel, CPF_prop, CPF_corretor)
VALUES (31, 2500.00, 'Ativo', '2025-12-01', '2027-12-01', 'Aluguel', '1001001001001011', '12345678901', '28780010489');

-- 25. Registra a assinatura de um contrato por um adquirente, vinculando o CPF do cliente ao código do contrato

/*INSERT INTO assina(CPF_adq, codigo_c) 
VALUES (%s, %s);*/

INSERT INTO assina(CPF_adq, codigo_c) 
VALUES ('50170230455', 31);

-- 26. Deleta um contrato do sistema.

/* DELETE FROM contrato
WHERE codigo = %s;*/

DELETE FROM contrato
WHERE codigo = 31;

-- 27. Atualiza o status de um contrato existente

/*UPDATE contrato
SET status = %s
WHERE codigo = %s;*/

UPDATE contrato
SET status = 'Finalizado'
WHERE codigo = 4;

-- 28. Obtém o histórico de períodos (data de início e fim) de todos os contratos de aluguel associados a um imóvel específico, ordenados do mais recente para o mais antigo.

/*SELECT codigo, matricula_imovel, data_inicio, data_fim FROM contrato
WHERE tipo='Aluguel' AND matricula_imovel=%s
ORDER BY data_inicio DESC*/

SELECT codigo, matricula_imovel, data_inicio, data_fim FROM contrato
WHERE tipo='Aluguel' AND matricula_imovel='1001001001001007'
ORDER BY data_inicio DESC;

-- 29. Obtém todos os contratos de aluguel que estão com status 'Ativo', trazendo juntamente os dados básicos do imóvel (endereço).

SELECT c.codigo,c.status, c.data_inicio, c.data_fim, c.valor, i.matricula, i.logradouro, i.numero
        FROM contrato c
        JOIN imovel i ON c.matricula_imovel = i.matricula
        WHERE c.tipo='Aluguel' AND c.status='Ativo';

-- 30. Obtém o histórico de valores negociados (seja de venda ou aluguel) de todos os contratos associados a um imóvel específico, ordenados do mais recente para o mais antigo.

/*SELECT codigo, matricula_imovel, valor FROM contrato 
WHERE matricula_imovel = %s 
ORDER BY codigo DESC;*/

SELECT codigo, matricula_imovel, valor FROM contrato 
WHERE matricula_imovel = '1001001001001002' 
ORDER BY codigo DESC;

-- 31. Gera um relatório dos imóveis ordenados pelo número de vezes que foram alugados (contagem de contratos do tipo 'Aluguel'), do mais popular para o menos popular.

SELECT i.matricula, i.logradouro, i.numero, 
        COUNT(c.codigo) AS nr_de_vezes_alugado
        FROM contrato c JOIN imovel i ON c.matricula_imovel = i.matricula
        WHERE c.tipo='Aluguel'
		GROUP BY i.matricula
        ORDER BY nr_de_vezes_alugado DESC;

-- 32. Devolve o histórico de proprietários e adquirentes (ou inquilinos) associados a um imóvel através de seus contratos. A consulta recupera o nome do proprietário no momento do contrato e, se houver, o nome da pessoa que assinou (comprou ou alugou).

/*SELECT c.codigo, c.tipo, c.status, 
       prop.prenome AS proprietario_nome, prop.sobrenome AS proprietario_sobrenome, 
       adq.prenome AS adquirente_nome, adq.sobrenome AS adquirente_sobrenome
FROM contrato c
JOIN usuario prop ON c.CPF_prop = prop.CPF
LEFT JOIN assina a ON c.codigo = a.codigo_c
LEFT JOIN usuario adq ON a.CPF_adq = adq.CPF
WHERE c.matricula_imovel = %s
ORDER BY c.codigo DESC;*/

SELECT c.codigo, c.tipo, c.status, 
       prop.prenome AS proprietario_nome, prop.sobrenome AS proprietario_sobrenome, 
       adq.prenome AS adquirente_nome, adq.sobrenome AS adquirente_sobrenome
FROM contrato c
JOIN usuario prop ON c.CPF_prop = prop.CPF
LEFT JOIN assina a ON c.codigo = a.codigo_c
LEFT JOIN usuario adq ON a.CPF_adq = adq.CPF
WHERE c.matricula_imovel = '1001001001001001'
ORDER BY c.codigo DESC;