-- LIMPEZA DE REGISTROS REPETIDOS -> BUSCA E REMOÇÃO DE UM ELEMENTO

-- pt/br 1) BUSCAR QUAIS ELEMENTOS ESTÃO REPETIDOS NA BASE DE DADOS, DE ACORDO COM UMA CHAVE DE COMPARAÇÃO
-- eng   2) FIND REPEATED RECORDS ON DATA TABLE, BASED ON SOME COMPARING INFO COLUMN
/*
select * from MainTable where MainTableID in (
select idref from (
	select min(MainTableID) as idref, count(MainTableID) as total 
	  from MainTable
	 where DuplicatedInformationReferenceColumn is not null and DuplicatedInformationReferenceColumn <> ''
	group by DuplicatedInformationReferenceColumn
) as a where a.total > 1 order by a.total
)
;

-- pt/br 2) APAGAR REGISTROS EM TABELAS ASSOCIADAS, ANTES DE REMOVER DA PRINCIPAL
-- eng   2) FIRTS, REMOVE ASSOCIATED TABLES RECORDS, TO AVOID ORPHANS OR CONSTRAINT ERRORS
delete from MainTable where MainTableID in (
select idref from (
	select min(MainTableID) as idref, count(MainTableID) as total 
	  from MainTable
	 where DuplicatedInformationReferenceColumn is not null and DuplicatedInformationReferenceColumn <> ''
	group by DuplicatedInformationReferenceColumn
) as a where a.total > 1 order by a.total
)
;

-- pt/br 3) REMOVER UMA OCORRÊNCIA DA DUPLICAÇÃO NA TABELA PRINCIPAL
-- eng   3) REMOVE ONR RECORD FROM MAIN TABLE
delete from MainTable where MainTableID in (
select idref from (
	select min(MainTableID) as idref, count(MainTableID) as total 
	  from MainTable
	 where DuplicatedInformationReferenceColumn is not null and DuplicatedInformationReferenceColumn <> ''
	group by DuplicatedInformationReferenceColumn
) as a where a.total > 1 order by a.total
)
;
