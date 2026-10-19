-- 1. LEAGUE STRUCTURE
CREATE TABLE leagues (
    league_id INT AUTO_INCREMENT PRIMARY KEY,
    league_name VARCHAR(50) NOT NULL
);

CREATE TABLE conferences (
    conference_id INT AUTO_INCREMENT PRIMARY KEY,
    conference_name VARCHAR(50) NOT NULL,
    league_id INT NOT NULL,
    FOREIGN KEY (league_id) REFERENCES leagues(league_id)
);

CREATE TABLE divisions (
    division_id INT AUTO_INCREMENT PRIMARY KEY,
    division_name VARCHAR(50) NOT NULL,
    conference_id INT NOT NULL,
    FOREIGN KEY (conference_id) REFERENCES conferences(conference_id)
);

-- 2. TEAMS & ARENAS
CREATE TABLE arenas (
    arena_id INT AUTO_INCREMENT PRIMARY KEY,
    arena_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE teams (
    team_code VARCHAR(5) PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    arena_id INT,
    division_id INT NOT NULL,
    FOREIGN KEY (division_id) REFERENCES divisions(division_id)
);

CREATE TABLE coaches (
    coach_id INT AUTO_INCREMENT PRIMARY KEY,
    coach_name VARCHAR(100) NOT NULL,
    team_code VARCHAR(5) NOT NULL,
    FOREIGN KEY (team_code) REFERENCES teams(team_code)
);

-- 3. PLAYERS & ROSTERS
CREATE TABLE players (
    player_id VARCHAR(20) PRIMARY KEY,
    player_name VARCHAR(100) NOT NULL,
    position VARCHAR(10),
    age INT,
    team_code VARCHAR(5) NOT NULL,
    FOREIGN KEY (team_code) REFERENCES teams(team_code)
);

CREATE TABLE player_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(20) NOT NULL,
    college VARCHAR(100),
    draft_year INT,
    experience_years INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

CREATE TABLE team_rosters (
    roster_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(20) NOT NULL,
    team_code VARCHAR(5) NOT NULL,
    season INT NOT NULL,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_code) REFERENCES teams(team_code)
);

-- 4. SEASONS & GAMES
CREATE TABLE seasons (
    season INT PRIMARY KEY,
    season_type VARCHAR(20) DEFAULT 'Regular Season'
);

CREATE TABLE games (
    game_id VARCHAR(20) PRIMARY KEY,
    season INT NOT NULL,
    game_date TIMESTAMP NOT NULL,
    is_playoff BOOLEAN DEFAULT FALSE,
    start_time_et VARCHAR(10),
    arena_name VARCHAR(100),
    visitor_team_code VARCHAR(5) NOT NULL,
    visitor_pts INT NOT NULL,
    home_team_code VARCHAR(5) NOT NULL,
    home_pts INT NOT NULL,
    game_duration VARCHAR(10),
    FOREIGN KEY (season) REFERENCES seasons(season),
    FOREIGN KEY (visitor_team_code) REFERENCES teams(team_code),
    FOREIGN KEY (home_team_code) REFERENCES teams(team_code)
);

CREATE TABLE game_officials (
    official_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    official_name VARCHAR(100) NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(game_id)
);

-- 5. PLAYER TOTALS & BOX SCORES
CREATE TABLE player_totals_stats (
    stat_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(20) NOT NULL,
    team_code VARCHAR(5) NOT NULL,
    season INT NOT NULL,
    is_playoff BOOLEAN DEFAULT FALSE,
    games INT,
    games_started INT,
    minutes_pg INT,
    field_goals INT,
    field_attempts INT,
    field_percent DECIMAL(5,3),
    three_fg INT,
    three_attempts INT,
    three_percent DECIMAL(5,3),
    two_fg INT,
    two_attempts INT,
    two_percent DECIMAL(5,3),
    effect_fg_percent DECIMAL(5,3),
    ft INT,
    ft_attempts INT,
    ft_percent DECIMAL(5,3),
    offensive_rb INT,
    defensive_rb INT,
    total_rb INT,
    assists INT,
    steals INT,
    blocks INT,
    turnovers INT,
    personal_fouls INT,
    points INT,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_code) REFERENCES teams(team_code),
    FOREIGN KEY (season) REFERENCES seasons(season)
);

