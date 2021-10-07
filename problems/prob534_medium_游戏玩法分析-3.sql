SELECT player_id, event_date, games_played_so_far
FROM Activity
GROUP BY player_id, event_date
ORDER BY player_id, event_date | games_played
