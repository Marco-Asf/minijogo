extends TextureButton

@export_file("*.tscn") var target_scene := "res://fases/tela_selecao.tscn"

func _pressed() -> void:
    get_tree().change_scene_to_file(target_scene)
