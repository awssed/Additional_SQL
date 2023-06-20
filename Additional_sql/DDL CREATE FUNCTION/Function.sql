CREATE FUNCTION GET_trainee_group_members(IN i_group_id bigint DEFAULT null)
RETURNS TABLE (group_id bigint,
group_number integer,
trainee_id bigint,
full_name TEXT,
snapshot_date date )
AS $$
SELECT g.group_id,
		g.group_number,
		t.trainee_id,
		t.full_name,
		current_date AS snapshot_date
FROM training_data.dim_groups g
JOIN training_data.dim_trainess t 
ON g.group_id=t.group_id
WHERE g.group_id=i_group_id
OR i_group_id IS NULL AND g.disband_year IS NULL 
$$
LANGUAGE SQL;

SELECT *
FROM GET_trainee_group_members(1);