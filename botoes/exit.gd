extends TextureButton

func _ready() -> void:
    pressed.connect(_on_pressed)   # conecta o sinal via código

func _on_pressed() -> void:
    get_tree().quit()
