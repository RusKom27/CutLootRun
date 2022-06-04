extends Control

signal level_changed


func _on_Cell1_button_down():
	emit_signal("level_changed", 1)
	
func _on_Cell2_button_down():
	emit_signal("level_changed", 2)
	
func _on_Cell3_button_down():
	emit_signal("level_changed", 3)
	
func _on_Home_button_down():
	emit_signal("level_changed", "Home")



