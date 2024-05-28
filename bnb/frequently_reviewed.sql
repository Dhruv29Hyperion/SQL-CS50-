CREATE VIEW frequently_reviewed AS
    SELECT listings."id", listings."property_type", listings."host_name" FROM listings;

CREATE VIEW ROUGH AS
SELECT "listing_id", COUNT(reviews."listing_id") as "count" FROM reviews GROUP BY reviews."listing_id" ORDER BY COUNT(reviews."listing_id") DESC LIMIT 100;

DROP VIEW IF EXISTS ROUGH;

CREATE VIEW frequntly AS
SELECT frequently_reviewed."id", frequently_reviewed."property_type", frequently_reviewed."host_name", ROUGH."count" FROM frequently_reviewed JOIN ROUGH ON frequently_reviewed."id" = ROUGH."listing_id";

DROP VIEW IF EXISTS frequntly;