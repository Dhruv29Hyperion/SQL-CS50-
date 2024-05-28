CREATE VIEW "total" AS
    SELECT SUM(census."families") AS "families",
           SUM(census."households") as "households",
           SUM(census."population") as "population",
           SUM(census."male") AS "male",
           SUM(census."female") AS "female"
    FROM census;

DROP VIEW IF EXISTS "total";