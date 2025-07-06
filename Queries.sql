-- Basic SQL Queries --
# Total Missions per Mission Type
SELECT mission_type, COUNT(*) AS total_missions
FROM missions
GROUP BY mission_type
ORDER BY total_missions DESC;

#Top 5 Most Expensive Missions
SELECT mission_name, cost_billion_usd
FROM missions
ORDER BY cost_billion_usd DESC
LIMIT 5;

#Top 3 Most Frequently Used Launch Vehicles
SELECT launch_vehicle, COUNT(*) AS usage_count
FROM launch_details
GROUP BY launch_vehicle
ORDER BY usage_count DESC
LIMIT 3;

#Classify Mission Outcome Using CASE
SELECT mission_name, success_rate,
  CASE
    WHEN success_rate >= 90 THEN 'Successful'
    WHEN success_rate >= 60 THEN 'Partial Failure'
    ELSE 'Failed'
  END AS mission_outcome
FROM missions;

#Total Launch Cost by Launch Site
SELECT launch_site, SUM(launch_cost) AS total_cost_million_usd
FROM launch_details
GROUP BY launch_site
ORDER BY total_cost_million_usd DESC;

#Return All Missions Sorted by Yield Efficiency
SELECT mission_name, yield_points, cost_billion_usd,
       ROUND(yield_points / cost_billion_usd, 2) AS yield_per_billion
FROM missions
ORDER BY yield_per_billion DESC;


-- joins/window functions --

# Missions with Yield Per Crew Member
SELECT m.mission_name, m.yield_points / c.crew_size AS yield_per_astronaut
FROM missions m
JOIN crew c ON m.mission_id = c.mission_id
ORDER BY yield_per_astronaut DESC
LIMIT 10;

# Rank Missions by Cost Using Window Function
SELECT mission_name, cost_billion_usd,
  RANK() OVER (ORDER BY cost_billion_usd DESC) AS cost_rank
FROM missions;

# Average Mission Success by Launch Site
SELECT ld.launch_site, AVG(m.success_rate) AS avg_success_rate
FROM launch_details ld
JOIN missions m ON ld.mission_id = m.mission_id
GROUP BY ld.launch_site
ORDER BY avg_success_rate DESC;

# Window Function – Percentile Crew Size
SELECT mission_id, crew_size,
  NTILE(4) OVER (ORDER BY crew_size DESC) AS crew_size_quartile
FROM crew;

# Missions with Highest Launch Mass per Vehicle
SELECT mission_id, launch_vehicle, launch_mass
FROM (
  SELECT *, RANK() OVER (PARTITION BY launch_vehicle ORDER BY launch_mass DESC) AS rnk
  FROM launch_details
) ranked
WHERE rnk = 1;

-- Subquery-Based Queries

# Above-Average Cost Missions
SELECT mission_name, cost_billion_usd
FROM missions
WHERE cost_billion_usd > (SELECT AVG(cost_billion_usd) FROM missions);

# Cost Above Avg of Same Mission Type (Correlated Subquery)
SELECT mission_name, mission_type, cost_billion_usd
FROM missions m1
WHERE cost_billion_usd > (
  SELECT AVG(cost_billion_usd)
  FROM missions m2
  WHERE m1.mission_type = m2.mission_type
);

# Crew Size Greater Than Average
SELECT mission_name
FROM missions
WHERE mission_id IN (
  SELECT mission_id
  FROM crew
  WHERE crew_size > (SELECT AVG(crew_size) FROM crew)
);

# Yield Greater Than Average
SELECT mission_name, yield_points
FROM missions
WHERE yield_points > (
  SELECT AVG(yield_points)
  FROM missions
);

# Missions with Launch Cost Greater Than Vehicle-Wise Average
SELECT mission_id, launch_vehicle, launch_cost
FROM launch_details l1
WHERE launch_cost > (
  SELECT AVG(launch_cost)
  FROM launch_details l2
  WHERE l2.launch_vehicle = l1.launch_vehicle
);


