extends Node


# <<< AJUSTE estes caminhos para as suas cenas >>>
const LEVELS := [
	"res:///mano_roods.tscn",        # Fase 1 #verde
	"res://level2.tscn",  # Fase 2 # 
	"res://main.tscn",      # Fase 3 (troque quando tiver)
]

const SAVE_PATH := "user://progress.cfg"

var highestStage: int = 1   # quantas fases estão liberadas (1..3)
var numStage: int = 1       # fase atual (1..3)

func _ready() -> void:
	load_progress()

# ------ API que a tela de seleção e as fases vão usar ------
func get_unlocked_count() -> int:
	return highestStage

func is_unlocked_zero_based(level_index: int) -> bool:
	return level_index < highestStage   # 0 < 1 => só fase 1 aberta

func start_level_zero_based(level_index: int) -> void:
	if not is_unlocked_zero_based(level_index): return
	if level_index < 0 or level_index >= LEVELS.size(): return
	var packed := load(LEVELS[level_index])
	if packed:
		numStage = level_index + 1
		get_tree().change_scene_to_packed(packed)
	else:
		push_error("Falha ao carregar: %s" % LEVELS[level_index])

# chame isto quando o jogador vencer a fase `level_index` (0,1,2)
func unlock_next_from_zero_based(level_index: int) -> void:
	var want := level_index + 2  # venceu 0 -> libera 2 (highestStage=2)
	if want > highestStage and want <= LEVELS.size():
		highestStage = want
		save_progress()

# ------ salvar / carregar ------
func save_progress() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "highestStage", highestStage)
	cfg.save(SAVE_PATH)

func load_progress() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		highestStage = int(cfg.get_value("progress", "highestStage", 1))
	else:
		highestStage = 1

func reset_progress() -> void:
	highestStage = 1
	save_progress()
