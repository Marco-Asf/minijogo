extends Node2D

func _ready():
	var save = FileAccess.open("user://savegame.save", FileAccess.READ)
	var data = save.get_var()
	save.close()

	if data["level_unlocked"] >= 2:
		$Cadeado.hide()
		$Botao.disabled = false
	else:
		$Cadeado.show()
		$Botao.disabled = true
