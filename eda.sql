-- how much data am I working with?
SELECT COUNT(DISTINCT hospital_id)
FROM prices;

SELECT COUNT(DISTINCT concept_id) AS price_concepts,
	(SELECT COUNT( DISTINCT concept_id) 
    FROM concept) AS concepts
FROM prices;

-- why are their more prices for concepts then their are defined concepts? let me look into one
-- first, what are the concepts? let me confirm these on https://athena.ohdsi.org/search-terms/start
SELECT *
FROM concept
LIMIT 10;
-- manually checking a handful of concept_ids shows they match info provided by Athena.

-- now let's look into the concept_ids missing from prices
SELECT DISTINCT *
FROM prices
WHERE concept_id NOT IN
	(SELECT DISTINCT concept_id
    FROM concept)
LIMIT 10;

/* The first thing I noticed is my ten concept_ids above are all vocabulary_id = 'HCPCS.'
The price.concept_ids missing from concept, that I looked up on Athena are a variety of other vocab.alter
I'll check if that holds true.
*/
SELECT DISTINCT vocabulary_id
FROM concept;

-- Yep, only HCPCS. Not sure why. Let me see if I can pull them.
-- With some trial and error, I pulled them (INFILE code in import_prices.sql). I'll explore if I did it correctly now.
SELECT COUNT(DISTINCT concept_id) AS count
FROM prices
WHERE concept_id NOT IN
	(SELECT DISTINCT concept_id
    FROM codes);
    
SELECT DISTINCT concept_id
FROM prices
WHERE concept_id NOT IN
	(SELECT DISTINCT concept_id
    FROM codes);  
    
SELECT DISTINCT concept_id
FROM cpts
WHERE vocabulary_id = 'CPT4'
LIMIT 10;
-- ok, got 3808 more but not all. I'm going to stop this adventure for now and refocus to narrow down what I already have for this project

-- checking for concerning nulls
SELECT *
FROM prices
WHERE price IS NULL
    OR amount IS NULL;

SELECT *
FROM hospitals
WHERE hospital_id IS NULL
    OR city IS NULL
	OR hospital_npi IS NULL
    OR disclosure IS NULL; -- now i'm sus that nothing is null. checking that next.

SELECT *
FROM prices
WHERE price = '' OR price = ' '
	OR amount = '' OR amount = ' ';
-- prices still look good. may be the og data, or they way i imported it. either way, I'll just look at fixing hospitals and concept now

SELECT *
FROM hospitals
WHERE hospital_id = '' OR hospital_id = ' '
	OR city = '' OR city = ' '
    OR hospital_npi = '' OR hospital_npi = ' '
    OR disclosure = '' OR disclosure = ' ' ; -- aha! sneaky sneaky
    
-- fix the table
UPDATE hospitals
SET disclosure = NULL
WHERE disclosure = '' or disclosure = ' ';

-- check
SELECT *
FROM hospitals
WHERE disclosure IS NULL;

SELECT *
FROM concept
WHERE concept_name IS NULL
	OR concept_name = ''
    OR concept_name = ' ';
    
-- I want to know what hospitals and locations I'm working with
SELECT COUNT(DISTINCT hospital_name) AS hospital, COUNT(DISTINCT affiliation) AS affil, COUNT(DISTINCT city) AS city
FROM hospitals;

-- geographical concentrations?
SELECT city, COUNT(city) AS city_ct
FROM hospitals
GROUP BY city
ORDER BY city_ct DESC;

-- affilations?
SELECT affiliation, COUNT(affiliation) AS ct
FROM hospitals
GROUP BY affiliation
ORDER BY ct DESC;
-- interesting that Duke LifePoint and Duke Health are seperate. I will leave them as such on work on the assumption that the collector of this data knows better than me.
-- do i want to focus on comparing top affilations or locations? let's take a look at these indeps.

SELECT *
FROM hospitals
WHERE affiliation = 'Independent';

-- hmm, there's also cricital_access_ind
SELECT critical_access_ind, COUNT(critical_access_ind) AS ct
FROM hospitals
GROUP BY critical_access_ind; -- 1 being yes

SELECT *
FROM hospitals
WHERE critical_access_ind = 1;
-- in the future i would be interested in comparing costs with cricital access vs not because it could be important insight for rural healthcare access, but i don't think i'll focus on it at the moment.

