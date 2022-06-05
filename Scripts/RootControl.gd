extends Node


func _ready():

	#$AnimationPlayer.play("hide_game")
	$AnimationPlayer.play("show_start_menu")
		
func start_game(new_game = false):
	#$AnimationPlayer.play("show_game")
	$AnimationPlayer.play("hide_start_menu")

	if new_game:
		$Map.change_lvl("Home")
	else:
		$SaveLoadNode.load_game()
	

func exit_game():

	#$AnimationPlayer.play("hide_game")
	$AnimationPlayer.play("show_start_menu")
