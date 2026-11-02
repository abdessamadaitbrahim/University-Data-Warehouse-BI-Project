-- SCRIPT : CRÉATION DES DIMENSIONS DW_Universite
USE DW_Universite;
GO

-- 1. DIMENSION ÉTUDIANT + (validation)

CREATE TABLE dim_etudiant (
    SK_Etudiant INT PRIMARY KEY IDENTITY(1,1),         -- SK est la clé technique auto-incrémentée
    id_etudiant INT NOT NULL,                          -- Clé métier (id_etu du fichier )
    nom NVARCHAR(100) NOT NULL,                         -- Nom de l'étudiant
    sexe CHAR(1) NOT NULL CHECK (sexe IN ('M', 'F')),  -- Validation : M ou F
    age INT NOT NULL CHECK (age >= 18 AND age <= 100), -- Validation : age réaliste et logique hh
    categorie_age NVARCHAR(10) NOT NULL,                --  '18-22', '23-27', '28+'
    date_insertion DATETIME DEFAULT GETDATE()          -- Date d'insertion automatique
);
GO

-- Index pour les lookups SSIS et requêtes Power BI 
CREATE UNIQUE INDEX IX_id_etudiant ON dim_etudiant(id_etudiant);
GO

-- 2. DIMENSION COURS 
CREATE TABLE dim_cours (
    SK_Cours INT PRIMARY KEY IDENTITY(1,1),       -- Clé technique auto-incrémentée
    id_cours INT NOT NULL,                        -- Clé métier (100 à 107) en se basant sur le fichier initial 
    nom_cours NVARCHAR(100) NOT NULL,              -- Cours_1 à Cours_8 en se basant aussi sur le fichier inital 
    type_cours NVARCHAR(50) NOT NULL CHECK (type_cours IN ('Obligatoire', 'Optionnel'))
);
GO

-- Index pour les lookups SSIS
CREATE UNIQUE INDEX IX_id_cours ON dim_cours(id_cours);
GO

-- 3. DIMENSION DATE   
CREATE TABLE dim_date (
    SK_Date INT PRIMARY KEY IDENTITY(1,1),
    date_complete DATE NOT NULL UNIQUE,
    annee INT NOT NULL,
    trimestre INT NOT NULL CHECK (trimestre BETWEEN 1 AND 4),
    mois INT NOT NULL CHECK (mois BETWEEN 1 AND 12),
    nom_mois NVARCHAR(50) NOT NULL,
    semestre INT NOT NULL CHECK (semestre IN (1, 2))
);
GO
CREATE INDEX IX_date_complete ON dim_date(date_complete);
CREATE INDEX IX_annee_trimestre ON dim_date(annee, trimestre);
GO

-- 4. DIMENSION RÉUSSITE (valeurs fixes)
CREATE TABLE dim_reussite (
    SK_Reussite INT PRIMARY KEY,                  -- Clé fixe (pas auto-incrémentée)
    statut_reussite VARCHAR(10) NOT NULL CHECK (statut_reussite IN ('Oui', 'Non')),
    categorie_note VARCHAR(20) NOT NULL
);
GO

-- Insertion des 4 catégories 
INSERT INTO dim_reussite (SK_Reussite, statut_reussite, categorie_note) VALUES
(1, 'Oui', 'Excellent'),
(2, 'Oui', 'Bien'),
(3, 'Oui', 'Passable'),
(4, 'Non', 'Échec');
GO



