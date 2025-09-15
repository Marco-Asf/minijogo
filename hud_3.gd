# HUD.gd
extends CanvasLayer

@onready var lbl_time: Label = $TimeLabel
@onready var progress_bar: ProgressBar = $ProgressBar

@export var time_limit: float = 240.0
@export var max_score: int = 100  # valor total da barra (100%)
var time_left: float
var score: int = 0

func _ready():
    time_left = time_limit
    progress_bar.max_value = max_score
    progress_bar.value = score

func _process(delta: float) -> void:
    if time_left > 0.0:
        time_left -= delta
        if time_left <= 0.0:
            time_left = 0.0
            game_over()
    lbl_time.text = "Tempo: %d" % int(ceil(time_left))
    progress_bar.value = score

func add_correct():
    # Cada item correto aumenta a barra proporcionalmente
    var per_item = max_score / 10  # 11 items correctos
    score = clamp(score + per_item, 0, max_score)
    
    print("📊 Score: ", score, "/", max_score)  # ← Adicione este print
    
    if score >= max_score:
        print("🎉 VITÓRIA! Chamando win_level()...")
        win_level()

func add_wrong(penalize_seconds: float = 5.0):
    time_left = max(0.0, time_left - penalize_seconds)

func game_over():
    print("Tempo esgotado - Game Over")
    get_tree().change_scene_to_file("res://fases/tela_selecao.tscn")


func win_level():
    print("Fase 1 concluída!")
    var pm = get_node("/root/ProgressManager")
    if pm:
        pm.on_level_completed(2, score)  # ← Número 1 para Fase 1
    await get_tree().create_timer(3.0).timeout
    get_tree().change_scene_to_file("res://fases/tela_selecao.tscn")
    
func show_win_popup():
    # Criar o popup
    var popup = AcceptDialog.new()  # ← CORRIGIDO: .new() não .next()
    popup.title = "🎉 Vitória!"  # Título da janela
    popup.dialog_text = "PARABÉNS!\nVocê encontrou todos os itens!"  # Mensagem
    popup.size = Vector2(400, 200)  # Tamanho da janela
    
    # Adicionar à cena
    get_tree().root.add_child(popup)  # ← CORRIGIDO: add_child() não add_cbild()
    popup.popup_centered()  # Centralizar na tela
    
    # CONECTAR o botão "OK" para fechar e trocar de cena
    popup.confirmed.connect(
        func():
            # Trocar para level select após clicar em OK
            var pm = get_node("/root/ProgressManager")
            if pm:
                pm.on_level_completed(2, score)  # ← Ajuste o número da fase
            get_tree().change_scene_to_file("res://fases/tela_selecao.tscn")
            popup.queue_free()  # Remover o popup
    )
