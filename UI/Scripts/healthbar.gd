extends ProgressBar


func _on_Player_player_stats_changed(var player):
	max_value = player.health_max
	value = player.health
