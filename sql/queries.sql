--Mostar pokemon por nome

SQL: SELECT p.id, p.nome FROM pokedex p
WHERE
  	p.nome = 'Groudon'

--Mostrar pokemon por id

SQL: SELECT p.id, p.nome FROM pokedex p
WHERE
 	 p.id = 254


--Mostrar por raridade

SQL: SELECT p.id, p.nome FROM pokedex p
JOIN raridade AS r 
  	ON p.raridade_id = r.id
WHERE
  	r.nome = 'Lendário'


 --Mostrar por dois filtros ex: geração e raridade

SQL: SELECT p.id, p.nome FROM pokedex p
JOIN geracao AS g 
  	ON p.geracao_id = g.id
JOIN raridade AS r
 	 ON p.raridade_id = r.id
WHERE
  	g.nome = 'Johto' AND r.nome = 'Pseudo-lendário'


--Mostrar o tipo independente de ser o primeiro ou o segundo

SQL: SELECT p.id, p.nome FROM pokedex p
JOIN tipo AS t
 	 ON t.id IN (p.tipo_id, p.tipo2_id)
WHERE
 	 t.nome = 'Poison'


--Batalha
SQL: SELECT
    t1.posicao,
    p1.nome AS pokemon_time1,
    p2.nome AS pokemon_time2,
    m1.power AS power_time1,
    m2.power AS power_time2,
    CASE
        WHEN m1.power > m2.power THEN p1.nome
        WHEN m2.power > m1.power THEN p2.nome
        ELSE 'EMPATE'
    END AS vencedor
FROM time_pokemon_selecao t1
JOIN time_pokemon_selecao t2
  ON t1.posicao = t2.posicao
 AND t2.time_pokemon_id = 3     /* id do segundo treinador */
JOIN pokedex p1 ON p1.id = t1.pokedex_id
JOIN pokedex p2 ON p2.id = t2.pokedex_id
JOIN movimento m1 ON m1.id = p1.move_id
JOIN movimento m2 ON m2.id = p2.move_id
WHERE t1.time_pokemon_id = 1   /* id do primeiro treinador */
ORDER BY t1.posicao;



--Mostrar quantas vitórias (para os céticos)

SQL: SELECT
    SUM(CASE WHEN m1.power > m2.power THEN 1 ELSE 0 END) AS vitorias_rodada_time1,
    SUM(CASE WHEN m2.power > m1.power THEN 1 ELSE 0 END) AS vitorias_rodada_time2
FROM time_pokemon_selecao t1
JOIN time_pokemon_selecao t2
  ON t1.posicao = t2.posicao
 AND t2.time_pokemon_id = 3     /* id do segundo treinador */
JOIN pokedex p1 ON p1.id = t1.pokedex_id
JOIN pokedex p2 ON p2.id = t2.pokedex_id
JOIN movimento m1 ON m1.id = p1.move_id
JOIN movimento m2 ON m2.id = p2.move_id
WHERE t1.time_pokemon_id = 4;   /* id do primeiro treinador */


--Mostrar os 6 pokémons de um time

SQL: SELECT 
    p.id,
    p.nome
FROM time_pokemon tp
JOIN time_pokemon_selecao tps 
    ON tps.time_pokemon_id = tp.id
JOIN pokedex p 
    ON p.id = tps.pokedex_id
WHERE tp.id = 2
ORDER BY tps.posicao


--Mostrar quais pokemons tem determinado movimento

SQL: SELECT
    p.id,
    p.nome AS pokemon,
    m.nome AS movimento,
    m.power
FROM pokedex p
JOIN movimento m
    ON m.id = p.move_id
WHERE m.nome = 'Pound'
ORDER BY p.nome;


--Mostrar os pokémons de um treinador

SQL: SELECT DISTINCT
    tp.id            AS time_id,
    p.id,
    p.nome AS pokemon
FROM treinador tr
JOIN time_pokemon tp
    ON tp.treinador_id = tr.id
JOIN time_pokemon_selecao tps
    ON tps.time_pokemon_id = tp.id
JOIN pokedex p
    ON p.id = tps.pokedex_id
WHERE tr.id = 1
ORDER BY tp.id, p.nome;


--Mostrar qual o pokémon mais forte

SQL: SELECT 
    p.nome AS pokemon,
    m.nome AS movimento,
    m.power
FROM pokedex p
JOIN movimento m ON m.id = p.move_id
WHERE m.power = (
    SELECT MAX(power) FROM movimento
);


--Média de poder de cada time de um treinador

SQL: SELECT
    tp.id AS time_id,
    AVG(m.power) AS media_poder
FROM treinador tr
JOIN time_pokemon tp ON tp.treinador_id = tr.id
JOIN time_pokemon_selecao tps ON tps.time_pokemon_id = tp.id
JOIN pokedex p ON p.id = tps.pokedex_id
JOIN movimento m ON m.id = p.move_id
WHERE tr.id = 1
GROUP BY tp.id;


--Mostrar o menor ao maior pokemon de um time (power)

SQL: SELECT
    p.nome        AS pokemon,
    m.nome        AS movimento,
    m.power       AS poder
FROM time_pokemon tp
JOIN time_pokemon_selecao tps
    ON tps.time_pokemon_id = tp.id
JOIN pokedex p
    ON p.id = tps.pokedex_id
JOIN movimento m
    ON m.id = p.move_id
WHERE tp.id = 1
ORDER BY m.power ASC;


--Mostrar o top 5 movimento mais forte

SQL: SELECT
    nome,
    power
FROM movimento
ORDER BY power DESC
LIMIT 5;


--Mostrar qual o pokémon mais utilizado de um treinador

SQL: SELECT
    p.nome AS pokemon,
    COUNT(*) AS vezes_usado
FROM treinador tr
JOIN time_pokemon tp ON tp.treinador_id = tr.id
JOIN time_pokemon_selecao tps ON tps.time_pokemon_id = tp.id
JOIN pokedex p ON p.id = tps.pokedex_id
WHERE tr.id = 1
GROUP BY p.nome
ORDER BY vezes_usado DESC
LIMIT 1;



