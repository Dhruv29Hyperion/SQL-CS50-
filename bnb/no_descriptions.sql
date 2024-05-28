CREATE VIEW no_description AS
    SELECT "id", "property_type", "host_name", "accommodates", "bedrooms" FROM listings;

DROP VIEW no_description;