extends TextureButton

@export var is_correct_object := false
@onready var card = $InfoCard
@onready var correct_sound = $"../AudioPlayerCorrect"
@onready var wrong_sound = $"../AudioPlayerWrong"

var clicked: bool = false

func _pressed():
    if clicked:
        return
    clicked = true
    disabled = true

    if is_correct_object:
        if card:
            card.visible = true
            card.modulate.a = 0.0
            card.create_tween().tween_property(card, "modulate:a", 1.0, 0.3)
        if correct_sound:
            correct_sound.play()

        # 🔑 Avisa o HUD que o jogador acertou
        var hud = get_tree().current_scene.get_node("HUD")
        if hud and hud.has_method("add_correct"):
            hud.add_correct()
    else:
        if wrong_sound:
            wrong_sound.play()
        # 🔑 Opcional: avisa HUD que errou (ex: diminuir tempo)
        var hud = get_tree().current_scene.get_node("HUD")
        if hud and hud.has_method("add_wrong"):
            hud.add_wrong(5.0)  # penaliza 5s
        

func _on_mouse_entered():
    create_tween().tween_property(self, "self_modulate", Color(0.85, 0.85, 0.85), 0.15)

func _on_mouse_exited():
    create_tween().tween_property(self, "self_modulate", Color(1, 1, 1), 0.15)
