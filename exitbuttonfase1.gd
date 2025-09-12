
extends TextureButton

# >>> Troque para o caminho da sua tela inicial (com .tscn)
const MENU_SCENE_PATH := "res://scenes/inicio.tscn"
const MENU_SCENE := preload("res://level_select.tscn")

func _ready() -> void:
	# Conecta o sinal "pressed" via código (não precisa conectar no editor)
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	# Carregado com preload para trocar de cena mais rápido
	get_tree().change_scene_to_packed(MENU_SCENE)
	# Se preferir sem preload, use a linha abaixo e remova a de cima:
	# get_tree().change_scene_to_file(MENU_SCENE_PATH)
