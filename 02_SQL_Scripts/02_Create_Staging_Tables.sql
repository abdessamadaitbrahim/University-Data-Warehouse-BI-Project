-- Utiliser la base de staging
USE DW_Universite_Staging;
GO

-- Table pour les étudiants (brut)
CREATE TABLE STG_Etudiants (
    id_etu INT,
    nom NVARCHAR(100),
    sexe NVARCHAR(50),
    age NVARCHAR(50),  -- VARCHAR car peut contenir qlq chose autre que les int ...
    categorie_age NVARCHAR(10) NOT NULL);
GO

-- Table pour les cours (brut)
CREATE TABLE STG_Cours (
    id_cours INT,
    nom_cours NVARCHAR(100),
    type_cours NVARCHAR(20)
);
GO

-- Table pour les examens (brut)
CREATE TABLE STG_Examens (
    id_exam INT,
    id_etu INT,
    id_cours INT,
    date_exam DATE,
    note DECIMAL(4,2),
    reussi VARCHAR(3)
);
GO

-- Table pour les étudiants rejetés (dirty)
CREATE TABLE STG_Etudiants_Dirty (
    id_etu INT,
    nom NVARCHAR(100),
    sexe NVARCHAR(50),
    age NVARCHAR(50),
    raison_erreur NVARCHAR(200)
);
GO


-- Vérification
SELECT 'Tables de staging créées avec succès' AS Message; 




