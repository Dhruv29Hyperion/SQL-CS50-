CREATE VIEW "by_district" AS
    SELECT "district",
        SUM(census."families") AS "families",
           SUM(census."households") as "households",
           SUM(census."population") as "population",
           SUM(census."male") AS "male",
           SUM(census."female") AS "female"
    FROM census GROUP BY census."district";

DROP VIEW IF EXISTS "by_district";