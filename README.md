# dbt + Snowflake Analytics Engineering Project

## 1. Project Overview

This repository contains a **production-grade analytics engineering project** built using **dbt on Snowflake**, with a clear separation of concerns and future-ready orchestration design.

The project demonstrates how raw data ingested into Snowflake is transformed into **clean, tested, and documented analytics models** suitable for BI and downstream consumption.

---

## 2. High-Level Data Flow

```
S3
  ↓
Snowflake (RAW)
  ↓
dbt STAGING (views)
  ↓
dbt INTERMEDIATE (tables)
  ↓
dbt MARTS (facts & dimensions)
  ↓
BI / Analytics Tools
```

---

## 3. Technology Stack

* **Data Warehouse**: Snowflake
* **Transformation Tool**: dbt Core
* **Raw Storage**: Amazon S3
* **Orchestration (planned)**: Apache Airflow (Dockerized)
* **Version Control**: Git + GitHub
* **Local Runtime**: Python virtual environment

---

## 4. Project Structure

```
netflix_dbt/
├── dbt_project.yml
├── macros/
│   └── generate_schema_name.sql
├── models/
│   ├── staging/
│   │   └── movielens/
│   ├── intermediate/
│   │   └── movielens/
│   └── marts/
│       └── movielens/
├── tests/
└── analysis/
```

---

## 5. Layered Modeling Approach

### RAW (Snowflake)

* Contains data ingested from S3
* No transformations applied by dbt
* Treated as immutable

---

### STAGING Layer

**Purpose**: Standardization and cleanup

* Materialization: `view`

* Responsibilities:

  * column renaming
  * type casting
  * basic filtering

* No joins or aggregations

* Uses `source()` references only

Example models:

* `stg_movies`
* `stg_ratings`

---

### INTERMEDIATE Layer

**Purpose**: Reusable business logic

* Materialization: `table`

* Responsibilities:

  * joins across staging models
  * aggregations
  * reusable transformations

* Uses only `ref()` references

Example models:

* `int_movie_ratings`
* `int_user_activity`

---

### MART Layer

**Purpose**: BI-ready data models

* Materialization: `table`

* Contains:

  * fact tables
  * dimension tables

* Optimized for analytics and reporting

Example models:

* `fct_movie_ratings`
* `dim_movies`
* `dim_users`

---

## 6. Schema Management Strategy

* Schema names are **explicitly controlled** per layer
* Default dbt schema concatenation is disabled using a custom macro

```
{% macro generate_schema_name(custom_schema_name, node) %}
  {{ custom_schema_name }}
{% endmacro %}
```

This guarantees deterministic schema names such as:

* `STAGING`
* `INTERMEDIATE`
* `MART`

---

## 7. dbt Configuration Highlights

* `dbt_project.yml` defines:

  * schema per layer
  * materialization per layer
  * tagging strategy

* `profiles.yml`:

  * stored in `~/.dbt`
  * never committed to Git

---

## 8. Data Quality & Testing

Data quality is enforced using dbt tests:

* `not_null`
* `unique`
* `relationships`

Tests are applied at:

* STAGING (key integrity)
* INTERMEDIATE (business guarantees)
* MARTS (referential integrity)

---

## 9. Documentation

* dbt documentation is auto-generated using:

```
dbt docs generate
dbt docs serve
```

* Provides:

  * lineage graph
  * column-level metadata
  * test visibility

---

## 10. Execution Workflow

Recommended execution order:

```
dbt clean
dbt run --select staging
dbt run --select intermediate
dbt run --select marts
dbt test
dbt docs generate
```

---

## 11. Orchestration (Planned)

* dbt runs will be orchestrated via **Airflow**
* Airflow will:

  * control execution order
  * manage retries
  * enable scheduling

---

## 12. Key Takeaways

* Deterministic schema control is critical in dbt
* Clear layer separation prevents long-term complexity
* Tests and docs are first-class citizens
* dbt behaves predictably only when initialized correctly

---

## 13. Status

* Core transformations: ✅ Complete
* Tests & documentation: ✅ Complete
* Airflow integration: ⏳ Planned

---

This repository reflects **real-world analytics engineering practices** and is suitable for **production usage and technical interviews**.
