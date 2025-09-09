extends Control
# (se o nó raiz da cena for Node2D, troque para 'extends Node2D')

const SAVE_PATH := "user://savegame.save"

# LIGUE ESTES CAMINHOS NO INSPECTOR (sem depender de $nomes fixos)
@export var botao_path: NodePath          # ex.: o botão "play"
@export var cadeado_path: NodePath        # ex.: um TextureRect/ícone de cadeado

@onready var botao: BaseButton = get_node_or_null(botao_path)
@onready var cadeado: CanvasItem = get_node_or_null(cadeado_path)

func _ready() -> void:
	var data: Dictionary = _load_or_init_save()
	var unlocked: int = int(data.get("level_unlocked", 1))

	# avisos úteis se esquecer de ligar no Inspector
	if botao == null:
		push_warning("botao_path não configurado (ligue o botão Play no Inspector).")
	if cadeado == null:
		push_warning("cadeado_path não configurado (ligue o nó do cadeado no Inspector).")

	# aplica estado somente se os nós existirem
	if botao:
		botao.disabled = unlocked < 3
	if cadeado:
		cadeado.visible = unlocked < 3   # true = aparece enquanto bloqueado

# ==== UTILIDADES DE SAVE ====

func _load_or_init_save() -> Dictionary:
	var path: String = SAVE_PATH

	if FileAccess.file_exists(path):
		var save := FileAccess.open(path, FileAccess.READ)
		if save:
			var data: Dictionary = (save.get_var() as Dictionary)
			save.close()
			if typeof(data) == TYPE_DICTIONARY:
				return data
		push_warning("Save inválido/corrompido. Recriando…")

	var default_data: Dictionary = {"level_unlocked": 1}
	var write := FileAccess.open(path, FileAccess.WRITE)
	if write:
		write.store_var(default_data)
		write.close()
	else:
		push_warning("Não consegui criar o save: %s" % FileAccess.get_open_error())
	return default_data

func _save_data(data: Dictionary) -> void:
	var write := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if write:
		write.store_var(data)
		write.close()
	else:
		push_warning("Falha ao salvar: %s" % FileAccess.get_open_error())

# Chame quando avançar fases (opcional)
func set_level_unlocked(level: int) -> void:
	var data: Dictionary = _load_or_init_save()
	var cur: int = int(data.get("level_unlocked", 1))
	if level > cur:
		data["level_unlocked"] = level
		_save_data(data)
