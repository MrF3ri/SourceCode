extends Control

func _ready():
	$Panel.scale = Vector2(0.85, 0.85)
	var tween = create_tween()
	tween.tween_property($Panel, "scale", Vector2.ONE, 0.25)

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://newGame/scenes/arena.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
