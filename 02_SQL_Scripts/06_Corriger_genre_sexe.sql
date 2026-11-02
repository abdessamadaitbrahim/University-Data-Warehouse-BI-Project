select * from STG_Etudiants
TRUNCATE TABLE STG_Etudiants
TRUNCATE TABLE STG_Etudiants_Dirty
select * from STG_Etudiants_Dirty
UPDATE STG_Etudiants
SET sexe = 'M'
WHERE nom IN (
    'ALI','ANAS','AYOUB','HAMZA','HASSAN','ILYAS','KARIM','KHALID',
    'NABIL','OMAR','RACHID','REDA','SALIM','SAMI','SAMIR','SOUFIANE',
    'YASSINE','YOUNES','YOUSSEF'
);

UPDATE STG_Etudiants
SET sexe = 'F'
WHERE nom IN (
    'FATIMA','ILHAM','IMANE','KENZA','LINA','MANAL','MARWA','MERIEM',
    'MERYEM','MOUNA','NADIA','RANIA','SALIMA','SARA','SIHAM','ZINEB'
);

USE DW_Universite_Staging;

-- Chercher les doublons dans STG_Etudiants
SELECT 
    id_etu, 
    COUNT(*) as nb
FROM STG_Etudiants
GROUP BY id_etu
HAVING COUNT(*) > 1;


