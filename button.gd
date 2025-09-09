extends Button

func _on_pressed() -> void:
	var card = get_parent()
	var tween = card.create_tween()
	tween.tween_property(card, "modulate:a", 0.0, 0.3)
	tween.tween_callback(Callable(card, "hide"))
