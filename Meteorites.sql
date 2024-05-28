DELETE FROM meteorites WHERE "nametype" = 'Relict';

SELECT * FROM meteorites WHERE "nametype" = 'Relict';

UPDATE meteorites
SET
  "mass" = ROUND("mass", 2),
  "lat" = ROUND("lat", 2),
  "long" = ROUND("long", 2);

CREATE TABLE temp_meteorites AS
SELECT *,
       ROW_NUMBER() OVER (ORDER BY year ASC, name ASC) AS new_id
FROM meteorites;

SELECT * FROM temp_meteorites;

DROP TABLE meteorites;

ALTER TABLE temp_meteorites RENAME TO meteorites;

ALTER TABLE meteorites DROP COLUMN id;

ALTER TABLE meteorites RENAME COLUMN new_id TO id;

SELECT * FROM meteorites;