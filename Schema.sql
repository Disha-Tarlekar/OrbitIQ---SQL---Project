CREATE DATABASE Space_Mission_Analytics;
USE Space_Mission_Analytics;

CREATE TABLE targets (
    target_id INT AUTO_INCREMENT PRIMARY KEY,
    target_type VARCHAR(50),
    target_name VARCHAR(50),
    distance_ly FLOAT
);

CREATE TABLE missions (
    mission_id VARCHAR(10) PRIMARY KEY,
    mission_name VARCHAR(100),
    target_name varchar(100),
    launch_date DATE,
    mission_type VARCHAR(50),
    success_rate FLOAT,
    cost_billion_usd FLOAT,
    duration_years FLOAT,
    yield_points FLOAT,
    target_id INT,
    FOREIGN KEY (target_id) REFERENCES targets(target_id)
);

CREATE TABLE crew (
    mission_id VARCHAR(10),
    crew_size INT,
    FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);

CREATE TABLE launch_details (
    mission_id VARCHAR(10),
    launch_vehicle VARCHAR(50),
    launch_site varchar(20),
    launch_mass FLOAT,
    launch_cost int,
    launch_outcome varchar(20),
    FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);