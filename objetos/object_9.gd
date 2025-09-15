extends TextureButton

@export var is_correct_object := false
@onready var card = $InfoCard
@onready var correct_sound = $"../AudioPlayerCorrect"
@onready var wrong_sound = $"../AudioPlayerWrong"

func _pressed():
    if is_correct_object:
        if card:
            card.visible = true
            card.modulate.a = 0.0
            card.create_tween().tween_property(card, "modulate:a", 1.0, 0.3)
        if correct_sound:
            correct_sound.play()
    else:
        if wrong_sound:
            wrong_sound.play()

func _on_mouse_entered():
    create_tween().tween_property(self, "self_modulate", Color(0.85, 0.85, 0.85), 0.15)

func _on_mouse_exited():
    create_tween().tween_property(self, "self_modulate", Color(1, 1, 1), 0.15)
