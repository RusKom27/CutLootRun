extends Control

signal level_changed


func change_level(var lvl):
	emit_signal("level_changed", lvl)

func _on_Cell1_button_down():
	emit_signal("level_changed", 1)
	
func _on_Cell2_button_down():
	emit_signal("level_changed", 2)
	
func _on_Home_button_down():
	emit_signal("level_changed", "Home")

