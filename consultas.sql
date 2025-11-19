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

-- 12. Filtra imóveis com base nos parâmetros fornecidos, permitindo uma filtragem flexível.

	-- Cenário A: Filtro Simples (Sem Comodidades). Busca imóveis que correspondam a um ou mais critérios simples (ex: por bairro, tipo, faixa de valor). A cláusula WHERE é montada dinamicamente.

/*SELECT DISTINCT i.* FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
WHERE i.tipo = %s AND i.bairro = %s AND i.valor_venal >= %s;*/

SELECT DISTINCT i.* FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
WHERE i.tipo = 'Apartamento' 
  AND i.bairro = 'Tatuapé' 
  AND i.valor_venal >= 800000;

	-- Cenário B: Filtro por Comodidades (Lógica Especial). Busca imóveis que possuam todas as comodidades que o usuário queira.
/*SELECT DISTINCT i.* FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
WHERE i.bairro = %s AND c.comodidade = ANY(%s)
GROUP BY i.matricula 
HAVING COUNT(DISTINCT c.comodidade) = %s;*/

SELECT DISTINCT i.* FROM imovel i
LEFT JOIN comodidades_imovel c ON i.matricula = c.matricula
WHERE i.bairro = 'Tatuapé' AND c.comodidade = ANY(ARRAY['Elevador', 'Academia'])
GROUP BY i.matricula 
HAVING COUNT(DISTINCT c.comodidade) = 2;

-- 13. Obtém os status de um imóvel (o código em python confere se a data de fim de um contrato já passou. Se tiver, altera o status do contrato para finalizado e o status do imóvel para disponível)

/*SELECT c.codigo, c.status, c.data_fim FROM imovel i 
LEFT JOIN contrato c ON i.matricula = c.matricula_imovel 
WHERE i.matricula = %s 
ORDER BY c.codigo DESC;*/

SELECT c.codigo, c.status, c.data_fim FROM imovel i 
LEFT JOIN contrato c ON i.matricula = c.matricula_imovel 
WHERE i.matricula = '1001001001001002' 
ORDER BY c.codigo DESC;

