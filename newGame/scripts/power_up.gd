extends Area2D

@export var power_type = "heal"

func _ready():
	if power_type == "heal":
		$Icon.color = Color(0.2, 1, 0.35, 1)
	elif power_type == "speed":
		$Icon.color = Color(0.2, 0.7, 1, 1)
	else:
		$Icon.color = Color(1, 0.9, 0.2, 1)
	var tween = create_tween().set_loops()
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)

func _on_body_entered(body):
	if body.is_in_group("ArenaPlayer"):
		if power_type == "heal":
			body.heal_player(25)
		elif power_type == "speed":
			body.add_speed_time(6.0)
		else:
			body.add_shield()
		queue_free()
