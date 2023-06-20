CREATE SCHEMA training_data;

CREATE TABLE training_data.dim_groups(
	group_id	BIGSERIAL PRIMARY KEY,
	group_number	INTEGER NOT null,
	creation_year INTEGER DEFAULT EXTRACT(YEAR FROM current_date),
	disband_year INTEGER
);

INSERT INTO training_data.dim_groups(group_number)
VALUES (105);

 SELECT * FROM training_data.dim_groups;
 
CREATE TABLE training_data.dim_trainess(
	trainee_id BIGSERIAL PRIMARY KEY,
	group_id BIGINT NOT NULL REFERENCES training_data.dim_groups,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	full_name TEXT GENERATED ALWAYS AS (first_name || ' ' || last_name)
					STORED NOT NULL,
	birth_date DATE NOT NULL,
	enrollment_year INTEGER DEFAULT EXTRACT (YEAR FROM current_date) NOT NULL ,
	graduation_year INTEGER
);
INSERT INTO training_data.dim_trainess(group_id, first_name, last_name, birth_date,education)
VALUES(2,'Artem', 'Ferod', '1989-01-01'::date ,'completed')

CREATE TABLE training_data.active_trainess_snapshot AS
SELECT  g.group_id,
		g.group_number,
		t.trainee_id,
		t.full_name,
		current_date AS snapshor_date
FROM training_data.dim_groups g
JOIN training_data.dim_trainess t 
ON g.group_id=t.group_id
WHERE g.disband_year IS NULL;

CREATE VIEW training_data.active_trainess_snapshot AS 
SELECT g.group_id,
		g.group_number,
		t.trainee_id,
		t.full_name,
		current_date AS snapshot_date
FROM training_data.dim_groups g
JOIN training_data.dim_trainess t 
ON g.group_id=t.group_id
WHERE g.disband_year IS NULL;

ALTER TABLE training_data.dim_trainess ADD COLUMN education TEXT ;
ALTER TABLE training_data.dim_trainess ADD CHECK (education IN('completed','incomplete'));

