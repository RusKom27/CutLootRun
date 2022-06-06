extends Node


func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("hide_game")
		
func start_game(new_game = false):
	if new_game:
		$CanvasLayer.changePauseState()
		$Map.change_lvl("Home", {}, true)
	else:
		$CanvasLayer.changePauseState()
		$SaveLoadNode.load_game()
	$AnimationPlayer.play("show_game")
	get_tree().paused = false

func exit_game():
	get_tree().paused = true
	$AnimationPlayer.play("hide_game")
