-- script for testing 

-- dim tables
use DW_Universite
select * from dim_cours
select * from dim_date
select count(*) from dim_date
select * from dim_etudiant
select * from dim_reussite
select * from fact_examens
select count(*) from fact_examens where reussi = 'Non'

USE DW_Universite_Staging
SELECT * FROM STG_Etudiants_Dirty
