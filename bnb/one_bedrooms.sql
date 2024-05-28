CREATE VIEW one_bedrooms AS
    SELECT "id", listings."property_type", listings."host_name", listings."accommodates" FROM listings WHERE "bedrooms" = 1;