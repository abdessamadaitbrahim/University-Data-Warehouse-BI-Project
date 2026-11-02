# University Data Warehouse & Business Intelligence Project

**Designing and Implementing an End-to-End Business Intelligence Solution for University Data Analytics.**

A complete Data Warehouse and Business Intelligence project focused on centralizing university data, automating ETL processes, ensuring data quality, performing multidimensional analysis, and building interactive dashboards for academic decision-making.

Academic project — **Big Data & Artificial Intelligence**, National School of Applied Sciences of Tetouan (ENSA).

**Student:** Abdessamad Ait Brahim  
**Module:** Business Intelligence  
**Supervisor:** El Ayat Nisrine  
**Academic Year:** 2025–2026

---

<div align="center">

[![Overview](https://img.shields.io/badge/Overview-2563EB?style=flat-square)](#project-overview)
[![Architecture](https://img.shields.io/badge/Architecture-2563EB?style=flat-square)](#solution-architecture)
[![Data Modeling](https://img.shields.io/badge/Data_Modeling-0891B2?style=flat-square)](#data-modeling)
[![ETL](https://img.shields.io/badge/ETL-0891B2?style=flat-square)](#etl-process-ssis)
[![OLAP](https://img.shields.io/badge/OLAP-7C3AED?style=flat-square)](#olap-analysis-ssas)
[![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)](#interactive-dashboards)
[![Results](https://img.shields.io/badge/Results-7C3AED?style=flat-square)](#dashboard-results)
[![Documentation](https://img.shields.io/badge/Documentation-F59E0B?style=flat-square)](#documentation)
[![Author](https://img.shields.io/badge/Author-DC2626?style=flat-square)](#author)

</div>

---

## 1. Project Overview

University information is often distributed across multiple data sources, making it difficult to maintain data consistency and extract meaningful insights.

This project implements a complete **Business Intelligence solution** that transforms raw academic data into structured, reliable and actionable information.

### Main objectives

- Centralize university data in a relational Data Warehouse.
- Clean and validate inconsistent or erroneous records.
- Design a Star Schema for efficient analytical queries.
- Automate data integration using SSIS.
- Build multidimensional OLAP cubes using SSAS.
- Develop interactive Power BI dashboards.
- Support academic performance monitoring and decision-making.

### Project scope

The solution covers the complete BI lifecycle:

**Raw CSV Data → ETL → Data Warehouse → OLAP Cube → Power BI Dashboards**

## 2. Solution Architecture

The project follows an end-to-end Data Warehouse architecture integrating data extraction, transformation, storage and analytics.

### Data processing workflow

1. **Data Sources:** CSV files containing student, course and examination information.
2. **ETL Processing:** SSIS extracts, transforms and loads the source data.
3. **Staging Database:** Intermediate storage in `DW_Universite_Staging`.
4. **Dirty Data Management:** Invalid records are automatically exported to Excel for correction and tracking.
5. **Final Data Warehouse:** Validated data is loaded into `DW_Universite`.
6. **OLAP Processing:** SSAS builds a MOLAP cube for multidimensional analysis.
7. **Business Intelligence:** Power BI provides interactive dashboards and academic insights.

### Architecture diagram

![Project Architecture](06_Documentation/SCREEN%20SHOT/Architecture%20de%20projet%20.png)

## 3. Data Modeling

The final Data Warehouse uses a **Star Schema** to organize academic information and simplify analytical queries.

### Fact table

| Table | Description |
|---|---|
| `Fact_Examens` | Stores examination results, grades and relationships with dimensions |

### Dimension tables

| Dimension | Description |
|---|---|
| `Dim_Etudiant` | Student profile, gender, age and age category |
| `Dim_Cours` | Course name and type (mandatory or optional) |
| `Dim_Date` | Year, semester, quarter and month |
| `Dim_Reussite` | Success status and grade category |

### Dimensional model

![Star Schema](06_Documentation/SCREEN%20SHOT/model%20dimens.png)

## 4. ETL Process (SSIS)

The ETL workflow is orchestrated by a master package called `ETL_Master.dtsx`.

### Data transformation and cleaning

The pipeline performs several data quality operations:

- Duplicate detection and removal.
- Null value handling.
- Date and email format standardization.
- Gender value correction (M/F).
- Student name cleaning.
- Grade validation (rejecting negative grades and grades above 20).

### Dirty Data Management

A dedicated anomaly management mechanism ensures that problematic records are not silently lost.

1. Identify invalid records.
2. Redirect anomalies into `Dirty_Etudiant.xlsx`.
3. Export the file to `07_Outputs`.
4. Analyze and correct erroneous records.
5. Reintegrate validated data into the system.

### Final Data Warehouse loading

- Dimension loading with surrogate key management.
- Fact table loading with correct relationships.
- Incremental updates for improved processing efficiency.

### ETL Master Package

![ETL Master](06_Documentation/SCREEN%20SHOT/ETL_master.png)

## 5. OLAP Analysis (SSAS)

An Analysis Services project was developed to create the **Cube Analyses Universitaires** using a MOLAP storage model.

### Measures

| Measure | Description |
|---|---|
| `Note` | Examination grade |
| `Fact Examens Count` | Total number of examinations |

### Dimensions and hierarchies

| Dimension | Hierarchy |
|---|---|
| Student | Gender → Age Category → Name |
| Success | Status → Grade Category |
| Course | Course Type → Course Name |
| Date | Year → Quarter → Month |
| Academic Date | Year → Semester → Quarter |

### Deployment

The cube is deployed and processed on the SSAS server with pre-calculated MOLAP aggregations to support fast multidimensional analysis.

![OLAP Cube](06_Documentation/SCREEN%20SHOT/cube.png)

## 6. Interactive Dashboards

Three interactive Power BI dashboards were developed to explore academic performance from different analytical perspectives.

### Dashboard 1 — University Overview

<text weight="medium" color="secondary" size="sm">Key performance indicators</text>

| KPI | Result |
|---|---:|
| Total Exams | 752 |
| Success Rate | 71.14% |
| Average Grade | 13.08 |
| Number of Students | 92 |

**Visualizations:**
- Success rate evolution by year and quarter.
- Examination distribution by quarter.
- Grade mentions by course.
- Student distribution by gender.
- Success rate by course type.

![Overview Dashboard](06_Documentation/SCREEN%20SHOT/DASH%201.png)

### Dashboard 2 — Student Performance Analysis

**Key indicators:**

| KPI | Result |
|---|---:|
| Male Success Rate | 74.01% |
| Female Success Rate | 69% |

**Visualizations:**
- Top 10 best-performing students.
- Success rate by age category.
- Student distribution by age.
- Performance analysis by gender and course type.

![Student Analysis Dashboard](06_Documentation/SCREEN%20SHOT/DASH%202.png)

### Dashboard 3 — Course Analysis

**Visualizations:**
- Average grade and success rate per course.
- Number of examinations by course.
- Monthly success rate evolution.
- Examination distribution by quarter and year.
- Year × Semester cross-analysis.

![Course Analysis Dashboard](06_Documentation/SCREEN%20SHOT/DASH%203.png)

### Interactive features

- Navigation between the three dashboards.
- Dynamic filters by year, quarter, semester and course.
- Cross-filtering between visualizations.
- Drill-down for detailed academic analysis.

## 7. Technology Stack

| Component | Technology |
|---|---|
| Database | Microsoft SQL Server |
| Database Management | SQL Server Management Studio (SSMS) |
| ETL | SQL Server Integration Services (SSIS) |
| OLAP | SQL Server Analysis Services (SSAS) |
| Visualization | Microsoft Power BI Desktop |
| Development Environment | Visual Studio + SSDT |
| Source Data | CSV Files |
| Data Quality | SSIS + Excel |

## 8. Project Structure

```text
University-Data-Warehouse-BI-Project/
│
├── 01_Data_Sources/
│   └── Raw CSV files
│
├── 02_SQL_Scripts/
│   └── Database creation, staging, dimensions,
│       facts and views
│
├── 03_SSIS_Packages/
│   └── ETL packages and master workflow
│
├── 04_SSAS_Cube/
│   └── OLAP cube and Analysis Services project
│
├── 05_PowerBI/
│   └── Power BI dashboards and PDF exports
│
├── 06_Documentation/
│   ├── SCREEN SHOT/
│   ├── Architecture diagrams
│   ├── Final report
│   └── Demo video
│
└── 07_Outputs/
    └── Dirty data Excel exports
```

## 9. Installation & Execution

### Prerequisites

- Microsoft SQL Server.
- SQL Server Integration Services (SSIS).
- SQL Server Analysis Services (SSAS).
- SQL Server Management Studio (SSMS).
- Visual Studio with SQL Server Data Tools (SSDT).
- Microsoft Power BI Desktop.

### Step 1 — Database initialization

Open SSMS and execute the SQL scripts located in `02_SQL_Scripts` in the required order (01 to 07).

This creates the staging database, final Data Warehouse, tables and related database objects.

### Step 2 — Execute the ETL pipeline

Open the SSIS solution:

```text
03_SSIS_Packages/ETL_DW_Universite.sln
```

Configure the connection managers:

- CSV source file paths.
- SQL Server database connections.

Execute the master package:

```text
ETL_Master.dtsx
```

### Step 3 — Deploy the OLAP cube

Open the SSAS solution:

```text
04_SSAS_Cube/Cube_Analyses_Universitaire.sln
```

Verify the data source, deploy the project and process the cube.

### Step 4 — Open Power BI dashboards

Open:

```text
05_PowerBI/Dashboard_Universite.pbix
```

Connect to the appropriate Data Warehouse and refresh the data.

## 10. Results & Achievements

The project successfully demonstrates the implementation of an end-to-end Business Intelligence solution.

### Key achievements

- Centralized university information in a structured Data Warehouse.
- Implemented a Star Schema for analytical processing.
- Automated ETL workflows using SSIS.
- Established a dirty data detection and correction mechanism.
- Built a MOLAP cube for multidimensional analysis.
- Developed three interactive Power BI dashboards.
- Created academic KPIs to support performance monitoring.

### Future perspectives

- Introduce additional dimensions such as departments and teachers.
- Integrate attendance and academic progression data.
- Automate scheduled data refreshes.
- Extend the platform with predictive analytics for academic failure risk and enrollment forecasting.

## 11. Author

**Abdessamad Ait Brahim**

Big Data & Artificial Intelligence Student  
National School of Applied Sciences of Tetouan (ENSA)

**Module:** Business Intelligence  
**Supervisor:** El Ayat Nisrine  
**Academic Year:** 2025–2026

GitHub: [@abdessamadaitbrahim](https://github.com/abdessamadaitbrahim)

---

<div align="center">

**UNIVERSITY DATA WAREHOUSE & BUSINESS INTELLIGENCE**

*From Raw Data to Academic Insights.*

SQL Server · SSIS · SSAS · Power BI

Developed at ENSA Tetouan — 2025–2026

</div>