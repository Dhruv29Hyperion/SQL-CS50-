CREATE TABLE passengers (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "age" INTEGER,
    PRIMARY KEY("id")
);

CREATE TABLE airlines (
    "id" INTEGER,
    "name" TEXT,
    "concourse" TEXT CHECK(concourse IN ('A', 'B', 'C', 'D', 'E', 'F', 'T')),
    PRIMARY KEY("id")
);

CREATE TABLE checkins (
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "passenger_id" INTEGER,
    "flight_id" INTEGER,
    FOREIGN KEY("passenger_id") REFERENCES "passengers"("id"),
    FOREIGN KEY("flight_id") REFERENCES "airlines"("id")
);

CREATE TABLE flights (
    "flight_number" INTEGER,
    "airline_id" INTEGER,
    "from_airport_code" TEXT,
    "to_airport_code" TEXT,
    "departure_datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "arrival_datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY("airline_id") REFERENCES "airlines"("id")
);




