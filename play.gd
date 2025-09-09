extends TextureButton

@export_file("*.tscn") var target_scene := "res://level_select.tscn"

func _pressed() -> void:
	get_tree().change_scene_to_file(target_scene)
