-- Create the crime investigation database
CREATE DATABASE crime_investigation;

-- Connect to the crime investigation database
\c crime_investigation;

-- Create the table for storing information about crimes
CREATE TABLE crimes (
    crime_id SERIAL PRIMARY KEY,
    case_number VARCHAR(20) NOT NULL,
    crime_type VARCHAR(50) NOT NULL,
    location VARCHAR(100) NOT NULL,
    date_occurred DATE NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'Pending'
);

-- Create the table for storing information about humans
CREATE TABLE humans (
    human_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    address VARCHAR(100)
);

-- Create the table for storing information about victims
CREATE TABLE victims (
    victim_id SERIAL PRIMARY KEY,
    human_id INT REFERENCES humans(human_id),
    crime_id INT REFERENCES crimes(crime_id),
    statement TEXT
);

-- Create the table for storing information about witnesses
CREATE TABLE witnesses (
    witness_id SERIAL PRIMARY KEY,
    human_id INT REFERENCES humans(human_id),
    crime_id INT REFERENCES crimes(crime_id),
    statement TEXT
);

-- Create the table for storing information about suspects
CREATE TABLE suspects (
    suspect_id SERIAL PRIMARY KEY,
    human_id INT REFERENCES humans(human_id),
    crime_id INT REFERENCES crimes(crime_id),
    description TEXT
);

-- Create the table for storing information about criminals
CREATE TABLE criminals (
    criminal_id SERIAL PRIMARY KEY,
    human_id INT REFERENCES humans(human_id),
    description TEXT
);

-- Create the table for tracking the involvement of criminals in previous crimes
CREATE TABLE criminal_previous_crimes (
    criminal_id INT REFERENCES criminals(criminal_id),
    crime_id INT REFERENCES crimes(crime_id),
    PRIMARY KEY (criminal_id, crime_id)
);


-- Create the table for storing information about investigators
CREATE TABLE investigators (
    investigator_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    badge_number VARCHAR(20) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'Disengaged'
);

-- Create the table for tracking the involvement of investigators in cases
CREATE TABLE case_investigators (
    crime_id INT REFERENCES crimes(crime_id),
    investigator_id INT REFERENCES investigators(investigator_id),
    PRIMARY KEY (crime_id, investigator_id)
);

-- Create the table for storing information about evidence
CREATE TABLE evidence (
    evidence_id SERIAL PRIMARY KEY,
    crime_id INT REFERENCES crimes(crime_id),
    description TEXT,
    collection_date DATE,
    collected_by VARCHAR(100),
    type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'Uncollected'
);

-- Create the table for storing information about forensic analysis
CREATE TABLE forensic_analysis (
    analysis_id SERIAL PRIMARY KEY,
    evidence_id INT REFERENCES evidence(evidence_id),
    analyst_name VARCHAR(100) NOT NULL,
    analysis_date DATE,
    result TEXT,
    conclusion TEXT
);

-- Create a view for crime information with names and order by date occurred
CREATE VIEW crime_info AS
SELECT
    c.crime_id,
    c.case_number,
    c.crime_type,
    c.location,
    c.date_occurred,
    c.description,
    c.status,
    h_victim.full_name AS victim_name,
    h_witness.full_name AS witness_name,
    h_suspect.full_name AS suspect_name
FROM crimes c
LEFT JOIN victims v ON c.crime_id = v.crime_id
LEFT JOIN humans h_victim ON v.human_id = h_victim.human_id
LEFT JOIN witnesses w ON c.crime_id = w.crime_id
LEFT JOIN humans h_witness ON w.human_id = h_witness.human_id
LEFT JOIN suspects s ON c.crime_id = s.crime_id
LEFT JOIN humans h_suspect ON s.human_id = h_suspect.human_id
ORDER BY c.date_occurred;

-- Create a view for evidence information with crime case number
CREATE VIEW evidence_info AS
SELECT
    e.evidence_id,
    e.crime_id,
    c.case_number,
    e.description,
    e.collection_date,
    e.collected_by,
    e.type,
    e.status,
    fa.analyst_name,
    fa.analysis_date,
    fa.result,
    fa.conclusion
FROM evidence e
LEFT JOIN forensic_analysis fa ON e.evidence_id = fa.evidence_id
LEFT JOIN crimes c ON e.crime_id = c.crime_id;

-- Create triggers to automatically update the status of evidence
CREATE OR REPLACE FUNCTION update_evidence_status()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE evidence
        SET status = 'Collected'
        WHERE evidence_id = NEW.evidence_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER evidence_insert
AFTER INSERT ON forensic_analysis
FOR EACH ROW
EXECUTE FUNCTION update_evidence_status();

-- Create a trigger to automatically update the status of a crime
CREATE OR REPLACE FUNCTION update_crime_status()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE crimes
        SET status = 'Solved'
        WHERE crime_id = NEW.crime_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER crime_insert
AFTER INSERT ON forensic_analysis
FOR EACH ROW
EXECUTE FUNCTION update_crime_status();

-- Create a trigger to update the status of an investigator when assigned to a new case
CREATE OR REPLACE FUNCTION update_investigator_status()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE investigators
    SET status = 'Active'
    WHERE investigator_id = NEW.investigator_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER investigator_assigned
AFTER INSERT ON case_investigators
FOR EACH ROW
EXECUTE FUNCTION update_investigator_status();



-- Index for frequently used columns in the crimes table
CREATE INDEX idx_crimes_location ON crimes(location);
CREATE INDEX idx_crimes_status ON crimes(status);

-- Index for foreign key columns in related tables
CREATE INDEX idx_victims_crime_id ON victims(crime_id);
CREATE INDEX idx_suspects_crime_id ON suspects(crime_id);
CREATE INDEX idx_case_investigators_crime_id ON case_investigators(crime_id);
CREATE INDEX idx_evidence_crime_id ON evidence(crime_id);
