-- Query 1: Retrieve all information about crimes that occurred in a specific location and are still pending.
SELECT *
FROM crimes
WHERE location = 'Specific Location' AND status = 'Pending';

-- Query 2: List all suspects along with the crimes they are associated with, including the crime type and case number.
SELECT s.suspect_id, h.full_name AS suspect_name, c.case_number, c.crime_type
FROM suspects s
JOIN humans h ON s.human_id = h.human_id
JOIN crimes c ON s.crime_id = c.crime_id;

-- Query 3: Find all victims of a particular crime type, ordered by the date the crime occurred.
SELECT v.victim_id, h.full_name AS victim_name, c.crime_type, c.date_occurred
FROM victims v
JOIN humans h ON v.human_id = h.human_id
JOIN crimes c ON v.crime_id = c.crime_id
WHERE c.crime_type = 'Particular Crime Type'
ORDER BY c.date_occurred;

-- Query 4: Get a list of crimes with no evidence collected yet, including the crime type and location.
SELECT c.case_number, c.crime_type, c.location
FROM crimes c
LEFT JOIN evidence e ON c.crime_id = e.crime_id
WHERE e.evidence_id IS NULL;

-- Query 5: Retrieve all evidence that has been collected for a specific case number, including the type of evidence and its current status.
SELECT e.evidence_id, e.type, e.status
FROM evidence e
JOIN crimes c ON e.crime_id = c.crime_id
WHERE c.case_number = 'Specific Case Number';

-- Query 6: List all witnesses who have provided statements for crimes in a specific location, including witness names and the corresponding crime case numbers.
SELECT w.witness_id, h.full_name AS witness_name, c.case_number
FROM witnesses w
JOIN humans h ON w.human_id = h.human_id
JOIN crimes c ON w.crime_id = c.crime_id
WHERE c.location = 'Specific Location';

-- Query 7: Aggregate the number of crimes solved by each investigator, sorted by the most successful investigator first.
SELECT i.full_name AS investigator_name, COUNT(c.crime_id) AS solved_crimes_count
FROM investigators i
JOIN case_investigators ci ON i.investigator_id = ci.investigator_id
JOIN crimes c ON ci.crime_id = c.crime_id
WHERE c.status = 'Solved'
GROUP BY i.full_name
ORDER BY solved_crimes_count DESC;

-- Query 8: Identify criminals with multiple offenses by listing their names and the number of crimes they are linked to, focusing on those linked to more than one crime.
SELECT h.full_name AS criminal_name, COUNT(cpc.crime_id) AS offenses_count
FROM criminals cr
JOIN criminal_previous_crimes cpc ON cr.criminal_id = cpc.criminal_id
JOIN humans h ON cr.human_id = h.human_id
GROUP BY h.full_name
HAVING COUNT(cpc.crime_id) > 1;
