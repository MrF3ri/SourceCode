extends Control

func _ready():
	$PausePanel.hide()
	$GameOverPanel.hide()
	$MessageLabel.modulate.a = 0

func update_score(score, kills, victory_kills):
	$TopBar/ScoreLabel.text = "امتیاز: " + str(score)
	$TopBar/KillLabel.text = "نابودی: " + str(kills) + " / " + str(victory_kills)

func _on_health_changed(value, max_value):
	# update hp
	$TopBar/HealthLabel.text = "سلامتی: " + str(max(value, 0))
	$TopBar/HealthBar.max_value = max_value
	$TopBar/HealthBar.value = value

func _on_shield_changed(active):
	$TopBar/ShieldLabel.text = "سپر: فعال" if active else "سپر: خاموش"

func show_message(text):
	$MessageLabel.text = text
	var tween = create_tween()
	tween.tween_property($MessageLabel, "modulate:a", 1.0, 0.25)
	tween.tween_interval(2.0)
	tween.tween_property($MessageLabel, "modulate:a", 0.0, 0.4)

func show_pause():
	get_tree().paused = true
	$PausePanel.show()
	animate_panel($PausePanel)

func show_game_over(score, kills):
	get_tree().paused = true
	$GameOverPanel/TitleLabel.text = "شکست خوردی"
	$GameOverPanel/InfoLabel.text = "امتیاز: " + str(score) + "\nتعداد دشمنان نابود شده: " + str(kills)
	$GameOverPanel.show()
	animate_panel($GameOverPanel)

func show_victory(score, kills):
	get_tree().paused = true
	$GameOverPanel/TitleLabel.text = "پیروزی"
	$GameOverPanel/InfoLabel.text = "امتیاز: " + str(score) + "\nتعداد دشمنان نابود شده: " + str(kills)
	$GameOverPanel.show()
	animate_panel($GameOverPanel)

func animate_panel(panel):
	panel.scale = Vector2(0.85, 0.85)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(panel, "scale", Vector2.ONE, 0.18)

func _on_resume_button_pressed():
	$PausePanel.hide()
	get_tree().paused = false

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://newGame/scenes/main_menu.tscn")
