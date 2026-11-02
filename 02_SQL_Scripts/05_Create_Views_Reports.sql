-- ce script sert a creer le vue pour faciliter la craetiokn de rapport de visualisatiokn

USE DW_Universite;
GO

-- VUE 1 : ANALYSE DE PERFORMANCE (Vue complète détaillée)
-- Utilisation : Power BI, analyses croisées

CREATE VIEW v_analyse_performance AS
SELECT
    -- Informations Étudiant
    e.nom AS Nom_Etudiant,
    e.sexe AS Sexe,
    e.age AS Age,
    e.categorie_age AS Categorie_Age,
    
    -- Informations Cours
    c.nom_cours AS Cours,
    c.type_cours AS Type_Cours,
    
    -- Informations Temporelles
    d.date_complete AS Date_Examen,
    d.annee AS Annee,
    d.trimestre AS Trimestre,
    d.mois AS Mois,
    d.nom_mois AS Nom_Mois,
    d.semestre AS Semestre,
    
    -- Informations Réussite
    r.statut_reussite AS Statut_Reussite,
    r.categorie_note AS Categorie_Note,
    
    -- Mesures calculées (agrégées)
    COUNT(f.SK_Examen) AS Nombre_Examens,
    AVG(f.note) AS Note_Moyenne,
    MIN(f.note) AS Note_Min,
    MAX(f.note) AS Note_Max,
    SUM(CASE WHEN f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Nombre_Reussites,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct
    
FROM fact_examens f
INNER JOIN dim_etudiant e ON f.SK_Etudiant = e.SK_Etudiant
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
INNER JOIN dim_date d ON f.SK_Date = d.SK_Date
INNER JOIN dim_reussite r ON f.SK_Reussite = r.SK_Reussite

GROUP BY 
    e.nom, e.sexe, e.age, e.categorie_age,
    c.nom_cours, c.type_cours,
    d.date_complete, d.annee, d.trimestre, d.mois, d.nom_mois, d.semestre,
    r.statut_reussite, r.categorie_note;
GO

PRINT ' Vue 1 créée : v_analyse_performance';
GO


-- VUE 2 : STATISTIQUES PAR COURS
-- Utilisation : Dashboard Power BI - c est pour la page de cours

CREATE VIEW v_statistiques_cours AS
SELECT
    c.nom_cours AS Cours,
    c.type_cours AS Type_Cours,
    
    -- Métriques principales
    COUNT(f.SK_Examen) AS Nombre_Total_Examens,
    COUNT(DISTINCT f.SK_Etudiant) AS Nombre_Etudiants_Differents,
    
    -- Statistiques de notes
    AVG(f.note) AS Note_Moyenne,
    MIN(f.note) AS Note_Min,
    MAX(f.note) AS Note_Max,
    STDEV(f.note) AS Ecart_Type_Note,
    
    -- Réussite/Échec
    SUM(CASE WHEN f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Nombre_Reussites,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct,
    
    -- Catégories de notes
    SUM(CASE WHEN f.note >= 16 THEN 1 ELSE 0 END) AS Nb_Excellent,
    SUM(CASE WHEN f.note >= 12 AND f.note < 16 THEN 1 ELSE 0 END) AS Nb_Bien,
    SUM(CASE WHEN f.note >= 10 AND f.note < 12 THEN 1 ELSE 0 END) AS Nb_Passable,
    SUM(CASE WHEN f.note < 10 THEN 1 ELSE 0 END) AS Nb_Echec
    
FROM fact_examens f
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
GROUP BY c.nom_cours, c.type_cours;
GO

PRINT ' Vue 2 créée : v_statistiques_cours';
GO

-- VUE 3 : PERFORMANCE DES ÉTUDIANTS
-- Utilisation : Dashboard Power BI - Page Étudiants

CREATE VIEW v_performance_etudiants AS
SELECT
    e.nom AS Nom_Etudiant,
    e.sexe AS Sexe,
    e.age AS Age,
    e.categorie_age AS Categorie_Age,
    
    -- Statistiques des examens
    COUNT(f.SK_Examen) AS Nombre_Examens_Passes,
    AVG(f.note) AS Note_Moyenne,
    MIN(f.note) AS Note_Min,
    MAX(f.note) AS Note_Max,
    
    -- Réussite
    SUM(CASE WHEN f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Nombre_Reussites,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct,
    
    -- Performance par type de cours
    SUM(CASE WHEN c.type_cours = 'Obligatoire' AND f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Reussite_Obligatoires,
    SUM(CASE WHEN c.type_cours = 'Optionnel' AND f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Reussite_Optionnels
    
FROM fact_examens f
INNER JOIN dim_etudiant e ON f.SK_Etudiant = e.SK_Etudiant
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
GROUP BY e.nom, e.sexe, e.age, e.categorie_age;
GO

PRINT ' Vue 3 créée : v_performance_etudiants';
GO


-- VUE 4 : TOP 10 MEILLEURS ÉTUDIANTS
-- Utilisation : Dashboard Power BI - KPI

CREATE VIEW v_top_etudiants AS
SELECT TOP 10
    e.nom AS Nom_Etudiant,
    e.sexe AS Sexe,
    e.categorie_age AS Categorie_Age,
    COUNT(f.SK_Examen) AS Nombre_Examens,
    AVG(f.note) AS Note_Moyenne,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct
FROM fact_examens f
INNER JOIN dim_etudiant e ON f.SK_Etudiant = e.SK_Etudiant
GROUP BY e.nom, e.sexe, e.categorie_age
HAVING COUNT(f.SK_Examen) >= 5  -- Au moins 5 examens pour être classé
ORDER BY AVG(f.note) DESC;
GO

PRINT ' Vue 4 créée : v_top_etudiants';
GO


-- VUE 5 : ÉVOLUTION TEMPORELLE (par trimestre)
-- Utilisation : Dashboard Power BI - Graphiques temporels

CREATE VIEW v_evolution_temporelle AS
SELECT
    d.annee AS Annee,
    d.trimestre AS Trimestre,
    d.semestre AS Semestre,
    
    -- Métriques
    COUNT(f.SK_Examen) AS Nombre_Examens,
    COUNT(DISTINCT f.SK_Etudiant) AS Nombre_Etudiants,
    AVG(f.note) AS Note_Moyenne,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct,
    
    -- Par type de cours
    COUNT(CASE WHEN c.type_cours = 'Obligatoire' THEN 1 END) AS Nb_Examens_Obligatoires,
    COUNT(CASE WHEN c.type_cours = 'Optionnel' THEN 1 END) AS Nb_Examens_Optionnels
    
FROM fact_examens f
INNER JOIN dim_date d ON f.SK_Date = d.SK_Date
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
GROUP BY d.annee, d.trimestre, d.semestre;
GO

PRINT ' Vue 5 créée : v_evolution_temporelle';
GO

-- VUE 6 : COURS LES PLUS DIFFICILES (Bottom 5)
-- Utilisation : Dashboard Power BI - Alertes


CREATE VIEW v_cours_difficiles AS
SELECT TOP 5
    c.nom_cours AS Cours,
    c.type_cours AS Type_Cours,
    COUNT(f.SK_Examen) AS Nombre_Examens,
    AVG(f.note) AS Note_Moyenne,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Non' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Echec_Pct
FROM fact_examens f
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
GROUP BY c.nom_cours, c.type_cours
ORDER BY CAST(SUM(CASE WHEN f.reussi = 'Non' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) DESC;
GO

PRINT ' Vue 6 créée : v_cours_difficiles';
GO


CREATE VIEW v_reussite_par_genre AS
SELECT
    e.sexe AS Sexe,
    
    COUNT(DISTINCT e.SK_Etudiant) AS Nombre_Etudiants,
    COUNT(f.SK_Examen) AS Nombre_Examens,
    AVG(f.note) AS Note_Moyenne,
    MIN(f.note) AS Note_Min,
    MAX(f.note) AS Note_Max,
    
    SUM(CASE WHEN f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Nombre_Reussites,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct,
    
    -- Par type de cours
    SUM(CASE WHEN c.type_cours = 'Obligatoire' THEN 1 ELSE 0 END) AS Examens_Obligatoires,
    SUM(CASE WHEN c.type_cours = 'Optionnel' THEN 1 ELSE 0 END) AS Examens_Optionnels,
    
    -- Taux par type
    CAST(SUM(CASE WHEN c.type_cours = 'Obligatoire' AND f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / 
         NULLIF(SUM(CASE WHEN c.type_cours = 'Obligatoire' THEN 1 ELSE 0 END), 0) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Obligatoire,
    CAST(SUM(CASE WHEN c.type_cours = 'Optionnel' AND f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / 
         NULLIF(SUM(CASE WHEN c.type_cours = 'Optionnel' THEN 1 ELSE 0 END), 0) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Optionnel
    
FROM fact_examens f
INNER JOIN dim_etudiant e ON f.SK_Etudiant = e.SK_Etudiant
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
GROUP BY e.sexe;
GO

PRINT 'Vue 7 créée : v_reussite_par_genre';
GO



CREATE VIEW v_reussite_par_age AS
SELECT
    e.categorie_age AS Categorie_Age,
    
    COUNT(DISTINCT e.SK_Etudiant) AS Nombre_Etudiants,
    COUNT(f.SK_Examen) AS Nombre_Examens,
    AVG(f.note) AS Note_Moyenne,
    MIN(f.note) AS Note_Min,
    MAX(f.note) AS Note_Max,
    
    SUM(CASE WHEN f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Nombre_Reussites,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct
    
FROM fact_examens f
INNER JOIN dim_etudiant e ON f.SK_Etudiant = e.SK_Etudiant
GROUP BY e.categorie_age;
GO

PRINT 'Vue 8 créée : v_reussite_par_age';
GO


CREATE VIEW v_genre_x_type_cours AS
SELECT
    e.sexe AS Sexe,
    c.type_cours AS Type_Cours,
    
    COUNT(f.SK_Examen) AS Nombre_Examens,
    AVG(f.note) AS Note_Moyenne,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct
    
FROM fact_examens f
INNER JOIN dim_etudiant e ON f.SK_Etudiant = e.SK_Etudiant
INNER JOIN dim_cours c ON f.SK_Cours = c.SK_Cours
GROUP BY e.sexe, c.type_cours;
GO

PRINT 'Vue 9 créée : v_genre_x_type_cours';
GO

USE DW_Universite;
GO

CREATE VIEW v_reussite_par_mois AS
SELECT
    d.annee AS Annee,
    d.mois AS Mois,
    d.nom_mois AS Nom_Mois,
    
    COUNT(f.SK_Examen) AS Nombre_Examens,
    COUNT(DISTINCT f.SK_Etudiant) AS Nombre_Etudiants,
    AVG(f.note) AS Note_Moyenne,
    SUM(CASE WHEN f.reussi = 'Oui' THEN 1 ELSE 0 END) AS Nombre_Reussites,
    SUM(CASE WHEN f.reussi = 'Non' THEN 1 ELSE 0 END) AS Nombre_Echecs,
    CAST(SUM(CASE WHEN f.reussi = 'Oui' THEN 1.0 ELSE 0 END) / COUNT(f.SK_Examen) * 100 AS DECIMAL(5,2)) AS Taux_Reussite_Pct
    
FROM fact_examens f
INNER JOIN dim_date d ON f.SK_Date = d.SK_Date
GROUP BY d.annee, d.mois, d.nom_mois;
GO

PRINT 'Vue 10 créée : v_reussite_par_mois';
GO

/*
1. **v_analyse_performance** - Vue la plus complète (toutes dimensions + toutes mesures)
2. **v_statistiques_cours** - Stats par cours (pour page "Analyse Cours")
3. **v_performance_etudiants** - Stats par étudiant (pour page "Analyse Étudiants")
4. **v_top_etudiants** - Top 10 meilleurs étudiants
5. **v_evolution_temporelle** - Évolution dans le temps (trimestre/année)
6. **v_cours_difficiles** - 5 cours les plus difficiles  */

