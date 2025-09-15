extends TextureButton

func _pressed() -> void:
    get_tree().change_scene_to_file("res://fases/magno_roots.tscn")