CREATE TABLE player_advanced_stats (
    adv_id INT AUTO_INCREMENT PRIMARY KEY,
    player_id VARCHAR(20) NOT NULL,
    team_code VARCHAR(5) NOT NULL,
    season INT NOT NULL,
    is_playoff BOOLEAN DEFAULT FALSE,
    games INT,
    minutes_played INT,
    per DECIMAL(4,1),
    ts_percent DECIMAL(5,3),
    three_par DECIMAL(5,3),
    ftr DECIMAL(5,3),
    offensive_rb_percent DECIMAL(4,1),
    defensive_rb_percent DECIMAL(4,1),
    total_rb_percent DECIMAL(4,1),
    assist_percent DECIMAL(4,1),
    steal_percent DECIMAL(4,1),
    block_percent DECIMAL(4,1),
    turnover_percent DECIMAL(4,1),
    usage_percent DECIMAL(4,1),
    offensive_ws DECIMAL(4,1),
    defensive_ws DECIMAL(4,1),
    win_shares DECIMAL(4,1),
    win_shares_per DECIMAL(5,3),
    offensive_box DECIMAL(4,1),
    defensive_box DECIMAL(4,1),
    box DECIMAL(4,1),
    vorp DECIMAL(4,1),
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (team_code) REFERENCES teams(team_code),
    FOREIGN KEY (season) REFERENCES seasons(season)
);

-- 6. SHOT CHART DATA
CREATE TABLE player_shot_chart (
    shot_id INT PRIMARY KEY,
    player_id VARCHAR(20) NOT NULL,
    season INT NOT NULL,
    shot_date VARCHAR(20),
    qtr VARCHAR(10),
    time_remaining VARCHAR(10),
    loc_top INT,
    loc_left INT,
    result BOOLEAN NOT NULL,
    shot_type VARCHAR(20),
    distance_ft INT,
    is_lead BOOLEAN,
    team_score INT,
    opponent_team_score INT,
    team_code VARCHAR(5) NOT NULL,
    opponent_code VARCHAR(5) NOT NULL,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (season) REFERENCES seasons(season),
    FOREIGN KEY (team_code) REFERENCES teams(team_code),
    FOREIGN KEY (opponent_code) REFERENCES teams(team_code)
);

-- 7. ADDITIONAL TEAM & GAME METRICS
CREATE TABLE game_team_summaries (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_code VARCHAR(5) NOT NULL,
    points INT NOT NULL,
    is_winner BOOLEAN,
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (team_code) REFERENCES teams(team_code)
);

CREATE TABLE game_quarter_scores (
    quarter_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_code VARCHAR(5) NOT NULL,
    q1_pts INT,
    q2_pts INT,
    q3_pts INT,
    q4_pts INT,
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (team_code) REFERENCES teams(team_code)
);

CREATE TABLE play_by_play_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    player_id VARCHAR(20) NOT NULL,
    qtr VARCHAR(10),
    time_remaining VARCHAR(10),
    description TEXT,
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

CREATE TABLE team_season_summaries (
    season_summary_id INT AUTO_INCREMENT PRIMARY KEY,
    team_code VARCHAR(5) NOT NULL,
    season INT NOT NULL,
    wins INT,
    losses INT,
    FOREIGN KEY (team_code) REFERENCES teams(team_code),
    FOREIGN KEY (season) REFERENCES seasons(season)
);

CREATE TABLE player_comparisons_cache (
    cache_id INT AUTO_INCREMENT PRIMARY KEY,
    player1_id VARCHAR(20) NOT NULL,
    player2_id VARCHAR(20) NOT NULL,
    metric_summary TEXT,
    FOREIGN KEY (player1_id) REFERENCES players(player_id),
    FOREIGN KEY (player2_id) REFERENCES players(player_id)
);

CREATE TABLE kpi_thresholds (
    kpi_id INT AUTO_INCREMENT PRIMARY KEY,
    metric_name VARCHAR(50) NOT NULL,
    threshold_val DECIMAL(8,2) NOT NULL
);
