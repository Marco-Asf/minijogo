extends Node2D

@export var total_correct_objects := 0
var found_count := 0
var elapsed_time := 0.0

@onready var progress_label := $ProgressLabel
@onready var timer_label := $TimerLabel

func _ready():
    # Conta automaticamente quantos objetos corretos existem
    total_correct_objects = get_tree().get_nodes_in_group("correct_object").size()
    _update_progress()
    # Inicia o contador de tempo
    set_process(true)

func _process(delta):
    elapsed_time += delta
    _update_timer()

func on_correct_found():
    found_count += 1
    _update_progress()
    if found_count >= total_correct_objects:
        _on_level_complete()

func _on_level_complete():
    print("✅ Fase concluída!")
    Global.unlock_next_from_zero_based(Global.numStage - 1)
    # Mostra tempo final (opcional)
    print("⏱ Tempo final: %.2f segundos" % elapsed_time)
    # Aqui você pode abrir uma tela de "Vitória" ou voltar para o menu
    await get_tree().create_timer(1.0).timeout
    get_tree().change_scene_to_file("res://fases/tela_selecao.tscn")

func _update_progress():
    if progress_label:
        progress_label.text = "%d / %d encontrados" % [found_count, total_correct_objects]

func _update_timer():
    if timer_label:
        var minutes = int(elapsed_time) / 60
        var seconds = int(elapsed_time) % 60
        timer_label.text = "%02d:%02d" % [minutes, seconds]
        
