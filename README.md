# sql-remove-rec
Hot-To: Locate and remove one duplicated record from database, based on first or last record put on table.

Intent: The main objective is, not just find duplicated records, but also, remove one repetition, or as explained on this post, n-1 repetitions, based on some information taken as a comparision info.

The command is a simple count into one or more columns on table that can grant us, that the info is the same. After finding that, we can take only Max or Min Primary Key.

```
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
```

As we have only one of the repetition keys, we can delete them, lasting the other one record on the table. If this table is referenced as foreign on some other table, first, we need to remove references. Hoppely we have constrints on database that avoid us to remove referenced key. If it's not the case, we will end with a lot of orphan references.

```
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
```

We last removing duplicates from main table, using the same procedure.

```
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
```
And if we have more than one repetition? In this case, we can create a function on the database, that iteract this query while we have repetitions on database.

Hope that helps, and improvements are always welcome.
