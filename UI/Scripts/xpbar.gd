extends ProgressBar


func _on_Player_player_stats_changed(var player):
	max_value = player.xp_next_level
	value = player.xp
