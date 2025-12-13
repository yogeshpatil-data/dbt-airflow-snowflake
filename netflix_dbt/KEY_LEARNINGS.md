# God-Tier Learnings — dbt + Snowflake + Airflow Project

## 0. How to Read This Document

This is a **single source of truth** capturing everything that mattered while building a **production-grade dbt project**. It intentionally includes:

* mistakes made
* root causes (not symptoms)
* exact fixes
* dbt internals and behaviors that are poorly documented
* engineering rules that must never be violated again

This is **not a tutorial**. It is a **post‑mortem + engineering playbook**.

If you fully understand this file, you understand dbt **better than many senior data engineers**.

---

## 1. Project Objective (Non‑Negotiable)

Build a **real, professional analytics engineering system** with:

* Snowflake as the data warehouse
* dbt as the transformation layer
* S3 as the raw ingestion source
* Clear RAW → STAGING → INTERMEDIATE → MART layering
* Deterministic schema behavior
* Strong data quality guarantees
* Auto‑generated documentation
* Future‑ready for Airflow orchestration

The goal was **correctness and predictability**, not speed.

---

## 2. Final Architecture (Locked)

Data flow:

S3
→ Snowflake RAW
→ dbt STAGING (views)
→ dbt INTERMEDIATE (tables)
→ dbt MARTS (facts + dimensions)
→ BI / Analytics

Key architectural rules:

* dbt **never** touches RAW
* STAGING = cleanup + renaming only
* INTERMEDIATE = reusable business logic
* MARTS = BI‑ready fact and dimension models

---

## 3. Final Folder Structure (Strict)

```
netflix_dbt/
├── dbt_project.yml
├── macros/
│   └── generate_schema_name.sql
├── models/
│   ├── staging/
│   │   └── movielens/
│   │       ├── sources.yml
│   │       ├── stg_movies.sql
│   │       ├── stg_ratings.sql
│   │       ├── stg_tags.sql
│   │       ├── stg_genome_scores.sql
│   │       └── stg_genome_tags.sql
│   ├── intermediate/
│   │   └── movielens/
│   │       ├── int_movie_ratings.sql
│   │       ├── int_user_activity.sql
│   │       └── int_movie_genome_enriched.sql
│   └── marts/
│       └── movielens/
│           ├── dim_movies.sql
│           ├── dim_users.sql
│           └── fct_movie_ratings.sql
└── tests/
```

This structure is **intentional**. Deviating from it re‑introduces ambiguity.

---

## 4. The Single Biggest Mistake (Root Cause)

### ❌ Not using `dbt init`

This was the **primary failure point**.

### What went wrong

* dbt was run inside a folder that was **not initialized** via `dbt init`
* dbt silently entered **fallback mode**
* project metadata was partially inferred
* `dbt_project.yml` configs were inconsistently applied
* schema resolution became unpredictable

### Why this is dangerous

When dbt is not initialized:

* dbt does **not fail loudly**
* it assumes defaults
* behavior appears random
* debugging becomes nearly impossible

### Correct rule

**Every dbt project must be created using `dbt init`.**

No exceptions. Ever.

---

## 5. Schema Concatenation — The Most Misunderstood dbt Concept

### Default dbt behavior (documented but often missed)

```
final_schema = target.schema + '_' + custom_schema
```

This means:

* If profile schema = DEV
* If model schema = STAGING

Final schema becomes:

```
DEV_STAGING
```

This is **expected dbt behavior**, not a bug.

---

## 6. The ONLY Correct Way to Control Schema Names

### ❌ What does NOT work reliably

* empty schema values
* environment variables
* role defaults
* database‑level hacks

### ✅ The only documented and guaranteed solution

Override the macro:

```
macros/generate_schema_name.sql
```

```
{% macro generate_schema_name(custom_schema_name, node) %}
  {{ custom_schema_name }}
{% endmacro %}
```

This tells dbt:

* Ignore `target.schema`
* Use **only** the schema defined in model configs

This single macro **eliminates all schema concatenation issues permanently**.

---

## 7. Profiles Location — Another Silent Failure Mode

### dbt profile resolution order

1. `DBT_PROFILES_DIR` (if set)
2. `~/.dbt/profiles.yml` (default)

### What went wrong

* `DBT_PROFILES_DIR` was pointing to a deleted folder
* dbt silently failed to find profiles
* connection tests were skipped
* fallback behavior was triggered

### Final rule

* Use **only** `~/.dbt/profiles.yml`
* Never commit profiles to Git
* Never move profiles per project
* Never forget that env vars override everything

---

## 8. Virtual Environment + Git Pitfall (Critical)

### What went wrong

* `.venv/` was accidentally committed
* project folders were renamed
* Python interpreter paths broke
* dbt binaries became invalid

### Why this matters

Virtual environments are **path‑bound**.
Renaming folders **breaks executables**.

### Final rules

* `.venv/` must ALWAYS be in `.gitignore`
* One venv per repo
* Never rename repo folders after creating venv

---

## 9. Layer Responsibilities (Must Be Enforced)

### STAGING

Allowed:

* renaming columns
* type casting
* null handling

Not allowed:

* joins
* aggregations
* business logic

### INTERMEDIATE

Allowed:

* joins
* aggregations
* reusable transformations

Not allowed:

* BI‑specific logic

### MARTS

Allowed:

* fact tables
* dimension tables
* BI‑ready metrics

This separation is **non‑negotiable**.

---

## 10. dbt Ref and Source Rules (Never Break These)

* `source()` → ONLY in staging
* `ref()` → EVERYWHERE else
* No fully qualified table names
* No hardcoded schemas

Breaking this destroys:

* lineage
* docs
* test guarantees

---

## 11. Tests Are Not Optional

### Tests implemented

* `not_null`
* `unique`
* `relationships`

### Key learning

Tests caught **real data issues**, not theoretical ones.

### Advanced insight

dbt 1.10 introduced stricter test syntax.
Generic test arguments must be nested under `arguments`.

Ignoring deprecation warnings today = broken pipelines tomorrow.

---

## 12. dbt Docs — Why They Matter

### What dbt docs actually provide

* lineage graph
* column‑level documentation
* test visibility
* source‑to‑mart traceability

### Key rule

Docs are generated from code.
If docs are wrong, code is wrong.

---

## 13. WSL + dbt Docs Behavior

### Observed behavior

* `dbt docs serve` works
* browser auto‑open fails (`gio` error)

### Root cause

WSL has no GUI browser support.

### Correct usage

Open `http://localhost:8080` manually in Windows browser.

---

## 14. Execution Discipline

Correct run order:

```
dbt clean
dbt run --select staging
dbt run --select intermediate
dbt run --select marts
dbt test
dbt docs generate
```

Never run full refresh blindly.

---

## 15. Interview‑Level Takeaways

If asked about dbt in interviews, this project proves:

* you understand dbt internals
* you can debug non‑obvious issues
* you know why dbt behaves the way it does
* you can build deterministic, production systems

---

## 16. Final Engineering Rules (Memorize These)

1. Always use `dbt init`
2. Always control schema via macro
3. Never commit `.venv` or `profiles.yml`
4. Never hardcode schemas
5. Never skip tests
6. Never ignore dbt warnings
7. Never mix layer responsibilities

Breaking any of these rules re‑introduces chaos.

---

## 17. Closing Note

This project was difficult **because it was real**.

The pain came from:

* silent fallbacks
* implicit defaults
* hidden precedence rules

Understanding and fixing these puts you **ahead of the curve**.

This document exists so you never have to relearn these lessons the hard way.
