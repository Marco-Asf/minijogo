extends TextureButton

@export var is_correct_object := false

@onready var card = $"../InfoCard"
@onready var correct_sound = $"../AudioPlayerCorrect"
@onready var wrong_sound = $"../AudioPlayerWrong"


func _pressed():
	if is_correct_object:
		card.visible = true
		correct_sound.play()
	else:
		wrong_sound.play()

func _on_mouse_entered():
	self.self_modulate = Color(0.7, 0.7, 0.7)
	create_tween().tween_property(self, "modulate", Color(0.7, 0.7, 0.7), 0.2)
func _on_mouse_exited():
	self.self_modulate = Color(1, 1, 1)
	create_tween().tween_property(self, "modulate", Color(1, 1, 1), 0.2)