-- i want to look at the types of charges we have now
SELECT *
FROM codes
WHERE concept_name LIKE "%tumor%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%cardiovascular%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);

SELECT *
FROM codes
WHERE concept_name LIKE "%diabetes%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%outpatient%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%inpatient%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%acute%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%test%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%surgery%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
    
SELECT *
FROM codes
WHERE concept_name LIKE "%imaging%"
	AND
    concept_id IN
    (SELECT concept_id
    FROM prices);
-- idk what to focus on yet, so let's explore charges
-- what about ordering by expense?

SELECT p.hospital_id, p.concept_id, p.price, p.amount, c.concept_name
FROM prices AS p
LEFT JOIN codes AS c
ON p.concept_id = c.concept_id
ORDER BY p.amount DESC; -- holy smokes are these costs serious?!

-- how about most reported?
SELECT
	p.concept_id,
    COUNT(p.concept_id) AS ct,
    c.concept_name,
    min(amount) AS min,
    max(amount) AS max,
    ROUND(avg(amount),2) AS avg
FROM prices AS p
LEFT JOIN codes AS c
ON p.concept_id = c.concept_id
WHERE p.price = 'cash'
GROUP BY p.concept_id
ORDER BY ct DESC;

SELECT *
FROM prices
WHERE concept_id = '2615740'
AND hospital_id = 1
AND price = 'cash';
/* I looked into why a single code could have so many amounts listed.
Looks like this code description is not as specific as, at least for this hosital's, "procedure desc."
For instance, a screw may be different sizes, types, or for different procedures.

TL;DR I can't simply compare codes. At least in some cases. */

-- how about most reported within systems?
SELECT
    p.concept_id,
    affiliation,
    COUNT(p.concept_id) AS concept_ct,
    SUM(COUNT(p.concept_id)) OVER ( PARTITION BY p.concept_id) AS ttl,
    c.concept_name
FROM prices AS p
LEFT JOIN hospitals AS h
ON p.hospital_id = h.hospital_id
LEFT JOIN concept AS c
ON p.concept_id = c.concept_id
GROUP BY p.concept_id, affiliation, c.concept_name
ORDER BY ttl DESC;

-- how about most reported within hosptials? And deciding to narrow my project to Charlotte
SELECT
    p.concept_id,
    hospital_name,
    COUNT(p.concept_id) AS concept_ct,
    SUM(COUNT(p.concept_id)) OVER ( PARTITION BY p.concept_id) AS ttl,
    c.concept_name
FROM prices AS p
LEFT JOIN hospitals AS h
ON p.hospital_id = h.hospital_id
LEFT JOIN concept AS c
ON p.concept_id = c.concept_id
WHERE h.city = 'Charlotte'
	AND concept_name IS NOT NULL
GROUP BY p.concept_id, hospital_name, c.concept_name
ORDER BY ttl DESC;

SELECT *
    FROM hospitals
    WHERE city = 'Charlotte';

SELECT *
FROM prices
WHERE hospital_id IN
	(SELECT hospital_id
    FROM hospitals
    WHERE city = 'Charlotte');
    
-- do single concept_ids have multiple costs listed per category?
SELECT
    hospital_id,
    concept_id,
    price,
    COUNT(*) AS price_count
FROM prices
WHERE hospital_id IN
	(SELECT hospital_id
    FROM hospitals
    WHERE city = 'Charlotte')
GROUP BY hospital_id, concept_id, price
ORDER BY price_count DESC;

SELECT *
FROM codes
WHERE concept_id = 2615740;

-- how many prices have concept descriptions?
SELECT COUNT(*)
FROM prices
WHERE concept_id IN
	(SELECT DISTINCT concept_id
    FROM concept);
    
-- let's explore just these in power bi.
CREATE TABLE priced_concepts AS
SELECT *
FROM prices
WHERE concept_id IN
    (SELECT DISTINCT concept_id
     FROM concept);
    
CREATE TABLE priced_concepts_clt AS
SELECT *
FROM prices
WHERE concept_id IN
    (SELECT DISTINCT concept_id
     FROM concept)
AND hospital_id IN
	(SELECT hospital_id
    FROM hospitals
    WHERE city = 'Charlotte');