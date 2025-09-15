extends Node2D
@onready var hud = $HUD
@export var total_correct_objects := 0
var found_count := 0

func _ready():
    # Conta automaticamente quantos objetos corretos existem
    total_correct_objects = get_tree().get_nodes_in_group("correct_object").size()
    hud.time_left = 60  # define o tempo da fase
    hud.score = 0
func on_correct_found():
    found_count += 1
    if found_count >= total_correct_objects:
        _on_level_complete()

func _on_level_complete():
    print("✅ Fase concluída!")
    Global.unlock_next_from_zero_based(Global.numStage - 1)
    # Aqui você pode abrir uma tela de "Vitória" ou voltar para o menu
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://fases/tela_selecao.tscn")

func _process(delta):
    if hud.time_left <= 0:
        game_over()
func game_over():
    # Aqui você decide o que acontece quando o tempo acaba
    print("Fim do tempo! Game Over")
    get_tree().change_scene("res://fases/tela_selecao.tscn")  # volta pro menu
