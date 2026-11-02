-- le but de ce script est de creer table des faits 

USE DW_Universite;
GO

-- Table de faits sans colonnes redondantes
CREATE TABLE fact_examens (
    -- Clé primaire technique
    SK_Examen INT PRIMARY KEY IDENTITY(1,1),  -- auto_incrementataion 
    
    -- Clés étrangères vers les dimensions pour creer le modele en etoile 
    SK_Etudiant INT NOT NULL,
    SK_Cours INT NOT NULL,
    SK_Date INT NOT NULL,
    SK_Reussite INT NOT NULL,
    
    -- Clé métier c'est id original dans le fichier 
    id_examen INT NOT NULL,
    
    -- Mesures , données brutes du fichier 
    note DECIMAL(4,2) NOT NULL CHECK (note >= 0 AND note <= 20),
    reussi VARCHAR(3) NOT NULL CHECK (reussi IN ('Oui', 'Non')),
    
    -- Contraintes de clés étrangères
    CONSTRAINT FK_fact_examens_dim_etudiant 
        FOREIGN KEY (SK_Etudiant) REFERENCES dim_etudiant(SK_Etudiant),
    CONSTRAINT FK_fact_examens_dim_cours 
        FOREIGN KEY (SK_Cours) REFERENCES dim_cours(SK_Cours),
    CONSTRAINT FK_fact_examens_dim_date 
        FOREIGN KEY (SK_Date) REFERENCES dim_date(SK_Date),
    CONSTRAINT FK_fact_examens_dim_reussite 
        FOREIGN KEY (SK_Reussite) REFERENCES dim_reussite(SK_Reussite)
);
GO

--  les index  pour SSIS , pour la performance 
CREATE INDEX IX_fact_SK_Etudiant ON fact_examens(SK_Etudiant);
CREATE INDEX IX_fact_SK_Cours ON fact_examens(SK_Cours);
CREATE INDEX IX_fact_SK_Date ON fact_examens(SK_Date);
-- Pas d'index sur SK_Reussite car on a seulement 4 
GO

