-- Script 1 : Création des bases de données

-- Supprimer les bases si elles existent déjà pour commencer a zero 
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DW_Universite')
    DROP DATABASE DW_Universite;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DW_Universite_Staging')
    DROP DATABASE DW_Universite_Staging;
GO

-- Créer la base Staging (temporaire) pour faire des operations aisni de suite
CREATE DATABASE DW_Universite_Staging;
GO

-- Créer la base Data Warehouse (finale)
CREATE DATABASE DW_Universite;
GO

-- Vérification
SELECT name AS 'Base créée', create_date AS 'Date création'
FROM sys.databases
WHERE name IN ('DW_Universite', 'DW_Universite_Staging');
GO

PRINT ' Les 2 bases de données ont été créées avec succes';