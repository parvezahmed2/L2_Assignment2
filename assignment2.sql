
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(100),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(species_id),
    ranger_id INT REFERENCES rangers(ranger_id),
    location VARCHAR(100),
    sighting_time TIMESTAMP,
    notes TEXT
);

SELECT * from sightings;

 
INSERT INTO rangers (ranger_id, name, region) VALUES
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

 
INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

 
INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);



-- problem 1 

INSERT INTO rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

 

 -- problem 2 
SELECT COUNT(DISTINCT species_id) as unique_species_count
from sightings;



-- problem 3 
SELECT * from sightings
WHERE location LIKE '%Pass%';


-- problem 4 

SELECT r.name, COUNT(s.sighting_id) as total_sightings from rangers r
LEFT JOIN sightings s on r.ranger_id = s.ranger_id
GROUP BY r.name
ORDER BY r.name;


-- problem 5 

SELECT s.common_name from  species s
WHERE s.species_id NOT IN (
    SELECT species_id FROM sightings
);


-- problem 6 

WITH latest_sightings as (
    SELECT *
    from sightings
    ORDER BY sighting_time DESC
    LIMIT 2
)
SELECT sp.common_name, ls.sighting_time, r.name
from latest_sightings ls
JOIN species sp ON ls.species_id = sp.species_id
JOIN rangers r ON ls.ranger_id = r.ranger_id;



-- problem 7 
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';


-- problem 8 
SELECT 
    sighting_id,
    CASE 
        WHEN TO_CHAR(sighting_time, 'HH24')::INT < 12 then 'Morning'
        WHEN TO_CHAR(sighting_time, 'HH24')::INT BETWEEN 12 AND 17 then 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;



-- problem 9 
DELETE from rangers
WHERE ranger_id not in(
    SELECT DISTINCT ranger_id FROM sightings
);


