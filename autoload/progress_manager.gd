extends Node
# Singleton: cadastrado como "ProgressManager" em Projeto > Configurações > Globais

# Liste aqui as cenas de fase
const LEVELS := [
	"res://levels/Level1.tscn",
	"res://levels/Level2.tscn",
	"res://levels/Level3.tscn",
]

const SAVE_PATH := "user://progress.cfg"

var unlocked_count: int = 1  # começa com a Fase 1 liberada

func _ready() -> void:
	load_progress()

func get_levels() -> Array[String]:
	return LEVELS

func get_unlocked_count() -> int:
	return unlocked_count

func is_unlocked(level_index: int) -> bool:
	return level_index < unlocked_count

func unlock_next_from(level_index: int) -> void:
	# libera APENAS a próxima, e só se a atual foi concluída
	if unlocked_count == level_index + 1 and unlocked_count < LEVELS.size():
		unlocked_count += 1
		save_progress()

func save_progress() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "unlocked_count", unlocked_count)
	cfg.save(SAVE_PATH)

func load_progress() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		unlocked_count = int(cfg.get_value("progress", "unlocked_count", 1))
	else:
		unlocked_count = 1

# opcional: reset (p/ botão de opções)
func reset_progress() -> void:
	unlocked_count = 1
	save_progress()
